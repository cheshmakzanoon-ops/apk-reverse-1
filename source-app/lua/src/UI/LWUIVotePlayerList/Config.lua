local LWUIVotePlayerList = {
  Name = UIWindowNames.LWUIVotePlayerList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIVotePlayerList.Controller.LWUIVotePlayerListCtrl"),
  View = require("UI.LWUIVotePlayerList.View.LWUIVotePlayerListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatNotice/LWUIVotePlayerList.prefab"
}
return {LWUIVotePlayerList = LWUIVotePlayerList}
