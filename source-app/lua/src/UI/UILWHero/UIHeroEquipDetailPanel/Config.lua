local UIHeroEquipDetailPanel = {
  Name = UIWindowNames.UIHeroEquipDetailPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroEquipDetailPanel.Controller.UIHeroEquipDetailPanelCtrl"),
  View = require("UI.UILWHero.UIHeroEquipDetailPanel.View.UIHeroEquipDetailPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroEquipDetailPanel.prefab",
  CustomKeyCodeEscape = true
}
return {UIHeroEquipDetailPanel = UIHeroEquipDetailPanel}
