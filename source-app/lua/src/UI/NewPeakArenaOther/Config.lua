local NewPeakArenaOther = {
  Name = UIWindowNames.NewPeakArenaOther,
  Layer = UILayer.Normal,
  Ctrl = require("UI.NewPeakArenaOther.Controller.NewPeakArenaOtherCtrl"),
  View = require("UI.NewPeakArenaOther.View.NewPeakArenaOtherView"),
  PrefabPath = "Assets/Main/Prefabs/NewPeakArena/NewPeakArenaOther.prefab"
}
return {NewPeakArenaOther = NewPeakArenaOther}
