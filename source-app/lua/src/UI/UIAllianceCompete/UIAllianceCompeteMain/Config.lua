local UIAllianceCompeteMain = {
  Name = UIWindowNames.UIAllianceCompeteMain,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIAllianceCompete.UIAllianceCompeteMain.Controller.UIAllianceCompeteMainCtrl"),
  View = require("UI.UIAllianceCompete.UIAllianceCompeteMain.View.UIAllianceCompeteMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllianceCompeteNew/UIAllianceCompeteMain.prefab"
}
return {UIAllianceCompeteMain = UIAllianceCompeteMain}
