local UIRewardShow = {
  Name = UIWindowNames.UIRewardShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIRewardShow.Controller.UIRewardShowCtrl"),
  View = require("UI.UIRewardShow.View.UIRewardShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BattlePass/UIRewardShow.prefab"
}
return {UIRewardShow = UIRewardShow}
