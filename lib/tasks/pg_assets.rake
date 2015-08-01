namespace :pg do
  namespace :assets do
    file_location = 'db/assets.sql'

    desc 'Install database assets (triggers, functions, views)'
    task :load => :environment do
      start_time = Time.now

      File.open(file_location, 'r') do |f|
        ActiveRecord::Base.transaction do
          ActiveRecord::Base.connection.execute(f.read)
        end
      end

      puts "Installed assets into the database in #{(Time.now - start_time) * 1000 } milliseconds"
    end

    desc 'Dump db assets (triggers, functions, views)'
    task :dump => :environment do
      File.open(file_location, 'w') do |file|
        file.puts '------------------------------ PG ASSETS ------------------------------'
        file.puts '--  BRO, DON\'T MODIFY THIS DIRECTLY'
        file.puts '--  IF YOU MODIFY THIS DIRECTLY,'
        file.puts '--  YOU\'RE GONNA HAVE A BAD TIME'
        file.puts '-----------------------------------------------------------------------'

        ::Services::PGAssetReader.views.each do |v|
          file.puts ''
          file.puts ''
          file.puts '-----------------------------------------------------------------------'
          file.puts '---------- VIEW: ' + v.identity
          file.puts '-----------------------------------------------------------------------'
          file.write v.sql_for_reinstall
        end

        ::Services::PGAssetReader.functions.each do |f|
          file.puts ''
          file.puts ''
          file.puts '-----------------------------------------------------------------------'
          file.puts '---------- FUNCTION: ' + f.identity
          file.puts '-----------------------------------------------------------------------'
          file.write f.sql_for_reinstall + ';'
        end

        ::Services::PGAssetReader.triggers.each do |t|
          file.puts ''
          file.puts ''
          file.puts '-----------------------------------------------------------------------'
          file.puts '---------- TRIGGER: ' + t.identity
          file.puts '-----------------------------------------------------------------------'
          file.write t.sql_for_remove + ';'
          file.puts ''
          file.write t.sql_for_reinstall + ';'
        end
      end
    end
  end
end

namespace :db do
  namespace :schema do
    task :load do
      # Run this after the regular db:schema:load stuff
      Rake::Task['pg:assets:load'].invoke
    end

    task :dump do
      # Run this after the regular db:schema:dump stuff
      Rake::Task['pg:assets:dump'].invoke
    end
  end
end
