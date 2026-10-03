local UINoticeHeroTips = {
  Name = UIWindowNames.UINoticeHeroTips,
  Layer = UILayer.Info,
  Ctrl = require("UI.UINoticeHeroTips.Controller.UINoticeHeroTipsCtrl"),
  View = require("UI.UINoticeHeroTips.View.UINoticeHeroTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UINoticeHeroTips.prefab"
}
return {UINoticeHeroTips = UINoticeHeroTips}
