# Site


# Testing Locally

### Docker

```bash
docker run -p 4000:4000 --rm -it $(docker build -q .)
```

### Manual

To test your site locally, you’ll need
- [ruby](https://www.ruby-lang.org/en/)
- the [github-pages](https://github.com/github/pages-gem) gem
#### Installing ruby
There are [lots of different ways to install ruby](https://www.ruby-lang.org/en/documentation/installation/).
In Mac OS X, older versions of ruby will already be installed. But I use the [Ruby Version Manager (RVM)](https://rvm.io/) to have a more recent version. You could also use [Homebrew](https://brew.sh/).
In Windows, use [RubyInstaller](https://rubyinstaller.org/). (In most of this tutorial, I’ve assumed you’re using a Mac or some flavor of Unix. It’s possible that none of this was usable for Windows folks. Sorry!)
#### Installing the github-pages gem
Run the following command:
```
gem install github-pages
```
This will install the github-pages gem and all dependencies (including [jekyll](https://jekyllrb.com/)).
#### Later, to update the gem, type:
```
gem update github-pages
```
Testing your site locally
To construct and test your site locally, go into the directory and type
```
jekyll build
```
This will create (or modify) a `_site/ directory`, containing everything from `assets/`, and then the `index.md` and all `pages/*.md` files, converted to html. (So there’ll be `_site/index.html` and the various `_site/pages/*.html.`)
Type the following in order to “serve” the site. This will first run build, and so it does not need to be preceded by `jekyll build`.
```
jekyll serve
```
Now open your browser and go to `http://localhost:4000/site-name/`

## Index page

The index page is seprated into several sections and they are located in `_includes/sections`,the configuration is in `_data/landing.yml` and section's detail configuration is in `_data/*.yml`.

### `_data/*.yml`

These files are used to dynamically render pages, so you almost don't have to edit *html files* to change your own theme, besides you can use `jekyll serve --watch` to reload changes.

The following is mapping between *yml files* to *sections*.

* landing.yml ==> index.html
* index/language.yml ==> index.html
* index/careers.yml  ==>  _includes/sections/career.html
* index/skills.yml  ==>  _includes/sections/skills.html
* index/projects.yml  ==>  _includes/sections/projects.html
* index/links.yml  ==>  _includes/sections/links.html

This *yml file* is about blog page navbar

* blog.yml ==> _includes/header.html

The following is mapping between *yml files* to *donation*

* donation/donationlist.yml ==> blog/donate.html
* donation/alipay.yml  ==>  blog/donate.html
* donation/wechat_pay.yml ==> blog/donate.yml

## Chart Skills

[Chart.js](http://www.chartjs.org/) to show skills, the type of skills' chart is radar, if you want to custom, please read document of Chart.js and edit **_includes/sections/skills.html** and **_data/index/skills.yml**.

## Categories in blog page

In blog page, we categorize posts into several categories by url, all category pages use same template html file - `_includes/category.html`.

For example: URL is `http://127.0.0.1:4000/python/`. In `_data/blog.yml`, we define this category named `Python`, so in `_includes/category.html` we get this URL(/python/) and change it to my category(Python), then this page are posts about **Python**. The following code is about how to get url and display corresponding posts in  `_includes/category.html`.

```html
<div class="row">
    <div class="col-lg-12 text-center">
        <div class="navy-line"></div>
        {% assign category = page.url | remove:'/' | capitalize %}
        {% if category == 'Html' %}
            {% assign category = category | upcase %}
        {% endif %}
        <h1>{{ category }}</h1>
    </div>
</div>
<div class="wrapper wrapper-content  animated fadeInRight blog">
    <div class="row">
        <ul id="pag-itemContainer" style="list-style:none;">
            {% assign counter = 0 %}
            {% for post in site.categories[category] %}
                {% assign counter = counter | plus: 1 %}
            {% endfor %}
            <li>
```

## Pagination

The pagination in jekyll is not very perfect,so I use front-end web method,there is a [blog](http://www.jarrekk.com/html/2016/06/04/jekyll-pagination-with-jpages.html) about the method and you can refer to [jPages](http://luis-almeida.github.io/jPages).

## Page views counter

Many third party page counter platforms are too slow,so I count my website page view myself,the javascript file is [static/js/count.min.js](https://github.com/jarrekk/jalpc_jekyll_theme/blob/gh-pages/static/js/count.min.js) ([static/js/count.js](https://github.com/jarrekk/jalpc_jekyll_theme/blob/gh-pages/static/js/count.js)),the backend API is written with flask on [Vultr VPS](https://www.vultr.com/), detail code please see [ztool-backhend-mongo](https://github.com/Z-Tool/ztool-backhend-mongo).

## Multilingual Page

The landing page has multilingual support with the [i18next](http://i18next.com) plugin.

Languages are configured in the `_data/index/language.yml` file.

> Not everyone needs this feature, so I make it very easy to remove it, just clear content in file `_data/language.yml` and folder `static/locales/`.

About how to custom multilingual page, please see [wiki](https://github.com/jarrekk/Jalpc/wiki/Multilingual-Page).

## Web analytics

I use [Google analytics](https://www.google.com/analytics/) and [GrowingIO](https://www.growingio.com/) to do web analytics, you can choose either to realize it,just register a account and replace id in `_config.yml`.

## Comment

I use [Disqus](https://disqus.com/) to realize comment. You should set disqus_shortname and get public key and then, in `_config.yml`, edit the disqus value to enable Disqus.

## Share

I use [AddToAny](https://www.addtoany.com/) to share my blog on other social network platform. You can go to this website to custom your share buttons and paste code at `_includes/share.html`.

![share](https://github.com/jarrekk/Jalpc/raw/master/readme_files/share.png)

## Search engines

I use javascript to realize blog search,you can double click `Ctrl` or click the icon at lower right corner of the page,the detail you can got to this [repository](https://github.com/androiddevelop/jekyll-search). Just use it.


## Compress CSS and JS files

All CSS and JS files are compressed at `/static/assets`.

I use [UglifyJS2](https://github.com/mishoo/UglifyJS2), [clean-css](https://github.com/jakubpawlowicz/clean-css) to compress CSS and JS files, customised CSS files are at `_sass` folder which is feature of [Jekyll](https://jekyllrb.com/docs/assets/). If you want to custom CSS and JS files, you need to do the following:

1. Install [NPM](https://github.com/npm/npm) then install **UglifyJS2** and **clean-css**: `npm install -g uglifyjs; npm install -g clean-css`, then run `npm install` at root dir of project.
2. Compress script is **build.js**
3. If you want to add or remove CSS/JS files, just edit **build/build.js** and **build/files.conf.js**, then run `npm run build` at root dir of project, link/src files will use new files.

OR

Edit CSS files at `_sass` folder.