dhall-cv-web
==============

HTML generation for my dhall cv system in <https://github.com/mstksg/dhall-cv>.
Uses the XML library in dhall prelude, but care must be taken to ensure that
XML's self-closing tags are not invoked.

The full ecosystem:

*   Base types for CV data: <https://github.com/mstksg/dhall-cv>
*   Render in latex for pdf: <https://github.com/mstksg/dhall-cv-latex>
*   Render in HTML for web: <https://github.com/mstksg/dhall-cv-web>
*   Actual CV data (using base types): <https://github.com/mstksg/dhall-cv-personal>
*   Build system (using Shake) for assembling static website:
    <https://github.com/mstksg/cv-static> (live at <https://cv.jle.im>)
