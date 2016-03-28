module CrudResponder
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('..', __FILE__)

      desc 'Creates an initializer with default crud_responder configuration and copy locale file'

      def update_application_controller
        inject_into_class 'app/controllers/application_controller.rb', 'ApplicationController', <<-RUBY
  include CrudResponder

        RUBY
      end

      def copy_locale
        copy_file '../../crud_responder/locales/en.yml', 'config/locales/crud_responder.en.yml'
      end
    end
  end
end
