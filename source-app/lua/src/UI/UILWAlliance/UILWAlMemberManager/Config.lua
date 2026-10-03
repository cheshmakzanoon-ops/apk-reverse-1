local UILWAlMemberManager = {
  Name = UIWindowNames.UILWAlMemberManager,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlMemberManager.Controller.UILWAlMemberManagerCtrl"),
  View = require("UI.UILWAlliance.UILWAlMemberManager.View.UILWAlMemberManagerView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlMemberManager.prefab"
}
return {UILWAlMemberManager = UILWAlMemberManager}
