local UISetPlayerNation = {
  Name = UIWindowNames.UISetPlayerNation,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetPlayerNation.Controller.UISetPlayerNationCtrl"),
  View = require("UI.UISetPlayerNation.View.UISetPlayerNationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetPlayerNation/UISetPlayerNationNew.prefab"
}
return {UISetPlayerNation = UISetPlayerNation}
