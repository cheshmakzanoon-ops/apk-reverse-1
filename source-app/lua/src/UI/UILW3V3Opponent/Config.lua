local UILW3V3Opponent = {
  Name = UIWindowNames.UILW3V3Opponent,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILW3V3Opponent.Controller.UILW3V3OpponentCtrl"),
  View = require("UI.UILW3V3Opponent.View.UILW3V3OpponentView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/LWUI3V3Opponent.prefab"
}
return {UILW3V3Opponent = UILW3V3Opponent}
