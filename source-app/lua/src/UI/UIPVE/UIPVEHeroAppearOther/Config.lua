local UIPVEHeroAppearOther = {
  Name = UIWindowNames.UIPVEHeroAppearOther,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVEHeroAppearOther.Controller.UIPVEHeroAppearOtherCtrl"),
  View = require("UI.UIPVE.UIPVEHeroAppearOther.View.UIPVEHeroAppearOtherView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVEHeroAppearOther.prefab"
}
return {UIPVEHeroAppearOther = UIPVEHeroAppearOther}
