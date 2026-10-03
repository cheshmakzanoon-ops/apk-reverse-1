local LWUIFriendsCircleSetting = {
  Name = UIWindowNames.LWUIFriendsCircleSetting,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWFriendsCircleSetting.Controller.UILWFriendsCircleSettingCtrl"),
  View = require("UI.LWPlayerInfo.UILWFriendsCircleSetting.View.UILWFriendsCircleSettingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/MomentDetail/LWUIFriendsCircleSetting.prefab"
}
return {LWUIFriendsCircleSetting = LWUIFriendsCircleSetting}
