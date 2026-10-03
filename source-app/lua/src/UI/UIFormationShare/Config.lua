local UIFormationShare = {
  Name = UIWindowNames.UIFormationShare,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormationShare.Controller.UIFormationShareCtrl"),
  View = require("UI.UIFormationShare.View.UIFormationShareView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFormation/UIFormationSharePopUp.prefab"
}
return {UIFormationShare = UIFormationShare}
