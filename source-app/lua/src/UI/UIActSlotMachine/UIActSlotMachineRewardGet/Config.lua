local UIActSlotMachineRewardGet = {
  Name = UIWindowNames.UIActSlotMachineRewardGet,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIActSlotMachine.UIActSlotMachineRewardGet.Controller.UIActSlotMachineRewardGetCtrl"),
  View = require("UI.UIActSlotMachine.UIActSlotMachineRewardGet.View.UIActSlotMachineRewardGetView"),
  PrefabPath = "Assets/Main/ActivityFestival/ActSlotMachine/Prefab/UIActSlotMachineGetReward.prefab"
}
return {UIActSlotMachineRewardGet = UIActSlotMachineRewardGet}
