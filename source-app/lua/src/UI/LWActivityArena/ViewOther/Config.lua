local LWActivityArenaViewOther = {
  Name = UIWindowNames.LWActivityArenaViewOther,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActivityArena.ViewOther.LWActivityArenaViewOtherCtrl"),
  View = require("UI.LWActivityArena.ViewOther.LWActivityArenaViewOtherView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ArenaNewbie/UIActivityArenaViewOther.prefab"
}
return {LWActivityArenaViewOther = LWActivityArenaViewOther}
