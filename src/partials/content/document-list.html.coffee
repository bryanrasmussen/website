# Document List'
    div '.span7', ->
        for document in @documents
                tagg = ""
                for tag in document.tags
                    tagg = tagg + tag + " "
                
                h5 ->
                    a class: 'document-link ' + tagg, href:document.url, ->
                        strong '.document-title', property:'dc:title', ->
                            document.title
                        small '.document-date', property:'dc:date', ->
                            document.date.toDateString()
                if document.description
                    p class: 'document-description ' + tagg, property:'dc:description', ->
                        document.description
                else
                    article  class: 'postbody ' + tagg, ->
                        document.contentRenderedWithoutLayouts
            
                    
    
