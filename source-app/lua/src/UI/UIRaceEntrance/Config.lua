local UIRaceEntrance = {
  Name = UIWindowNames.UIRaceEntrance,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIRaceEntrance.Controller.UIRaceEntranceCtrl"),
  View = require("UI.UIRaceEntrance.View.UIRaceEntranceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIRaceEntrance/UIRaceEntrance.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {UIRaceEntrance = UIRaceEntrance}
