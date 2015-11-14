require 'crud_responder/version'
require 'action_view/helpers/text_helper'

module CrudResponder
  include ActionView::Helpers::TextHelper

  protected

  def crud_respond(object, options = {})
    method = options.fetch(:method, method_by_caller(caller))
    success_url = options.fetch(:success_url) { default_redirect_url(method, object) }
    error_action = options.fetch(:error_action) { default_render_action(method, object) }
    error_url = options.fetch(:error_url, nil)

    if perform(caller, object, method)
      redirect_to success_url
    else
      if error_url
        redirect_to error_url
      else
        render error_action
      end
    end
  end

  private

  def object_index_url object
    polymorphic_url(object.class)
  rescue NoMethodError
    nil
  end

  def object_url object
    polymorphic_url(object)
  rescue NoMethodError
    nil
  end

  def default_redirect_url(method, object)
    if method == :destroy
      object_index_url(object)
    else
      object_url(object)
    end || :back
  end

  def default_render_action(method, object)
    if object.persisted?
      :edit
    else
      :new
    end
  end

  def caller_name(_caller)
    _caller[0][/`.*'/][1..-2]
  end

  def method_by_caller(_caller)
    if caller_name(_caller) =~ /destroy/
      :destroy
    else
      :save
    end
  end

  def perform(_caller, object, method)
    ok = object.public_send(method)
    t_key = "flash.actions.#{action_by_caller(_caller)}.#{ok ? 'notice' : 'alert'}"
    if ok
      flash_success I18n.t(t_key, resource_name: resoucre_name_by_object(object), resource_desc: object.to_s)
    else
      flash_error I18n.t(t_key, resource_name: resoucre_name_by_object(object), resource_desc: object.to_s, errors: object.errors.full_messages.to_sentence)
    end
    ok
  end

  def action_by_caller(_caller)
    case caller_name(_caller)
    when /destroy/
      :destroy
    when /update/
      :update
    when /create/
      :create
    else
      "unknown_action_from_#{caller_name(_caller)}".to_sym
    end
  end

  def resoucre_name_by_object(object)
    object.class.to_s
  end

  def flash_success msg
    flash[:notice] = truncate_message(msg)
  end

  def flash_error msg
    flash[:alert] = truncate_message(msg)
  end

  def truncate_message msg
    truncate(msg.to_s, length: 256, escape: false)
  end

end
