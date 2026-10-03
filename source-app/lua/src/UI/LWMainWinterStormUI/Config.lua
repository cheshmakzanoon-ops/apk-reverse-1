local LWMainWinterStormUI = {
  Name = UIWindowNames.LWMainWinterStormUI,
  Layer = UILayer.UIResource,
  Ctrl = require("UI.BattleFieldBase.BattleFieldBaseCtrl"),
  View = require("UI.LWMainWinterStormUI.View.LWMainWinterStormUIView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMainUI/LWMainWinterStormUI.prefab"
}
return {LWMainWinterStormUI = LWMainWinterStormUI}
