let xml =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v22.0.0/Prelude/XML/package.dhall
        sha256:2e111f0952087d42072b059f0bf4c95861a46bffa67ad4c8c39086edf405f32e

let text =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v22.0.0/Prelude/Text/package.dhall
        sha256:79b671a70ac459b799a53bbb8a383cc8b81b40421745c54bf0fb1143168cbd6f

let util =
      { node =
          λ(name : Text) →
          λ(cls : Optional Text) →
          λ(content : List xml.Type) →
            xml.element
              { name
              , attributes =
                  merge
                    { Some = λ(c : Text) → [ xml.attribute "class" c ]
                    , None = xml.emptyAttributes
                    }
                    cls
              , content
              }
      , meta =
          λ(prop : Text) →
          λ(content : Text) →
            xml.element
              { name = "meta"
              , attributes =
                [ xml.attribute "name" prop, xml.attribute "content" content ]
              , content = [] : List xml.Type
              }
      , fromMarkdown = xml.text
      , optionalList =
          λ(a : Type) →
          λ(b : Type) →
          λ(f : a → b) →
          λ(o : Optional a) →
            merge { Some = λ(x : a) → [ f x ], None = [] : List b } o
      , optionalListMany =
          λ(a : Type) →
          λ(b : Type) →
          λ(f : a → List b) →
          λ(o : Optional a) →
            merge { Some = λ(x : a) → f x, None = [] : List b } o
      , optionalListXML =
          λ(a : Type) →
          λ(f : a → xml.Type) →
          λ(o : Optional a) →
            merge { Some = λ(x : a) → [ f x ], None = [ xml.rawText " " ] } o
      , optionalListManyXML =
          λ(a : Type) →
          λ(f : a → List xml.Type) →
          λ(o : Optional a) →
            merge { Some = λ(x : a) → f x, None = [ xml.rawText " " ] } o
      , snaker = λ(t : Text) → text.lowerASCII (Text/replace " " "-" t)
      }

in  { cv =
        https://github.com/mstksg/dhall-cv/raw/v2.3.0/package.dhall
          sha256:0faa0f7a67a124d97790fd3535eadf09d7e845ae618b72999655384adbb0822c
    , text
    , optional =
        https://raw.githubusercontent.com/dhall-lang/dhall-lang/v22.0.0/Prelude/Optional/package.dhall
          sha256:37b84d6fe94c591d603d7b06527a2d3439ba83361e9326bc7b72517c7dc54d4e
    , list =
        https://raw.githubusercontent.com/dhall-lang/dhall-lang/v22.0.0/Prelude/List/package.dhall
          sha256:9354d34f85346a9bfc486e3454b0368c48d7021d926832943ae3f423bce64f83
    , function =
        https://raw.githubusercontent.com/dhall-lang/dhall-lang/v22.0.0/Prelude/Function/package.dhall
          sha256:6d17cf0fd4fabe1737fb117f87c04b8ff82b299915a5b673c0a543b134b8fffe
    , xml
    , util
    }
