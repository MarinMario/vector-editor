module View exposing (view)

import Html exposing (Html)
import Html.Events as He
import Html.Attributes as Ha

import Svg exposing (Svg)
import Svg.Attributes as Sa

import Components exposing (..)
import CustomTypes exposing (..)
import HelperFunctions exposing (..)

import Html.Events.Extra.Mouse as Mouse

view : Model -> Html Msg
view model =
    Html.div 
        [ He.onMouseUp StopDrag, Ha.class "app"
        , Mouse.onMove (\event -> MoveMouse event.clientPos)
        ]
        [ svgArea model
        , menu model
        ]

menu model =
    let width =
            if model.tab == None then "0px" else "300px"
    in
    Html.div [ Ha.class "menu" ]
        [ Html.div [ Ha.class "box", Ha.style "width" width ] 
            [ case model.tab of
                None -> Html.div [] []
                Canvas ->
                    Html.div []
                        [ customInputField SvgSizeX model.inputShapeData.svgSizeX "canvas width"
                        , customInputField SvgSizeY model.inputShapeData.svgSizeY "canvas height"
                        , newShapeButtons
                        ]
                Properties ->
                    Html.div []
                        [ Html.button [ He.onClick DeleteSelectedShapes ] [ Html.text "Delete" ]
                        , Html.button [ He.onClick DuplicateSelectedShapes ] [ Html.text "Duplicate" ]
                        , Html.div [] [ Html.text <| "Shape id: " ++ String.fromInt model.selectedShape ]
                        , inputDataFields model
                        ]
                Save ->
                    Html.div []
                        [ Html.button [ He.onClick DownloadSvg ] [ Html.text "Download" ]
                        , Html.textarea [ Ha.class "stringifiedCode" ] [ Html.text <| convertShapeDataToString model ]
                        ]
            ]
        , sidebar model
        ]