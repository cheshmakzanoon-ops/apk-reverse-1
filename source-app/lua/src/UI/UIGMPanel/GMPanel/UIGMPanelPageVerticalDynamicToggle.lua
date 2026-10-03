local base = UIAsyncContainer
local UIGMPanelPageVerticalDynamicToggle = BaseClass("UIGMPanelPageVerticalDynamicToggle", base)
local Localization = CS.GameEntry.Localization

function UIGMPanelPageVerticalDynamicToggle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGMPanelPageVerticalDynamicToggle:OnDestroy()
  self.data = nil
  self.parentItem = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGMPanelPageVerticalDynamicToggle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnToggle = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnToggle:SetOnClick(function()
    self:OnBtnToggleClick()
  end)
  self.compToggleSelected = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
end

function UIGMPanelPageVerticalDynamicToggle:ComponentDestroy()
  self.viewSkin = nil
  self.btnToggle = nil
  self.compToggleSelected = nil
end

function UIGMPanelPageVerticalDynamicToggle:DataDefine()
end

function UIGMPanelPageVerticalDynamicToggle:DataDestroy()
end

function UIGMPanelPageVerticalDynamicToggle:OnAddListener()
  base.OnAddListener(self)
end

function UIGMPanelPageVerticalDynamicToggle:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGMPanelPageVerticalDynamicToggle:ReInit(data, parentItem)
  self.data = data
  self.parentItem = parentItem
  self:RefreshToggleState()
end

function UIGMPanelPageVerticalDynamicToggle:OnBtnToggleClick()
  if not (self.data ~= nil and self.data.set) or not self.data.get then
    return
  end
  self.data.set(not self:IsToggleSelected())
  self:RefreshToggleState()
end

function UIGMPanelPageVerticalDynamicToggle:OnToggleClicked()
end

function UIGMPanelPageVerticalDynamicToggle:IsToggleSelected()
  if not self.data or not self.data.get then
    return nil
  end
  return self.data.get()
end

function UIGMPanelPageVerticalDynamicToggle:RefreshToggleState()
  local isSelected = self:IsToggleSelected() or false
  self.compToggleSelected:SetActive(isSelected)
end

function UIGMPanelPageVerticalDynamicToggle:RefreshSkin(skin)
end

return UIGMPanelPageVerticalDynamicToggle
