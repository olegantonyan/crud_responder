require 'action_dispatch/routing/polymorphic_routes'

module CrudResponder
  class DefaultOptions
    include ActionDispatch::Routing::PolymorphicRoutes

    attr_reader :method, :object

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

    def _error_url
      nil
    end

    private

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
