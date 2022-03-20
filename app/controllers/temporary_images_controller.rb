# frozen_string_literal: true

class TemporaryImagesController < ApplicationController
  def show
    image = File.open("tmp/#{params[:id]}.png", 'rb')

    send_data image.read, type: 'image/png', disposition: 'inline'
  end
end
