local UILWSurfingBattleBuffPopView = {
  Name = UIWindowNames.UILWSurfingBattleBuffPopView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISurfing.UIAct.BuffPop.Ctrl.UILWSurfingBattleBuffPopCtrl"),
  View = require("UI.UISurfing.UIAct.BuffPop.View.UILWSurfingBattleBuffPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SurfingBattle/UILWSurfingBattleBuffPop.prefab"
}
return {UILWSurfingBattleBuffPopView = UILWSurfingBattleBuffPopView}
