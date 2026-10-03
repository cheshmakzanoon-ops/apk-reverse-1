local UIMonsterInvasionPlanTimeView = BaseClass("UIMonsterInvasionPlanTimeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local OptionData = CS.TMPro.TMP_Dropdown.OptionData
local ItemHeight = 56.18

function UIMonsterInvasionPlanTimeView:OnCreate()
  base.OnCreate(self)
  self.bNeedUpdate = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshTime()
  self:SetRecordToggle()
  self:OnTimeChange()
end

function UIMonsterInvasionPlanTimeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMonsterInvasionPlanTimeView:ComponentDefine()
  self.btnConfirm = self:AddComponent(UIButton, "Root/confirmBtn")
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "Root/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTimeZone = self:AddComponent(UITextMeshProUGUIEx, "Root/timeSelect/timeZone")
  self.rawImgBanner = self:AddComponent(UIRawImage, "Root/bannerImg")
  self.textToggle = self:AddComponent(UITextMeshProUGUIEx, "Root/Toggle/ToggleText")
  self.toggleSelect = self:AddComponent(UIToggle, "Root/Toggle/SelectToggle")
  self.textDate = self:AddComponent(UITextMeshProUGUIEx, "Root/timeSelect/Date/dateTxt")
  self.dateDrop = self:AddComponent(UIDropdown, "Root/timeSelect/dateDrop")
  self.dateDrop:SetOnValueChanged(function(nIndex)
    self:OnDateChange(nIndex)
  end)
  self.hourDrop = self:AddComponent(UIDropdown, "Root/timeSelect/hourDrop")
  self.hourDrop:SetOnValueChanged(function()
    self:OnHourChange()
  end)
  self.hourDrop:RegisterCreateDropdownListCallBack(function()
    self:SetDefaultDropDownPos(true, self.hourDrop)
  end)
  self.minDrop = self:AddComponent(UIDropdown, "Root/timeSelect/minDrop")
  self.minDrop:SetOnValueChanged(function()
    self:OnMinuteChange()
  end)
  self.minDrop:RegisterCreateDropdownListCallBack(function()
    self:SetDefaultDropDownPos(false, self.minDrop)
  end)
  self.textHour = self:AddComponent(UITextMeshProUGUIEx, "Root/timeSelect/hourDrop/LabelHour")
  self.textMin = self:AddComponent(UITextMeshProUGUIEx, "Root/timeSelect/minDrop/LabelMin")
  self.textHour.transform.localScale = Vector3.one
  self.textMin.transform.localScale = Vector3.one
  self.textToggle:SetText(Localization:GetString("appointment_time_last_select"))
  self.toggleSelect:SetOnValueChanged(function(isOn)
    self.bIsRecordTime = isOn
    CommonUtil.PlayerPrefsSetBool(SettingKeys.MONSTER_INVASION_LAST_PLAN_TIME, isOn)
    self:SetLastRecordTime(isOn)
    if not isOn then
      self:SetRecommendTime()
    end
  end)
end

function UIMonsterInvasionPlanTimeView:ComponentDestroy()
  self.btnConfirm = nil
  self.btnClose = nil
  self.btnPanel = nil
  self.textTimeZone = nil
  self.rawImgBanner = nil
  self.textToggle = nil
  self.toggleSelect = nil
  self.textDate = nil
  self.dateDrop = nil
  self.hourDrop = nil
  self.minDrop = nil
  if self.seq then
    self.seq:Kill()
    self.seq = nil
  end
end

function UIMonsterInvasionPlanTimeView:DataDefine()
  self.nSelectDate = 0
  self.nSelectHour = 0
  self.nSelectMinute = 0
  self.bFirstShow = true
  self.tActData = DataCenter.ActivityMonsterInvasionDataManager:GetActData()
  self.nLastPlanTime = DataCenter.ActivityMonsterInvasionDataManager:GetLastPlanTime()
  self.bIsRecordTime = CommonUtil.PlayerPrefsGetBool(SettingKeys.MONSTER_INVASION_LAST_PLAN_TIME, false)
end

function UIMonsterInvasionPlanTimeView:SetRecordToggle()
  self.toggleSelect:SetIsOn(self.bIsRecordTime)
end

function UIMonsterInvasionPlanTimeView:RefreshTime()
  self.nRecommendCd = LuaEntry.DataConfig:TryGetNum("monster_invasion", "k23", 600)
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  self.tCurTimeData = UITimeManager:GetInstance():TimeStampToServerDate(nCurTime)
  self.nRecommendTimeStamp = nCurTime + self.nRecommendCd * 1000
  local tRecommendDate = UITimeManager:GetInstance():TimeStampToServerDate(self.nRecommendTimeStamp)
  self.tRecommendDate = tRecommendDate
  if self.nLastPlanTime and self.nLastPlanTime > 0 then
    self.tLastPlanTimeData = UITimeManager:GetInstance():TimeStampToServerDate(self.nLastPlanTime)
  end
  self.nStartZeroTime = UITimeManager:GetInstance():GetTodayZeroServerTime(nCurTime // 1000) * 1000
  local nDiff = UITimeManager:GetInstance():GetBetweenDaysForServerTime(self.nStartZeroTime / 1000, self.tActData.endTime / 1000)
  self.nShowDays = nDiff + 1
  self.dateDrop:Clear()
  for i = 0, self.nShowDays - 1 do
    local temp = OptionData()
    local tCurDate = UITimeManager:GetInstance():TimeStampToServerDate(self.nStartZeroTime + i * OneDayTime * 1000)
    temp.text = string.format("%d/%d", tCurDate.month, tCurDate.day)
    self.dateDrop:Add(temp)
  end
  self.hourDrop:Clear()
  for i = 0, 23 do
    local temp = OptionData()
    temp.text = string.format("%d", i)
    self.hourDrop:Add(temp)
  end
  self.minDrop:Clear()
  for i = 0, 59 do
    local temp = OptionData()
    temp.text = string.format("%d", i)
    self.minDrop:Add(temp)
  end
  if self.bIsRecordTime and self.nLastPlanTime and self.nLastPlanTime > 0 then
    self:SetLastRecordTime()
  else
    self.nSelectDate = 0
    self.nSelectHour = tRecommendDate.hour
    self.nSelectMinute = tRecommendDate.min
    self.hourDrop:SetValue(self.nSelectHour)
    self.minDrop:SetValue(self.nSelectMinute)
    self.dateDrop:SetValue(self.nSelectDate)
  end
end

function UIMonsterInvasionPlanTimeView:SetRecommendTime()
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  local tCurTimeDate = UITimeManager:GetInstance():TimeStampToServerDate(nCurTime)
  self.nRecommendTimeStamp = nCurTime + self.nRecommendCd * 1000
  self.tRecommendDate = UITimeManager:GetInstance():TimeStampToServerDate(self.nRecommendTimeStamp)
  self.nSelectHour = self.tRecommendDate.hour
  self.nSelectMinute = self.tRecommendDate.min
  if tCurTimeDate.day == self.tRecommendDate.day and tCurTimeDate.month == self.tRecommendDate.month then
    self.nSelectDate = 0
  elseif self.nShowDays > 1 then
    self.nSelectDate = 1
  else
    self.nSelectDate = 0
  end
  self.hourDrop:SetValue(self.nSelectHour)
  self.minDrop:SetValue(self.nSelectMinute)
  self.dateDrop:SetValue(self.nSelectDate)
  self:PlayTimeChangeAnim()
end

function UIMonsterInvasionPlanTimeView:SetLastRecordTime(isOn)
  if not (self.bIsRecordTime and self.nLastPlanTime) or self.nLastPlanTime <= 0 then
    return
  end
  local nLastRecordHour = self.tLastPlanTimeData.hour
  local nLastRecordMin = self.tLastPlanTimeData.min
  if nLastRecordHour < self.tCurTimeData.hour or nLastRecordHour == self.tCurTimeData.hour and nLastRecordMin < self.tCurTimeData.min then
    if self.nShowDays > 1 then
      self.nSelectDate = 1
      self.nSelectHour = nLastRecordHour
      self.nSelectMinute = nLastRecordMin
    else
      self.nSelectDate = 0
      self.nSelectHour = self.tRecommendDate.hour
      self.nSelectMinute = self.tRecommendDate.min
    end
  else
    self.nSelectDate = 0
    self.nSelectHour = nLastRecordHour
    self.nSelectMinute = nLastRecordMin
  end
  self.hourDrop:SetValue(self.nSelectHour)
  self.minDrop:SetValue(self.nSelectMinute)
  self.dateDrop:SetValue(self.nSelectDate)
  if isOn then
    self:PlayTimeChangeAnim()
  end
end

function UIMonsterInvasionPlanTimeView:PlayTimeChangeAnim()
  if self.bFirstShow then
    self.bFirstShow = false
    return
  end
  if self.seq then
    self.seq:Kill()
    self.seq = nil
    self.textHour.transform.localScale = Vector3.one
    self.textMin.transform.localScale = Vector3.one
  end
  self.seq = DOTween.Sequence()
  self.seq:Append(self.textHour.transform:DOScale(Vector3.New(1.5, 1.5, 1.5), 0.2):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo))
  self.seq:Join(self.textMin.transform:DOScale(Vector3.New(1.5, 1.5, 1.5), 0.2):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo))
