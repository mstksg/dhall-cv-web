-- |
-- cvPage :: Config -> CVPage H.Html -> H.Html
-- cvPage cfg CVPage{..} = do
--     H.header ! A.class_ "grid__col grid__col--6-of-6" $ do
--       H.h1 $ H.toHtml cvpTitle
--       mapM_ (H.h2 . H.toHtml) cvpSubtitle
--       H.div ! A.class_ "links" $
--         cvpLinks
--     H.div ! A.class_ "cvpage" $
--       mapM_ (cvSection cfg) cvpSections
let xml = (../prelude.dhall).xml

let list = (../prelude.dhall).list

let util = (../prelude.dhall).util

let types = (../prelude.dhall).cv.types ∧ ../types.dhall

in  λ(conf : types.WebConfig) →
    λ(page : types.CVPage xml.Type) →
        [ util.node
            "header"
            (Some "grid__col grid__col--6-of-6")
            (   [ util.node "h1" (None Text) [ xml.text page.title ] ]
              # util.optionalList
                  Text
                  xml.Type
                  ( λ(subtitle : Text) →
                      util.node "h2" (None Text) [ xml.text subtitle ]
                  )
                  page.subtitle
              # [ util.node "div" (Some "links") [ page.links ] ]
            )
        , util.node
            "div"
            (Some "cvpage")
            ( list.map
                (types.CVSection xml.Type)
                xml.Type
                (./section.dhall conf)
                page.sections
            )
        ]
      : List xml.Type
