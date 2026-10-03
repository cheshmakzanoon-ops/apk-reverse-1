local LWUIRefundFaqView = BaseClass("LWUIRefundFaqView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIRefundFaqItem = require("UI.LWUIRefundFaq.Component.LWUIRefundFaqItem")
local M = LWUIRefundFaqView

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function M:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "TopBar/TextTitle")
  self.scroll = self:AddComponent(UILoopListView2, "ScrollRect")
  self.compContent = self:AddComponent(UIBaseContainer, "ScrollRect/Viewport/Content")
  self.btnClose = self:AddComponent(UIButton, "BottomBar/BtnClose")
  self.btnClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnRequest = self:AddComponent(UIButton, "BottomBar/RefundBtns/RequestBtn")
  self.btnRequest:SetOnClick(function()
    self:OnBtnRequestClick()
  end)
  self.textRequestBtn = self:AddComponent(UITextMeshProUGUIEx, "BottomBar/RefundBtns/RequestBtn/RequestBtnText")
  self.goldBlockBtn = self:AddComponent(UIButton, "BottomBar/RefundBtns/goldBlockBtn")
  self.goldBlockBtn:SetOnClick(function()
    self:OnBtnGoldBlockClick()
  end)
  self.textGoldBlockBtn = self:AddComponent(UITextMeshProUGUIEx, "BottomBar/RefundBtns/goldBlockBtn/goldBlockBtnText")
  self.scroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
end

function M:ComponentDestroy()
  self.textTitle = nil
  self.scroll = nil
  self.compContent = nil
  self.btnClose = nil
  self.btnRequest = nil
  self.textRequestBtn = nil
  self.goldBlockBtn = nil
  self.textGoldBlockBtn = nil
end

function M:DataDefine()
  self.faqMap = nil
  self.itemIndex = 0
end

function M:DataDestroy()
  self.faqMap = nil
  self.itemIndex = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWRefundFAQClick, self.OnClickFAQ)
  self:AddUIListener(EventId.LWRefundBanUpdate, self.RefreshRefundBtnState)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.LWRefundFAQClick, self.OnClickFAQ)
  self:RemoveUIListener(EventId.LWRefundBanUpdate, self.RefreshRefundBtnState)
end

function M:OnBtnRequestClick()
  DataCenter.LWRefundManager.CurRefundListPfType = RefundListPfType.Google
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIRefund)
  PostEventLog.Track(PostEventLog.Defines.OpenRefundApplicationView)
end

function M:OnBtnGoldBlockClick()
  DataCenter.LWRefundManager.CurRefundListPfType = RefundListPfType.GoldBlock
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIRefund)
  PostEventLog.Track(PostEventLog.Defines.OpenGoldBrickRetrieval)
end

function M:ClearScroll()
  self.compContent:RemoveComponents(LWUIRefundFaqItem)
  self.scroll:ClearAllItems()
  self.scroll.unity_looplistview2.mOnDragingAction = nil
end

function M:InitView()
  self.textTitle:SetLocalText("refund_interface_subject_help")
  self.textRequestBtn:SetLocalText("refund_interface_button_request")
  self.textGoldBlockBtn:SetLocalText("refund_btn_goldbrick")
  self:RefreshRefundBtnState()
  self.faqMap = DataCenter.LWRefundManager:GetFAQMap()
  for _, v in pairs(self.faqMap) do
    v.curState = 0
  end
  if not self.faqMap or table.count(self.faqMap) == 0 then
    Logger.LogError("faq map is nil")
    return
  end
  self:RefreshScroll()
end

function M:RefreshRefundBtnState()
  local showRequest = self.ctrl:GetShowRequestBtn()
  self.btnRequest:SetActive(showRequest)
  local showGoldBlock = self.ctrl:GetShowGoldBlockBtn()
  self.goldBlockBtn:SetActive(showGoldBlock)
  local isRefundBan = self.ctrl:IsRefundBan()
  if isRefundBan then
    self.btnRequest:SetActive(false)
    self.goldBlockBtn:SetActive(false)
  end
end

function M:RefreshScroll()
  if self.scroll == nil or #self.faqMap == 0 then
    self.scroll:SetActive(false)
  else
    self.scroll:SetActive(true)
    self.scroll:SetListItemCount(#self.faqMap, false, false)
    self.scroll:RefreshAllShownItem()
  end
end

function M:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.faqMap then
    return nil
  end
  local faqInfo = self.faqMap[index]
  local item = loopScroll:NewListViewItem("LWUIRefundFaqItem")
  local script = self.compContent:GetComponent(item.gameObject.name, LWUIRefundFaqItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.compContent:AddComponent(LWUIRefundFaqItem, objectName)
  end
  script:SetActive(true)
  script:ReInit(faqInfo, self.scroll, index)
  return item
end

function M:OnClickFAQ(index)
  local faqInfo = self.faqMap[index]
  if not faqInfo then
    Logger.LogError("faqInfo is nil for index: " .. index)
    return
  end
  faqInfo.curState = (faqInfo.curState + 1) % 2
  self:RefreshScroll()
end

return LWUIRefundFaqView
