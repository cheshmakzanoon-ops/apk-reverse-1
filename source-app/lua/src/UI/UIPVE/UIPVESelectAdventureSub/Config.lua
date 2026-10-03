local UIPVESelectAdventureSub = {
  Name = UIWindowNames.UIPVESelectAdventureSub,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVESelectAdventureSub.Controller.UIPVESelectAdventureSubCtrl"),
  View = require("UI.UIPVE.UIPVESelectAdventureSub.View.UIPVESelectAdventureSubView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVESelectAdventureSub.prefab"
}
return {UIPVESelectAdventureSub = UIPVESelectAdventureSub}
