local LWUIZoneMobilizationSuppliesList = {
  Name = UIWindowNames.LWUIZoneMobilizationSuppliesList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIZoneMobilization.LWUISuppliesListView.Controller.LWUIZoneMobilizationSuppliesListCtrl"),
  View = require("UI.LWUIZoneMobilization.LWUISuppliesListView.View.LWUIZoneMobilizationSuppliesListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIZoneMobilization/LWUIZoneMobilizationSuppliesListPanel.prefab"
}
return {LWUIZoneMobilizationSuppliesList = LWUIZoneMobilizationSuppliesList}
