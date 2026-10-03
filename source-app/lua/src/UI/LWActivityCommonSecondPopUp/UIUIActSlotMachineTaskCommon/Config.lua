local UIActSlotMachineTaskCommon = {
  Name = UIWindowNames.UIActSlotMachineTaskCommon,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActivityCommonSecondPopUp.UIUIActSlotMachineTaskCommon.Ctrl.UIActSlotMachineTaskCommonCtrl"),
  View = require("UI.LWActivityCommonSecondPopUp.UIUIActSlotMachineTaskCommon.View.UIActSlotMachineTaskCommonView"),
  PrefabPath = "Assets/Main/ActivityFestival/ActSlotMachine/Prefab/UIActSlotMachineTaskCommon.prefab"
}
return {UIActSlotMachineTaskCommon = UIActSlotMachineTaskCommon}
