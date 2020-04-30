module Components.InputFields exposing (..)

import Html exposing (Html)
import Html.Events as He
import Html.Attributes as Ha

import CustomTypes exposing (..)

import Json.Decode as Decode

import Functions.BasicsShape exposing (getSelectedShapeData)

inputDataFields : Model -> Html Msg
inputDataFields model =
    let constantFields =
            Html.div []
            [ customInputField StrokeWidth model.inputShapeData.strokeWidth "stroke width"
            , customInputField Zindex model.inputShapeData.zIndex "z index"
            , customInputField FillColor model.inputShapeData.fillColor "fill color"
            , customInputField StrokeColor model.inputShapeData.strokeColor "stroke color"
            ]
        xywh x y w h =
            Html.div []
                [ customInputField Xpos model.inputShapeData.xPos x
                , customInputField Ypos model.inputShapeData.yPos y
                , customInputField Width model.inputShapeData.width w
                , customInputField Height model.inputShapeData.height h
                ]
        fields =  Html.div [ Ha.class "inputFields" ]
    in
    case (getSelectedShapeData model).shapeType of
        Rect ->
            fields
                [ xywh "x" "y" "width" "height"
                , constantFields
                -- , customInputField Points model.inputShapeData.points "points"
                ]
        Ellipse -> 
            fields
                [ xywh "x" "y" "radius x" "radius y"
                , constantFields
                ]
        Polyline ->
            fields
                [ customInputField Points model.inputShapeData.points "points"
                , constantFields
                ]
        Polygon ->
            fields
                [ customInputField Points model.inputShapeData.points "points"
                , constantFields
                ]
        Label ->
            fields
                [ customInputField Xpos model.inputShapeData.xPos "x"
                , customInputField Xpos model.inputShapeData.xPos "y"
                , customInputField Width model.inputShapeData.width "size"
                , customInputField LabelText model.inputShapeData.labelText "text"
                , constantFields
                ]
        Selector -> Html.div [] []

customInputField : InputProperty -> String -> String -> Html Msg
customInputField property whatValue text =
    Html.div [ Ha.class "inputField" ] 
        [ Html.div [] [ Html.text <| text ]
        , Html.input [ Ha.value whatValue, He.onInput <| InputData property ] []
        ]
svgInputField : InputSvgProperty -> String -> String -> Html Msg
svgInputField property whatValue text =
    Html.div [ Ha.class "inputField"] 
        [ Html.div [] [ Html.text <| text ]
        , Html.input [ Ha.value whatValue, He.onInput <| InputSvgData property ] []
        ]
