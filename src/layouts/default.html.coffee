---
title: 'Bryan Rasmussen'
---

# Prepare
documentTitle = @getPreparedTitle()
lingo = if @document.lang then document.lang else 'en'
# HTML
doctype 5
html lang: lingo, ->
	head ->
		# Standard
		meta charset: 'utf-8'
		meta 'http-equiv': 'X-UA-Compatible', content: 'IE=edge,chrome=1'
		meta 'http-equiv': 'content-type', content: 'text/html; charset=utf-8'
		meta name: 'viewport', content: 'width=device-width, initial-scale=1'
		text  @getBlock('meta').toHTML()

		# Feed
		for feed in @site.feeds
			link
				href: h feed.href
				title: h feed.title
				type: (feed.type or 'application/atom+xml')
				rel: 'alternate'

		# SEO
		title documentTitle
		meta name: 'title', content: documentTitle
		meta name: 'author', content: @getPreparedAuthor()
		meta name: 'email', content: @getPreparedEmail()
		meta name: 'description', content: @getPreparedDescription()
		meta name: 'keywords', content: @getPreparedKeywords()

		# Styles
		link rel: 'stylesheet', href: "http://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css", media: 'screen, projection'
		link rel: 'stylesheet', href: "http://netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css", media: 'screen, projection'

		link rel: 'stylesheet', href: "/styles/style.css?v=#{@site.version}", media: 'screen, projection'
		link rel: 'stylesheet', href: "/styles/print.css?v=#{@site.version}", media: 'print'
		link rel: 'stylesheet', href: '/vendor/fancybox-2.1.5/jquery.fancybox.css', media: 'screen, projection'
	body '#css-zen-garden', ->
        div class:"navbar navbar-fixed-top", role:"navigation", ->
            div ".container", ->
                div ".navbar-header", ->
                    a ".navbar-brand", href: "/", ->
                        text 'Compender ->'
                        span '.compended', -> 'Bryan Rasmussen'
                div class:"collapse navbar-collapse", ->
                    ul class: "nav navbar-nav", ->
                        li -> a href: "/about", -> 'About'
                        li -> a href: "/contact", -> 'Contact'
                        
        div "#sidebar", class: "col-xs-6 col-sm-3 sidebar-offcanvas", role: "navigation", ->
            div class: "well sidebar-nav", ->
                img src: "/images/blog_profile_pic.png", width: 200, height: 200
                ul ".nav", ->
                    li -> a href: '/chunky', -> 'Bacon!'
        
        div '#container' ,class: 'container', ->
           
            div "#content", class: "row row-offcanvas row-offcanvas-right", ->
                div "#column1", class: "col-xs-12 col-sm-9", ->
                    div ".row", ->
                        @content                    
            footer '.footing', ->
                div '.about', -> @site.text.about
                div '.copyright', -> @site.text.copyright
        
        # Sidebar
        
        # Social
        #text @partial("social/#{social}", @)  for social in @site.social
        
        # Scripts
        text @getBlock('scripts').add(@site.scripts).toHTML()
