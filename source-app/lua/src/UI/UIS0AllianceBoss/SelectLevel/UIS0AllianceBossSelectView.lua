local UIS0AllianceBossSelectView = BaseClass("UIS0AllianceBossSelectView", UIBaseView)
local base = UIBaseView
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local UIS0AllianceBossSelectLevel = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossSelectLevel")
local UIS0AllianceBossSelectTimeItem = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossSelectTimeItem")

function UIS0AllianceBossSelectView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIS0AllianceBossSelectView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossSelectView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.emptyClick = self.viewSkin:AddComponent(self, UIButton, 1)
  self.emptyClick:SetOnClick(function()
    self:OnEmptyClickClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.rawImgBanner = self.viewSkin:AddComponent(self, UIRawImage, 4)
  self.compS0AllianceBossSelectLevel = self.viewSkin:AddComponent(self, UIS0AllianceBossSelectLevel, 5)
  self.textTitleSelectTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compHour = self.viewSkin:AddComponent(self, UIS0AllianceBossSelectTimeItem, 7)
  self.compMin = self.viewSkin:AddComponent(self, UIS0AllianceBossSelectTimeItem, 8)
  self.toggleSelect = self.viewSkin:AddComponent(self, UIToggle, 9)
  self.textToggle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnSelect = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnSelect:SetOnClick(function()
    self:OnBtnSelectClick()
  end)
  self.textSelectTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textTimeZone = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textTitleDate = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textDate = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.canvasGroup = self.viewSkin:AddComponent(self, UICanvasGroup, 16)
  self.toggleSelect:SetOnValueChanged(function(on)
    self:OnToggleSelect(on)
  end)
  self.compHour:InitView(1)
  self.compMin:InitView(2)
  self.compHour:RefreshHour(0, 23)
  self.compMin:RefreshMin(0, 59)
end

function UIS0AllianceBossSelectView:ComponentDestroy()
  self:SetCanvasInteractable(true)
  self.compHour:Clear()
  self.compMin:Clear()
  self.viewSkin = nil
  self.emptyClick = nil
  self.textTitle = nil
  self.btnClose = nil
  self.rawImgBanner = nil
  self.compS0AllianceBossSelectLevel = nil
  self.textTitleSelectTime = nil
  self.compHour = nil
  self.compMin = nil
  self.toggleSelect = nil
  self.textToggle = nil
  self.btnSelect = nil
  self.textSelectTime = nil
  self.textTimeZone = nil
  self.textTitleDate = nil
  self.textDate = nil
  self.canvasGroup = nil
end

function UIS0AllianceBossSelectView:DataDefine()
  self.viewDifficulty = nil
  self.maxDifficulty = DataCenter.AllianceBossS0TemplateManager.maxDifficulty
  self.openDifficultyLevel = DataCenter.S0AllianceBossDataManager.openDifficultyLevel
  self.lastSelectTime = nil
  self.isSelectLastTime = nil
  self.seq = nil
end

function UIS0AllianceBossSelectView:DataDestroy()
  self.viewDifficulty = nil
  self.maxDifficulty = nil
  self.openDifficultyLevel = nil
  self.lastSelectTime = nil
  self.isSelectLastTime = nil
  if self.seq then
    self.seq:Kill()
    self.seq = nil
  end
end

function UIS0AllianceBossSelectView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnS0AllianceBossOnLevelSelectChanged, self.OnViewIndexChanged)
  self:AddUIListener(EventId.OnS0AllianceBossTimeSelectChanged, self.OnTimeSelectChanged)
  self:AddUIListener(EventId.OpenUI, self.OnWindowOpened)
  self:AddUIListener(EventId.OnS0AllianceBossLastChooseTime, self.OnS0AllianceBossLastChooseTimeGot)
  self:AddUIListener(EventId.OnS0AllianceBossAppointSuccess, self.OnAppointSuccess)
  self:AddUIListener(EventId.OnS0AllianceBossOnSelectLevel, self.OnSelectLevelReqBack)
end

