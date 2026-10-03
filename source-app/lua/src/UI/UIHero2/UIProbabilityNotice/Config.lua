local UIProbabilityNotice = {
  Name = UIWindowNames.UIProbabilityNotice,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIHero2.UIProbabilityNotice.Controller.UIProbabilityNoticeCtrl"),
  View = require("UI.UIHero2.UIProbabilityNotice.View.UIProbabilityNoticeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIProbabilityNotice.prefab"
}
return {UIProbabilityNotice = UIProbabilityNotice}
