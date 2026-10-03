local UIActSlotMachineRecord = {
  Name = UIWindowNames.UIActSlotMachineRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActSlotMachine.UIActSlotMachineRecord.Controller.UIActSlotMachineRecordCtrl"),
  View = require("UI.UIActSlotMachine.UIActSlotMachineRecord.View.UIActSlotMachineRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActSlotMachine/UIActSlotMachineRecord.prefab"
}
return {UIActSlotMachineRecord = UIActSlotMachineRecord}
