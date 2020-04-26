module View exposing (view)

import Html exposing (Html)
import Html.Events as He
import Html.Attributes as Ha

import Svg exposing (Svg)
import Svg.Attributes as Sa

import Html.Events.Extra.Mouse as Mouse

import Components exposing (..)
import CustomTypes exposing (..)
import HelperFunctions exposing (..)

view : Model -> Html Msg
view model =
    let shapes = convertDataToSvg model
    in
    Html.div [ He.onMouseUp StopDrag ] 
        [ Svg.svg 
            [ Sa.width "1000", Sa.height "400"
            , Ha.style "border" "solid 1px"
            , Mouse.onMove (\event -> MoveMouse event.clientPos)
            ] shapes
        , Html.br [] []
        , newShapeButton Rect "Rect"
        , newShapeButton Ellipse "Ellipse"
        , newShapeButton Polyline "Polyline"
        , Html.button [ He.onClick DeleteSelectedShapes ] [ Html.text "Delete" ]
        , Html.button [ He.onClick DuplicateSelectedShapes ] [ Html.text "Duplicate" ]
        , Html.div [] [ Html.text <| "Shape id: " ++ String.fromInt model.selectedShape ]
        , inputDataFields model
        , Html.button [ He.onClick DownloadSvg ] [ Html.text "Download" ]
        ]