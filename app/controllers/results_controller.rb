# frozen_string_literal: true

require 'rmagick'

class ResultsController < ApplicationController
  def create
    image = Magick::Image.from_blob(result_params[:image].read)[0]

    frame = image.clone
                 .threshold(Magick::QuantumRange * 0.6)
                 .transparent('white', alpha: Magick::TransparentAlpha)

    frame.format = 'png'

    after = image.clone
                 .composite(frame, Magick::CenterGravity, Magick::DstInCompositeOp)
                 .transparent('black', alpha: Magick::TransparentAlpha)

    after.format = 'png'

    id = SecureRandom.uuid

    File.open("tmp/#{id}.png", 'wb') { |f| f.write(after.to_blob) }

    redirect_to result_path(id)
  end

  def show
    @id = params[:id]
  end

  private

  def result_params
    params.permit(:image)
  end
end