function UIS0AllianceBossSelectView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnS0AllianceBossOnLevelSelectChanged, self.OnViewIndexChanged)
  self:RemoveUIListener(EventId.OnS0AllianceBossTimeSelectChanged, self.OnTimeSelectChanged)
  self:RemoveUIListener(EventId.OpenUI, self.OnWindowOpened)
  self:RemoveUIListener(EventId.OnS0AllianceBossLastChooseTime, self.OnS0AllianceBossLastChooseTimeGot)
  self:RemoveUIListener(EventId.OnS0AllianceBossAppointSuccess, self.OnAppointSuccess)
  self:RemoveUIListener(EventId.OnS0AllianceBossOnSelectLevel, self.OnSelectLevelReqBack)
  base.OnRemoveListener(self)
end

function UIS0AllianceBossSelectView:InitView()
  self.textTitle:SetLocalText("s0_alliance_boss_challenge_schedule")
  self.textTitleSelectTime:SetLocalText("s0_alliance_boss_server_start")
  self.textSelectTime:SetLocalText("s0_alliance_boss_confirm_btn")
  self.textToggle:SetLocalText("s0_alliance_boss_reuse_schedule")
  self.textTitleDate:SetLocalText("s0_alliance_boss_date_select")
  local param = self:GetUserData()
  if param == nil then
    return
  end
  self.viewDifficulty = param.viewDifficulty
  self.curDifficulty = param.curDifficulty
  self.compS0AllianceBossSelectLevel:InitView(self.maxDifficulty, self.viewDifficulty, UIWindowNames.UIS0AllianceBossSelect)
  self.bossDifficultyIds = DataCenter.AllianceBossS0TemplateManager:GetBossDifficultyIds()
  local mgr = DataCenter.S0AllianceBossDataManager
  local battleDayTime = mgr.battleDayTime
  if self.actEndTime == nil then
    self.actEndTime = mgr.actEndTime
  end
  if battleDayTime == nil or battleDayTime == 0 then
    Logger.LogError("S0AllianceBoss -- battleDayTime is error")
    return
  end
  self.battleDayTime = battleDayTime
  self.deadlineOffset = mgr:GetDeadlineOffset()
  self.isSelectLastTime = Setting:GetPrivateBool(SettingKeys.ALLIANCE_BOSS_S0_LAST_ATTEND_TIME, false)
  self.toggleSelect:SetIsOn(self.isSelectLastTime)
  mgr:ReqGainLastTimeInfo()
  self:RefreshView()
end

function UIS0AllianceBossSelectView:RefreshView()
  self:RefreshCurView(self.viewDifficulty)
  self.compS0AllianceBossSelectLevel:RefreshSelectedItem(self.viewDifficulty)
end

function UIS0AllianceBossSelectView:OnViewIndexChanged(param)
  if param == nil or param.uiName ~= UIWindowNames.UIS0AllianceBossSelect then
    return
  end
  local index = param.value
  if index ~= self.viewDifficulty then
    self.viewDifficulty = index
    self:RefreshCurView(index)
  end
end

function UIS0AllianceBossSelectView:RefreshCurView(index)
  if self.bossDifficultyIds == nil then
    self.bossDifficultyIds = DataCenter.AllianceBossS0TemplateManager:GetBossDifficultyIds()
  end
  local bossId = self.bossDifficultyIds and self.bossDifficultyIds[index]
  if bossId then
    local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(bossId)
    if bossTemp then
      self.rawImgBanner:LoadSpriteAuto(bossTemp.record_banner)
    end
  end
  self.btnDisable = index > self.openDifficultyLevel
  CS.UIGray.SetGray(self.btnSelect.transform, self.btnDisable, true)
  if self.isSelectLastTime then
    self:RefreshTime()
    self:SetLastSelectTimeInfo()
  else
    self:RefreshTime(index)
  end
end

