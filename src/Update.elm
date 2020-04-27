module Update exposing (update)

import CustomTypes exposing (..)
import HelperFunctions exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MoveMouse pos ->
            let selectedShapeData = getSelectedShapeData model

                inputShapeData = model.inputShapeData
                newInputShapeData =
                    { inputShapeData
                    | xPos = String.fromFloat <| Tuple.first selectedShapeData.position
                    , yPos = String.fromFloat <| Tuple.second selectedShapeData.position
                    , width = String.fromFloat <| Tuple.first selectedShapeData.size
                    , height = String.fromFloat <| Tuple.second selectedShapeData.size
                    , fillColor = selectedShapeData.fillColor
                    , points = pointsToString selectedShapeData
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
            }, Cmd.none)
            
        NewShape shapeType ->
            let newId = model.lastId + 1
                newShape = 
                    { initShape 
                    | shapeType = shapeType
                    , id = newId
                    , fillColor =
                        if shapeType == Polyline then "none"
                        else initShape.fillColor
                    , points =
                        case shapeType of 
                            Polygon -> 
                                [PolylinePoint 1 20 20, PolylinePoint 1.5 20 100, PolylinePoint 2 100 100]
                            _ -> initShape.points
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
                        , updatePoint = Nothing
                        }) model.shapes
            in
            ({ model
            | shapes = newShapes
            }, Cmd.none)
        
        AddNewPoint nextOrder ->
            ( addNewPoint model nextOrder
            , Cmd.none
            )
        
        DeleteSelectedShapes ->
            let newShapes = deleteSelectedShape model
            in
            ({ model
            | shapes = newShapes
            }, Cmd.none)

        DuplicateSelectedShapes ->
            let selectedShapeData = getSelectedShapeData model
                
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
        
        DeleteLinePoints pointOrder ->
            let selectedShapeData = getSelectedShapeData model
                updatedPoints =
                    List.filter (\point -> point.order /= pointOrder) selectedShapeData.points
                updatedSelectedShape =
                    { selectedShapeData | points = updatedPoints }
                updatedShapes =
                    List.map (\shape ->
                        if shape.id == updatedSelectedShape.id then
                            updatedSelectedShape
                        else shape
                    ) model.shapes
            in
            ({ model
            | shapes = 
                if List.length selectedShapeData.points <= 2 then
                    deleteSelectedShape model
                else updatedShapes
            }, Cmd.none)
        
        DownloadSvg ->
            (model, downloadSvg model)
        
        ChangeTab tab ->
            ({ model | tab = tab }
            , Cmd.none )