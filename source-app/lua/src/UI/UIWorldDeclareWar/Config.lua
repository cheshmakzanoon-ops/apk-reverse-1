local UIWorldDeclareWar = {
  Name = UIWindowNames.UIWorldDeclareWar,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldDeclareWar.Controller.UIWorldDeclareWarCtrl"),
  View = require("UI.UIWorldDeclareWar.View.UIWorldDeclareWarView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIWorldDeclareWar.prefab"
}
return {UIWorldDeclareWar = UIWorldDeclareWar}