function UIS0AllianceBossSelectView:CalRecommendTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  local secondDayZero = self.battleDayTime
  local delay = now - secondDayZero
  if now - self.actEndTime >= 0 then
    self.recommendTime = nil
    self.recommendHour = 0
    self.recommendMinute = 0
    self.recommendDate = 0
  elseif 0 < delay then
    local date = UITimeManager:GetInstance():TimeStampToServerDate(now)
    local hour, min = date.hour, date.min
    if 23 <= hour then
      if min < 50 then
        min = min + 10
      else
        min = 59
      end
    elseif 50 <= min then
      min = min - 50
      hour = hour + 1
    else
      min = min + 10
    end
    if hour == 24 - self.deadlineOffset and min < 10 then
      min = 0
    end
    self.recommendDate = (delay + 600000) // 86400000
    local selectDelay = ((hour * 60 + min) * 60 + self.recommendDate * OneDayTime) * 1000
    local selectTime = self.battleDayTime + selectDelay
    self.recommendTime = selectTime
    self.recommendHour = hour
    self.recommendMinute = min
  else
    self.recommendTime = secondDayZero
    self.recommendHour = 0
    self.recommendMinute = 0
    self.recommendDate = 0
  end
  if not self.recommendTime then
    self.selectDisable = true
    CS.UIGray.SetGray(self.btnSelect.transform, self.selectDisable, true)
  else
    self.selectDisable = false
    CS.UIGray.SetGray(self.btnSelect.transform, self.btnDisable, true)
  end
end

function UIS0AllianceBossSelectView:RefreshTime(index)
  self:CalRecommendTime()
  if not self.recommendTime then
    local monthDate = UITimeManager:GetInstance():TimeStampToMDForServer(math.modf(self.actEndTime / 1000))
    self.textDate:SetText(monthDate)
    return
  end
  local monthDate = UITimeManager:GetInstance():TimeStampToMDForServer(math.modf(self.recommendTime / 1000))
  self.textDate:SetText(monthDate)
  self.selectHour = self.recommendHour
  self.compHour:SetValue(self.recommendHour)
  self.compHour:SetText(self.recommendHour)
  self.selectMinute = self.recommendMinute
  self.compMin:SetValue(self.recommendMinute)
  self.compMin:SetText(self.recommendMinute)
  self:RefreshLocalTime()
end

function UIS0AllianceBossSelectView:RefreshLocalTime()
  local time
  if self.selectHour and self.selectMinute then
    local selectDelay = ((self.selectHour * 60 + self.selectMinute) * 60 + self.recommendDate * OneDayTime) * 1000
    time = self.battleDayTime + selectDelay
  else
    time = self.recommendTime
  end
  local localTime = UITimeManager:GetInstance():TimeStampToTimeForLocal(time)
  self.textTimeZone:SetLocalText("s0_alliance_boss_timezone_2", localTime)
end

function UIS0AllianceBossSelectView:SetCanvasInteractable(interactable)
  self.canvasGroup:SetInteractable(interactable)
end

function UIS0AllianceBossSelectView:OnEmptyClickClick()
  self:OnBtnCloseClick()
end

function UIS0AllianceBossSelectView:OnBtnCloseClick()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UIS0AllianceBossSelectView:OnToggleSelect(isOn)
  if self.isSelectLastTime == isOn then
    return
  end
  self:PlayTimeChangeAnim()
  Setting:SetPrivateBool(SettingKeys.ALLIANCE_BOSS_S0_LAST_ATTEND_TIME, isOn)
  self.isSelectLastTime = isOn
  if isOn then
    self:SetLastSelectTimeInfo()
  else
    self:RefreshTime()
  end
  CommonUtil.PlayerPrefsSetBool(SettingKeys.ALLIANCE_BOSS_S0_LAST_ATTEND_TIME, isOn)
end

function UIS0AllianceBossSelectView:ClearSequence()
  if self.seq then
    self.seq:Kill()
    self.seq = nil
    self.compHour:ResetTxtScale()
    self.compMin:ResetTxtScale()
  end
end

function UIS0AllianceBossSelectView:PlayTimeChangeAnim()
  if self.seq then
    self.seq:Kill()
    self.seq = nil
    self.compHour:ResetTxtScale()
    self.compMin:ResetTxtScale()
  end
  self.seq = DOTween.Sequence()
  self.seq:Append(self.compHour:DOScale())
  self.seq:Join(self.compMin:DOScale())
