local UIGetVirus = {
  Name = UIWindowNames.UIGetVirus,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGetVirus.Controller.UIGetVirusCtrl"),
  View = require("UI.UIGetVirus.View.UIGetVirusView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGetVirus/UIGetVirus.prefab"
}
return {UIGetVirus = UIGetVirus}
