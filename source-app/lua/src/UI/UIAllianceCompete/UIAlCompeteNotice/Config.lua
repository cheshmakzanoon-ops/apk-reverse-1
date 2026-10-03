local UIAlCompeteNotice = {
  Name = UIWindowNames.UIAlCompeteNotice,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllianceCompete.UIAlCompeteNotice.Controller.UIAlCompeteNoticeCtrl"),
  View = require("UI.UIAllianceCompete.UIAlCompeteNotice.View.UIAlCompeteNoticeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllianceCompeteNew/UIAlCompeteNotice.prefab"
}
return {UIAlCompeteNotice = UIAlCompeteNotice}
