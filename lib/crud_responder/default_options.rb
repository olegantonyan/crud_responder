require 'action_dispatch/routing/polymorphic_routes'

module CrudResponder
  class DefaultOptions
    include ActionDispatch::Routing::PolymorphicRoutes

    def self.all_available
      @_all_available ||= new(nil, nil).public_methods(false).map(&:to_sym)
    end

    def initialize(method, object)
      @method = method
      @object = object
    end

    def success_url
      if method == :destroy
        object_index_url
      else
        object_url
      end || :back
    end

    def error_action
      if object.persisted?
        :edit
      else
        :new
      end
    end

    def error_url
      nil
    end

    def success_message
      nil # lazily calcucalted in DefaultNotification
    end

    def error_message
      nil # lazily calcucalted in DefaultNotification
    end

    private

    attr_reader :method, :object

    def object_index_url
      polymorphic_url(object.class)
    rescue NoMethodError
      nil
    end

    def object_url
      polymorphic_url(object)
    rescue NoMethodError
      nil
    end
  end
end
