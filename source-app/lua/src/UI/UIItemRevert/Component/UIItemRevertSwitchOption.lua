local base = UIBaseContainer
local UIItemRevertSwitchOption = BaseClass("UIItemRevertSwitchOption", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIItemRevertSwitchOption:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIItemRevertSwitchOption:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIItemRevertSwitchOption:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textOptionName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 2)
  self.btnSwitch = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnSwitch:SetOnClick(function()
    self:OnBtnSwitchClick()
  end)
end

function UIItemRevertSwitchOption:ComponentDestroy()
  self.viewSkin = nil
  self.textOptionName = nil
  self.slider = nil
  self.btnSwitch = nil
end

function UIItemRevertSwitchOption:DataDefine()
end

function UIItemRevertSwitchOption:DataDestroy()
end

function UIItemRevertSwitchOption:OnAddListener()
  base.OnAddListener(self)
end

function UIItemRevertSwitchOption:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIItemRevertSwitchOption:SetCallData(index, onClick, selfData)
  self.index = index
  self.onClick = onClick
  self.selfData = selfData
  self.slider:SetValue(0.15)
  if self.index == 1 then
    self.textOptionName:SetText(Localization:GetString("undo_system2_condition7"))
  elseif self.index == 2 then
    self.textOptionName:SetText(Localization:GetString("undo_system2_condition8"))
  end
end

function UIItemRevertSwitchOption:OnBtnSwitchClick()
  if self.onClick then
    self.onClick(self.selfData, self.index)
  end
end

function UIItemRevertSwitchOption:SetSelected(isSelected)
  if isSelected then
    self.slider:SetValue(0.85)
  else
    self.slider:SetValue(0.15)
  end
end

return UIItemRevertSwitchOption
