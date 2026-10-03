local UILWFriendsCircleFollowee = {
  Name = UIWindowNames.UILWFriendsCircleFollowee,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWFriendsCircleFollowee.Controller.UILWFriendsCircleFolloweeCtrl"),
  View = require("UI.UILWFriendsCircleFollowee.View.UILWFriendsCircleFolloweeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/FiendCircle/UILWFriendsCircleFollowee.prefab"
}
return {UILWFriendsCircleFollowee = UILWFriendsCircleFollowee}
