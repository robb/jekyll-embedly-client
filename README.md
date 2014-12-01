# A embed.ly client for Jekyll

This is a handy embed.ly client for people that use the static-site generator
jekyll.

## How to install

1. Make sure you have the _json_, _domainatrix_ and _compose_url_ gems installed.
2. Download the `embedly.rb` file and place it in the `_plugins/` inside your
   Jekyll project directory.
3. Go to the embed.ly site, register an account and get your API key.
4. Add your site address to the referrer section e.g. 'localhost.com*' or 'www.mywebsite.com*'
5. Edit your `_config.yml` as described below.
6. Make use of the new `embedly`-Liquid tag somewhere on your site.
   E.g. `{% embedly  http://soundcloud.com/mightyoaksmusic/rainier %}`
7. Compile your site.

Please not that github-pages does not allow the use of plugins, if you want
to make use of this plugin, you have to compile your site yourself.

## How to set up the `_config.yml`

First, pass in your newly acquired API key like so:

    embedly:
      api_key: abcdefg123456780cafebabe101cat44

You can further customize your embeds adding host-specific parameters.

    embedly:
      api_key: abcdefg123456780cafebabe101cat44

      soundcloud:
        width: 500px

      vimeo:
        width: 500px
        vimeo_color: FF0000

You can also pass along parameters to individual embeds, e.g.

    {% embedly  http://soundcloud.com/mightyoaksmusic/rainier, color: 00FFFF %}
    # Linebreaks are currently not supported :-/

For a list of supported parameters, please have a look at
[embed.ly’s documentation][docs] as well as the documentation for the oEmbed
implementation of the specific hosts.

Provider specific parameters are currently not working properly across the
board. Please let me know what works and what doesn't.

## Style your embeds

Your embed will be wrapped inside a `div`-tag that has classes matching the
embeds type, provider as well as the generic `embed`.

E.g.

    {% embedly  http://soundcloud.com/mightyoaksmusic/rainier %}

will result in

    <div class="embed rich soundcloud">
      ...
    </div>

[docs]: http://embed.ly/docs/endpoints/arguments
