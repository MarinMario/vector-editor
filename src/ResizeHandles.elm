module ResizeHandles exposing (..)

import Svg exposing (Svg)
import Svg.Events as Se
import Svg.Attributes as Sa

import Html.Events as He

import CustomTypes exposing (..)
import HelperFunctions exposing (getSelectedPoint, shapeProps)

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
            , Sa.width "20", Sa.height "20", Sa.fill "#84a9ac" 
            , Sa.rx "2", Sa.ry "2"
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

polylineHandle : ShapeData -> Int -> Float -> Svg Msg
polylineHandle shapeData selectedShape pointToHandle =
    let selectedPoint = getSelectedPoint shapeData pointToHandle
        x = String.fromFloat <| selectedPoint.x -- + Tuple.first shapeData.position
        y = String.fromFloat <| selectedPoint.y -- + Tuple.second shapeData.position
    in
    if shapeData.id == selectedShape then
        Svg.g []
            [ Svg.circle 
                [ Sa.cx x
                , Sa.cy y
                , Sa.r "10", Sa.fill "#84a9ac"
                , Se.onMouseDown <| EditShape { shapeData | updatePoint = Just pointToHandle }
                -- , Sa.transform <| "translate(" ++ x ++ " " ++ y ++ ")"
                ] []
            , Svg.rect 
                [ Sa.x <| String.fromFloat (selectedPoint.x + 15)
                , Sa.y <| String.fromFloat (selectedPoint.y- 15)
                , Sa.width "10", Sa.height "10", Sa.fill "#8b1919"
                , Sa.rx "1", Sa.ry "2"
                , He.onClick <| DeleteLinePoints pointToHandle
                ] []
            ]
    else Svg.g [] []

moveHandle : ShapeData -> Int -> Float -> Float -> Svg Msg
moveHandle shapeData selectedShape xpos ypos =
    let x = Tuple.first shapeData.position - 10 + xpos
        y = Tuple.second shapeData.position - 10 + ypos
    in
    if shapeData.hovered || shapeData.id == selectedShape then
        Svg.g [ He.onMouseDown <| InputSelectedShape shapeData.id ] 
            [ Svg.rect
                [ Sa.x <| String.fromFloat x
                , Sa.y <| String.fromFloat y
                , Sa.width "20", Sa.height "20", Sa.fill "#3b6978" 
                , Sa.rx "2", Sa.ry "2"
                , Se.onMouseDown <| EditShape { shapeData | followMouse = True }
                , He.onMouseOver <| EditShape { shapeData | hovered = True}
                , He.onMouseOut <| EditShape { shapeData | hovered = False }
                ] []
            ]
    else Svg.g [] []

ellipseHandles shapeData selectedShape =
    if shapeData.id == selectedShape then
        Svg.g [] 
            [ changeSizeHandle shapeData selectedShape
            , ellipseWidthHandle shapeData selectedShape
            , ellipseHeightHandle shapeData selectedShape
            ]
    else Svg.g [] []

rectHandles shapeData selectedShape =
    if shapeData.id == selectedShape then
        Svg.g [] 
            [ changeSizeHandle shapeData selectedShape
            , changeWidthHandle shapeData selectedShape
            , changeHeightHandle shapeData selectedShape
            ]
    else Svg.g [] []
