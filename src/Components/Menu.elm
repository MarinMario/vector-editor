module Components.Menu exposing (menu)

import Html exposing (Html)
import Html.Events as He
import Html.Attributes as Ha

import Svg exposing (Svg)
import Svg.Attributes as Sa

import CustomTypes exposing (..)

import Components.InputFields exposing (..)

import Functions.ConvertShapeDataToString exposing (convertShapeDataToString)

sidebar : Model -> Html Msg
sidebar model =
    let tabButton tab svgshape =  
            Html.div 
                [ Ha.class <| 
                    if model.tab == tab then "selectedTab" 
                    else if model.hoveredTab == Just tab then "hoveredTab"
                    else "tab"
                , He.onClick <| 
                    if model.tab == tab then ChangeTab None
                    else ChangeTab tab
                , He.onMouseOver <| HoverTab <| Just tab 
                , He.onMouseLeave <| HoverTab Nothing
                ]
                [ Svg.svg [ Sa.width "30", Sa.height "30" ] [ svgshape ]
                ]
        
        tabColor tab =
            if model.tab == tab then Sa.fill "black"
            else Sa.fill "#ececec"
    in
    Html.div [ Ha.class "sidebar" ]
        [ tabButton None <| Svg.rect [ Sa.width "30", Sa.height "30", tabColor None ] []
        , tabButton Canvas <| Svg.rect [ Sa.width "30", Sa.height "30", tabColor Canvas ] []
        , tabButton Properties <| Svg.rect [ Sa.width "30", Sa.height "30", tabColor Properties ] []
        , tabButton Save <| Svg.rect [ Sa.width "30", Sa.height "30", tabColor Save ] []
        ]

menu : Model -> Html Msg
menu model =
    let boxWidth =
            if model.tab == None then "0px" else "300px"
    in
    Html.div [ Ha.class "menu" ]
        [ Html.div [ Ha.class "box", Ha.style "width" boxWidth ] 
            [ case model.tab of
                None -> Html.div [] []
                Canvas ->
                    Html.div []
                        [ svgInputField SvgWidth (String.fromFloat model.svgProps.width) "canvas width"
                        , svgInputField SvgHeight (String.fromFloat model.svgProps.height) "canvas height"
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

newShapeButton : ShapeType -> String -> Html Msg
newShapeButton shapeType text =
    Html.button [ He.onClick <| NewShape shapeType ] [ Html.text text ]
newShapeButtons : Html Msg
newShapeButtons =
    Html.div [] 
        [ newShapeButton Rect "Rect"
        , newShapeButton Ellipse "Ellipse"
        , newShapeButton Polyline "Line"
        , newShapeButton Polygon "Polygon"
        , newShapeButton Label "Label"
        ]