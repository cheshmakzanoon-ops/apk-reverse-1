local UILWAlMail = {
  Name = UIWindowNames.UILWAlMail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlMail.Controller.UILWAlMailCtrl"),
  View = require("UI.UILWAlliance.UILWAlMail.View.UILWAlMailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlMail.prefab"
}
return {UILWAlMail = UILWAlMail}
