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

import Functions.CustomEvents exposing (onRightClick)

view : Model -> Html Msg
view model =
    Html.div 
        [ Ha.class "app"
        , Mouse.onMove (\event -> MoveMouse event.clientPos)
        , He.onMouseUp StopDrag
        ]
        [ svgArea model
        , menu model
        ]

