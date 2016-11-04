module Halogen.HTML.CSS.Indexed where

import Unsafe.Coerce (unsafeCoerce)

import CSS.Stylesheet (CSS)

import Halogen.HTML.Elements.Indexed (NoninteractiveNode)
import Halogen.HTML.Properties.Indexed (IProp, I)
import Halogen.HTML.CSS as CSS

style
  ∷ ∀ i r. CSS → IProp (style ∷ I | r) i
style =
  unsafeCoerce CSS.style

stylesheet
  ∷ ∀ p i
  . CSS
  → NoninteractiveNode (media ∷ I, onError ∷ I, onLoad ∷ I, scoped ∷ I, mediaType ∷ I) p i
stylesheet =
  unsafeCoerce CSS.stylesheet