end

function UIMonsterInvasionPlanTimeView:DataDestroy()
  self.tActData = nil
  self.bNeedUpdate = nil
  self.bFirstShow = nil
end

function UIMonsterInvasionPlanTimeView:OnAddListener()
  base.OnAddListener(self)
end

function UIMonsterInvasionPlanTimeView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIMonsterInvasionPlanTimeView:OnBtnConfirmClick()
  local nTargetTimeStamp = self.nStartZeroTime + (self.nSelectDate * OneDayTime + self.nSelectHour * OneHourTime + self.nSelectMinute * 60) * 1000
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  if nTargetTimeStamp < nCurTime then
    UIUtil.ShowTipsId("appointment_time_exceed_tips_2")
    return
  end
  if nTargetTimeStamp > self.tActData.endTime then
    UIUtil.ShowTipsId("370100")
    return
  end
  local tActivityCfg = DataCenter.ActivityMonsterInvasionDataManager:GetActivityData()
  local nLimitHour = tActivityCfg and tActivityCfg.countDownHour or 0
  if nTargetTimeStamp >= self.tActData.endTime - nLimitHour * OneHourTime * 1000 then
    local sTip = Localization:GetString("appointment_time_count_down_hour", nLimitHour)
    UIUtil.ShowTips(sTip)
    return
  end
  local nCurPlanTime = DataCenter.ActivityMonsterInvasionDataManager:GetBossPlanTimeFromServer() or 0
  if math.abs(nTargetTimeStamp - nCurPlanTime) < 5000 then
    UIUtil.ShowTipsId("appointment_time_exceed_tips_2")
    return
  end
  DataCenter.ActivityMonsterInvasionDataManager:SetBossPlanTime(nTargetTimeStamp)
  if self.bNeedUpdate then
    SFSNetwork.SendMessage(MsgDefines.MonsterInvasionBossUpdate, nTargetTimeStamp)
    self.ctrl.CloseSelf()
  else
    DataCenter.ActivityMonsterInvasionDataManager:RequestGetMonsterInvasionPoint()
  end
