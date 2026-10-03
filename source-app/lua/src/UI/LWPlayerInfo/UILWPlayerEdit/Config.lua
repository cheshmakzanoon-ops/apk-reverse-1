local UILWPlayerEdit = {
  Name = UIWindowNames.UILWPlayerEdit,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWPlayerEdit.Controller.UILWPlayerEditCtrl"),
  View = require("UI.LWPlayerInfo.UILWPlayerEdit.View.UILWPlayerEditView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/PlayerEditMain.prefab"
}
return {UILWPlayerEdit = UILWPlayerEdit}
