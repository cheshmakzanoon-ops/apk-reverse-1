local UIDesertJumpTo = {
  Name = UIWindowNames.UIDesertJumpTo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.JumpTo.Controller.UIDesertJumpToCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.JumpTo.View.UIDesertJumpToView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/JumpTo.prefab"
}
return {UIDesertJumpTo = UIDesertJumpTo}
