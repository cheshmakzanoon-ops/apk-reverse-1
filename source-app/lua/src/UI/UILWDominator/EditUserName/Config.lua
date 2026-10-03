local UILWDominatorEditUserName = {
  Name = UIWindowNames.UILWDominatorEditUserName,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWDominator.EditUserName.Ctrl.UILWDominatorEditUserNameCtrl"),
  View = require("UI.UILWDominator.EditUserName.View.UILWDominatorEditUserNameView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorEditUserName.prefab"
}
return {UILWDominatorEditUserName = UILWDominatorEditUserName}
