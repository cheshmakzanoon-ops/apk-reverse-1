local base = UIBaseContainer
local LWRefundPenaltyContentItem = BaseClass("LWRefundPenaltyContentItem", UIBaseContainer)
local M = LWRefundPenaltyContentItem
local Localization = CS.GameEntry.Localization
local banLoginDayNum = 30

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
  self:OnGoldBrickUpdate()
end

function M:ComponentDefine()
  self.textGoldBrick = self:AddComponent(UITextMeshProUGUIEx, "GoldBrick/GoldBrickText")
  self.textCurBrickNum = self:AddComponent(UITextMeshProUGUIEx, "GoldBrick/CurBrickNum")
  self.btnAddBrick = self:AddComponent(UIButton, "GoldBrick/AddBrickBtn")
  self.btnAddBrick:SetOnClick(function()
    self:OnBtnAddBrickClick()
  end)
  self.textPay = self:AddComponent(UITextMeshProUGUIEx, "CountDown/PayText")
  self.textPayCountDown = self:AddComponent(UITextMeshProUGUIEx, "CountDown/PayCountDownText")
  self.textRefundDes = self:AddComponent(UITextMeshProUGUIEx, "RefundDes")
  self.textShopLimit = self:AddComponent(UITextMeshProUGUIEx, "RestrictNode/ShopLimitText")
  self.textSpeechLimit = self:AddComponent(UITextMeshProUGUIEx, "RestrictNode/SpeechLimitText")
  self.textMarchLimit = self:AddComponent(UITextMeshProUGUIEx, "RestrictNode/MarchLimitText")
  self.textLoginLimit = self:AddComponent(UITextMeshProUGUIEx, "RestrictNode/LoginLimitText")
  self.textProgressText1 = self:AddComponent(UITextMeshProUGUIEx, "RestrictNode/ProgressNode/ProgressText1")
  self.textProgressText2 = self:AddComponent(UITextMeshProUGUIEx, "RestrictNode/ProgressNode/ProgressText2")
  self.textProgressText3 = self:AddComponent(UITextMeshProUGUIEx, "RestrictNode/ProgressNode/ProgressText3")
  self.compProgressNode2 = self:AddComponent(UIBaseContainer, "RestrictNode/ProgressNode/ProgressNode2")
  self.compProgressNode3 = self:AddComponent(UIBaseContainer, "RestrictNode/ProgressNode/ProgressNode3")
  self.compProgressNode4 = self:AddComponent(UIBaseContainer, "RestrictNode/ProgressNode/ProgressNode4")
  self.compProgressBar = self:AddComponent(UIBaseContainer, "RestrictNode/ProgressNode/ProgressBar")
  self.textRefundDesTitle = self:AddComponent(UITextMeshProUGUIEx, "RefundDesTitle")
  self.compProgressNode1 = self:AddComponent(UIBaseContainer, "RestrictNode/ProgressNode/ProgressNode1")
  self.compProgressNode5 = self:AddComponent(UIBaseContainer, "RestrictNode/ProgressNode/ProgressNode5")
  self.btnInfo = self:AddComponent(UIButton, "InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
end

function M:ComponentDestroy()
  self.textGoldBrick = nil
  self.textCurBrickNum = nil
  self.btnAddBrick = nil
  self.textPay = nil
  self.textPayCountDown = nil
  self.textRefundDes = nil
  self.textShopLimit = nil
  self.textSpeechLimit = nil
  self.textMarchLimit = nil
  self.textLoginLimit = nil
  self.textProgressText1 = nil
  self.textProgressText2 = nil
  self.textProgressText3 = nil
  self.compProgressNode2 = nil
  self.compProgressNode3 = nil
  self.compProgressNode4 = nil
  self.compProgressBar = nil
  self.textRefundDesTitle = nil
  self.compProgressNode1 = nil
  self.compProgressNode5 = nil
  self.btnInfo = nil
end

function M:DataDefine()
  self.limitMap = {}
  self.progressNodeList = {
    self.compProgressNode1,
    self.compProgressNode2,
    self.compProgressNode3,
    self.compProgressNode4,
    self.compProgressNode5
  }
end

function M:DataDestroy()
  self.limitMap = nil
  self.progressNodeList = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GoldBrickUpdate, self.OnGoldBrickUpdate)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.GoldBrickUpdate, self.OnGoldBrickUpdate)
  base.OnRemoveListener(self)
end

function M:Init()
  self:SetLocalization()
end

function M:SetLocalization()
  self.textGoldBrick:SetLocalText("refund_window_limit_goldbrick")
  self.textPay:SetLocalText("refund_window_limit_cd")
  self.textRefundDes:SetLocalText("refund_window_limit_description")
  self.textRefundDesTitle:SetLocalText("refund_window_limit_detail")
  self.textShopLimit:SetLocalText("refund_window_limit_noaffect")
  self.textSpeechLimit:SetLocalText("refund_window_limit_buypack")
  self.textMarchLimit:SetLocalText("refund_window_limit_chat")
  self.textLoginLimit:SetLocalText("refund_window_limit_march")
