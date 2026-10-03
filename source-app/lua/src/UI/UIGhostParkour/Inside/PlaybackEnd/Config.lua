local UIGhostParkourPlaybackEnd = {
  Name = UIWindowNames.UIGhostParkourPlaybackEnd,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGhostParkour.Inside.PlaybackEnd.Controller.UIGhostParkourPlaybackEndCtrl"),
  View = require("UI.UIGhostParkour.Inside.PlaybackEnd.View.UIGhostParkourPlaybackEndView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/Inside/UIGhostParkourPlaybackEnd.prefab"
}
return {UIGhostParkourPlaybackEnd = UIGhostParkourPlaybackEnd}
