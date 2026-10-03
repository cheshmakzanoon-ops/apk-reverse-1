local base = UIBaseContainer
local UIItemRevertFilterOption = BaseClass("UIItemRevertFilterOption", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIItemRevertFilterOption:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIItemRevertFilterOption:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIItemRevertFilterOption:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compImageGou = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.textOptionName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClick = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClick:SetOnClick(function()
    self:OnBtnClickClick()
  end)
end

function UIItemRevertFilterOption:ComponentDestroy()
  self.viewSkin = nil
  self.compImageGou = nil
  self.textOptionName = nil
  self.btnClick = nil
end

function UIItemRevertFilterOption:DataDefine()
end

function UIItemRevertFilterOption:DataDestroy()
end

function UIItemRevertFilterOption:OnAddListener()
  base.OnAddListener(self)
end

function UIItemRevertFilterOption:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIItemRevertFilterOption:SetCallData(index, onClick, selfData)
  self.index = index
  self.onClick = onClick
  self.selfData = selfData
  local optionNameKey = string.format("undo_system2_condition%d", index)
  local optionNameStr = Localization:GetString(optionNameKey)
  self.textOptionName:SetText(optionNameStr)
end

function UIItemRevertFilterOption:OnBtnClickClick()
  if self.onClick then
    self.onClick(self.selfData, self.index)
  end
end

function UIItemRevertFilterOption:SetSelected(selected)
  self.compImageGou:SetActive(selected)
end

return UIItemRevertFilterOption
