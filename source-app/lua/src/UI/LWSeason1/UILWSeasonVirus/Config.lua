local UILWSeasonVirus = {
  Name = UIWindowNames.UILWSeasonVirus,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.UILWSeasonVirus.Controller.UILWSeasonVirusCtrl"),
  View = require("UI.LWSeason1.UILWSeasonVirus.View.UILWSeasonVirusView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/VirusPopup.prefab"
}
return {UILWSeasonVirus = UILWSeasonVirus}
