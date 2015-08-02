module Services
  class PGAssetReader
    
    def self.views
      PGView.ours.to_a.sort_by { |v| v.identity }
    end

    def self.specific_view(name)
      PGView.ours.by_name(name).first
    end

    def self.triggers
      PGTrigger.ours.to_a.sort_by { |t| t.identity }
    end

    def self.functions
      PGFunction.ours.to_a.sort_by { |f| f.identity }
    end

   end
end
