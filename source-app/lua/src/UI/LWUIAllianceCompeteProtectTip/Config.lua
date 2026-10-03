local LWUIAllianceCompeteProtectTip = {
  Name = UIWindowNames.LWUIAllianceCompeteProtectTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIAllianceCompeteProtectTip.Controller.LWUIAllianceCompeteProtectTipCtrl"),
  View = require("UI.LWUIAllianceCompeteProtectTip.View.LWUIAllianceCompeteProtectTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/AllianceCompeteProtect/AllianceCompeteProtectTip.prefab"
}
return {LWUIAllianceCompeteProtectTip = LWUIAllianceCompeteProtectTip}
