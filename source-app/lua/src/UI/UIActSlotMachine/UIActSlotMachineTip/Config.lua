local UIActSlotMachineTip = {
  Name = UIWindowNames.UIActSlotMachineTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActSlotMachine.UIActSlotMachineTip.Controller.UIActSlotMachineTipCtrl"),
  View = require("UI.UIActSlotMachine.UIActSlotMachineTip.View.UIActSlotMachineTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActSlotMachine/UIActSlotMachineTip.prefab"
}
return {UIActSlotMachineTip = UIActSlotMachineTip}
