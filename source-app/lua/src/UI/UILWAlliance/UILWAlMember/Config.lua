local UILWAlMember = {
  Name = UIWindowNames.UILWAlMember,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlMember.Controller.UILWAlMemberCtrl"),
  View = require("UI.UILWAlliance.UILWAlMember.View.UILWAlMemberView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlMember.prefab"
}
return {UILWAlMember = UILWAlMember}
