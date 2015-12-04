namespace :crud_responder do
  desc 'Install localizations for crud_responder'
  task :copy_locales do
    localpath = File.dirname(__FILE__)
    puts localpath
  end
end
