local UIWorldServerChangeTip = {
  Name = UIWindowNames.UIWorldServerChangeTip,
  Layer = UILayer.Scene,
  Ctrl = require("UI.LWSeasonShared.UIWorldServerChangeTip.Controller.UIWorldServerChangeTipCtrl"),
  View = require("UI.LWSeasonShared.UIWorldServerChangeTip.View.UIWorldServerChangeTipView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/World/UIWorldServerChangeTip.prefab"
}
return {UIWorldServerChangeTip = UIWorldServerChangeTip}
