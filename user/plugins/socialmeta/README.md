# Grav SocialMeta Plugin

SocialMeta provides automatic generation of `og:` and `twitter:` tags on your pages.

# Features

* [Open Graph](http://ogp.me/) support
* [Twitter Cards](https://dev.twitter.com/cards/overview) support
* Provides sane values by default, but users can override the tags in pages [using the `metadata` header]((https://learn.getgrav.org/content/headers#meta-page-headers)).
* [AboutMe plugin](https://github.com/Birssan/grav-plugin-about-me) integration

# Installation

As this plugin is not yet in the Grav repository, you need to install it manually. From your plugins folder:
```
git clone https://github.com/paulcmal/grav-plugin-socialmeta socialmeta
```

This will clone this repository into the socialmeta folder.

# Usage

You need to include the `partials\socialmeta.html.twig` template where the `<meta>` tags are defined. 

## Antimatter

To integrate in the official Grav theme [Antimatter](https://github.com/getgrav/grav), add at the end of your `partials/metadata.html.twig`:
```
{% include 'partials/socialmeta.html.twig' %}
```

## HPSTR

To integrate in the [HPSTR](https://github.com/getgrav/grav-theme-hpstr) theme, add to `partials/head.html.twig`, just after `<meta http-equiv="cleartype" content="on">`:
```
{% include 'partials/socialmeta.html.twig' %}
```

# Configuration

## Overriding the defaults

If you need specific metadata for a page, just add them to this page as recommended in the [Grav Docs](https://learn.getgrav.org/content/headers#standard-metatag-examples).

SocialMeta first checks whether a metadata has been manually set before settings its default value.

## Associate Twitter account

SocialMeta supports [AboutMe plugin](https://github.com/Birssan/grav-plugin-about-me). To add/change the Twitter defined in `twitter:site`, edit your profile in the AboutMe plugin.

Alternatively, you can manually add `<meta name="twitter:site" property="twitter:site" content="@USERNAME">` to your `<head>`. In the default [Antimatter](https://github.com/getgrav/grav-theme-antimatter), you can add it in `templates/partials/metadata.html.twig`.

# Future of this plugin

For now this plugin is a test release. If the proposed defaults are widely accepted, I'll release version 1.0.

## Will it support customization of default values through the admin interface?

If some people find this useful (and ask for it), sure.

## Will it brings microformats2 support to my website?

Short answer: no.

This plugin only adds metadata in the `<head>` of your pages. That means it cannot possibly add [microformats2](http://microformats.org) to your site.

Like Open Graph and Twitter Cards tags, microformats2 are semantic markup: they add meaning to your website, for parsers to understand what information your page gives.

Open Graph and Twitter Cards, though, support only marking one item per page. microformats2, on the other hand, allows you to give meaning to content all over your website pages.

Implementing microformats2 support to become a part of [the Indieweb](https://indieweb.org) is within the realm of theme-making, not plugin-making.

Don't hesitate to ask your theme maintainer to add microformats2 support, so all together we can take down GAFAMs.

# License

This work is too short and generic to be subject to intellectual property laws. It is therefore considered to be in the public domain.

However, if need be, you can consider this work to be released under the `Fuck Property Public License`.

## Fuck Property Public License

This production is released as part of the public domain. I renounce every so-called right of intellectual property over it.

As [property is theft](https://propertyistheft.wordpress.com/what-i-believe-in/property-is-theft/) and oppression, and no form of property is ever tolerable, feel free to [do what the fuck you want with it](http://www.wtfpl.net/), but don't forget to share around in the pure copyleft spirit.

# Contributing

If you think some of the defaults proposed are just not the best, feel free to submit ideas and pull requests.
