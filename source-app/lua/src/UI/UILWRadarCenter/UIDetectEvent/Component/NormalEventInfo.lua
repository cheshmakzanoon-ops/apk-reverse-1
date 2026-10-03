local NormalEventInfo = BaseClass("NormalEventInfo", UIBaseContainer)
local base = UIBaseContainer
local normal_event_next_recovery_time_text_path = "BG/Normal_Event_Next_Recovery_Time/Normal_Event_Next_Recovery_Time_Text"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.normal_event_next_recovery_time_text = self:AddComponent(UIText, normal_event_next_recovery_time_text_path)
end

local function DataDefine(self)
  self.showTimeInterval = 6
  self.currentShowTime = self.showTimeInterval
  self.isShowNextRecoveryTime = true
  self.isUpdate = false
  self.needPlayAnimation = false
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  self:StopFadeAnimation()
end

local function DataDestroy(self)
  self.showTimeInterval = nil
  self.currentShowTime = nil
  self.isShowNextRecoveryTime = nil
  self.isUpdate = nil
  self.needPlayAnimation = nil
end

local function Update1000MS(self)
  if not self.isUpdate then
    return
  end
  self.currentShowTime = self.currentShowTime - 1
  if self.currentShowTime < 0 then
    self.isShowNextRecoveryTime = not self.isShowNextRecoveryTime
    self.currentShowTime = self.showTimeInterval
    self.needPlayAnimation = true
  end
  self:RefreshTime()
end

local function SetData(self, data)
  self.data = data
  local now = UITimeManager:GetInstance():GetServerTime()
  self.isUpdate = now < self.data.totalEndTime
  self.normal_event_next_recovery_time_text:SetAlpha(1)
  self:RefreshView()
end

local function RefreshView(self)
  if self.data == nil then
    return
  end
  self:RefreshTime()
end

local function RefreshTime(self)
  if self.data == nil then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now >= self.data.totalEndTime then
    self.isUpdate = false
    self.needPlayAnimation = false
    self:StopFadeAnimation()
    self.normal_event_next_recovery_time_text:SetAlpha(1)
    self.normal_event_next_recovery_time_text:SetLocalText("radar_tips_19")
    return
  end
  if self.needPlayAnimation then
    self.needPlayAnimation = false
    self:StopFadeAnimation()
    self.tweenSeq = CS.DG.Tweening.DOTween.Sequence()
    self.tweenSeq:Append(self.normal_event_next_recovery_time_text.unity_tmpro:DOFade(0, 0.5))
    self.tweenSeq:AppendCallback(function()
      self:SetShowTimeDes()
    end)
    self.tweenSeq:Append(self.normal_event_next_recovery_time_text.unity_tmpro:DOFade(1, 0.5))
  else
    self:SetShowTimeDes()
  end
end

local function SetShowTimeDes(self)
  if self.isShowNextRecoveryTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local currentLeftTime = (self.data.currentEndTime - now) / 1000
    currentLeftTime = math.max(0, currentLeftTime)
    local timeStr = UITimeManager:GetInstance():SecondToFmtString(currentLeftTime)
    local currentLv = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
    local curNum = self.view.ctrl:GetEventRecoverNum(currentLv)
    self.normal_event_next_recovery_time_text:SetLocalText("radar_tips_21", timeStr, curNum)
  else
    local localTimeData = UITimeManager:GetInstance():TimeStampToLocalDate(self.data.totalEndTime)
    local timeStr = string.format("%d-%d %02d:%02d:%02d", localTimeData.month, localTimeData.day, localTimeData.hour, localTimeData.min, localTimeData.sec)
    self.normal_event_next_recovery_time_text:SetLocalText("radar_tips_22", timeStr)
  end
end

local function StopFadeAnimation(self)
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
end

NormalEventInfo.RefreshTime = RefreshTime
NormalEventInfo.SetData = SetData
NormalEventInfo.RefreshView = RefreshView
NormalEventInfo.OnCreate = OnCreate
NormalEventInfo.OnDestroy = OnDestroy
NormalEventInfo.ComponentDefine = ComponentDefine
NormalEventInfo.ComponentDestroy = ComponentDestroy
NormalEventInfo.DataDefine = DataDefine
NormalEventInfo.DataDestroy = DataDestroy
NormalEventInfo.Update1000MS = Update1000MS
NormalEventInfo.SetShowTimeDes = SetShowTimeDes
NormalEventInfo.StopFadeAnimation = StopFadeAnimation
return NormalEventInfo
