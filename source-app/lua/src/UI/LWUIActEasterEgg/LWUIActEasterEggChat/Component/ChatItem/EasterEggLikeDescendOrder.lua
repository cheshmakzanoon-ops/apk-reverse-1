local base = UIBaseContainer
local EasterEggLikeDescendOrder = BaseClass("EasterEggLikeDescendOrder", base)
local M = EasterEggLikeDescendOrder

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function M:ComponentDefine()
  self.btnSelect = self:AddComponent(UIButton, "Root/selectBtn")
  self.btnSelect:SetOnClick(function()
    self:OnBtnSelectClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/title")
  self.compCheck = self:AddComponent(UIBaseContainer, "Root/selectBtn/Background/Checkmark")
end

function M:OnDestroy()
  self:OnRecycleItem()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDestroy()
  self.btnSelect = nil
  self.textTitle = nil
  self.compCheck = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EasterEggChatChangeCommentLikeOrderState, self.ChangeCheckState)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.EasterEggChatChangeCommentLikeOrderState, self.ChangeCheckState)
  base.OnRemoveListener(self)
end

function M:OnRecycleItem()
end

function M:UpdateItem(chatdata, index)
  self._chatData = chatdata
  self.index = index
  self.textTitle:SetLocalText("activity_99144_ui_67")
  local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
  self.compCheck:SetActive(isLikeDescendOrder)
end

function M:SetContentViewScript(chatMainView)
  self._contentViewScript = chatMainView
end

function M:OnBtnSelectClick()
  local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
  isLikeDescendOrder = not isLikeDescendOrder
  DataCenter.ActEasterEggManager:SetIsOnLikeDescendOrder(isLikeDescendOrder)
  EventManager:GetInstance():Broadcast(EventId.EasterEggChatCommentLikeOrder)
end

function M:ChangeCheckState(state)
  self.compCheck:SetActive(state)
end

return M