end

function M:OnBtnAddBrickClick()
  EventManager:GetInstance():Broadcast(EventId.LWRefundOpenPayItem)
end

function M:ReInit()
  self:SetCurGoldBrick()
  self:InitCountDown()
  self:InitLimitValue()
  self:InitCurLimit()
end

function M:SetCurGoldBrick()
  local curBrickNum = DataCenter.GoldBrickDataManager:GetGoldBrickCount() or 0
  self.textCurBrickNum:SetText(curBrickNum)
end

function M:InitCountDown()
  local canLogIn = DataCenter.LWRefundPunishManager:GetCanLogIn()
  if not canLogIn then
    self.textPayCountDown:SetActive(false)
    self.textPay:SetActive(false)
    return
  end
  self.textPayCountDown:SetActive(true)
  self.textPay:SetActive(true)
  local punishTime = DataCenter.LWRefundPunishManager:GetPunishTime()
  if punishTime and 0 < punishTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local time = punishTime + banLoginDayNum * OneDayTime * 1000 - curTime
    if 0 < time then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(time)
      self.textPayCountDown:SetText(showTime)
    end
  end
  if CommonUtil.IsArabic() then
    if CommonUtil.ArabicAutoMirrorFactor() == 1 then
      self.textPay:SetAsLastSibling()
    end
  else
    self.textPay:SetAsFirstSibling()
  end
end

function M:InitLimitValue()
  local k2Str = LuaEntry.DataConfig:TryGetStr("refund_params", "k2", "")
  if string.IsNullOrEmpty(k2Str) then
    Logger.LogError("k2Str is nil")
    return
  end
  local k2List = string.split(k2Str, "|")
  for k, v in pairs(k2List) do
    local str = string.split(v, ";")
    local id = str[1]
    local beginValue = str[2]
    local endValue = str[3]
    table.insert(self.limitMap, {
      id = tonumber(id),
      beginValue = tonumber(beginValue),
      endValue = tonumber(endValue)
    })
  end
  if table.count(self.limitMap) == 0 then
    Logger.LogError("limitMap is nil")
    return
  end
  if self.limitMap[1] and self.limitMap[1].beginValue ~= 0 then
    table.insert(self.limitMap, 1, {
      id = 0,
      beginValue = 0,
      endValue = self.limitMap[1].beginValue
    })
  end
  table.sort(self.limitMap, function(a, b)
    return a.beginValue > b.beginValue
  end)
  if table.count(self.limitMap) > 4 then
    local newLimitMap = {}
    for i = 1, 4 do
      table.insert(newLimitMap, self.limitMap[i])
    end
    self.limitMap = newLimitMap
  end
  for i = 1, table.count(self.limitMap) do
    self.limitMap[i].id = i
  end
  local textProgressList = {
    self.textProgressText1,
    self.textProgressText2,
    self.textProgressText3
  }
  for k, v in pairs(textProgressList) do
    local endValue = string.GetFormattedStr0(self.limitMap[k].endValue)
    v:SetText(endValue)
  end
end

function M:InitCurLimit()
  local curBrickNum = DataCenter.GoldBrickDataManager:GetGoldBrickCount() or 0
  if table.count(self.limitMap) == 0 then
    return
  end
  local id = 0
  local curStageMin = 0
  local curStageMax = 0
  for k, v in pairs(self.limitMap) do
    if curBrickNum == v.endValue or curBrickNum == v.beginValue or curBrickNum < v.beginValue and curBrickNum > v.endValue then
      curStageMin = v.endValue
      curStageMax = v.beginValue
      id = v.id
      break
    end
  end
  if id == 0 then
    Logger.LogError("not found")
    return
  end
  local beginNode = self.progressNodeList[id]
  local endNode = self.progressNodeList[id + 1]
  if not beginNode or not endNode then
    Logger.LogError("not found")
    return
  end
  local delta = curStageMax - curBrickNum
  local stage = curStageMax - curStageMin
  local rate = (curStageMax - curBrickNum) / (curStageMax - curStageMin)
  if id and id == 4 then
    rate = 0.5
  end
  local progress = beginNode.rectTransform.anchoredPosition.x + (endNode.rectTransform.anchoredPosition.x - beginNode.rectTransform.anchoredPosition.x) * rate
  local anchoredPosition = self.compProgressBar:GetAnchoredPosition()
  local y = anchoredPosition.y
  if CommonUtil.IsArabicAutoMirrorOpen() then
    progress = 0 - progress
  end
  self.compProgressBar:SetAnchoredPositionXY(progress, y)
end

function M:OnGoldBrickUpdate()
  self:SetCurGoldBrick()
  self:InitCurLimit()
end

function M:OnBtnInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("refund_window_goldbrick_details")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

return LWRefundPenaltyContentItem
