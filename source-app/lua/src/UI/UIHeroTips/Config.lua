local UIHeroTips = {
  Name = UIWindowNames.UIHeroTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHeroTips.Controller.UIHeroTipsCtrl"),
  View = require("UI.UIHeroTips.View.UIHeroTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIHeroTips.prefab"
}
return {UIHeroTips = UIHeroTips}
