class RootController < ApplicationController
  IMAGE_SIZE = 64

  def index
  end

  def api
    data = params.require(:image)
    # image = Image.new(data, IMAGE_SIZE, 0) # label_no is dummy
    # bin = image.to_cifar10_binary
    binding.pry
    res = HTTPClient.new.post('http://localhost:5000/api', ['image', data])
    softmax = JSON.parse(res.body)
    render json: { faces: softmax, message: 'hello' }
  end
end
