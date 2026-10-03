local UIActSlotMachineBox = {
  Name = UIWindowNames.UIActSlotMachineBox,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActSlotMachine.UIActSlotMachineBox.Controller.UIActSlotMachineBoxCtrl"),
  View = require("UI.UIActSlotMachine.UIActSlotMachineBox.View.UIActSlotMachineBoxView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActSlotMachine/UIActSlotMachineChooseBoxReward.prefab",
  CustomKeyCodeEscape = true
}
return {UIActSlotMachineBox = UIActSlotMachineBox}
