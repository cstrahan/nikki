{-# language NamedFieldPuns #-}

module Editor.Scene.Types where


import Data.SelectTree
import qualified Data.Indexable as I
import Data.Indexable hiding (length, toList, findIndices, fromList)
import Data.Abelian
import Data.Initial

import Graphics.Qt

import Utils

import Base

import Sorts.Robots


-- type SceneMonad = StateT (EditorScene Sort_) IO


-- * getters

getSelectedLayerContent :: EditorScene Sort_ -> Indexable (EditorObject Sort_)
getSelectedLayerContent scene =
    scene ^. editorObjects ^. layerA (scene ^. selectedLayer) ^. content

-- | get the object that is actually selected by the cursor
getSelectedObject :: EditorScene Sort_ -> Maybe (EditorObject Sort_)
getSelectedObject scene =
    flip fmap (selected scene) $
        \ (layerIndex, i) ->
            scene ^. editorObjects ^. layerA layerIndex ^. content ^. indexA i

-- | returns all Indices (to the mainLayer) for robots
getRobotIndices :: Sort sort o => EditorScene sort -> [Index]
getRobotIndices scene =
    I.findIndices (isRobot . editorSort) $
        scene ^. editorObjects ^. mainLayer ^. content

getCursorSize :: Sort sort o => EditorScene sort -> (Size Double)
getCursorSize s@EditorScene{} =
    size $ getSelected $ s ^. availableSorts

-- | returns an object from the main layer
getMainLayerEditorObject :: EditorScene sort -> Index -> EditorObject sort
getMainLayerEditorObject scene i = os !!! i
  where
    os = mainLayerIndexable $ (scene ^. editorObjects)

-- returns the wanted cursor step
getCursorStep :: EditorScene Sort_ -> EditorPosition
getCursorStep s = case cursorStep s of
    Just x -> x
    Nothing ->
        let (Size x y) = size $ getSelected $ s ^. availableSorts
        in EditorPosition x y


-- * Setters

setCursorStep :: EditorScene s -> Maybe EditorPosition -> EditorScene s
setCursorStep scene x = scene{cursorStep = x}

-- | adds a new default Layer to the EditorScene
addDefaultLayerOnTop :: EditorScene Sort_ -> EditorScene Sort_
addDefaultLayerOnTop s = case s ^. selectedLayer of
    MainLayer -> editorObjects .> foregrounds ^: (initial <:) $ s
    Backgrounds i -> editorObjects .> backgrounds ^: (insertAfter i initial) $ s
    Foregrounds i -> editorObjects .> foregrounds ^: (insertAfter i initial) $ s

-- | adds a new default Layer to the EditorScene
addDefaultLayerBehind :: EditorScene Sort_ -> EditorScene Sort_
addDefaultLayerBehind s = case s ^. selectedLayer of
    MainLayer -> editorObjects .> backgrounds ^: (>: initial) $ s
    Backgrounds i -> editorObjects .> backgrounds ^: (insertBefore i initial) $ s
    Foregrounds i -> editorObjects .> foregrounds ^: (insertBefore i initial) $ s

-- | Deletes the current layer. Does nothing if that's the MainLayer.
-- Sets the current layer to the layer on top of the deleted one.
deleteCurrentLayer :: EditorScene Sort_ -> EditorScene Sort_
deleteCurrentLayer s = case s ^. selectedLayer of
    MainLayer -> s
    Backgrounds i ->
        setNewSelectedLayer $
        editorObjects .> backgrounds ^: deleteByIndex i $
        s
    Foregrounds i ->
        setNewSelectedLayer $
        editorObjects .> foregrounds ^: deleteByIndex i $
        s
  where
    newSelectedLayer = nextGroundsIndex (s ^. editorObjects) (s ^. selectedLayer)
    setNewSelectedLayer = assertion . (selectedLayer ^= newSelectedLayer)
    assertion s = if (isGroundsIndexOf (s ^. selectedLayer) (s ^. editorObjects))
        then s
        else error "deleteCurrentLayer.newSelectedLayer"

-- * modification

-- | returns if an object is currently in the copy selection
inCopySelection :: Sort s x => EditorScene s -> EditorObject s -> Bool
inCopySelection EditorScene{editorMode = SelectionMode endPosition, cursor} object =
    ((object ^. editorPosition) `pBetween` range) &&
    objectEndPosition `pBetween` range
  where
    Size w h = size $ editorSort object
    objectEndPosition = object ^. editorPosition +~ EditorPosition w (- h)
    range = (cursor, endPosition)

    pBetween (EditorPosition x y) (EditorPosition x1 y1, EditorPosition x2 y2) =
        (x `between` (x1, x2)) &&
        (y `between` (y1, y2))
    between x (a, b) = x >= min a b && x <= max a b


cutSelection :: EditorScene Sort_ -> EditorScene Sort_
cutSelection scene =
    editorObjects .> layerA (scene ^. selectedLayer) ^:
        (modifyContent deleteCutObjects) $
    scene{editorMode = NormalMode, clipBoard = clipBoard}
  where
    deleteCutObjects :: Indexable (EditorObject Sort_) -> Indexable (EditorObject Sort_)
    deleteCutObjects = foldr (.) id (map deleteByIndex cutIndices)
    clipBoard :: [EditorObject Sort_]
    clipBoard = map (moveSelectionToZero scene) $
        map (\ i -> getSelectedLayerContent scene !!! i) cutIndices
    cutIndices = findCopySelectionIndices scene

-- | deletes the selected objects without changing the clipboard contents.
-- implemented in terms of cutSelection (huzzah for non-destructive updates)
deleteSelection :: EditorScene Sort_ -> EditorScene Sort_
deleteSelection scene = (cutSelection scene){clipBoard = clipBoard scene}

copySelection :: EditorScene Sort_ -> EditorScene Sort_
copySelection scene =
    scene{editorMode = NormalMode, clipBoard = clipBoard}
  where
    clipBoard :: [EditorObject Sort_]
    clipBoard = map (moveSelectionToZero scene) $ 
        map (\ i -> getSelectedLayerContent scene !!! i) copyIndices
    copyIndices = findCopySelectionIndices scene

findCopySelectionIndices :: EditorScene Sort_ -> [Index]
findCopySelectionIndices scene =
    I.findIndices (inCopySelection scene) $ getSelectedLayerContent scene

moveSelectionToZero :: EditorScene Sort_ -> EditorObject Sort_ -> EditorObject Sort_
moveSelectionToZero scene@EditorScene{editorMode = SelectionMode (EditorPosition x2 y2)} =
    editorPosition ^: (-~ EditorPosition x y) >>>
    modifyOEMEditorPositions (-~ EditorPosition x y)
  where
    x = min x1 x2
    y = max y1 y2
    EditorPosition x1 y1 = cursor scene

pasteClipboard :: EditorScene Sort_ -> EditorScene Sort_
pasteClipboard scene =
    editorObjects .> layerA (scene ^. selectedLayer) ^: (modifyContent addClipboard) $
    scene
  where
    addClipboard :: Indexable (EditorObject Sort_) -> Indexable (EditorObject Sort_)
    addClipboard = 
        foldr (>>>) id $ map (\ o ix -> ix >: o) $
        map (editorPosition ^: (+~ cursor scene)) $
        map (modifyOEMEditorPositions (+~ cursor scene)) $
        clipBoard scene
