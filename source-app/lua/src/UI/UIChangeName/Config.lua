local UIChangeName = {
  Name = UIWindowNames.UIChangeName,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChangeName.Controller.UIChangeNameCtrl"),
  View = require("UI.UIChangeName.View.UIChangeNameView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Set/New/UIChangeName.prefab"
}
return {UIChangeName = UIChangeName}
