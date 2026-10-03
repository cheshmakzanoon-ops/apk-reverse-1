local UISiegeInstruction = {
  Name = UIWindowNames.UISiegeInstruction,
  Layer = UILayer.Info,
  Ctrl = require("UI.UISiegeInstruction.Controller.UISiegeInstructionCtrl"),
  View = require("UI.UISiegeInstruction.View.UISiegeInstructionView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UISiegeInstruction.prefab"
}
return {UISiegeInstruction = UISiegeInstruction}
