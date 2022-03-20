# frozen_string_literal: true

class TemporaryImagesController < ApplicationController
  def show
    respond_to do |format|
      format.png do
        image = File.read("tmp/#{params[:id]}.png")

        send_data image, type: 'image/png', disposition: 'inline'
      end

      format.svg do
        image = File.open("tmp/#{params[:id]}.svg", 'rb')
        document = Nokogiri::HTML::DocumentFragment.parse image.read
        svg = document.at_css "svg"

        send_data svg, type: 'image/svg+xml', disposition: 'inline'
      end
    end
  end
end
