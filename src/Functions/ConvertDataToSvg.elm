module Functions.ConvertDataToSvg exposing (convertDataToSvg)

import Svg exposing (Svg)

import CustomTypes exposing (ShapeType(..), Model, Msg(..))

import Components.CustomShapes exposing (..)

import Functions.BasicsShape exposing (orderShapes)

convertDataToSvg : Model -> List (Svg Msg)
convertDataToSvg model =
    List.map (\shapeData -> 
        case shapeData.shapeType of
            Rect ->
                customRect shapeData model.selectedShape
            Ellipse -> 
                customEllipse shapeData model.selectedShape
            Polyline ->
                customPolyline shapeData model.selectedShape Svg.polyline
            Polygon ->
                customPolyline shapeData model.selectedShape Svg.polygon
            Label ->
                customLabel shapeData model.selectedShape
    ) <| orderShapes model.shapes