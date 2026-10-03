local MailScoutFormationDetail = {
  Name = UIWindowNames.MailScoutFormationDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.MailScoutFormationDetail.Controller.MailScoutFormationDetailCtrl"),
  View = require("UI.MailScoutFormationDetail.View.MailScoutFormationDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMail/MailScout/MailScoutFormationDetail.prefab"
}
return {MailScoutFormationDetail = MailScoutFormationDetail}
