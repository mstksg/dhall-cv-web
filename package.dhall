let types = ./types.dhall ∧ (./prelude.dhall).cv.types

let functor = (./prelude.dhall).cv.functor

let xml = (./prelude.dhall).xml

let layout = ./layout.dhall

let fullRender =
      λ(markdownToHtml : Text → Text) →
      λ(conf : types.WebConfig) →
      λ(rconf : types.RenderConfig) →
      λ(p : types.CVPage types.Markdown) →
          layout.renderPage
            conf
            rconf
            ( layout.page
                conf
                ( functor.CVPage.map
                    types.Markdown
                    xml.Type
                    ( λ(md : types.Markdown) →
                        xml.rawText (markdownToHtml md.rawMarkdown)
                    )
                    p
                )
            )
        : xml.Type

in  { types = ./types.dhall
    , layout
    , fullRender
    , fullRenderAsText =
        λ(markdownToHtml : Text → Text) →
        λ(conf : types.WebConfig) →
        λ(rconf : types.RenderConfig) →
        λ(p : types.CVPage types.Markdown) →
          ''
          <!DOCTYPE html>
          ${xml.render (fullRender markdownToHtml conf rconf p)}
          ''
    }
