-- |
-- this omits the <!DOCTYPE html>
--
-- renderPage
--     :: Config
--     -> String       -- ^ Image URL
--     -> [Text]       -- ^ CSS links
--     -> H.Html       -- ^ Body
--     -> H.Html
-- renderPage Config{..} img css body = H.docTypeHtml $ do
--     H.head $ do

--       mapM_ googleAnalyticsJs confGA

--       H.title $ H.toHtml confName
--       H.meta ! A.name "description" ! A.content (H.textValue confDesc)

--       H.meta ! A.httpEquiv "Content-Type" ! A.content "text/html;charset=utf-8"
--       H.meta ! A.name "viewport" ! A.content "width=device-width,initial-scale=1.0"

--       viewOpenGraphMetas

--       H.link
--         ! A.href (H.textValue "/favicon.ico")
--         ! A.rel "shortcut icon"

--       forM_ css $ \u ->
--         H.link ! A.href (H.textValue u) ! A.rel "stylesheet" ! A.type_ "text/css"

--     H.body $
--       H.div ! A.id "body-container" ! A.class_ "container" $
--         H.div ! A.id "main-container" ! A.class_ "grid" $
--           body
let xml = (../prelude.dhall).xml

let list = (../prelude.dhall).list

let util = (../prelude.dhall).util

let types = (../prelude.dhall).cv.types ∧ ../types.dhall

let nodeId =
      λ(name : Text) →
      λ(id : Text) →
      λ(class : Text) →
      λ(content : List xml.Type) →
        xml.element
          { name
          , attributes = [ xml.attribute "id" id, xml.attribute "class" class ]
          , content
          }

in  λ(conf : types.WebConfig) →
    λ(rconf : types.RenderConfig) →
    λ(body : List xml.Type) →
        util.node
          "html"
          (None Text)
          [ util.node
              "head"
              (None Text)
              (   util.optionalListMany
                    Text
                    xml.Type
                    ./util/googleAnalytics.dhall
                    conf.googleAnalytics
                # [ util.meta "title" conf.name
                  , util.meta "description" conf.desc
                  , xml.element
                      { name = "meta"
                      , attributes =
                        [ xml.attribute "httpEquiv" "Content-Type"
                        , xml.attribute "content" "text/html;charset=utf-8"
                        ]
                      , content = [] : List xml.Type
                      }
                  , util.meta "viewport" "width=device-width,initial-scale=1.0"
                  , xml.element
                      { name = "link"
                      , attributes =
                        [ xml.attribute "href" "/favicon.ico"
                        , xml.attribute "rel" "shortcut icon"
                        ]
                      , content = [] : List xml.Type
                      }
                  ]
                # ./util/openGraphMetas.dhall conf rconf.photoImport
                # list.map
                    Text
                    xml.Type
                    ( λ(c : Text) →
                        xml.element
                          { name = "link"
                          , attributes =
                            [ xml.attribute "href" c
                            , xml.attribute "rel" "stylesheet"
                            , xml.attribute "type" "text/css"
                            ]
                          , content = [] : List xml.Type
                          }
                    )
                    rconf.cssImports
              )
          , util.node
              "body"
              (None Text)
              [ nodeId
                  "div"
                  "body-container"
                  "container"
                  [ nodeId "div" "main-container" "grid" body ]
              ]
          ]
      : xml.Type
