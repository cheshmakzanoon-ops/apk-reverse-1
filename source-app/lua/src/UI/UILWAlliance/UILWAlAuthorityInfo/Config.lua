local UILWAlAuthorityInfo = {
  Name = UIWindowNames.UILWAlAuthorityInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlAuthorityInfo.Controller.UILWAlAuthorityInfoCtrl"),
  View = require("UI.UILWAlliance.UILWAlAuthorityInfo.View.UILWAlAuthorityInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlAuthorityInfo.prefab"
}
return {UILWAlAuthorityInfo = UILWAlAuthorityInfo}
