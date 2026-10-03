local UIHeroResetSuccess = {
  Name = UIWindowNames.UIHeroResetSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroResetSuccess.Controller.UIHeroResetSuccessCtrl"),
  View = require("UI.UIHero2.UIHeroResetSuccess.View.UIHeroResetSuccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroResetSuccess.prefab"
}
return {UIHeroResetSuccess = UIHeroResetSuccess}
