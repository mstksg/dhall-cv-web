-- |
-- cvContents
--     :: CVCol H.Html
--     -> H.Html
-- cvContents CVCol{..} = H.div ! A.class_ "cvline" $ do
--     H.div ! A.class_ "grid__col grid__col--1-of-8 cvline-desc" $
--       mapM_ (H.h4 . H.toMarkup) cvcDesc
--     H.div ! A.class_ "grid__col grid__col--7-of-8 cvline-body" $
--       case cvcBody of
--         CVLSimple x -> x
--         CVLEntry  e -> cvEntry e
let xml = (../prelude.dhall).xml

let util = (../prelude.dhall).util

let types = (../prelude.dhall).cv.types

in  λ(c : types.CVCol xml.Type) →
        util.node
          "div"
          (Some "cvline")
          [ util.node
              "div"
              (Some "grid__col grid__col--1-of-8 cvline-desc")
              ( util.optionalListXML
                  Text
                  ( λ(desc : Text) →
                      util.node "h4" (None Text) [ xml.text desc ]
                  )
                  c.desc
              )
          , util.node
              "div"
              (Some "grid__col grid__col--7-of-8 cvline-body")
              ( merge
                  { Simple = λ(b : xml.Type) → [ b ], Entry = ./entry.dhall }
                  c.body
              )
          ]
      : xml.Type
