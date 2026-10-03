local UIPVEHeroAppear = {
  Name = UIWindowNames.UIPVEHeroAppear,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVEHeroAppear.Controller.UIPVEHeroAppearCtrl"),
  View = require("UI.UIPVE.UIPVEHeroAppear.View.UIPVEHeroAppearView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVEHeroAppear.prefab"
}
return {UIPVEHeroAppear = UIPVEHeroAppear}
