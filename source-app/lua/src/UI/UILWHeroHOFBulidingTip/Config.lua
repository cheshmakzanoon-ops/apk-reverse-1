local UILWHeroHOFBulidingTip = {
  Name = UIWindowNames.UILWHeroHOFBulidingTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHeroHOFBulidingTip.Controller.UILWHeroHOFBulidingTipCtrl"),
  View = require("UI.UILWHeroHOFBulidingTip.View.UILWHeroHOFBulidingTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UILWHeroHOFBuildingTip.prefab"
}
return {UILWHeroHOFBulidingTip = UILWHeroHOFBulidingTip}
