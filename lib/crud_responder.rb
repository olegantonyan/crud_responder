require 'action_view/helpers/text_helper'

require 'crud_responder/version'
require 'crud_responder/default_options'
require 'crud_responder/default_notification'
require 'crud_responder/caller_extractor'

module CrudResponder
  include ActionView::Helpers::TextHelper

  def crud_respond(object, opts = {})
    method = opts.fetch(:method, CallerExtractor.new(caller).method)
    options = final_options(opts, method, object)
    if object.public_send(method)
      success(options, object, caller)
    else
      error(options, object, caller)
    end
  end

  private

  def success(options, object, kaller)
    flash_success(options[:success_message] || DefaultNotification.new(object, kaller).text(true))
    redirect_to options[:success_url]
  end

  def error(options, object, kaller)
    flash_error(options[:error_message] || DefaultNotification.new(object, kaller).text(false))
    if options[:error_url]
      redirect_to options[:error_url]
    else
      render options[:error_action]
    end
  end

  def final_options(opts, method, object)
    @_options ||= begin
      {}.tap do |result|
        DefaultOptions.all_available.each do |opt|
          result[opt] = opts.fetch(opt) { |key| specific_options_for(key) || default_options_for(key, method, object) }
        end
      end
    end
  end

  def default_options_for(opt, method, object)
    default_options(method, object).public_send(opt)
  end

  def default_options(method, object)
    @_default_options ||= DefaultOptions.new(method, object)
  end

  def specific_options_for(opt)
    return nil unless respond_to?(:crud_responder_default_options, true)
    result = send(:crud_responder_default_options)
    return nil unless result
    result.fetch(opt, nil)
  end

  def flash_success(msg)
    flash[:notice] = truncate_message(msg)
  end

  def flash_error(msg)
    flash[:alert] = truncate_message(msg)
  end

  def truncate_message(msg)
    truncate(msg.to_s, length: 256, escape: false)
  end
end
