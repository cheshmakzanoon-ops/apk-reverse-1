local LWUIRefundApplicationView = BaseClass("LWUIRefundApplicationView", UIBaseView)
local base = UIBaseView
local M = LWUIRefundApplicationView
local Localization = CS.GameEntry.Localization
local LWUIRefundApplicationItem = require("UI.LWUIRefund.Component.LWUIRefundApplicationItem")

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
    self:OnBtnCloseClick()
  end)
  self.btnRequest = self:AddComponent(UIButton, "BottomBar/RequestBtn")
  self.btnRequest:SetOnClick(function()
    self:OnBtnRequestClick()
  end)
  self.textRequestBtn = self:AddComponent(UITextMeshProUGUIEx, "BottomBar/RequestBtn/RequestBtnText")
  self.textView = self:AddComponent(UITextMeshProUGUIEx, "ViewText")
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
  self.textView = nil
end

function M:DataDefine()
  self.payList = {}
  self.itemIndex = 0
end

function M:DataDestroy()
  self.payList = nil
  self.itemIndex = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWRefundRecPayList, self.OnReceivePayList)
  self:AddUIListener(EventId.LWRefundRecPayListClickOrder, self.OnRecCLickOrder)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.LWRefundRecPayList, self.OnReceivePayList)
  self:RemoveUIListener(EventId.LWRefundRecPayListClickOrder, self.OnRecCLickOrder)
  base.OnRemoveListener(self)
end

function M:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function M:OnBtnRequestClick()
  local orderId = self.ctrl:GetSelectOrder()
  if not orderId or orderId == 0 then
    return
  end
  local tmpMsg = ""
  if DataCenter.LWRefundManager.CurRefundListPfType == RefundListPfType.GoldBlock then
    tmpMsg = Localization:GetString("refund_tips_goldbrick_comfirm")
  else
    tmpMsg = Localization:GetString("refund_window_confirm_description")
  end
  UIUtil.ShowMessage(tmpMsg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self.ctrl:RequestRefund()
    self:SetRequestedText()
  end)
end

function M:InitView()
  self.ctrl:InitData()
  if DataCenter.LWRefundManager.CurRefundListPfType == RefundListPfType.GoldBlock then
    self.textTitle:SetLocalText("refund_title_goldbrick")
  else
    self.textTitle:SetLocalText("refund_interface_subject_request")
  end
  self.textRequestBtn:SetLocalText("refund_interface_button_submit")
  CS.UIGray.SetGray(self.btnRequest.transform, true, false)
  self.textView:SetActive(false)
  self.btnRequest:SetActive(true)
  self:RequestRefundList()
end

function M:ClearScroll()
  self.compContent:RemoveComponents(LWUIRefundApplicationItem)
  self.scroll:ClearAllItems()
end

function M:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.payList then
    return nil
  end
  local payData = self.payList[index]
  local item = loopScroll:NewListViewItem("LWUIRefundApplicationItem")
  local script = self.compContent:GetComponent(item.gameObject.name, LWUIRefundApplicationItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.compContent:AddComponent(LWUIRefundApplicationItem, objectName)
  end
  script:SetActive(true)
  script:ReInit(payData, self.ctrl)
  return item
end

function M:RequestRefundList()
  DataCenter.LWRefundManager:RequestPayRefundList()
end

function M:OnReceivePayList()
  self.payList = DataCenter.LWRefundManager:GetPayDataList()
  self:RefreshScroll()
end

function M:OnRecCLickOrder()
  local orderId = self.ctrl:GetSelectOrder()
  local gray = orderId == nil or orderId == 0
  CS.UIGray.SetGray(self.btnRequest.transform, gray, not gray)
end

function M:RefreshScroll()
  if self.scroll == nil or #self.payList == 0 then
    self.scroll:SetActive(false)
    self.textView:SetActive(true)
    if DataCenter.LWRefundManager.CurRefundListPfType == RefundListPfType.GoldBlock then
      self.textView:SetLocalText("refund_desc_goldbrick_empty")
    else
      self.textView:SetLocalText("refund_interface_empty")
    end
  else
    self.scroll:SetActive(true)
    self.scroll:SetListItemCount(#self.payList, false, false)
    self.scroll:RefreshAllShownItem()
  end
end

function M:SetRequestedText()
  self.scroll:SetActive(false)
  self.textView:SetActive(true)
  if DataCenter.LWRefundManager.CurRefundListPfType == RefundListPfType.GoldBlock then
    self.textView:SetLocalText("refund_desc_goldbrick_done")
  else
    self.textView:SetLocalText("refund_interface_done_description")
  end
  self.btnRequest:SetActive(false)
end

return LWUIRefundApplicationView
