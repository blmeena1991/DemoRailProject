require 'exceptions/validation_error'
module GlobalErrorHandler extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :render_custom_exception_response
    rescue_from RuntimeError, SignalException, with: :render_validation_exception_response
    rescue_from ValidationError, NameError, with: :render_custom_exception_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveModel::RangeError, with: :render_custom_response
    rescue_from ActiveRecord::RecordNotUnique, with: :render_not_unique_response
  end



  def render_unauthorized_response(exception)
    render json: { error: exception.message, errors: [exception.message] }, status: :unauthorized
  end

  def render_unprocessable_entity_response(exception)
    Rails.logger.error(exception)
    render json: { error: exception.record.errors.full_messages.join(','),
                   errors: exception.record.errors.full_messages
    }, status: :unprocessable_entity
  end

  def render_not_found_response(exception)
    Rails.logger.error(exception)
    render json: { error: exception.message, errors: [exception.message], }, status: :not_found
  end

  def render_validation_exception_response(exception)
    Rails.logger.error(exception)
    print_exception(exception)
    render json: { error: exception.message, errors: [exception.message], stacktrace: exception.backtrace }, status: :bad_request
  end

  def render_not_unique_response(exception)
    notify_airbrake(exception)
    render json: { error: "Oops! Something went wrong.Please try again", errors: ["Oops! Something went wrong.Please try again"] }, status: :internal_server_error
  end

  def render_custom_response(exception)
    render json: { error: "Oops! Something went wrong", errors: ["Oops! Something went wrong"] }, status: :internal_server_error
  end


  def render_custom_exception_response(exception)
    Rails.logger.error(exception)
    print_exception(exception)
    if exception.class == ValidationError
      render json: { error: exception.message, errors: [exception.message] }, status: :bad_request
    else
      render json: { error: exception.message, errors: [exception.message], stacktrace: exception.backtrace }, status: :internal_server_error
    end
  end

  def print_exception(exception)
    puts exception.backtrace
  end

end