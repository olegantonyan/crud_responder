require 'crud_responder/version'
require 'crud_responder/default_options'
require 'action_view/helpers/text_helper'

module CrudResponder
  include ActionView::Helpers::TextHelper

  protected

  def crud_respond(object, opts = {})
    method = opts.fetch(:method, method_by_caller(caller))
    options = final_options(opts, method, object)
    if perform(caller, object, method)
      success(options)
    else
      error(options)
    end
  end

  private

  def success(options)
    redirect_to options[:success_url]
  end

  def error(options)
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

  def caller_name(kaller)
    kaller[0][/`.*'/][1..-2]
  end

  def method_by_caller(kaller)
    if caller_name(kaller) =~ /destroy/
      :destroy
    else
      :save
    end
  end

  def perform(kaller, object, method)
    ok = object.public_send(method)
    t_key = "flash.actions.#{action_by_caller(kaller)}.#{ok ? 'notice' : 'alert'}"
    if ok
      flash_success I18n.t(t_key, resource_name: resource_name_by_object(object), resource_desc: object.to_s)
    else
      flash_error I18n.t(t_key, resource_name: resource_name_by_object(object), resource_desc: object.to_s, errors: object.errors.full_messages.to_sentence)
    end
    ok
  end

  def action_by_caller(kaller)
    case caller_name(kaller)
    when /destroy/
      :destroy
    when /update/
      :update
    when /create/
      :create
    else
      "unknown_action_from_#{caller_name(kaller)}".to_sym
    end
  end

  def resource_name_by_object(object)
    object.try(:model_name).try(:human) || object.class.name
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
