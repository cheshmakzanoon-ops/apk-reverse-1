local UIAllianceIntro = {
  Name = UIWindowNames.UIAllianceIntro,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllianceIntro.Controller.UIAllianceIntroCtrl"),
  View = require("UI.UIAllianceIntro.View.UIAllianceIntroView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceIntro.prefab"
}
return {UIAllianceIntro = UIAllianceIntro}
