local UILWAlAuthorityManager = {
  Name = UIWindowNames.UILWAlAuthorityManager,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlAuthorityManager.Controller.UILWAlAuthorityManagerCtrl"),
  View = require("UI.UILWAlliance.UILWAlAuthorityManager.View.UILWAlAuthorityManagerView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlAuthorityManager.prefab"
}
return {UILWAlAuthorityManager = UILWAlAuthorityManager}
