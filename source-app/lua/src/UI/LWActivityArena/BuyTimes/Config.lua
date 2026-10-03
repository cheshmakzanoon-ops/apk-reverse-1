local LWActivityArenaBuyTimes = {
  Name = UIWindowNames.LWActivityArenaBuyTimes,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActivityArena.BuyTimes.LWActivityArenaBuyTimesCtrl"),
  View = require("UI.LWActivityArena.BuyTimes.LWActivityArenaBuyTimesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ArenaNewbie/UIActivityArenaBuyTimes.prefab"
}
return {LWActivityArenaBuyTimes = LWActivityArenaBuyTimes}
