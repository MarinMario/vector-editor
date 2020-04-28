module Components.SvgArea exposing (svgArea)

import Svg exposing (Svg)
import Svg.Attributes as Sa

import CustomTypes exposing (Model, Msg)

import Functions.ConvertDataToSvg exposing (convertDataToSvg)

svgArea : Model -> Svg Msg
svgArea model =
    let width = model.inputShapeData.svgSizeX
        height = model.inputShapeData.svgSizeY
    in
    Svg.svg 
        [ Sa.width width, Sa.height height
        , Sa.class "canvas"
        ] <| convertDataToSvg model
