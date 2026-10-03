local UICoppaAppeal = {
  Name = UIWindowNames.UICoppaAppeal,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICoppa.UICoppaAppealCtrl"),
  View = require("UI.UICoppa.UICoppaAppealView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIPrivacy/UICoppaAppeal.prefab"
}
return {UICoppaAppeal = UICoppaAppeal}
