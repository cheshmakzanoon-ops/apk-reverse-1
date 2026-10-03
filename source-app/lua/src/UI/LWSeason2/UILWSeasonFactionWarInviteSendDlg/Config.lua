local UILWSeasonFactionWarInviteSendDlg = {
  Name = UIWindowNames.UILWSeasonFactionWarInviteSendDlg,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason2.UILWSeasonFactionWarInviteSendDlg.Controller.UILWSeasonFactionWarInviteSendDlgCtrl"),
  View = require("UI.LWSeason2.UILWSeasonFactionWarInviteSendDlg.View.UILWSeasonFactionWarInviteSendDlgView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonActivity/FactionWarInviteSendDlg.prefab"
}
return {UILWSeasonFactionWarInviteSendDlg = UILWSeasonFactionWarInviteSendDlg}
