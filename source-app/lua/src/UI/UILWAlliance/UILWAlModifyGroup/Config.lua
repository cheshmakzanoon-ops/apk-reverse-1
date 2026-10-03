local UILWAlModifyGroup = {
  Name = UIWindowNames.UILWAlModifyGroup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlModifyGroup.Controller.UILWAlModifyGroupCtrl"),
  View = require("UI.UILWAlliance.UILWAlModifyGroup.View.UILWAlModifyGroupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlModifyGroup.prefab"
}
return {UILWAlModifyGroup = UILWAlModifyGroup}
