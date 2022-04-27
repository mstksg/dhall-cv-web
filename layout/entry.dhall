-- |
-- cvEntry
--     :: CVEntry H.Html
--     -> H.Html
-- cvEntry CVEntry{..} = do
--     H.div ! A.class_ "cventry-heading" $ do
--       H.span ! A.class_ "cventry-title" $
--         H.toMarkup cveTitle
--       mapM_ ((H.span ! A.class_ "cventry-institution") . H.toMarkup) cveInstitution
--       mapM_ ((H.span ! A.class_ "cventry-location") . H.toMarkup) cveLocation
--       mapM_ ((H.span ! A.class_ "cventry-grade") . H.toMarkup) cveGrade
--     H.div ! A.class_ "cventry-body" $
--       sequence_ cveBody
let xml = (../prelude.dhall).xml

let util = (../prelude.dhall).util

let types = (../prelude.dhall).cv.types

let list = (../prelude.dhall).list

let function = (../prelude.dhall).function

let optionalSpan =
      λ(c : Text) →
        util.optionalList
          Text
          xml.Type
          ( λ(t : Text) →
              util.node "span" (Some ("cventry-" ++ c)) [ xml.text t ]
          )

in  λ(e : types.CVEntry xml.Type) →
        [ util.node
            "div"
            (Some "cventry-heading")
            ( list.concat
                xml.Type
                [ [ util.node "span" (Some "cventry-title") [ xml.text e.title ]
                  ]
                , optionalSpan "institution" e.institution
                , optionalSpan "location" e.location
                , optionalSpan "grade" e.grade
                ]
            )
        , util.node
            "div"
            (Some "cventry-body")
            ( util.optionalList
                xml.Type
                xml.Type
                (function.identity xml.Type)
                e.body
            )
        ]
      : List xml.Type
