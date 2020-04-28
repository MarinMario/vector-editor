module Functions.BasicsPoints exposing (..)

import CustomTypes exposing (..)

import Functions.BasicsShape exposing (getSelectedShapeData)


addNewPoint : Model -> Float -> Model
addNewPoint model nextOrder =
    let mousex = Tuple.first model.mousePosition
        mousey = Tuple.second model.mousePosition
        selectedShapeData = getSelectedShapeData model


        updatedPoints =
                selectedShapeData.points ++
                [PolylinePoint 
                    nextOrder mousex mousey
                ] |> List.sortBy .order

        st = selectedShapeData.shapeType
        newShapes = 
            List.map (\shape -> 
                if shape.id == model.selectedShape && (st == Polyline || st == Polygon) then
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


getSelectedPoint : ShapeData -> Float -> PolylinePoint
getSelectedPoint shapeData selectedPoint =
    Maybe.withDefault (PolylinePoint 0 0 0)
        <| List.head 
        <| List.filter 
            (\point -> point.order == selectedPoint) 
            shapeData.points

convertPointsToString : ShapeData -> String
convertPointsToString shapeData =
    List.map (\item -> 
        let x = String.fromFloat <| item.x
            y = String.fromFloat <| item.y
        in
        x ++ "," ++ y 
    ) shapeData.points
        |> String.join " "

