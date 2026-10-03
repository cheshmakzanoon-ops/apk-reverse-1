local UIHeroLackTips = {
  Name = UIWindowNames.UIHeroLackTips,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHeroLackTips.Controller.UIHeroLackTipsCtrl"),
  View = require("UI.UIHeroLackTips.View.UIHeroLackTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHeroLackTips/UIHeroLackTips.prefab"
}
return {UIHeroLackTips = UIHeroLackTips}
