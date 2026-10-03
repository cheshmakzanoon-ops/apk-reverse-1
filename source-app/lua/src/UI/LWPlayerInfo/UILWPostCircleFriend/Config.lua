local UILWPostCircleFriend = {
  Name = UIWindowNames.UILWPostCircleFriend,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWPostCircleFriend.Controller.UILWPostCircleFriendCtrl"),
  View = require("UI.LWPlayerInfo.UILWPostCircleFriend.View.UILWPostCircleFriendView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/UILWPostCircleFriend.prefab"
}
return {UILWPostCircleFriend = UILWPostCircleFriend}
