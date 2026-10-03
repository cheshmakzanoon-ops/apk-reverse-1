local UIBattleFieldUpDateNote = {
  Name = UIWindowNames.UIBattleFieldUpDateNote,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BattleFieldBase.UpdateNote.Ctrl.UIBattleFieldUpdateNoteCtrl"),
  View = require("UI.BattleFieldBase.UpdateNote.View.UIBattleFieldUpdateNoteView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BattleField/BattleFieldUpdateNote.prefab"
}
return {UIBattleFieldUpDateNote = UIBattleFieldUpDateNote}
