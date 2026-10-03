local T11SoldierPreviewView = {
  Name = UIWindowNames.T11SoldierPreviewView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11SoldierPreviewView.Ctrl.T11SoldierPreviewCtrl"),
  View = require("UI.T11SoldierPreviewView.View.T11SoldierPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11/T11SoldierPreview/T11SoldierPreview.prefab"
}
return {T11SoldierPreviewView = T11SoldierPreviewView}
