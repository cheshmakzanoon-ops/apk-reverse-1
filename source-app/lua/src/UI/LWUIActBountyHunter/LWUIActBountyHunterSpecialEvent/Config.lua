local BountyHunterSpecialEvent = {
  Name = UIWindowNames.BountyHunterSpecialEvent,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActBountyHunter.LWUIActBountyHunterSpecialEvent.Ctrl.UIActBountyHunterSpecialEventCtrl"),
  View = require("UI.LWUIActBountyHunter.LWUIActBountyHunterSpecialEvent.View.UIActBountyHunterSpecialEventView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterSpecialEvent/UIActBountyHunterSpecialEvent.prefab"
}
return {BountyHunterSpecialEvent = BountyHunterSpecialEvent}
