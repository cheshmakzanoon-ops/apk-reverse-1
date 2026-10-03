local UILWSeasonInviteDetail = {
  Name = UIWindowNames.UILWSeasonInviteDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.MakeFriends.UILWSeasonInviteDetail.Controller.UILWSeasonInviteDetailCtrl"),
  View = require("UI.LWSeason6.MakeFriends.UILWSeasonInviteDetail.View.UILWSeasonInviteDetailView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/MakeFriends/SeasonInviteDetail.prefab"
}
return {UILWSeasonInviteDetail = UILWSeasonInviteDetail}
