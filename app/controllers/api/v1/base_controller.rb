class Api::V1::BaseController < ApplicationController
  def render_success(object)
    data = object.is_a?(Array) ? object.map(&:serialize) : object.serialize
    render json: result_json(true, data, []), status: 200
  end

  def render_errors(object)
    errors = object.errors.full_messages
    render json: result_json(false, [], errors), status: 422
  end

  private

  def result_json(success, data, errors)
    {
      success: success,
      data: data,
      errors: errors,
    }
  end
end