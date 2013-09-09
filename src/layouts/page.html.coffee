---
layout: default
---

# Title
if @document.title
	header '.page-header', ->
		a href: @document.url, ->
			h4 property: 'dcterms:title', ->
				@document.title

# Content
div '.page-content', property: 'sioc:content', -> @content