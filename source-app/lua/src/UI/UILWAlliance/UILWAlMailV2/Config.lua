local UILWAlMail = {
  Name = UIWindowNames.UILWAlMail_v2,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlMailV2.Controller.UILWAlMailCtrl_v2"),
  View = require("UI.UILWAlliance.UILWAlMailV2.View.UILWAlMailView_v2"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlMail_v2.prefab"
}
return {UILWAlMail = UILWAlMail}
