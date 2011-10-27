# Copyright (c) 2011 RightScale Inc
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'cgi'
require 'base64'

module RightSupport::Net
  class StringEncoder
    ENCODINGS = [:base64, :url].freeze

    def initialize(*args)
      args = args.flatten
      args.each do |enc|
        raise ArgumentError, "Unknown encoding #{enc}" unless ENCODINGS.include?(enc)
      end

      @encodings = args
    end

    def encode(target)
      @encodings.each do |enc|
        case enc
          when :base64
            target = Base64.encode64(target)
          when :url
            target = CGI.escape(target)
        end
      end

      target
    end

    def decode(target)
      @encodings.reverse.each do |enc|
        case enc
          when :base64
            target = Base64.decode64(target)
          when :url
            target = CGI.unescape(target)
        end
      end

      target
    end
  end
end
