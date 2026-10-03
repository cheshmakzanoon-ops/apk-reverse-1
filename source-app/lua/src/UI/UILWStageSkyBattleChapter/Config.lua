local LWStageSkyBattleChapter = {
  Name = UIWindowNames.LWStageSkyBattleChapter,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWStageSkyBattleChapter.LWUIStageSkyBattleChapterCtrl"),
  View = require("UI.UILWStageSkyBattleChapter.LWUIStageSkyBattleChapterView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIStageSkyBattleChapter/LWUIStageSkyBattleChapter.prefab",
  HideBack = true
}
return {LWStageSkyBattleChapter = LWStageSkyBattleChapter}
