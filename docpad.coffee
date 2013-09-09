# =================================
# Misc Configuration

envConfig = process.env
githubAuthString = "client_id=#{envConfig.BALUPTON_GITHUB_CLIENT_ID}&client_secret=#{envConfig.BALUPTON_GITHUB_CLIENT_SECRET}"

getRankInUsers = (users=[]) ->
	rank = null

	for user,index in users
		if user.login is 'rasmussen'
			rank = String(index+1)
			break

	return rank

suffixNumber = (rank) ->
	rank = String(rank)

	if rank
		if rank >= 1000
			rank = rank.substring(0,rank.length-3)+','+rank.substr(-3)
		else if rank >= 10 and rank < 20
			rank += 'th'
		else switch rank.substr(-1)
			when '1'
				rank += 'st'
			when '2'
				rank += 'nd'
			when '3'
				rank += 'rd'
			else
				rank += 'th'

	return rank

floorToNearest = (value,floorToNearest) ->
	result = Math.floor(value/floorToNearest)*floorToNearest


# =================================
# DocPad Configuration

module.exports =
	regenerateEvery: 1000*60*60  # hour

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:
		# Site Data
		site:
			version: require('./package.json').version
			url: "http://bryanrasmussen.name"
			title: "Bryan Rasmussen"
			author: "Bryan Rasmussen"
			email: "rasmussen.bryan@ögmail.com"
			description: """
				Website of Bryan Rasmussen.
				"""
			keywords: """
				bryan rasmussen, node.js, javascript, processing, xml, xslt
				"""

			text:
				heading: "Bryan Rasmussen"
				subheading: '''
					
					'''
				about: '''
					<t render="html.coffee">
						link = @getPreparedLink.bind(@)
						text """
							This website was created with the open source #{link 'docpad'}
							"""
					</t>
					'''
				copyright: '''
					<t render="html.md">
						Unless stated otherwise; all content is Copyright © 2013+ [Bryan Rasmussen](http://bryanrasmussen.name) [Creative Commons Attribution 3.0 Unported License](http://creativecommons.org/licenses/by/3.0/)
					</t>
					'''

			services:
				#facebookLikeButton:
#					applicationId: '266367676718271'
#				facebookFollowButton:
#					applicationId: '266367676718271'
#					username: 'balupton'
#				twitterTweetButton: "balupton"
#				twitterFollowButton: "balupton"
#				githubFollowButton: "balupton"
#				quoraFollowButton: "Benjamin-Lupton"
#				disqus: 'balupton'
#				gauges: '5077ae93f5a1f5067b000028'
#				googleAnalytics: 'UA-4446117-1'
				reinvigorate: '52uel-236r9p108l'

			social:
				"""
				""".trim().split('\n')

			styles: []  # embedded in layout

			scripts: """
				/vendor/jquery-2.0.2.js
				/vendor/fancybox-2.1.5/jquery.fancybox.js
				/scripts/script.js
				""".trim().split('\n')

			feeds: [
					
			]

			links:
				docpad:
					text: 'DocPad'
					url: 'http://docpad.org'
					title: 'Visit Website'
				nodejs:
					text: 'Node.js'
					url: 'http://nodejs.org/'
					title: 'Visit Website'
				author:
					text: 'Bryan Rasmussen'
					url: 'http://bryanrasmussen.name'
					title: 'Visit Website'
				source:
					text: 'open-source'
					url: 'https://github.com/balupton/balupton.docpad'
					title: 'View Website Source'
				contact:
					text: 'Contact'
					url: 'mailto:rasmussen.bryan@gmail.com'
					title: 'Contact me'
					cssClass: 'contact-button'

		# Link Helper
		getPreparedLink: (name) ->
			link = @site.links[name]
			renderedLink = """
				<a href="#{link.url}" title="#{link.title}" class="#{link.cssClass or ''}">#{link.text}</a>
				"""
			return renderedLink

		# Meta Helpers
		getPreparedTitle: -> if @document.title then "#{@document.title} | #{@site.title}" else @site.title
        getPreparedLang: -> if @document.lang then "#{@document.lang} | 'en'}" else 'en'
		getPreparedAuthor: -> @document.author or @site.author
		getPreparedEmail: -> @document.email or @site.email
		getPreparedDescription: -> @document.description or @site.description
		getPreparedKeywords: -> @site.keywords.concat(@document.keywords or []).join(', ')

		# Ranking Helpers
		suffixNumber: suffixNumber
		floorToNearest: floorToNearest
		
		# Project Helpers
		getProjects:   ->
			return @projects  if @projects

			@projects = []

			feeds = []
			for feed in feeds
				projects = @feedr.feeds[feed+'-projects'] or []
				if projects.length is 0
					docpad.warn("The feed #{feed} was empty")
				else
					for project in projects
						continue  if project.fork
						@projects.push(project)

			@projects.sort?((a,b) -> b.watchers - a.watchers)

			return @projects

		# Project Counts
		getGithubCounts: ->
			@githubCounts or= (=>
				projects = @getProjects()
				forks = stars = 0
				total = projects.length

				top = @feedr.feeds['github-top'] ? null
				topData = /\#([0-9]+).+?balupton.+?([0-9]+)/.exec(top)
				rank = topData?[1] or 23
				contributions = topData?[2] or 3582

				for project in projects
					forks += project.forks
					stars += project.watchers

				total or= 136
				forks or= 1057
				stars or= 8024

				return {forks, stars, projects:total, rank, contributions}
			)()


	# =================================
	# Collections

	collections:
		pages: ->
			@getCollection('documents').findAllLive({menuOrder:$exists:true},[menuOrder:1])

		posts: ->
			@getCollection('documents').findAllLive({relativeOutDirPath:'blog'},[timestamp:-1])


	# =================================
	# Events

	events:

		serverExtend: (opts) ->
			# Prepare
			docpadServer = opts.server

			# ---------------------------------
			# Server Configuration

			# Redirect Middleware
			docpadServer.use (req,res,next) ->
				if req.headers.host in ['www.bryanrasmussen.name']
					res.redirect 301, 'http://bryanrasmussen.name'+req.url
				else
					next()

			# ---------------------------------
			# Server Extensions

			# Demos
			docpadServer.get /^\/sandbox(?:\/([^\/]+).*)?$/, (req, res) ->
				project = req.params[0]
				res.redirect 301, "http://balupton.github.com/#{project}/demo/"
				# ^ github pages don't have https

			# Projects
			#docpadServer.get /^\/projects\/(.*)$/, (req, res) ->
			#	project = req.params[0] or ''
			#	res.redirect 301, "https://github.com/balupton/#{project}"

			#docpadServer.get /^\/(?:g|gh|github)(?:\/(.*))?$/, (req, res) ->
				#project = req.params[0] or ''
