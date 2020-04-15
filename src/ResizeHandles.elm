module ResizeHandles exposing (..)

import Svg exposing (Svg)
import Svg.Events as Se
import Svg.Attributes as Sa

import CustomTypes exposing (..)

import Array
shapeProps shapeData =
    { xPos = Tuple.first shapeData.position
    , yPos = Tuple.second shapeData.position
    , width = Tuple.first shapeData.size
    , height = Tuple.second shapeData.size
    }

changeSizeHandle : ShapeData -> Int -> Svg Msg
changeSizeHandle shapeData selectedShape =
    let p = shapeProps shapeData 
    in
    handle 
        shapeData selectedShape 
        (p.xPos + p.width - 10) 
        (p.yPos + p.height - 10) 
        True True


changeWidthHandle : ShapeData -> Int -> Svg Msg
changeWidthHandle shapeData selectedShape =
    let p = shapeProps shapeData 
    in
    handle 
        shapeData selectedShape 
        (p.xPos + p.width - 10) 
        (p.yPos + p.height / 2 - 10) 
        True False

changeHeightHandle : ShapeData -> Int -> Svg Msg
changeHeightHandle shapeData selectedShape =
    let p = shapeProps shapeData 
    in
    handle 
        shapeData selectedShape 
        (p.xPos + p.width / 2 - 10) 
        (p.yPos + p.height - 10) 
        False True


handle shapeData selectedShape x y bool1 bool2=
    if shapeData.id == selectedShape then
        Svg.rect 
            [ Sa.x <| String.fromFloat x
            , Sa.y <| String.fromFloat y
            , Sa.width "20", Sa.height "20", Sa.fill "yellow" 
            , Se.onMouseDown <| EditShape { shapeData | updateSize = (bool1, bool2) }
            ] []
    else Svg.g [] []

ellipseHeightHandle shapeData selectedShape =
    let p = shapeProps shapeData 
    in
    handle 
        shapeData selectedShape 
        (p.xPos - 10) 
        (p.yPos + p.height - 10) 
        False True

ellipseWidthHandle shapeData selectedShape =
    let p = shapeProps shapeData 
    in
    handle 
        shapeData selectedShape 
        (p.xPos + p.width - 10) 
        (p.yPos - 10) 
        True False

polylineHandle : ShapeData -> Int -> Int -> Svg Msg
polylineHandle shapeData selectedShape pointsToHandle =
    let pointsArray = Array.fromList shapeData.points
        currentPoints = Maybe.withDefault [0, 0] <| Array.get pointsToHandle pointsArray
        pth = Array.fromList currentPoints
    in
    if shapeData.id == selectedShape then
        Svg.circle 
            [ Sa.cx <| String.fromFloat <| Maybe.withDefault 0 <| Array.get 0 pth
            , Sa.cy <| String.fromFloat <| Maybe.withDefault 0 <| Array.get 1 pth
            , Sa.r "10", Sa.fill "yellow" 
            , Se.onMouseDown <| EditShape { shapeData | updatePoints = Just pointsToHandle }
            ] []
    else Svg.g [] []