local UITimelineJump = {
  Name = UIWindowNames.UITimelineJump,
  Layer = UILayer.TopMost,
  Ctrl = require("UI.UITimelineJump.Controller.UITimelineJumpCtrl"),
  View = require("UI.UITimelineJump.View.UITimelineJumpView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UITimelineJump.prefab"
}
return {UITimelineJump = UITimelineJump}
