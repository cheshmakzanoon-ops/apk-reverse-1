local UIHeroAdvanceOneKeySuccess = {
  Name = UIWindowNames.UIHeroAdvanceOneKeySuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroAdvanceOneKeySuccess.Controller.UIHeroAdvanceOneKeySuccessCtrl"),
  View = require("UI.UIHero2.UIHeroAdvanceOneKeySuccess.View.UIHeroAdvanceOneKeySuccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroAdvanceOneKeySuccess.prefab"
}
return {UIHeroAdvanceOneKeySuccess = UIHeroAdvanceOneKeySuccess}
