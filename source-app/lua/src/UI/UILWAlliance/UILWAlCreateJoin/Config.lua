local UILWAlCreateJoin = {
  Name = UIWindowNames.UILWAlCreateJoin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlCreateJoin.Controller.UILWAlCreateJoinCtrl"),
  View = require("UI.UILWAlliance.UILWAlCreateJoin.View.UILWAlCreateJoinView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlCreateJoin.prefab",
  HideBack = true
}
return {UILWAlCreateJoin = UILWAlCreateJoin}
