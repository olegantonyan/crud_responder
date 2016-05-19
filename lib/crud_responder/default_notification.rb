require 'crud_responder/caller_extractor'

module CrudResponder
  class DefaultNotification
    attr_reader :object, :kaller

    def initialize(object, kaller)
      @object = object
      @kaller = kaller
    end

    def text(ok)
      t_key = "flash.actions.#{CallerExtractor.new(kaller).action}.#{ok ? 'notice' : 'alert'}"
      if ok
        I18n.t(t_key, resource_name: resource_name, resource_desc: resource_desc)
      else
        I18n.t(t_key, resource_name: resource_name, resource_desc: resource_desc, errors: errors)
      end
    end

    private

    def errors
      object.errors.full_messages.to_sentence
    end

    def resource_desc
      object.to_s
    end

    def resource_name
      object.try(:model_name).try(:human) || object.class.name
    end
  end
end
