module Functions.BasicsShape exposing (..)

import CustomTypes exposing (..)

import Init exposing (initShape)

orderShapes : List ShapeData -> List ShapeData
orderShapes shapes = List.sortBy .zIndex shapes

shapeProps shapeData =
    { xPos = Tuple.first shapeData.position
    , yPos = Tuple.second shapeData.position
    , width = Tuple.first shapeData.size
    , height = Tuple.second shapeData.size
    , fillColor = shapeData.fillColor
    , strokeWidth = shapeData.strokeWidth
    , strokeColor = shapeData.strokeColor
    , rotation = shapeData.rotation
    }

deleteSelectedShape model =
    List.filter 
        (\shape -> shape.id /= model.selectedShape)
        model.shapes

getSelectedShapeData model =
    Maybe.withDefault initShape 
        <| List.head 
        <| List.filter 
            (\shape -> shape.id == model.selectedShape) 
            model.shapes