end

function UIS0AllianceBossSelectView:SetLastSelectTimeInfo()
  if self.lastSelectTime and self.lastSelectTime ~= -1 then
    local lastDate = UITimeManager:GetInstance():TimeStampToServerDate(self.lastSelectTime)
    local lastHour = lastDate.hour
    local lastMin = lastDate.min
    self.compHour:SetValue(lastHour)
    self.compHour:SetText(lastHour)
    self.compMin:SetValue(lastMin)
    self.compMin:SetText(lastMin)
    self.selectHour = lastHour
    self.selectMinute = lastMin
  end
  self:RefreshLocalTime()
end

function UIS0AllianceBossSelectView:OnBtnSelectClick()
  if self.btnDisable then
    UIUtil.ShowTipsId("s0_alliance_boss_go_lock_tips")
    return
  end
  if self.selectDisable then
    local context = Localization:GetString("s0_alliance_boss_count_down_hour", self.deadlineOffset)
    UIUtil.ShowTips(context)
    return
  end
  if self.selectHour == nil or self.selectMinute == nil then
    return
  end
  local hour = self.selectHour
  local min = self.selectMinute
  local day = self.recommendDate or 0
  local selectDelay = ((hour * 60 + min) * 60 + day * OneDayTime) * 1000
  local selectTime = self.battleDayTime + selectDelay
  self:CalRecommendTime()
  if selectTime > self.actEndTime then
    local context = Localization:GetString("s0_alliance_boss_count_down_hour", self.deadlineOffset)
    UIUtil.ShowTips(context)
  elseif selectTime < self.recommendTime then
    local cutTs = UITimeManager:GetInstance():GetServerTime()
    if selectTime < cutTs then
      UIUtil.ShowTipsId("appointment_time_exceed_tips_2")
    else
      if DataCenter.S0AllianceBossDataManager.isSign == 1 then
        self:OnBtnCloseClick()
      else
        self:SetCanvasInteractable(false)
      end
      DataCenter.S0AllianceBossDataManager:ReqAllianceBossS0SelectTime(selectTime, self.viewDifficulty)
    end
  else
    if DataCenter.S0AllianceBossDataManager.isSign == 1 then
      self:OnBtnCloseClick()
    else
      self:SetCanvasInteractable(false)
    end
    DataCenter.S0AllianceBossDataManager:ReqAllianceBossS0SelectTime(selectTime, self.viewDifficulty)
  end
end

function UIS0AllianceBossSelectView:OnTimeSelectChanged(type)
  if type == 1 then
    self:OnHourChange()
  else
    self:OnMinuteChange()
  end
end

function UIS0AllianceBossSelectView:OnWindowOpened(uiName)
  if uiName == UIWindowNames.UIDisconnect then
    self:OnBtnCloseClick()
  end
end

function UIS0AllianceBossSelectView:OnS0AllianceBossLastChooseTimeGot(message)
  if message then
    self.lastSelectTime = message.lastSelectTime
    self:RefreshView()
  end
end

function UIS0AllianceBossSelectView:OnAppointSuccess()
  self:OnBtnCloseClick()
end

function UIS0AllianceBossSelectView:OnSelectLevelReqBack(message)
  local errorCode = message and message.errorCode
  if errorCode ~= nil then
    self:SetCanvasInteractable(true)
  end
end

function UIS0AllianceBossSelectView:OnHourChange()
  self:CalRecommendTime()
  if not self.recommendTime then
    return
  end
  self.selectHour = tonumber(self.compHour:GetText())
  if self.selectHour == self.recommendHour then
    self.compMin:SetValue(self.recommendMinute)
    self.compMin:SetText(self.recommendMinute)
    self.selectMinute = self.recommendMinute
  else
  end
  self:RefreshLocalTime()
end

function UIS0AllianceBossSelectView:OnMinuteChange()
  self:CalRecommendTime()
  if not self.recommendTime then
    return
  end
  self.selectMinute = tonumber(self.compMin:GetText())
  self:RefreshLocalTime()
end

return UIS0AllianceBossSelectView
