local UIWestwardExpansionInstruction = {
  Name = UIWindowNames.UIWestwardExpansionInstruction,
  Layer = UILayer.Normal,
  Ctrl = require("UI.WestwardExpansion.UIWestwardExpansionInstructionCtrl"),
  View = require("UI.WestwardExpansion.UIWestwardExpansionInstructionView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/WestwardExpansion/UIWestwardExpansionInstruction.prefab"
}
return {UIWestwardExpansionInstruction = UIWestwardExpansionInstruction}
