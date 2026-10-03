local UIAllyDuelNotice = {
  Name = UIWindowNames.UIAllyDuelNotice,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllyDuel.UIAllyDuelNotice.Controller.UIAllyDuelNoticeCtrl"),
  View = require("UI.UIAllyDuel.UIAllyDuelNotice.View.UIAllyDuelNoticeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllyDuel/UIAllyDuelNotice.prefab"
}
return {UIAllyDuelNotice = UIAllyDuelNotice}
