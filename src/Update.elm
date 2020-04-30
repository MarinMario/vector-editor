module Update exposing (update)

import CustomTypes exposing (..)

import Init exposing (initShape)

import Functions.Save exposing (downloadSvg, downloadModel)
import Functions.Load exposing (loadModel, selectFile)
import Functions.Drag exposing (dragShape, dragSvgSize)
import Functions.BasicsShape exposing (getSelectedShapeData, deleteSelectedShape)
import Functions.BasicsPoints exposing (convertPointsToString, addNewPoint)

import File
import Task

import Json.Decode as Dec

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
                    , points = convertPointsToString selectedShapeData
                    , zIndex = String.fromInt <| selectedShapeData.zIndex
                    , strokeWidth = String.fromFloat <| selectedShapeData.strokeWidth
                    , strokeColor = selectedShapeData.strokeColor
                    }
            in
            ({ model
            | mousePosition = pos
            , shapes = dragShape model
            , inputShapeData = newInputShapeData
            , svgProps = dragSvgSize model
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
                mousex = Tuple.first model.mousePosition
                mousey = Tuple.second model.mousePosition
                newShape =
                    { initShape 
                    | shapeType = Maybe.withDefault Rect shapeType
                    , id = newId
                    , size = (0, 0)
                    , fillColor =
                        if shapeType == Just Polyline then "none"
                        else initShape.fillColor
                    , points =
                        case shapeType of 
                            Just Polygon -> 
                                [ PolylinePoint 1 mousex mousey
                                , PolylinePoint 1.5 mousex mousey
                                , PolylinePoint 2 mousex (mousey +100)
                                ]
                            Just Polyline -> 
                                [ PolylinePoint 1 mousex mousey
                                , PolylinePoint 2 mousex mousey
                                ]
                            _ -> []
                    , strokeWidth =
                        if shapeType == Just Label then 1 else initShape.strokeWidth
                    , position = model.mousePosition
                    , updateSize = (True, True)
                    , updatePoint =
                        case shapeType of
                            Just Polygon -> Just 1.5
                            _ -> Just 2
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
                        LabelText -> { isd | labelText = val }

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
                            , labelText = newInputShapeData.labelText
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
                sp = model.svgProps
            in
            ({ model
            | shapes = newShapes
            , svgProps = { sp | updateSize = False }
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
        
        EditModel newModel ->
            (newModel, Cmd.none)
        
        InputSvgData vtc val ->
            let isd = model.svgProps
                updatedSvgProps =
                    case vtc of
                        SvgWidth ->
                            { isd | width = Maybe.withDefault 0 <| String.toFloat val }
                        SvgHeight ->
                            { isd | height = Maybe.withDefault 0 <| String.toFloat val }
                        UpdateSize ->
                            { isd | updateSize = val == "True" }
                        _ -> isd
            in
            ({ model | svgProps = updatedSvgProps }
            , Cmd.none )
        
        SaveModel ->
            (model, downloadModel model)
        
        OpenFile ->
            (model, selectFile)

        RequestFile file ->
            (model, Task.perform LoadModel (File.toString file))

        LoadModel theFile ->
            let decodedModel = loadModel theFile
                updatedModel =
                    case decodedModel of
                        Ok result -> result
                        Err _ ->
                            { lastId = model.lastId
                            , nextPoint = model.nextPoint
                            , shapes =
                                [{shapeType = "Rect"
                                , positionx = 0
                                , positiony = 0
                                , sizex = 0
                                , sizey = 0
                                , id = 0
                                , fillColor = "blue"
                                , strokeWidth = 10
                                , strokeColor = "red"
                                , points = Init.initPoints
                                , zIndex = 1
                                , labelText = "this shouldn't exist really"
                                }]
                            }
                updatedShapes = 
                    List.map (\shape ->
                        { initShape 
                        | position = (shape.positionx, shape.positiony)
                        , size = (shape.sizex, shape.sizey)
                        , shapeType =
                            case shape.shapeType of
                                "Rect" -> Rect
                                "Ellipse" -> Ellipse
                                "Polygon" -> Polygon
                                "Polyline" -> Polyline
                                _ -> Label
                        , id = shape.id, fillColor = shape.fillColor, strokeWidth = shape.strokeWidth
                        , points = shape.points, zIndex = shape.zIndex, labelText = shape.labelText
                        , strokeColor = shape.strokeColor
                        }
                    ) updatedModel.shapes
            in
            ({ model 
            | lastId = updatedModel.lastId
            , nextPoint = updatedModel.nextPoint
            , shapes = updatedShapes
            }
            , Cmd.none)