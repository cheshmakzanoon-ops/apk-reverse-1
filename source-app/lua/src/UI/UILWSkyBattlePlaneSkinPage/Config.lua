local UISkyBattlePlaneSkinPage = {
  Name = UIWindowNames.UISkyBattlePlaneSkinPage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWSkyBattlePlaneSkinPage.UISkyBattlePlaneSkinPageCtrl"),
  View = require("UI.UILWSkyBattlePlaneSkinPage.UISkyBattlePlaneSkinPageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIStageSkyBattleChapter/UISkyBattlePlaneSkinPage.prefab"
}
return {UISkyBattlePlaneSkinPage = UISkyBattlePlaneSkinPage}
