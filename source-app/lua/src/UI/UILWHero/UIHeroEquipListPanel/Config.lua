local UIHeroEquipListPanel = {
  Name = UIWindowNames.UIHeroEquipListPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroEquipListPanel.Controller.UIHeroEquipListPanelCtrl"),
  View = require("UI.UILWHero.UIHeroEquipListPanel.View.UIHeroEquipListPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroEquipListPanel.prefab"
}
return {UIHeroEquipListPanel = UIHeroEquipListPanel}
