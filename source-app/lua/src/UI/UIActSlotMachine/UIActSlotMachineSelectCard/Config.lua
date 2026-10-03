local UIActSlotMachineSelectCard = {
  Name = UIWindowNames.UIActSlotMachineSelectCard,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActSlotMachine.UIActSlotMachineSelectCard.Controller.UIActSlotMachineSelectCardCtrl"),
  View = require("UI.UIActSlotMachine.UIActSlotMachineSelectCard.View.UIActSlotMachineSelectCardView"),
  PrefabPath = "Assets/Main/ActivityFestival/ActSlotMachine/Prefab/UIActSlotMachineSelectCard.prefab",
  CustomKeyCodeEscape = true
}
return {UIActSlotMachineSelectCard = UIActSlotMachineSelectCard}
