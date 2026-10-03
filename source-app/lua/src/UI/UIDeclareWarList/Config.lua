local UIDeclareWarList = {
  Name = UIWindowNames.UIDeclareWarList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDeclareWarList.Controller.UIDeclareWarListCtrl"),
  View = require("UI.UIDeclareWarList.View.UIDeclareWarListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIDeclareWarList.prefab"
}
return {UIDeclareWarList = UIDeclareWarList}
