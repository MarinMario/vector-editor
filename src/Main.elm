module Main exposing (main)

import Browser

import Html exposing (Html)
import Html.Events as He
import Html.Attributes as Ha

import Svg exposing (Svg)
import Svg.Events as Se
import Svg.Attributes as Sa

import Html.Events.Extra.Mouse as Mouse

import Components exposing (..)
import CustomTypes exposing (..)
import HelperFunctions exposing (..)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : flags -> (Model, Cmd Msg)
init _ =
    ( Model (1, 1) 
        [initShape] 1 1 
        (InputShapeData "0" "0" "50" "50" "blue" "0 0" "1" "5" "black")
    , Cmd.none )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MoveMouse pos ->
            let selectedShapeData =
                    let ssd = List.filter (\shape -> shape.id == model.selectedShape) model.shapes
                    in
                    Maybe.withDefault initShape <| List.head ssd

                inputShapeData = model.inputShapeData
                newInputShapeData =
                    { inputShapeData
                    | xPos = String.fromFloat <| Tuple.first selectedShapeData.position
                    , yPos = String.fromFloat <| Tuple.second selectedShapeData.position
                    , width = String.fromFloat <| Tuple.first selectedShapeData.size
                    , height = String.fromFloat <| Tuple.second selectedShapeData.size
                    , fillColor = selectedShapeData.fillColor
                    , points = pointsToString selectedShapeData.points 
                    , zIndex = String.fromInt <| selectedShapeData.zIndex
                    , strokeWidth = String.fromFloat <| selectedShapeData.strokeWidth
                    , strokeColor = selectedShapeData.strokeColor
                    }
            in
            ({ model
            | mousePosition = pos
            , shapes = dragShape model
            , inputShapeData = newInputShapeData
            }, Cmd.none)
        
        EditShape newData ->
            let newShapes =
                    List.map (\shapeData ->
                        if shapeData.id == newData.id then
                            newData
                        else shapeData
                    ) model.shapes
            in
            ({ model
            | shapes = newShapes
            , selectedShape = newData.id
            }, Cmd.none)
            
        NewShape shapeType ->
            let newId = model.lastId + 1
                newShape = 
                    { initShape 
                    | shapeType = shapeType
                    , id = newId
                    }
            in
            ({ model
            | shapes = model.shapes ++ [newShape]
            , lastId = newId
            }, Cmd.none)
        
        InputSelectedShape val ->
            ({ model
            | selectedShape = val
            }, Cmd.none)
        
        InputData vtc val ->
            let isd = model.inputShapeData
                newInputShapeData =
                    case vtc of
                        Xpos -> { isd | xPos = val }
                        Ypos -> { isd | yPos = val }
                        Width -> { isd | width = val }
                        Height -> { isd | height = val }
                        FillColor -> { isd | fillColor = val }
                        Zindex -> { isd | zIndex = val }
                        StrokeWidth -> { isd | strokeWidth = val }
                        StrokeColor -> { isd | strokeColor = val }
                        Points -> isd

                
                newShapes =
                    List.map (\shape ->
                        if shape.id == model.selectedShape then
                            { shape
                            | position = 
                                ( Maybe.withDefault 0 <| String.toFloat newInputShapeData.xPos
                                , Maybe.withDefault 0 <| String.toFloat newInputShapeData.yPos
                                )
                            , size =
                                ( Maybe.withDefault 0 <| String.toFloat newInputShapeData.width
                                , Maybe.withDefault 0 <| String.toFloat newInputShapeData.height
                                )
                            , fillColor = newInputShapeData.fillColor
                            , zIndex = Maybe.withDefault 1 <| String.toInt newInputShapeData.zIndex
                            , strokeWidth = Maybe.withDefault 3 <| String.toFloat newInputShapeData.strokeWidth
                            , strokeColor = newInputShapeData.strokeColor
                            }
                        else shape
                    ) model.shapes
            in
            ({ model
            | inputShapeData = newInputShapeData
            , shapes = newShapes
            }, Cmd.none)
        
        StopDrag ->
            let newShapes = 
                    List.map (\shape ->
                        { shape
                        | followMouse = False
                        , updateSize = (False, False) 
                        , updatePoints = Nothing
                        }) model.shapes
            in
            ({ model
            | shapes = newShapes
            }, Cmd.none)
        
        AddNewPoint ->
            ( addNewPoint model
            , Cmd.none)
        
        DeleteSelectedShapes ->
            let newShapes =
                    List.filter 
                    (\shape -> shape.id /= model.selectedShape)
                    model.shapes
            in
            ({ model
            | shapes = newShapes
            }, Cmd.none)

        DuplicateSelectedShapes ->
            let selectedShapeData =
                    Maybe.withDefault initShape 
                        <| List.head 
                        <| List.filter 
                            (\shape -> shape.id == model.selectedShape) 
                            model.shapes
                
                nextId = model.lastId + 1
                newShapes = model.shapes ++ 
                    [{ selectedShapeData
                    | position = (100, 100)
                    , id = nextId
                    }]
            in
            ({ model
            | shapes = newShapes
            , lastId = nextId
            }, Cmd.none)

view : Model -> Html Msg
view model =
    let shapes = List.map (\shapeData -> 
            if shapeData.shapeType == Rect then 
                customRect shapeData model.selectedShape
            else if shapeData.shapeType == Ellipse then 
                customEllipse shapeData model.selectedShape
            else customPolyline shapeData model.selectedShape
            ) orderedData
        
        orderedData =
            List.sortBy .zIndex model.shapes
    in
    Html.div [ He.onMouseUp StopDrag ] 
        [ Svg.svg 
            [ Sa.width "1000", Sa.height "400"
            , Ha.style "border" "solid 1px"
            , Mouse.onMove (\event -> MoveMouse event.clientPos)
            , He.onDoubleClick AddNewPoint
            ] shapes
        , Html.br [] []
        , newShapeButton Rect "Rect"
        , newShapeButton Ellipse "Ellipse"
        , newShapeButton Polyline "Polyline"
        , Html.button [ He.onClick DeleteSelectedShapes ] [ Html.text "Delete" ]
        , Html.button [ He.onClick DuplicateSelectedShapes ] [ Html.text "Duplicate" ]
        , Html.div [] [ Html.text <| "Shape id: " ++ String.fromInt model.selectedShape ]
        , inputDataFields model
        ]
    

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none