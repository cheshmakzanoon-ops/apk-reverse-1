local UIAllianceCompeteNew = {
  Name = UIWindowNames.UIAllianceCompeteNew,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIAllianceCompeteNew.Controller.UIAllianceCompeteNewCtrl"),
  View = require("UI.UIAllianceCompeteNew.View.UIAllianceCompeteNewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllianceCompeteNew/UIAllianceCompeteNew.prefab"
}
return {UIAllianceCompeteNew = UIAllianceCompeteNew}