#				res.redirect 301, "https://github.com/balupton/#{project}"

			# Twitter
#			docpadServer.get /^\/(?:t|twitter|tweet)(?:\/(.*))?$/, (req, res) ->
#				res.redirect 301, "https://twitter.com/balupton"

			# Sharing Feed
#			docpadServer.get /^\/feeds?\/shar(e|ing)(?:\/(.*))?$/, (req, res) ->
#				res.redirect 301, "http://feeds.feedburner.com/balupton/shared"

			# Feeds
#			docpadServer.get /^\/feeds?(?:\/(.*))?$/, (req, res) ->
#				res.redirect 301, "http://feeds.feedburner.com/balupton"


	# =================================
	# Plugin Configuration

	plugins:
		feedr:
			timeout: 60*1000
			feeds:
				#'stackoverflow-profile':
				#	url: 'http://api.stackoverflow.com/1.0/users/130638/'
				#'github-australia-javascript':
				#	url: "https://api.github.com/legacy/user/search/location:Australia%20language:JavaScript?#{githubAuthString}"
				#'github-australia':
				#	url: "https://api.github.com/legacy/user/search/location:Australia?#{githubAuthString}"
					# https://github.com/search?q=location%3AAustralia&type=Users&s=followers
				#'github-gists':
				#	url: "https://api.github.com/users/balupton/gists?per_page=100&#{githubAuthString}"
				#'github-top':
				#	url: 'https://gist.github.com/paulmillr/2657075/raw/active.md'
				#'github-profile':
				#	url: "https://api.github.com/users/balupton?#{githubAuthString}"
				#'balupton-projects':
				#	url: "https://api.github.com/users/balupton/repos?per_page=100&#{githubAuthString}"
				#'bevry-projects':
				#	url: "https://api.github.com/users/bevry/repos?per_page=100&#{githubAuthString}"
				#'browserstate-projects':
				#	url: "https://api.github.com/users/browserstate/repos?per_page=100&#{githubAuthString}"
				#'docpad-projects':
				#	url: "https://api.github.com/users/docpad/repos?per_page=100&#{githubAuthString}"
				#'flattr':
				#	url: 'https://api.flattr.com/rest/v2/users/balupton/activities.atom'
				#'github':
				#	url: "https://github.com/balupton.atom"
				#'twitter':
				#	url: "https://api.twitter.com/1/statuses/user_timeline.json?screen_name=balupton&count=20&include_entities=true&include_rts=true"
#				'vimeo':
#					url: "http://vimeo.com/api/v2/balupton/videos.json"
				'youtube':
					#url: "http://gdata.youtube.com/feeds/base/users/balupton/uploads?alt=json&orderby=published&client=ytapi-youtube-profile"
					url: "http://gdata.youtube.com/feeds/api/playlists/PLYVl5EnzwqsQs0tBLO6ug6WbqAbrpVbNf?alt=json"
				#'flickr':
				#	url: "http://api.flickr.com/services/feeds/photos_public.gne?id=35776898@N00&lang=en-us&format=json"

