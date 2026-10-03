local GMPageStyle = {}
GMPageStyle.PageTemplate = {}
GMPageStyle.PageTemplate.Vertical = {
  name = "styleVertical",
  prefab = "Assets/Main/Prefabs/UI/UIGMPanel/GMPanelPage/UIGMPanelPageVertical.prefab",
  lua = "UI.UIGMPanel.GMPanel.UIGMPanelPageVerticalStyle"
}
GMPageStyle.ItemTemplate = {}
GMPageStyle.ItemTemplate.ToggleRenderer = {
  lua = "UI.UIGMPanel.GMPanel.UIGMPanelPageVerticalDynamicToggle",
  prefab = "Assets/Main/Prefabs/UI/UIGMPanel/GMPanelPage/UIGMPanelPageVerticalDynamicToggle.prefab"
}
GMPageStyle.ItemTemplate.ButtonRenderer = {
  lua = "UI.UIGMPanel.GMPanel.UIGMPanelPageVerticalDynamicButton",
  prefab = "Assets/Main/Prefabs/UI/UIGMPanel/GMPanelPage/UIGMPanelPageVerticalDynamicButton.prefab"
}
GMPageStyle.ItemTemplate.InputRenderer = {
  lua = "UI.UIGMPanel.GMPanel.UIGMPanelPageVerticalDynamicInput",
  prefab = "Assets/Main/Prefabs/UI/UIGMPanel/GMPanelPage/UIGMPanelPageVerticalDynamicInput.prefab"
}
GMPageStyle.ItemTemplate.InputButtonRenderer = {
  lua = "UI.UIGMPanel.GMPanel.UIGMPanelPageVerticalDynamicInputButton",
  prefab = "Assets/Main/Prefabs/UI/UIGMPanel/GMPanelPage/UIGMPanelPageVerticalDynamicInputButton.prefab"
}
return GMPageStyle
