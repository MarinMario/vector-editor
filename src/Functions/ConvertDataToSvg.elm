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
                customRect shapeData model
            Ellipse -> 
                customEllipse shapeData model
            Polyline ->
                customPolyline shapeData model Svg.polyline
            Polygon ->
                customPolyline shapeData model Svg.polygon
            Label ->
                customLabel shapeData model
    ) <| orderShapes model.shapes