-- |
-- googleAnalyticsJs :: String -> H.Html
-- googleAnalyticsJs aId = do
--     H.script ! A.async "" ! A.src (H.textValue scriptLink) $ pure ()
--     H.script $
--       H.toHtml $
--         T.unlines
--           [ "  window.dataLayer = window.dataLayer || [];"
--           , "  function gtag(){dataLayer.push(arguments);}"
--           , "  gtag('js', new Date());"
--           , ""
--           , T.pack $ [P.s|  gtag('config', '%s');|] aId
--           ]
--   where
--     scriptLink = T.pack $
--       [P.s|https://www.googletagmanager.com/gtag/js?id=%s|] aId
let prelude = ../../prelude.dhall

let xml = prelude.xml

let util = prelude.util

in  λ(aId : Text) →
        [ xml.element
            { name = "script"
            , attributes = toMap
                { async = ""
                , src = "https://www.googletagmanager.com/gtag/js?id=" ++ aId
                }
            , content = [] : List xml.Type
            }
        , xml.element
            { name = "script"
            , attributes = xml.emptyAttributes
            , content =
              [ xml.text
                  ''
                  window.dataLayer = window.dataLayer || [];
                  function gtag(){dataLayer.push(arguments);}
                  gtag('js', new Date());
                  gtag('config', ${aId});
                  ''
              ]
            }
        ]
      : List xml.Type
