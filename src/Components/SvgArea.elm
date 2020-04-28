module Components.SvgArea exposing (svgArea)

import Svg exposing (Svg)
import Svg.Attributes as Sa

import CustomTypes exposing (Model, Msg)

import Components.Handles exposing (svgHandle)

import Functions.ConvertDataToSvg exposing (convertDataToSvg)

svgArea : Model -> Svg Msg
svgArea model =
    let width = String.fromFloat model.svgProps.width
        height = String.fromFloat model.svgProps.height
    in
    Svg.svg 
        [ Sa.width width, Sa.height height
        , Sa.class "canvas"
        ] 
        [ Svg.g [] <| convertDataToSvg model
        , svgHandle model "True"
        ]
