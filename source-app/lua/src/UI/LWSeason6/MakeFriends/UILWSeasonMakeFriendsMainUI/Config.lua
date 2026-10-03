local UILWSeasonMakeFriendsMainUI = {
  Name = UIWindowNames.UILWSeasonMakeFriendsMainUI,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsMainUI.Controller.UILWSeasonMakeFriendsMainUICtrl"),
  View = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsMainUI.View.UILWSeasonMakeFriendsMainUIView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/MakeFriends/SeasonMakeFriendsMainUI.prefab",
  HideBack = true
}
return {UILWSeasonMakeFriendsMainUI = UILWSeasonMakeFriendsMainUI}
