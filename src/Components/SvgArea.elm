module Components.SvgArea exposing (svgArea)

import Svg exposing (Svg)
import Svg.Events as Se
import Svg.Attributes as Sa

import CustomTypes exposing (Model, Msg(..))

import Components.Handles exposing (svgHandle)

import Functions.ConvertDataToSvg exposing (convertDataToSvg)
import Functions.CustomEvents exposing(propagationMouseDown)

svgArea : Model -> Svg Msg
svgArea model =
    let width = String.fromFloat model.svgProps.width
        height = String.fromFloat model.svgProps.height
    in
    Svg.svg 
        [ Sa.width width, Sa.height height
        , Sa.class "canvas"
        , case model.selectHover.shape of 
                Just _ -> Se.onMouseDown <| NewShape model.selectHover.shape
                Nothing -> propagationMouseDown <| (EditModel model, True)
        ] 
        [ Svg.g [] <| convertDataToSvg model
        , svgHandle model "True"
        ]
