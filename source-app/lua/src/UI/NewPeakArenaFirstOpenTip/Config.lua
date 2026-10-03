local NewPeakArenaFirstOpenTip = {
  Name = UIWindowNames.NewPeakArenaFirstOpenTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.NewPeakArenaFirstOpenTip.Controller.NewPeakArenaFirstOpenTipCtrl"),
  View = require("UI.NewPeakArenaFirstOpenTip.View.NewPeakArenaFirstOpenTipView"),
  PrefabPath = "Assets/Main/Prefabs/NewPeakArena/NewPeakArenaFirstOpenTip.prefab"
}
return {NewPeakArenaFirstOpenTip = NewPeakArenaFirstOpenTip}
