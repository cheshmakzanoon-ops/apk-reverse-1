local UIPVEAdventure = {
  Name = UIWindowNames.UIPVEAdventure,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIPVE.UIPVEAdventure.Controller.UIPVEAdventureCtrl"),
  View = require("UI.UIPVE.UIPVEAdventure.View.UIPVEAdventureView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVEAdventure.prefab"
}
return {UIPVEAdventure = UIPVEAdventure}
