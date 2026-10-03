local UIActSlotMachineTask = {
  Name = UIWindowNames.UIActSlotMachineTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActSlotMachine.UIActSlotMachineTask.Controller.UIActSlotMachineTaskCtrl"),
  View = require("UI.UIActSlotMachine.UIActSlotMachineTask.View.UIActSlotMachineTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActSlotMachine/UIActSlotMachineTask.prefab"
}
return {UIActSlotMachineTask = UIActSlotMachineTask}
