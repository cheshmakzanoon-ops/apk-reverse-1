local UIPVEAdventureRaid = {
  Name = UIWindowNames.UIPVEAdventureRaid,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIPVE.UIPVEAdventureRaid.Controller.UIPVEAdventureRaidCtrl"),
  View = require("UI.UIPVE.UIPVEAdventureRaid.View.UIPVEAdventureRaidView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVEAdventureRaid.prefab"
}
return {UIPVEAdventureRaid = UIPVEAdventureRaid}
