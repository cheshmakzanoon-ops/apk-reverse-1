local UIAllianceStarMain = {
  Name = UIWindowNames.UIAllianceStarMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllianceStarMain.Controller.UIAllianceStarMainCtrl"),
  View = require("UI.UIAllianceStarMain.View.UIAllianceStarMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllianceStar/UIAllianceStarMain.prefab",
  HideBack = true,
  HideSceneCamera = true
}
return {UIAllianceStarMain = UIAllianceStarMain}
