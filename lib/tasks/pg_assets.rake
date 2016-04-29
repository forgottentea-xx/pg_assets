namespace :pg do
  namespace :assets do
    file_location = 'db/assets.sql'

    desc 'Install database assets (triggers, functions, views)'
    task :load => :environment do
      start_time = Time.now

      File.open(file_location, 'r') do |f|
        PgAssets::Services::PgAssetManager.assets_load(f.read)
      end

      puts "Installed assets into the database in #{(Time.now - start_time) * 1000 } milliseconds"
    end

    desc 'Dump db assets (triggers, functions, views)'
    task :dump => :environment do
      File.open(file_location, 'w') do |file|
        file.puts PgAssets::Services::PgAssetManager.assets_dump
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

  namespace :test do
    task :load do
      # Run this after the regular db:schema:load stuff
      Rake::Task['pg:assets:load'].invoke
    end
  end
end
