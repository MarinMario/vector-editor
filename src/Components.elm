module Components exposing (..)

import Html exposing (Html)
import Html.Events as He
import Html.Attributes as Ha

import Svg exposing (Svg)
import Svg.Events as Se
import Svg.Attributes as Sa

import CustomTypes exposing (..)
import ResizeHandles exposing (..)
import HelperFunctions exposing (pointsToString, getSelectedPoint, shapeProps)

import Array

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
                [ Sa.points <| pointsToString shapeData
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

        -- pointOrders =
        --     Array.fromList <| List.map (\point -> point.order) shapeData.points
    in
    if shapeData.id == selectedShape then
        Svg.circle 
            [ Sa.cx <| String.fromFloat x
            , Sa.cy <| String.fromFloat y
            , Sa.r "10", Sa.fill "green"
            , Se.onMouseDown <| AddNewPoint testOrder
            ] []
    else Svg.g [] []

hoverEventContainer shapeData =
    Svg.g
        [ Se.onMouseOver <| EditShape { shapeData | hovered = True } 
        , Se.onMouseOut <| EditShape { shapeData | hovered = False }
        ]

convertDataToSvg model =
    let orderedData =
            List.sortBy .zIndex model.shapes
    in
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
    ) orderedData