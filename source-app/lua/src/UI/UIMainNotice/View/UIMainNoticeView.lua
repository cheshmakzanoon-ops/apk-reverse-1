local MailListItem = require("UI.UIMainNotice.Component.MailListItem")
local UIMainNoticeView = BaseClass("UIMainNoticeView", UIBaseView)
local base = UIBaseView
local MailContentContainer = require("UI.UIMainNotice.Component.MailContentContainer")

function UIMainNoticeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:OnRefresh()
end

function UIMainNoticeView:OnDestroy()
  self._scrollviewContent:RemoveComponents(MailListItem)
  self._scrollMailList:ClearAllItems()
  DataCenter.WorldNoticeManager:SetCurId(0)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainNoticeView:ComponentDefine()
  self.return_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.close_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._scrollviewContent = self:AddComponent(UIBaseContainer, "LeftScrollView/viewport/Content")
  self._scrollMailList = self:AddComponent(UILoopListView2, "LeftScrollView")
  self._scrollMailList:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self._scrollMailList:SetOnDragingAction(function()
    self:OnDragingAction()
  end)
  self._scrollMailList:SetOnEndDragAction(function(...)
    self:OnEndDragAction()
  end)
  self._common_bg = self:AddComponent(UIBaseContainer, "common_bg")
  self._txtNoMail = self:AddComponent(UIText, "txtNoMail")
  self._rightScrollView = self:AddComponent(UIScrollRect, "RightScrollView")
  self._rightMailContent = self:AddComponent(MailContentContainer, "RightScrollView/Viewport/Content")
  self._btnToBottom = self:AddComponent(UIButton, "ToBottom")
  self._btnToBottom:SetOnClick(BindCallback(self, self.OnClickToBottomBtn))
  self._btnToBottom:SetActive(false)
  self._txtToBottom = self:AddComponent(UIText, "ToBottom/ToBottomText")
  self._txtToBottom:SetLocalText(208213)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._btnToBottom.rectTransform)
end

function UIMainNoticeView:ComponentDestroy()
  self.txt_title = nil
  self.close_btn = nil
  self.back_btn = nil
  self.day_task = nil
  self.return_btn = nil
end

function UIMainNoticeView:OnEnable()
  base.OnEnable(self)
end

function UIMainNoticeView:OnDisable()
  base.OnDisable(self)
end

function UIMainNoticeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.NoticeItemClick, self.ClickItem)
end

function UIMainNoticeView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.NoticeItemClick, self.ClickItem)
end

function UIMainNoticeView:RefreshTitleName(dialog)
  self.txt_title:SetLocalText(dialog)
end

function UIMainNoticeView:OnRefresh()
  self.noticeData = DataCenter.WorldNoticeManager:GetDataInfo()
  self._cellList = {}
  local _maillist = self.noticeData
  if table.count(self.noticeData) > 0 then
    self.maildata = self.noticeData[1]
  end
  self:ShowMailContentView()
  if self.toIndex ~= nil and self.toIndex ~= -1 then
    self._scrollMailList:SetListItemCount(#_maillist, false, false)
    self._scrollMailList:RefreshAllShownItem()
    self._scrollMailList:MovePanelToItemIndex(self.toIndex, 104)
    self._scrollMailList.unity_looplistview2:ForceUpdate()
  else
    self._scrollMailList:SetListItemCount(#_maillist, false, true)
    self._scrollMailList:RefreshAllShownItem()
  end
end

function UIMainNoticeView:ShowMailContentView()
  self._common_bg:SetActive(true)
  self._txtNoMail:SetActive(false)
  self._rightScrollView.unity_uiscrollRect.verticalNormalizedPosition = 1
  local result = self._rightMailContent:ShowData(self.maildata)
end

function UIMainNoticeView:GetScrollItem(listview, index)
  local _maillist = self.noticeData
  index = index + 1
  if index < 1 or index > #_maillist then
    return nil
  end
  local item = listview:NewListViewItem("UImail_list_item")
  if self._cellList[item] == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    local mailItem = self._scrollviewContent:AddComponent(MailListItem, nameStr)
    self._cellList[item] = mailItem
  end
  self._cellList[item]:SetItemShow(self.noticeData[index])
  return item
end

function UIMainNoticeView:OnDragingAction()
  local _totalCnt = #self.noticeData
  if self._loadingMail == true then
    return
  end
  local _lastItem = self._scrollMailList:GetShownItemByItemIndex(_totalCnt - 1)
  if _lastItem == nil then
    return
  end
  local _lastItemY = self._scrollMailList:GetItemCornerPosInViewPort(_lastItem).y
  local _viewPortSize = self._scrollMailList.unity_looplistview2.ViewPortSize
  if 50 <= _lastItemY + _viewPortSize then
    self._toLoadMore = true
  end
end

function UIMainNoticeView:OnEndDragAction()
  if self._toLoadMore == true then
    self._loadingMail = false
    self._toLoadMore = false
  end
end

function UIMainNoticeView:OnClickToBottomBtn()
  local y = self._rightMailContent.rectTransform.sizeDelta.y - self._rightScrollView.rectTransform.sizeDelta.y
  self._rightMailContent.rectTransform.anchoredPosition = Vector2.New(0, y)
  self._btnToBottom:SetActive(false)
end

function UIMainNoticeView:RefreshToBottomBtn(btnGetReward)
  local showToBottom = false
  self.btnGetReward = btnGetReward
  if btnGetReward ~= nil and btnGetReward:GetActive() then
    local standardScale = GetStandardScale()
    local posY = btnGetReward.transform.position.y + btnGetReward.rectTransform.sizeDelta.y / 2 * standardScale
    local bottom = self._rightScrollView.transform.position.y - self._rightScrollView.rectTransform.sizeDelta.y / 2 * standardScale
    if posY < bottom then
      showToBottom = true
    end
  end
  self._btnToBottom:SetActive(showToBottom)
end

function UIMainNoticeView:ClickItem(uuid)
  for i = 1, table.count(self.noticeData) do
    if self.noticeData[i].uuid == uuid then
      self.maildata = self.noticeData[i]
    end
  end
  self:ShowMailContentView()
end

return UIMainNoticeView
