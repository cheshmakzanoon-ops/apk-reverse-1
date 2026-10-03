local UIPersonalArmsCalendarExchangeItem = BaseClass("UIPersonalArmsCalendarExchangeItem", UIBaseContainer)
local base = UIBaseContainer

function UIPersonalArmsCalendarExchangeItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UIPersonalArmsCalendarExchangeItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIPersonalArmsCalendarExchangeItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityPersonalArmsCalenderSwitchTime, self.OnSwitchCallback)
end

function UIPersonalArmsCalendarExchangeItem:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityPersonalArmsCalenderSwitchTime, self.OnSwitchCallback)
  base.OnRemoveListener(self)
end

function UIPersonalArmsCalendarExchangeItem:ComponentDefine()
  self.bg = self:AddComponent(UIBaseContainer, "bg")
  self.weekText = self:AddComponent(UIText, "weekText")
  self.timeText = self:AddComponent(UIText, "timeContent/timeText")
  self.nameText = self:AddComponent(UIText, "nameText")
  self.contentExchange = self:AddComponent(UIButton, "timeContent/exchangeContent")
  self.p_btn_exchange = self:AddComponent(UIButton, "timeContent/exchangeContent/p_btn_exchange")
  self.p_btn_exchange:SetOnClick(BindCallback(self, self.OnExchangeClicked))
end

function UIPersonalArmsCalendarExchangeItem:ComponentDestroy()
  self.bg = nil
  self.weekText = nil
  self.timeText = nil
  self.nameText = nil
  self.p_btn_exchange = nil
end

function UIPersonalArmsCalendarExchangeItem:DataDefine()
end

function UIPersonalArmsCalendarExchangeItem:DataDestroy()
end

function UIPersonalArmsCalendarExchangeItem:SetData(itemData)
  self.Data = itemData
  self:SetActive(true)
  self.bg:SetActive(itemData.isCur)
  if itemData.isShowWeek then
    self.weekText:SetLocalText(2000379, itemData.dayNum)
  else
    self.weekText:SetText("")
  end
  self.nameText:SetLocalText(itemData.name)
  self.Time = itemData.startTime
  self:UpdateTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  CS.UIGray.SetGray(self.contentExchange.transform, now > self.Time, true)
  local exchangeFuncOpen = DataCenter.ActivityPersonalArmsDataManager:IsExchangeFuncOpen(self.Data.activityId)
  self.contentExchange:SetActive(exchangeFuncOpen and itemData.isCurDay and not itemData.isCur)
end

function UIPersonalArmsCalendarExchangeItem:UpdateTime()
  local timeTxt = UITimeManager:GetInstance():GetServerTimeByUTC(self.Time, true)
  local isServerTime = DataCenter.ActivityPersonalArmsDataManager.isShowSvrTimeDesc
  if not isServerTime then
    timeTxt = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.Time, true, false)
  end
  self.timeText:SetText(timeTxt)
end

function UIPersonalArmsCalendarExchangeItem:OnExchangeClicked()
  local isExchangeFuncOpen = DataCenter.ActivityPersonalArmsDataManager:IsExchangeFuncOpen(self.Data.activityId)
  if not isExchangeFuncOpen then
    return
  end
  if checknumber(self.Time) < UITimeManager:GetInstance():GetServerTime() then
    UIUtil.ShowTipsId("arms_race_exchange_tips1")
    return
  end
  local hasUnclaimReward = false
  local curData = DataCenter.ActivityPersonalArmsDataManager:GetCurData(self.Data.activityId)
  if curData ~= nil then
    local curScore = curData.sc
    for _, reward in pairs(curData.score_rewards) do
      if reward.receive == 0 and curScore >= reward.target then
        hasUnclaimReward = true
        break
      end
    end
  end
  if hasUnclaimReward then
    UIUtil.ShowTipsId("arms_race_exchange_tips2")
    return
  end
  if curData ~= nil then
    local minMinutes = LuaEntry.DataConfig:TryGetNum("person_arms_race", "k6", 5)
    local leftMinutes = math.max(0, math.floor((curData.stage_end_time - UITimeManager:GetInstance():GetServerSeconds()) / 60))
    if minMinutes > leftMinutes then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("arms_race_exchange_tips3", minMinutes))
      return
    end
  end
  local leftTime = DataCenter.ActivityPersonalArmsDataManager:GetLeftExchangeTimes(self.Data.activityId)
  if leftTime <= 0 then
    UIUtil.ShowTipsId("arms_race_exchange_tips4")
    return
  end
  
  local function openConfirmView()
    local param = {}
    param.ItemData = self.Data
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsCalendarExchangeConfirmView, {anim = true}, param)
  end
  
  if DataCenter.ActivityPersonalArmsDataManager:NeedExchangeConfirmMessage(self.Data.activityId) then
    DataCenter.ActivityPersonalArmsDataManager:SetExchangeConfirmed()
    local title = CS.GameEntry.Localization:GetString("arms_race_exchange_firstconfirm_title")
    local tips = CS.GameEntry.Localization:GetString("arms_race_exchange_firstconfirm_text")
    
    local function rightCallback()
    end
    
    local function leftCallback()
      openConfirmView()
    end
    
    UIUtil.ShowMessage(tips, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, leftCallback, rightCallback, nil, title)
  else
    openConfirmView()
  end
end

function UIPersonalArmsCalendarExchangeItem:OnSwitchCallback(evtData)
  self:UpdateTime()
end

return UIPersonalArmsCalendarExchangeItem
