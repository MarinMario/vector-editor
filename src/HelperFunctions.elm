module HelperFunctions exposing (..)

import CustomTypes exposing (..)

import Svg exposing (svg)
import Svg.Events as Se
import Svg.Attributes as Sa

initShape : ShapeData
initShape = 
    { shapeType = Rect
    , position = (50, 50)
    , followMouse = False
    , id = 1
    , size = (50, 50)
    , updateSize = (False, False)
    , fillColor = "grey"
    , points = initPoints
    , updatePoint = Nothing
    , zIndex = 1
    , strokeWidth = 5
    , strokeColor = "black"
    , hovered = False
    }

initPoints = [PolylinePoint 1 20 20, PolylinePoint 2 100 100]

dragShape : Model -> List ShapeData
dragShape model =
    List.map (\shape -> 
        let
            mousex = Tuple.first model.mousePosition
            mousey = Tuple.second model.mousePosition
            shapex = Tuple.first shape.position
            shapey = Tuple.second shape.position
            shapew = Tuple.first shape.size
            shapeh = Tuple.second shape.size

            newSizeX = mousex - shapex
            newSizeY = mousey - shapey
            newSize =
                if newSizeX > 10 && newSizeY > 10 then
                    (newSizeX, newSizeY)
                else if newSizeX > 10 && newSizeY < 10 then
                    (newSizeX, 10)
                else if newSizeX < 10 && newSizeY > 10 then
                    (10, newSizeY)
                else (10, 10)

            newPosition =
                case shape.shapeType of
                    Rect -> 
                        ( mousex
                        , mousey
                        )
                    Ellipse -> 
                        ( mousex, mousey )
                    Polyline -> 
                        ( mousex, mousey )

            updatedPoints =
                case shape.updatePoint of
                    Just one ->
                        List.map (\point ->
                            if point.order == one then
                                { point | x = mousex, y = mousey }
                            else point
                        ) shape.points
                    Nothing -> shape.points
        in
        { shape
        | position =
            if shape.followMouse then newPosition else shape.position
        , size = 
            ( if Tuple.first shape.updateSize then Tuple.first newSize else Tuple.first shape.size
            , if Tuple.second shape.updateSize then Tuple.second newSize else Tuple.second shape.size
            )
        , points = updatedPoints
        }) model.shapes

pointsToString : ShapeData -> String
pointsToString shapeData =
    List.map (\item -> 
        let x = String.fromFloat <| item.x
            y = String.fromFloat <| item.y
        in
        x ++ "," ++ y 
    ) shapeData.points
        |> String.join " "

addNewPoint : Model -> Float -> Model
addNewPoint model nextOrder =
    let mousex = Tuple.first model.mousePosition
        mousey = Tuple.second model.mousePosition
        selectedShapeData = getSelectedShapeData model

        point1 = getSelectedPoint selectedShapeData <| nextOrder
        point2 = getSelectedPoint selectedShapeData <| nextOrder / 1.5


        updatedPoints =
                selectedShapeData.points ++
                [PolylinePoint 
                    nextOrder mousex mousey
                ] |> List.sortBy .order

        newShapes = 
            List.map (\shape -> 
                if shape.id == model.selectedShape && selectedShapeData.shapeType == Polyline then
                    { shape
                    | points = updatedPoints
                    }
                else shape
            ) model.shapes
    in
    { model 
    | shapes = newShapes
    , nextPoint = nextOrder
    }

getSelectedShapeData model =
    Maybe.withDefault initShape 
        <| List.head 
        <| List.filter 
            (\shape -> shape.id == model.selectedShape) 
            model.shapes

deleteSelectedShape model =
    List.filter 
        (\shape -> shape.id /= model.selectedShape)
        model.shapes

getSelectedPoint shapeData selectedPoint =
    Maybe.withDefault (PolylinePoint 0 0 0)
        <| List.head 
        <| List.filter 
            (\point -> point.order == selectedPoint) 
            shapeData.points
