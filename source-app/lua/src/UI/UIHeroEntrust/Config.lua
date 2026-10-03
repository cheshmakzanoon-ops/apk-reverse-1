local UIHeroEntrust = {
  Name = UIWindowNames.UIHeroEntrust,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHeroEntrust.Controller.UIHeroEntrustCtrl"),
  View = require("UI.UIHeroEntrust.View.UIHeroEntrustView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHeroEntrust/UIHeroEntrust.prefab"
}
return {UIHeroEntrust = UIHeroEntrust}
