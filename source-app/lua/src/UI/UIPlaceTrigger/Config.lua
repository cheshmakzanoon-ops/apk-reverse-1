local Config = {
  Name = UIWindowNames.UIPlaceTrigger,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPlaceTrigger.Controller.UIPlaceTriggerCtrl"),
  View = require("UI.UIPlaceTrigger.View.UIPlaceTriggerView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIPlaceTrigger.prefab"
}
return {Config = Config}
