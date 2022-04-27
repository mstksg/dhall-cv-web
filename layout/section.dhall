-- |
-- cvSection
--     :: Config
--     -> CVSection H.Html
--     -> H.Html
-- cvSection Config{..} CVSection{..} = titler (H.div ! A.class_ "cvsection cvs-cols") $ do
--     H.div ! A.class_ "grid__col grid__col--1-of-8 cvsection-pretitle" $
--       forM_ titleName $ \t ->
--         H.a ! A.href (H.textValue . T.pack $ confHostBase </> T.unpack ("#" <> t)) $
--           "#"
--     H.div ! A.class_ "grid__col grid__col--7-of-8 cvsection-title" $
--       mapM_ (H.h3 . H.toHtml) cvsTitle
--     H.div ! A.class_ "cvsection-contents" $
--       mapM_ cvContents cvsContents
--   where
--     titleName = ("section-" <>) . snaker <$> cvsTitle
--     titler = case titleName of
--       Nothing -> id
--       Just t  -> (! A.id (H.textValue t))
--
-- snaker :: Text -> Text
-- snaker = T.intercalate "-" . T.words . T.toLower
let xml = (../prelude.dhall).xml

let optional = (../prelude.dhall).optional

let util = (../prelude.dhall).util

let types = (../prelude.dhall).cv.types ∧ ../types.dhall

in  λ(conf : types.WebConfig) →
    λ(sec : types.CVSection xml.Type) →
      let titleName =
            optional.map
              Text
              Text
              (λ(title : Text) → "section-" ++ util.snaker title)
              sec.title

      in    xml.element
              { name = "div"
              , attributes =
                    [ xml.attribute "class" "cvsection cvs-cols" ]
                  # util.optionalList
                      Text
                      { mapKey : Text, mapValue : Text }
                      (λ(t : Text) → xml.attribute "id" t)
                      titleName
              , content =
                [ util.node
                    "div"
                    (Some "grid__col grid__col--1-of-8 cvsection-pretitle")
                    ( util.optionalList
                        Text
                        xml.Type
                        ( λ(title : Text) →
                            xml.element
                              { name = "a"
                              , attributes =
                                [ xml.attribute
                                    "href"
                                    (conf.hostBase ++ "/#" ++ title)
                                ]
                              , content = [ xml.text "#" ]
                              }
                        )
                        titleName
                    )
                ]
              }
          : xml.Type