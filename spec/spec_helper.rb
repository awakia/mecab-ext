# Do not require original mecab-ruby gem for testing
require File.expand_path('../MeCab', __FILE__)

module MeCab
  class Tagger
  end
end

$LOAD_PATH.unshift File.expand_path("../", __FILE__)
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'coveralls'
require 'simplecov'

Coveralls.wear!
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'spec'
end

require 'mecab/ext'
