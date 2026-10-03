local UILWSeasonMakeFriendsPopup = {
  Name = UIWindowNames.UILWSeasonMakeFriendsPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsPopup.Controller.UILWSeasonMakeFriendsPopupCtrl"),
  View = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsPopup.View.UILWSeasonMakeFriendsPopupView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/MakeFriends/SeasonMakeFriendsPopup.prefab"
}
return {UILWSeasonMakeFriendsPopup = UILWSeasonMakeFriendsPopup}
