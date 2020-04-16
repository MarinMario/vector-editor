module Components exposing (..)

import Html exposing (Html)
import Html.Events as He
import Html.Attributes as Ha
import Html.Events.Extra.Mouse as Mouse

import Svg exposing (Svg)
import Svg.Events as Se
import Svg.Attributes as Sa

import CustomTypes exposing (..)
import HelperFunctions exposing (pointsToString)
import ResizeHandles exposing (..)

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
        p = shapeProps shapeData
        x = String.fromFloat p.xPos
        y = String.fromFloat p.yPos
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
            <| List.indexedMap 
                (\index _ -> polylineHandle shapeData selectedShape index) shapeData.points
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