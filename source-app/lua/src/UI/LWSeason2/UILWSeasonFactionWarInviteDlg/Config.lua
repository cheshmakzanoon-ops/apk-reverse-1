local UILWSeasonFactionWarInviteDlg = {
  Name = UIWindowNames.UILWSeasonFactionWarInviteDlg,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason2.UILWSeasonFactionWarInviteDlg.Controller.UILWSeasonFactionWarInviteDlgCtrl"),
  View = require("UI.LWSeason2.UILWSeasonFactionWarInviteDlg.View.UILWSeasonFactionWarInviteDlgView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonActivity/FactionWarInviteDlg.prefab"
}
return {UILWSeasonFactionWarInviteDlg = UILWSeasonFactionWarInviteDlg}
