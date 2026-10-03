local UIMailBattleAttrDetail = {
  Name = UIWindowNames.UIMailBattleAttrDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMailNew.UIMailBattleAttrDetail.Controller.UIMailBattleAttrDetailCtrl"),
  View = require("UI.UIMailNew.UIMailBattleAttrDetail.View.UIMailBattleAttrDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Mail/ObjMail/PlayerReport/MailPlayerReportInfo.prefab"
}
return {UIMailBattleAttrDetail = UIMailBattleAttrDetail}
