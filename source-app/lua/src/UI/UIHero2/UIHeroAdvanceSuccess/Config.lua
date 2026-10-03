local UIHeroAdvanceSuccess = {
  Name = UIWindowNames.UIHeroAdvanceSuccess,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHero2.UIHeroAdvanceSuccess.Controller.UIHeroAdvanceSuccessCtrl"),
  View = require("UI.UIHero2.UIHeroAdvanceSuccess.View.UIHeroAdvanceSuccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroAdvanceSuccess.prefab"
}
return {UIHeroAdvanceSuccess = UIHeroAdvanceSuccess}
