local UILWPlayerThumbsUpHistory = {
  Name = UIWindowNames.UILWPlayerThumbsUpHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWPlayerThumbsUpHistory.Controller.UILWPlayerThumbsUpHistoryCtrl"),
  View = require("UI.LWPlayerInfo.UILWPlayerThumbsUpHistory.View.UILWPlayerThumbsUpHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/PlayerThumbsUpHistory.prefab"
}
return {UILWPlayerThumbsUpHistory = UILWPlayerThumbsUpHistory}
