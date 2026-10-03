local UILWSeasonInviteMailPopup = {
  Name = UIWindowNames.UILWSeasonInviteMailPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.MakeFriends.UILWSeasonInviteMailPopup.Controller.UILWSeasonInviteMailPopupCtrl"),
  View = require("UI.LWSeason6.MakeFriends.UILWSeasonInviteMailPopup.View.UILWSeasonInviteMailPopupView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/MakeFriends/SeasonInviteMailPopup.prefab"
}
return {UILWSeasonInviteMailPopup = UILWSeasonInviteMailPopup}
