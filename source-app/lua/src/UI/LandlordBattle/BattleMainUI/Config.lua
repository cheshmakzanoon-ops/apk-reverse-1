local LWLLBattleMainUIView = {
  Name = UIWindowNames.LWLLBattleMainUIView,
  Layer = UILayer.UIResource,
  Ctrl = require("UI.LandlordBattle.BattleMainUI.Controller.LWLLBattleMainUICtrl"),
  View = require("UI.LandlordBattle.BattleMainUI.View.LWLLBattleMainUIView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMainUI/LandlordBattle/LWLandlordMainBattleUI.prefab"
}
return {LWLLBattleMainUIView = LWLLBattleMainUIView}
