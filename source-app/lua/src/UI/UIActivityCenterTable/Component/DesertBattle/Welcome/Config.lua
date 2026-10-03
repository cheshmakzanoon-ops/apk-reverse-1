local UIDesertWelcome = {
  Name = UIWindowNames.UIDesertWelcome,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.Welcome.Controller.UIDesertWelcomeCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.Welcome.View.UIDesertWelcomeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/Welcome.prefab"
}
return {UIDesertWelcome = UIDesertWelcome}
