# Image Recognizer (TensorFlow, CNN)

This is Image Recognizer for own images by using TensorFlow & CNN model ([CIFR-10 tutorial](https://www.tensorflow.org/versions/r0.10/tutorials/deep_cnn/index.html#convolutional-neural-networks)).
You can gather images, convert them to fit learning model's input. and then train. Finally, you launch web application on localhost, the application classify images you upload into the application.

# Processes

* [x] 1. Gather images you want to recognize from TensorFlow and put into `/data/raw`
* [x] 2. Process the images to CIFAR-10 dataset (`data/input/images.bin`)
* [x] 3. Train CIFAR-10's model using by your images.
* [ ] 4. Classify from New data.

# Versions

* Mac OS Sierra (10.12)
* Ruby 2.2.2
* Python 3.4.5

# Usage

## 1. [Optional] Download images you want to recognize.

You don't need download any images because the sample images already exist in `data/raw`. If you need original images and recognize them, execute below commands.

```
# install chrome binary and move to PATH directory
# Download url: http://chromedriver.storage.googleapis.com/index.html

# gem installs
$ bundle install

# Scrape google images by using `keyword`
# num is less than 400 because of bugs
$ ./scrape/scrape.rb -k <keyword> -n <num>

# and then remove the images not matched with keyword.
```

## 2. Process your images to fit TensorFlow CNN model dataset (CIFAR-10)

Process your images to CIFAR-10 binary

```
# Options
#   -s src directory
#   -o output directory
#   (Be carefull directory path starts with '.' and doesn't end with '/')
$ ./image_processor/processor.rb -s ./data/raw -o ./data/input
```

## 3. Train images by using TensorFlow CNN model.

Run training (training will take 1 hours. depends on machine power)
Be careful to re-run this command. because checkpoint file(trained data) is removed and new one is created.

```
$ cd recognizer
$ python model_train.py
Filling queue with 40 CIFAR images before starting to train. This will take a few minutes.
2016-10-07 11:02:45.512924: step 0, loss = 4.77 (78.8 examples/sec; 0.813 sec/batch)
2016-10-07 11:02:55.742913: step 10, loss = 4.72 (87.8 examples/sec; 0.729 sec/batch)
2016-10-07 11:03:03.609812: step 20, loss = 4.70 (53.7 examples/sec; 1.191 sec/batch)
2016-10-07 11:03:10.959503: step 30, loss = 4.64 (85.9 examples/sec; 0.745 sec/batch)
2016-10-07 11:03:18.221603: step 40, loss = 4.58 (94.1 examples/sec; 0.680 sec/batch)
...
```

Visualize results by TensorBoard.

```
$ tensorboard --logdir=/tmp/my_model_train
```

## 4. Classify images as web application.

Measure accuracy by using test data.

```
$ cd recognizer
$ python model_eval.py

# if 2 classifications (cat or dog)
2016-10-07 13:30:44.203764: precision @ 1 = 0.802

# if 3 classification (cat, dog or bird)
2016-10-07 15:00:27.723453: precision @ 1 = 0.656
```

# Reference

* https://github.com/sugyan/face-collector
* https://github.com/sugyan/tf-classifier
* https://github.com/sugyan/face-recognizer
