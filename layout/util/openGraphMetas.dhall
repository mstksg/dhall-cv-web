-- |
-- viewOpenGraphMetas = do
--     H.meta
--       ! H.customAttribute "property" "og:site_name"
--       ! A.content (H.textValue confName)
--     H.meta
--       ! H.customAttribute "property" "og:description"
--       ! A.content (H.textValue confDesc)
--     H.meta
--       ! H.customAttribute "property" "og:type"
--       ! A.content "website"
--     H.meta
--       ! H.customAttribute "property" "og:title"
--       ! A.content (H.textValue confName)
--     H.meta
--       ! H.customAttribute "property" "og:image"
--       ! A.content (H.textValue img')
--     H.meta
--       ! H.customAttribute "property" "og:locale"
--       ! A.content "en_US"
--     H.meta
--       ! H.customAttribute "property" "og:url"
--       ! A.content (H.textValue (T.pack confHostBase))
--
--     H.meta
--       ! A.name "twitter:card"
--       ! A.content "summary"
--     H.meta
--       ! A.name "twitter:title"
--       ! A.content (H.textValue confName)
--     H.meta
--       ! A.name "twitter:description"
--       ! A.content (H.textValue confDesc)
--     H.meta
--       ! A.name "twitter:image"
--       ! A.content (H.textValue img')
--     forM_ confTwitter $ \t -> do
--       H.meta
--         ! A.name "twitter:site"
--         ! A.content (H.textValue (T.pack t))
--       H.meta
--         ! A.name "twitter:creator"
--         ! A.content (H.textValue (T.pack t))
let prelude = ../../prelude.dhall

let types = ../../types.dhall

let list = prelude.list

let xml = prelude.xml

let util = prelude.util

let ogMeta = λ(prop : Text) → util.meta ("og:" ++ prop)

let twitterMeta = λ(prop : Text) → util.meta ("twitter:" ++ prop)

in  λ(conf : types.WebConfig) →
    λ(img : Text) →
        list.map
          { mapKey : Text, mapValue : Text }
          xml.Type
          ( λ(kv : { mapKey : Text, mapValue : Text }) →
              ogMeta kv.mapKey kv.mapValue
          )
          ( toMap
              { site_name = conf.name
              , description = conf.desc
              , type = "website"
              , title = conf.name
              , image = conf.hostBase ++ "/" ++ img
              , locale = "en_US"
              , url = conf.hostBase
              }
          )
      # list.map
          { mapKey : Text, mapValue : Text }
          xml.Type
          ( λ(kv : { mapKey : Text, mapValue : Text }) →
              twitterMeta kv.mapKey kv.mapValue
          )
          ( toMap
              { card = "summary"
              , title = conf.name
              , description = conf.desc
              , image = conf.hostBase ++ "/" ++ img
              , locale = "en_US"
              , url = conf.hostBase
              }
          )
      # util.optionalListManyXML
          Text
          (λ(t : Text) → [ twitterMeta "site" t, twitterMeta "creator" t ])
          conf.twitter
