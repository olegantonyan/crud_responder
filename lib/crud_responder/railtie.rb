require 'crud_responder'
require 'rails'

module CrudResponder
  class Railtie < Rails::Railtie
    railtie_name :crud_responder

    rake_tasks do
      load 'tasks/crud_responder.rake'
    end
  end
end
