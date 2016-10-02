# Image Recognizer (TensorFlow, CNN)

This is Image Recognizer for own images by using TensorFlow & CNN model ([CIFR-10 tutorial](https://www.tensorflow.org/versions/r0.10/tutorials/deep_cnn/index.html#convolutional-neural-networks)).
You can gather images, convert them to fit learning model's input. and then train. Finally, you launch web application on localhost, the application classify images you upload into the application.

# Processes

* [x] 1. Gather images you want to recognize from TensorFlow and put into `/data/raw`
* [ ] 2. Process the images to like CIFAR-10 dataset
* [ ] 3. Train CIFAR-10's model using by your images.
* [ ] 4. Classify from New data.

# Versions

* Mac OS Sierra (10.12)
* Ruby 2.2.2
* Python 3.4.5

# Usage

1. [Optional] Download images you want to recognize.

You don't need download any images because the sample images already exist in `data/raw`. If you need original images and recognize them, execute below commands.

```
# gem installs
bundle install

# Scrape google images by using `keyword`
./scrape/scrape.rb -k <keyword>
```

2. Process your images to fit TensorFlow CNN model dataset

Processing

3. Train images by using TensorFlow CNN model.

Processing

4. Classify images as web application.

Processing

# Reference

* https://github.com/sugyan/face-collector
* https://github.com/sugyan/tf-classifier
* https://github.com/sugyan/face-recognizer
