module Components.CustomShapes exposing (..)

import Html exposing (Html)
import Html.Events as He
import Html.Attributes as Ha

import Svg exposing (Svg)
import Svg.Events as Se
import Svg.Attributes as Sa

import CustomTypes exposing (..)
import Components.Handles exposing (..)

import Functions.BasicsShape exposing (shapeProps)
import Functions.BasicsPoints exposing (convertPointsToString)

import Components.CreatePointButton exposing (createPointButton)

hoverEventContainer shapeData =
    Svg.g
        [ Se.onMouseOver <| EditShape { shapeData | hovered = True } 
        , Se.onMouseOut <| EditShape { shapeData | hovered = False }
        ]

customRect : ShapeData -> Int -> Svg Msg
customRect shapeData selectedShape =
    let p = shapeProps shapeData 
    in
    Svg.g []
        [ hoverEventContainer shapeData
            [ Svg.rect 
                [ Sa.x <| String.fromFloat p.xPos, Sa.y <| String.fromFloat p.yPos
                , Sa.width <| String.fromFloat p.width, Sa.height <| String.fromFloat p.height
                , Sa.fill shapeData.fillColor
                , Sa.strokeWidth <| String.fromFloat shapeData.strokeWidth
                , Sa.stroke shapeData.strokeColor
                , He.onMouseDown <| InputSelectedShape shapeData.id
                ] []
            ]
        , rectHandles shapeData selectedShape
        , moveHandle shapeData selectedShape (p.width / 2) ( p.height / 2)
        ]

customEllipse : ShapeData -> Int -> Svg Msg
customEllipse shapeData selectedShape =
    let p = shapeProps shapeData 
    in
    Svg.g []
        [ hoverEventContainer shapeData
            [ Svg.ellipse
                [ Sa.cx <| String.fromFloat p.xPos, Sa.cy <| String.fromFloat p.yPos
                , Sa.rx <| String.fromFloat p.width, Sa.ry <| String.fromFloat p.height
                , Sa.fill shapeData.fillColor
                , Sa.strokeWidth <| String.fromFloat shapeData.strokeWidth
                , Sa.stroke shapeData.strokeColor
                , He.onMouseDown <| InputSelectedShape shapeData.id
                ] []
            ]
        , ellipseHandles shapeData selectedShape
        , moveHandle shapeData selectedShape 0 0
        ]

customPolyline shapeData selectedShape polytype =
    let strokeWidth = String.fromFloat shapeData.strokeWidth
    in
    Svg.g []
        [ hoverEventContainer shapeData
            [ polytype
                [ Sa.points <| convertPointsToString shapeData
                , Sa.fill shapeData.fillColor
                , Sa.style <| "fill:" ++ shapeData.fillColor ++ ";stroke-width:" ++ strokeWidth
                , Sa.stroke shapeData.strokeColor
                -- , Sa.transform <| "translate(" ++ x ++ " " ++ y ++ ")"
                , He.onClick <| InputSelectedShape shapeData.id
                ] []
            ]
        , Svg.g [] 
            <| List.map (\point -> polylineHandle shapeData selectedShape point.order) shapeData.points
        , Svg.g []
            <| List.map (\point -> 
                    createPointButton shapeData selectedShape point.order) 
            <| List.take (List.length shapeData.points - 1) shapeData.points
        -- , moveHandle shapeData
        ]

customLabel shapeData selectedShape =
    let p = shapeProps shapeData
        x = String.fromFloat p.xPos
        y = String.fromFloat p.yPos
        w = String.fromFloat p.width
        sw = String.fromFloat p.strokeWidth
    in
    Svg.g []
        [ hoverEventContainer shapeData
            [ Svg.text_ 
                [ Sa.x x, Sa.y y, Sa.fill shapeData.fillColor
                , Sa.fontSize <| w ++ "px"
                , Sa.stroke shapeData.strokeColor, Sa.strokeWidth sw
                , He.onMouseDown <| InputSelectedShape shapeData.id
                ] 
                [ Svg.text shapeData.labelText ]
            ]
        , moveHandle shapeData selectedShape -10 -10
        , changeWidthHandle shapeData selectedShape
        ]
