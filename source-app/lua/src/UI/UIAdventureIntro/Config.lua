local UIAdventureIntro = {
  Name = UIWindowNames.UIAdventureIntro,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIAdventureIntro.Controller.UIAdventureIntroCtrl"),
  View = require("UI.UIAdventureIntro.View.UIAdventureIntroView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAdventureIntro/UIAdventureIntro.prefab"
}
return {UIAdventureIntro = UIAdventureIntro}
