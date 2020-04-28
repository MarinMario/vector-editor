module View exposing (view)

import Html exposing (Html)
import Html.Events as He
import Html.Attributes as Ha
import Html.Events.Extra.Mouse as Mouse

import Svg exposing (Svg)
import Svg.Attributes as Sa

import CustomTypes exposing (..)

import Components.Menu exposing (menu)
import Components.SvgArea exposing (svgArea)


view : Model -> Html Msg
view model =
    Html.div 
        [ He.onMouseUp StopDrag, Ha.class "app"
        , Mouse.onMove (\event -> MoveMouse event.clientPos)
        ]
        [ svgArea model
        , menu model
        ]

