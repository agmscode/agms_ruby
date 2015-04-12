#!/usr/bin/env ruby
$:.unshift File.expand_path('../../lib', __FILE__)

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'bundler/setup'
require 'yaml'

require 'agms'

require 'test/unit'
require 'mocha/test_unit'
