local base = UIBaseContainer
local LWUIRefundFaqItem = BaseClass("LWUIRefundFaqItem", UIBaseContainer)
local M = LWUIRefundFaqItem
local Localization = CS.GameEntry.Localization
local bottomBlankHeight = 28
local topHeight = 62
local State = {Contract = 0, Expand = 1}
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local QUEST_ENTRY_WIDTH_LIMIT = 670
local QUEST_ENTRY_ROLLING_SPD = 90
local QUEST_ENTRY_ROLLING_DELAY = 1
local QUEST_ENTRY_ROLLING_HOLD = 2

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
  self.tweenSeq = nil
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "Title/Btn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Title/Btn/TitleMask/TitleText")
  self.imgArrowUp = self:AddComponent(UIImage, "Title/ArrowUp")
  self.textDMessage = self:AddComponent(UITextMeshProUGUIEx, "DMessage")
  self.imgArrowDown = self:AddComponent(UIImage, "Title/ArrowDown")
end

function M:ComponentDestroy()
  self.btn = nil
  self.textTitle = nil
  self.imgArrowUp = nil
  self.textDMessage = nil
  self.imgArrowDown = nil
end

function M:DataDefine()
  self.curState = State.Contract
  self.scrollView = nil
  self.index = nil
  self.expandedHeight = nil
end

function M:DataDestroy()
  self.curState = nil
  self.scrollView = nil
  self.index = nil
  self.expandedHeight = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:OnBtnClick()
  self:ChangeState()
end

function M:ReInit(faqInfo, scrollView, index)
  if not faqInfo then
    Logger.LogError("faqInfo is nil")
    return
  end
  self.scrollView = scrollView
  self.index = index
  local question = faqInfo.id .. ". " .. Localization:GetString(faqInfo.question)
  self.textTitle:SetText(question)
  local param = self:GetParam(faqInfo.para1 or "")
  self.textDMessage:SetLocalText(faqInfo.answer or "", param)
  self.expandedHeight = nil
  self.curState = faqInfo.curState
  self:SetItemByState()
end

function M:ChangeState()
  EventManager:GetInstance():Broadcast(EventId.LWRefundFAQClick, self.index)
end

function M:SetItemByState()
  if self.curState == State.Contract then
    self.imgArrowUp:SetActive(true)
    self.imgArrowDown:SetActive(false)
    self.textDMessage:SetActive(false)
    if self.tweenSeq then
      self.tweenSeq:Kill()
      self.tweenSeq = nil
    end
    self:InitTitlePos()
  else
    self.imgArrowUp:SetActive(false)
    self.imgArrowDown:SetActive(true)
    self.textDMessage:SetActive(true)
    self:AdjustMaskText()
  end
  self:RefreshItemSize()
end

function M:RefreshItemSize()
  local contentHeight = 0
  if self.curState == State.Contract then
    contentHeight = 0
  else
    contentHeight = self:GetExpandHeight()
  end
  self.textDMessage:SetSizeDeltaY(contentHeight)
  local totalHeight = topHeight + contentHeight + bottomBlankHeight
  self:SetSizeDeltaY(totalHeight)
  self.scrollView:OnItemSizeChanged(self.index)
end

function M:GetParam(para)
  if not para then
    return nil
  end
  if para == "region_time" then
    return DataCenter.LWRefundManager:GetRefundLimitDays()
  end
end

function M:AdjustMaskText()
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  self.tweenSeq = self:SetAni(self.textTitle, QUEST_ENTRY_WIDTH_LIMIT, QUEST_ENTRY_ROLLING_DELAY, QUEST_ENTRY_ROLLING_SPD, QUEST_ENTRY_ROLLING_HOLD)
end

function M:SetAni(textComponent, widthLimit, rollingDelay, rollingSpeed, rollingHold)
  local rawWidth = textComponent:GetWidth()
  local width = math.min(widthLimit, rawWidth)
  if rawWidth > width then
    local startPox = 0
    local endPox = width - rawWidth
    if CommonUtil.IsArabic() then
      endPox = rawWidth - width
    end
    self.textTitle:SetAnchoredPositionXY(startPox, 0)
    local tweenSeq = DOTween.Sequence()
    tweenSeq:AppendInterval(rollingDelay)
    tweenSeq:Append(textComponent.transform:DOAnchorPosX(endPox, (rawWidth - width) / rollingSpeed):SetEase(CS.DG.Tweening.Ease.Linear))
    tweenSeq:AppendInterval(rollingHold)
    tweenSeq:SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
    return tweenSeq
  end
end

function M:InitTitlePos()
  if CommonUtil.IsArabic() then
    self.textTitle:SetAnchorMinXY(1, 0.5)
    self.textTitle:SetAnchorMaxXY(1, 0.5)
    self.textTitle:SetPivotXY(1, 0.5)
  else
    self.textTitle:SetAnchorMinXY(0, 0.5)
    self.textTitle:SetAnchorMaxXY(0, 0.5)
    self.textTitle:SetPivotXY(0, 0.5)
  end
  local curX, curY, curZ = self.textTitle:GetAnchoredPosition()
  self.textTitle:SetAnchoredPositionXY(0, curY)
end

function M:GetExpandHeight()
  if not self.expandedHeight then
    self.expandedHeight = self:CalculateMessageHeight()
  end
  return self.expandedHeight
end

function M:CalculateMessageHeight()
  local textContentPreferHeight = self.textDMessage.unity_tmpro:GetPreferredValues().y
  return textContentPreferHeight
end

return LWUIRefundFaqItem
