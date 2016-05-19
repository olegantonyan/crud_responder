module CrudResponder
  class CallerExtractor
    attr_reader :kaller

    def initialize(kaller)
      @kaller = kaller
    end

    def name
      kaller[0][/`.*'/][1..-2]
    end

    def method
      if name =~ /destroy/
        :destroy
      else
        :save
      end
    end

    def action
      case name
      when /destroy/
        :destroy
      when /update/
        :update
      when /create/
        :create
      else
        name.to_sym
      end
    end
  end
end
