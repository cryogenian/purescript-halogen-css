module Halogen.HTML.CSS.Indexed where

import Unsafe.Coerce (unsafeCoerce)

import Css.Stylesheet (Css())

import Halogen.HTML.Elements.Indexed (NoninteractiveNode())
import Halogen.HTML.Properties.Indexed (IProp(), I())
import qualified Halogen.HTML.CSS as CSS

style :: forall i r. Css -> IProp (style :: I | r) i
style = unsafeCoerce CSS.style

stylesheet :: forall p i. Css -> NoninteractiveNode (media :: I, onError :: I, onLoad :: I, scoped :: I, mediaType :: I) p i
stylesheet = unsafeCoerce CSS.stylesheet
