require 'rubygems'
require 'net/https'
require 'uri'
require 'json'
require 'domainatrix'

module Jekyll
  class Embedly < Liquid::Tag
    @@EMBEDLY_PARAMETERS = ['maxwidth', 'maxheight', 'format', 'callback',
                            'wmode', 'allowscripts', 'nostyle', 'autoplay',
                            'videosrc', 'words', 'chars', 'width', 'height']

    def initialize(tag_name, text, tokens)
      super
      @text = text.strip
    end

    def render(context)
      @config  = context.registers[:site].config['embedly']
      @api_key = @config['api_key']

      if @api_key.nil?
        raise "You must provide embed.ly api key."
      end

      embed @text
    end

    private

    def embed(url)
      provider = Domainatrix.parse(url).domain

      parameters = ""
      if @config[provider]
        @config[provider].each do |key, value|
          if @@EMBEDLY_PARAMETERS.member? key
            parameters << "&#{key}=#{value}"
          else
            url << (url.match(/\?/) ? "&" : "?") << "#{key}=#{value}"
          end
        end
      end

      encoded_url = CGI::escape url
      embedly_url = URI.parse "http://api.embed.ly/1/oembed?key=#{@api_key}" +
                              "&url=#{encoded_url}#{parameters}"

      json_rep = JSON.parse resolve(embedly_url)

      compose json_rep
    end

    def compose(json_rep)
      type     = json_rep['type']
      provider = json_rep['provider_name'].downcase

      if type == 'photo'
        url, width, height = json_rep['url'], json_rep['width'], json_rep['height']
        html  = "<img src='#{url}' width='#{width}' height='#{height}' />"
      else
        html = json_rep['html']
      end

      "<div class=\"embed #{type} #{provider}\">#{html}</div>"
    end

    def resolve(uri)
      response = Net::HTTP.get_response(uri)

      unless response['location'].nil? and response['Location'].nil?
        resolve URI.parse(response['location']) or
                URI.parse(response['Location'])
      else
        response.body
      end
    end
  end
end

Liquid::Template.register_tag('embedly', Jekyll::Embedly)