end

function UIMonsterInvasionPlanTimeView:OnBtnCloseClick()
  self.ctrl.CloseSelf()
end

function UIMonsterInvasionPlanTimeView:OnBtnPanelClick()
  self.ctrl.CloseSelf()
end

function UIMonsterInvasionPlanTimeView:OnDateChange(nIndex)
  self.nSelectDate = nIndex
  self:OnTimeChange()
end

function UIMonsterInvasionPlanTimeView:OnHourChange()
  self.nSelectHour = tonumber(self.hourDrop:GetText())
  self:OnTimeChange()
end

function UIMonsterInvasionPlanTimeView:OnMinuteChange()
  self.nSelectMinute = tonumber(self.minDrop:GetText())
  self:OnTimeChange()
end

function UIMonsterInvasionPlanTimeView:OnTimeChange()
  local nTime
  if self.nSelectHour and self.nSelectMinute then
    if self.nSelectHour == 0 then
      local hour = tonumber(self.hourDrop:GetText())
      local min = tonumber(self.minDrop:GetText())
      self.nSelectHour = hour and hour or 0
      self.nSelectMinute = min and min or 0
    end
    nTime = (self.nSelectDate * OneDayTime + self.nSelectHour * OneHourTime + self.nSelectMinute * 60) * 1000 + self.nStartZeroTime
  else
    nTime = self.nRecommendTimeStamp * 1000
  end
  local localTime = UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(nTime)
  self.textTimeZone:SetLocalText(2010345, localTime)
end

function UIMonsterInvasionPlanTimeView:SetDefaultDropDownPos(bIsHour, dropTrans)
  if IsNull(dropTrans) then
    return
  end
  local content = dropTrans.transform:Find("Dropdown List/Viewport/Content")
  if IsNull(content) then
    return
  end
  local nSelectMin = tonumber(dropTrans:GetText()) or 0
  local nTotalHeight = bIsHour and 24 * ItemHeight or 60 * ItemHeight
  local nViewportHeight = 330
  local targetPos = nSelectMin * ItemHeight
  local nCenterOffset = nViewportHeight / 2
  local nMaxScroll = nTotalHeight - nViewportHeight
  local nTargetY = math.min(targetPos - nCenterOffset, nMaxScroll)
  nTargetY = math.max(nTargetY, 0)
  content.transform.anchoredPosition = Vector2.New(0, nTargetY)
end

return UIMonsterInvasionPlanTimeView
