Digestion
=========

The asset pipeline is a great new component of Rails 3.1. However it has a feature known as fingerprinting that makes it impossible to properly incorporate many popular JavaScript libraries (including [TinyMCE](http://tinymce.moxiecode.com/), [CKEditor](http://ckeditor.com/) and [FancyZoom](https://github.com/jnunemaker/fancy-zoom) to name just a few) into the asset pipeline.

This gem patches the asset pipeline to allow these libraries to be used, by disabling the fingerprinting functionality for specific files or paths.


Installation & Usage
--------------------

Add the following line to your Gemfile and run `bundle install`:

    gem 'digestion'

The `digestion` gem does not change any fingerprinting options by default but allows you to set the following options in your application configuration:

    # Exclude specific assets from fingerprinting (use a path, glob or regex)
    config.assets.digest_exclusions << "nofingerprints/*"

Rails plugins can require this gem and set these options in an initializer, making the whole process transparent to the end-developer. See the [tinymce-rails](https://github.com/spohlenz/tinymce-rails) project for an example of this.


The Problem With Fingerprinting
-------------------------------

Fingerprinting is used to improve caching of assets by including a version-specific fingerprint in the asset filename. From the [Asset Pipeline Rails Guide](http://guides.rubyonrails.org/asset_pipeline.html#what-is-fingerprinting-and-why-should-i-care):

> When a filename is unique and based on its content, HTTP headers can be set to encourage caches everywhere (at ISPs, in browsers) to keep their own copy of the content. When the content is updated, the fingerprint will change and the remote clients will request the new file. This is generally known as cachebusting.

In the Rails asset pipeline (in production mode), the MD5 hash of the file contents is inserted into the filename, e.g. `application-d41d8cd98f00b204e9800998ecf8427e.js`. This requires that the relevant `asset_url` helpers are used when referencing assets in your HTML, JavaScript or CSS (or CoffeeScript, SASS, etc).

When adding third-party code to your application, it is not always practical to make these changes. Worse still, more advanced libraries like TinyMCE load in plugins and other assets dynamically, making these changes virtually impossible. In these situations, the third-party code will work fine whilst in development but break suddenly when deployed to production.

One option is to move the assets into the `public` directory. Whilst this approach will work, it has some major drawbacks:

1. It prevents you from using the other great features of the asset pipeline such as asset concatenation and minification.
2. It leaves your assets scattered across multiple locations, making maintenance difficult.
3. A gem that provides assets must provide an additional rake task to copy its assets into `public`.

Asset fingerprinting is a great feature and it is recommended you use it wherever possible. However without this gem, it is impossible to disable it for those libraries that are incompatible.
