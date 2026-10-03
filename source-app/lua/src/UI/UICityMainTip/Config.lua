local UICityMainTip = {
  Name = UIWindowNames.UICityMainTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICityMainTip.Controller.UICityMainTipCtrl"),
  View = require("UI.UICityMainTip.View.UICityMainTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CityManage/UICityMainTips.prefab"
}
return {UICityMainTip = UICityMainTip}
