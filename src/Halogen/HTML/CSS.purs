-- | This module defines an adapter between the `purescript-halogen` and
-- | `purescript-css` libraries.
module Halogen.HTML.CSS
  ( style
  , stylesheet
  ) where

import Prelude

import Data.Array (mapMaybe)
import Data.Either (Either(), either)
import Data.List (toUnfoldable, fromFoldable)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String (joinWith)
import Data.StrMap as SM
import Data.Tuple (Tuple(..))

import CSS.Property (Key(), Value())
import CSS.Render (render, renderedSheet, collect)
import CSS.Stylesheet (CSS(), Rule(..), runS)

import Halogen.HTML as H
import Halogen.HTML.Core (HTML(), Prop(), class IsProp, prop, propName, attrName)
import Halogen.HTML.Properties as P

-- | A newtype for CSS styles
newtype Styles = Styles (SM.StrMap String)

-- | Unpack CSS styles
runStyles :: Styles -> SM.StrMap String
runStyles (Styles m) = m

instance stylesIsProp :: IsProp Styles where
  toPropString _ _ (Styles m) = joinWith "; " $ (\(Tuple key value) -> key <> ": " <> value) <$> toUnfoldable (SM.toList m)

-- | Render a set of rules as an inline style.
-- |
-- | For example:
-- |
-- | ```purescript
-- | H.div [ CSS.style do color red
-- |                      display block ]
-- |       [ ... ]
-- | ```
style :: forall i. CSS -> Prop i
style = prop (propName "style") (Just $ attrName "style") <<< Styles <<< rules <<< runS
  where
  rules :: Array Rule -> SM.StrMap String
  rules rs = SM.fromList (fromFoldable properties)
    where
    properties :: Array (Tuple String String)
    properties = mapMaybe property rs >>= collect >>> rights

  property :: Rule -> Maybe (Tuple (Key Unit) Value)
  property (Property k v) = Just (Tuple k v)
  property _              = Nothing

  rights :: forall a b. Array (Either a b) -> Array b
  rights = mapMaybe (either (const Nothing) Just)

-- | Render a set of rules as a `style` element.
stylesheet :: forall p i. CSS -> HTML p i
stylesheet css = H.style [ P.type_ "text/css" ] [ H.text content ]
  where
  content = fromMaybe "" $ renderedSheet $ render css
