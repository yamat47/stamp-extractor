# frozen_string_literal: true

class ResultsController < ApplicationController
  def create
    raise result_params.inspect
  end

  def show; end

  private

  def result_params
    params.permit(:image)
  end
end
