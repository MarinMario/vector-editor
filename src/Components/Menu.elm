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
    let sh = model.selectHover
    in
    let tabButton tab svgshape =  
            Html.div 
                [ Ha.class <| 
                    if model.selectHover.tab == tab then "selectedTab" 
                    else if model.selectHover.hoveredTab == Just tab then "hoveredTab"
                    else "tab"
                , He.onClick
                    <| EditModel 
                        {model | selectHover = 
                            {sh | tab = if sh.tab == tab then None else tab} 
                        }
                , He.onMouseEnter <| EditModel {model | selectHover = {sh | hoveredTab = Just tab} }
                , He.onMouseLeave <| EditModel {model | selectHover = {sh | hoveredTab = Nothing} }
                ]
                [ Svg.svg [ Sa.width "30", Sa.height "30" ] [ svgshape ]
                ]
        
        tabColor tab =
            if model.selectHover.tab == tab then Sa.fill "black"
            else Sa.fill "#ececec"
    in
    Html.div [ Ha.class "sidebar" ]
        [ tabButton None <| Svg.rect [ Sa.width "30", Sa.height "30", tabColor None ] []
        , tabButton Canvas <| Svg.rect [ Sa.width "30", Sa.height "30", tabColor Canvas ] []
        , tabButton Tools <| Svg.rect [ Sa.width "30", Sa.height "30", tabColor Tools ] []
        , tabButton Properties <| Svg.rect [ Sa.width "30", Sa.height "30", tabColor Properties ] []
        , tabButton Save <| Svg.rect [ Sa.width "30", Sa.height "30", tabColor Save ] []
        ]

menu : Model -> Html Msg
menu model =
    let boxWidth =
            if model.selectHover.tab == None then "0px" else "300px"
    in
    Html.div [ Ha.class "menu" ]
        [ Html.div [ Ha.class "box", Ha.style "width" boxWidth ] 
            [ case model.selectHover.tab of
                None -> Html.div [] []
                Canvas ->
                    Html.div []
                        [ svgInputField SvgName model.svgProps.name "name"
                        , svgInputField SvgWidth (String.fromFloat model.svgProps.width) "width"
                        , svgInputField SvgHeight (String.fromFloat model.svgProps.height) "height"
                        ]
                Properties ->
                    Html.div []
                        [ Html.button [ He.onClick DeleteSelectedShapes ] [ Html.text "Delete" ]
                        , Html.button [ He.onClick DuplicateSelectedShapes ] [ Html.text "Duplicate" ]
                        , Html.div [ Ha.class "label" ] [ Html.text <| "Shape id: " ++ String.fromInt model.selectedShape ]
                        , inputDataFields model
                        ]
                Save ->
                    let btn msg str = Html.button [ He.onClick msg ] [ Html.text str ]
                    in
                    Html.div []
                        [ btn DownloadSvg "Download as Svg"
                        , svgInputField SvgName model.svgProps.name "name"
                        , btn SaveModel "Save File"
                        , btn OpenFile "Load File"
                        , Html.div [ Ha.class "stringifiedCode" ] [ Html.text <| convertShapeDataToString model ]
                        ]
                Tools ->
                    Html.div [] [ newShapeButtons model ]
            ]
        , sidebar model
        ]

newShapeButton : Model -> ShapeType -> Svg Msg -> Html Msg
newShapeButton model shapeType someSvg =
    let sh = model.selectHover  
    in
    Html.div 
        [ He.onClick <| EditModel { model | selectHover = {sh | shape = shapeType} }
        , He.onMouseEnter <| EditModel { model | selectHover = {sh | hoveredShape = Just shapeType} }
        , He.onMouseLeave <| EditModel { model | selectHover = {sh | hoveredShape = Nothing} }
        , 
        if sh.shape == shapeType then
            Ha.class "selectedShapeButton"
        else if sh.hoveredShape == Just shapeType then
            Ha.class "hoveredShapeButton"
        else Ha.class "shapeButton"
        ]
        [ Svg.svg 
            [ Sa.width "40", Sa.height "40" 
            ] [ someSvg ] ]
newShapeButtons : Model -> Html Msg
newShapeButtons model =
    let sh = model.selectHover
        fill shape =
            if sh.shape == shape then "#222831"
            else "#f2a365"
    in
    Html.div [] 
        [ newShapeButton model Selector
            <| Svg.g [] 
                [ Svg.polygon 
                    [ Sa.points "0,0 30,10 10,30"
                    , Sa.fill (fill Selector)] []
                , Svg.polyline 
                    [ Sa.points "10,10 40,40"
                    , Sa.stroke (fill Selector)
                    , Sa.strokeWidth "5" ] []
                ]
        , newShapeButton model Rect 
            <| Svg.rect [ Sa.width "40", Sa.height "40", Sa.fill (fill Rect) ] []
        , newShapeButton model Ellipse
            <| Svg.circle [ Sa.cx "20", Sa.cy "20", Sa.r "20", Sa.fill (fill Ellipse) ] []
        , newShapeButton model Polyline
            <| Svg.polyline [ Sa.points "0,20 40,20", Sa.stroke (fill Polyline), Sa.strokeWidth "10px" ] []
        , newShapeButton model Polygon
            <| Svg.polyline [ Sa.points "0,40 20,0 40,40", Sa.fill (fill Polygon) ] []
        , newShapeButton model Label
            <| Svg.text_ [ Sa.y "25", Sa.fill (fill Label) ] [ Svg.text "TEXT" ]
        ]