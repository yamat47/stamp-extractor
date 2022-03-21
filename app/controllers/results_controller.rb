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

    pnm = after.clone
    background = Magick::Image.new(after.columns, after.rows) { |image| image.background_color = 'white' }
    pnm = background.composite(pnm, Magick::CenterGravity, Magick::OverCompositeOp)
    pnm.format = 'pnm'

    id = SecureRandom.uuid

    File.open("tmp/#{id}.png", 'wb') { |f| f.write(after.to_blob) }
    File.open("tmp/#{id}.pnm", 'wb') { |f| f.write(pnm.to_blob) }

    system("potrace -s -o #{Rails.root}/tmp/#{id}.svg #{Rails.root}/tmp/#{id}.pnm")

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
