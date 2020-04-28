module Components.CreatePointButton exposing (createPointButton)

import Svg exposing (Svg)
import Svg.Events as Se
import Svg.Attributes as Sa

import CustomTypes exposing (..)

import Components.InputFields exposing (..)

import Functions.BasicsPoints exposing (getSelectedPoint)

import Array

createPointButton : ShapeData -> Int -> Float -> Svg Msg
createPointButton shapeData selectedShape pointOrder =
    let point1 = getSelectedPoint shapeData pointOrder
        point2 = 
            Array.indexedMap (\index point ->
                if point.order == pointOrder then
                    Maybe.withDefault defaultPoint <| Array.get (index + 1) pointsArray
                else defaultPoint
            ) pointsArray
            |> Array.filter (\point -> point.order /= 0)
            |> Array.get 0
            |> Maybe.withDefault defaultPoint
        
        x = (point1.x + point2.x) / 2
        y = (point1.y + point2.y) / 2
        defaultPoint = PolylinePoint 0 0 0
        pointsArray = Array.fromList shapeData.points
        testOrder = (point1.order + point2.order) / 2

        -- pointOrders =
        --     Array.fromList <| List.map (\point -> point.order) shapeData.points
    in
    if shapeData.id == selectedShape then
        Svg.circle 
            [ Sa.cx <| String.fromFloat x
            , Sa.cy <| String.fromFloat y
            , Sa.r "5", Sa.fill "#cae8d5"
            , Se.onMouseDown <| AddNewPoint testOrder
            ] []
    else Svg.g [] []
