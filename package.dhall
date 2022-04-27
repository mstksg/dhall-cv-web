let types = ./types.dhall /\ (./prelude.dhall).cv.types

let functor = (./prelude.dhall).cv.functor

let xml = (./prelude.dhall).xml

let layout = ./layout.dhall

let fullRender =
      \(markdownToHtml : Text -> Text) ->
      \(conf : types.WebConfig) ->
      \(img : Text) ->
      \(css : List Text) ->
      \(p : types.CVPage types.Markdown) ->
          layout.renderPage
            conf
            img
            css
            ( layout.page
                conf
                ( functor.CVPage.map
                    types.Markdown
                    xml.Type
                    ( \(md : types.Markdown) ->
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
        \(markdownToHtml : Text -> Text) ->
        \(conf : types.WebConfig) ->
        \(img : Text) ->
        \(css : List Text) ->
        \(p : types.CVPage types.Markdown) ->
          ''
          <!DOCTYPE html>
          ${xml.render (fullRender markdownToHtml conf img css p)}
          ''
    }
