local UIPersonalWar = {
  Name = UIWindowNames.UIPersonalWar,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIPersonalWar.Controller.UIPersonalWarCtrl"),
  View = require("UI.UIAlliance.UIPersonalWar.View.UIPersonalWarView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIPersonalWar.prefab"
}
return {UIPersonalWar = UIPersonalWar}
