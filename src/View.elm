module View exposing (view)

import Html exposing (Html)
import Html.Events as He
import Html.Attributes as Ha

import Svg exposing (Svg)
import Svg.Attributes as Sa

import Components exposing (..)
import CustomTypes exposing (..)
import HelperFunctions exposing (..)

view : Model -> Html Msg
view model =
    Html.div [ He.onMouseUp StopDrag,  Ha.class "app" ]
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
                        [ newShapeButtons
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
                        ]
            ]
        , sidebar model
        ]