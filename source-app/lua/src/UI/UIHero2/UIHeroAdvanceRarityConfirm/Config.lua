local UIHeroAdvanceRarityConfirm = {
  Name = UIWindowNames.UIHeroAdvanceRarityConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroAdvanceRarityConfirm.Controller.UIHeroAdvanceRarityConfirmCtrl"),
  View = require("UI.UIHero2.UIHeroAdvanceRarityConfirm.View.UIHeroAdvanceRarityConfirm"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroAdvanceRarityConfirm.prefab"
}
return {UIHeroAdvanceRarityConfirm = UIHeroAdvanceRarityConfirm}
