module Components exposing (..)

import Html exposing (Html)
import Html.Events as He
import Html.Attributes as Ha
import Html.Events.Extra.Mouse as Mouse

import Svg exposing (Svg)
import Svg.Events as Se
import Svg.Attributes as Sa

import CustomTypes exposing (..)
import ResizeHandles exposing (..)
import HelperFunctions exposing (pointsToString, getSelectedPoint)

import Array

shapeEvents shapeData =
    Svg.g 
        [ Se.onMouseDown <| EditShape { shapeData | followMouse = True }
        , Se.onMouseUp <| EditShape { shapeData | followMouse = False }
        ]

customRect : ShapeData -> Int -> Svg Msg
customRect shapeData selectedShape =
    let p = shapeProps shapeData 
    in
    Svg.g []
        [ shapeEvents shapeData
            [ Svg.rect 
                [ Sa.x <| String.fromFloat p.xPos, Sa.y <| String.fromFloat p.yPos
                , Sa.width <| String.fromFloat p.width, Sa.height <| String.fromFloat p.height
                , Sa.fill shapeData.fillColor
                , Sa.strokeWidth <| String.fromFloat shapeData.strokeWidth
                , Sa.stroke shapeData.strokeColor
                ] []
            ]
        , changeSizeHandle shapeData selectedShape
        , changeWidthHandle shapeData selectedShape
        , changeHeightHandle shapeData selectedShape
        ]

customEllipse : ShapeData -> Int -> Svg Msg
customEllipse shapeData selectedShape =
    let p = shapeProps shapeData 
    in
    Svg.g []
        [ shapeEvents shapeData
            [ Svg.ellipse
                [ Sa.cx <| String.fromFloat p.xPos, Sa.cy <| String.fromFloat p.yPos
                , Sa.rx <| String.fromFloat p.width, Sa.ry <| String.fromFloat p.height
                , Sa.fill shapeData.fillColor
                , Sa.strokeWidth <| String.fromFloat shapeData.strokeWidth
                , Sa.stroke shapeData.strokeColor
                ] []
            ]
        , changeSizeHandle shapeData selectedShape
        , ellipseWidthHandle shapeData selectedShape
        , ellipseHeightHandle shapeData selectedShape
        ]

customPolyline shapeData selectedShape =
    let strokeWidth = String.fromFloat shapeData.strokeWidth
        -- p = shapeProps shapeData
        -- x = String.fromFloat p.xPos
        -- y = String.fromFloat p.yPos

        -- selectedPoint = getSelectedPoint shapeData
    in
    Svg.g []
        [ shapeEvents shapeData
            [ Svg.polyline
                [ Sa.points <| pointsToString shapeData.points
                , Sa.fill shapeData.fillColor
                , Sa.style <| "fill:none;stroke-width:" ++ strokeWidth
                , Sa.stroke shapeData.strokeColor
                -- , Sa.transform <| "translate(" ++ x ++ " " ++ y ++ ")"
                ] []
            ]
        , Svg.g [] 
            <| List.map (\point -> polylineHandle shapeData selectedShape point.order) shapeData.points
        , Svg.g [] 
            <| List.map (\point -> 
                    createPointButton shapeData selectedShape point.order) 
            <| List.filter (\point -> point.order /= 2) shapeData.points
        ]

inputDataFields : Model -> Html Msg
inputDataFields model =
    Html.div [] 
        [ customInputField Xpos model.inputShapeData.xPos "x"
        , customInputField Ypos model.inputShapeData.yPos "y"
        , customInputField Width model.inputShapeData.width "width"
        , customInputField Height model.inputShapeData.height "height"
        , customInputField StrokeWidth model.inputShapeData.strokeWidth "stroke-width"
        , customInputField Zindex model.inputShapeData.zIndex "z-index"
        , customInputField FillColor model.inputShapeData.fillColor "fill-color"
        , customInputField StrokeColor model.inputShapeData.strokeColor "stroke-color"
        , customInputField Points model.inputShapeData.points "points"
        ]

customInputField : InputProperty -> String -> String -> Html Msg
customInputField property whatValue text =
    Html.div [] 
        [ Html.text <| text ++ ": "
        , Html.input [ Ha.value whatValue, He.onInput <| InputData property ] []
        ]

newShapeButton : ShapeType -> String -> Html Msg
newShapeButton shapeType text =
    Html.button [ He.onClick <| NewShape shapeType ] [ Html.text text ]

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
        pointOrders =
            Array.fromList <| List.map (\point -> point.order) shapeData.points
    in
    if shapeData.id == selectedShape then
        Svg.circle 
            [ Sa.cx <| String.fromFloat x
            , Sa.cy <| String.fromFloat y
            , Sa.r "10", Sa.fill "green"
            , Se.onClick <| AddNewPoint testOrder
            ] []
    else Svg.g [] []