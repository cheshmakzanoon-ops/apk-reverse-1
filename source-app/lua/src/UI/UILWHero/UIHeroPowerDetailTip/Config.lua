local UIHeroPowerDetailTip = {
  Name = UIWindowNames.UIHeroPowerDetailTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroPowerDetailTip.Controller.UIHeroPowerDetailTipCtrl"),
  View = require("UI.UILWHero.UIHeroPowerDetailTip.View.UIHeroPowerDetailTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroPowerDetailTip.prefab"
}
return {UIHeroPowerDetailTip = UIHeroPowerDetailTip}
