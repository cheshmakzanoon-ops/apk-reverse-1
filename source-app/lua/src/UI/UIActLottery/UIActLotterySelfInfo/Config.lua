local UIActLotterySelfInfo = {
  Name = UIWindowNames.UIActLotterySelfInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActLottery.UIActLotterySelfInfo.Ctrl.UIActLotterySelfInfoCtrl"),
  View = require("UI.UIActLottery.UIActLotterySelfInfo.View.UIActLotterySelfInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActLottery/UIActLotterySelfInfo.prefab"
}
return {UIActLotterySelfInfo = UIActLotterySelfInfo}
