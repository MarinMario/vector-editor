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
                ] []
            ]
        , changeSizeHandle shapeData selectedShape
        , changeWidthHandle shapeData selectedShape
        , changeHeightHandle shapeData selectedShape
        ]

inputDataFields : Model -> Html Msg
inputDataFields model =
    Html.div [] 
        [ customInputField model.inputShapeData.xPos "xPos"
        , customInputField model.inputShapeData.yPos "yPos"
        , customInputField model.inputShapeData.width "width"
        , customInputField model.inputShapeData.height "height"
        , customInputField model.inputShapeData.fillColor "fillColor"
        ]

customInputField whatValue sameButString =
    Html.div [] 
        [ Html.text <| sameButString ++ ": "
        , Html.input [ Ha.value whatValue, He.onInput <| InputData sameButString ] []
        ]



newShapeButton : ShapeType -> String -> Html Msg
newShapeButton shapeType text =
    Html.button [ He.onClick <| NewShape shapeType ] [ Html.text text ]