local UIMoveModel = {
  Name = UIWindowNames.UIMoveModel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMoveModel.Controller.UIMoveModelCtrl"),
  View = require("UI.UIMoveModel.View.UIMoveModelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Build/UIMoveModel.prefab"
}
return {UIMoveModel = UIMoveModel}
