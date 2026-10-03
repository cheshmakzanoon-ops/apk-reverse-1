local base = UIBaseContainer
local LWUIActivityAlarmClockDesItemRender = BaseClass("LWUIActivityAlarmClockDesItemRender", base)
local showAniName = "LWUIActivityAlarmClockDesItemRender_Open"
local desText_path = "Content/DesText"
local anim_path = "Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearAniTimer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.desText = self:AddComponent(UIText, desText_path)
  self.anim = self:AddComponent(UIAnimator, anim_path)
end

local function ComponentDestroy(self)
  self.desText = nil
  self.anim = nil
end

local function DataDefine(self)
  self.time = -1
  self.languageKey = ""
  self.isShowServerTime = true
  self.playAniDelayTimer = nil
end

local function DataDestroy(self)
  self.time = nil
  self.languageKey = nil
  self.isShowServerTime = nil
  self.playAniDelayTimer = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function InitData(self, groupType, isShowServerTime, delayShowTime)
  self.groupType = groupType
  self.isShowServerTime = isShowServerTime
  self:UpdateView()
end

local function UpdateView(self)
  local day
  if self.groupType == ActivityAlarmClockGroupType.Doing then
    self.desText:SetLocalText("activity_clock_group_inprogress")
  elseif self.groupType == ActivityAlarmClockGroupType.Alliance then
    self.desText:SetLocalText("activity_clock_group_allianceEvent")
  elseif self.groupType == ActivityAlarmClockGroupType.Today then
    day = 0
  elseif self.groupType == ActivityAlarmClockGroupType.Tomorrow then
    day = 1
  elseif self.groupType == ActivityAlarmClockGroupType.DayAfterTomorrow then
    day = 2
  end
  if day then
    local timeStr = ""
    local curTime = UITimeManager:GetInstance():GetServerTime()
    curTime = curTime + day * OneDayTime * 1000
    if self.isShowServerTime then
      timeStr = UITimeManager:GetInstance():GetTimeToMD(math.modf(curTime / 1000))
    else
      timeStr = UITimeManager:GetInstance():GetTimeToLocalYMD(curTime)
    end
    if day == 0 then
      self.desText:SetLocalText("activity_clock_group_today", timeStr)
    else
      self.desText:SetText(timeStr)
    end
  end
end

local function PlayAni(self, delayShowTime)
  if delayShowTime and 0 < delayShowTime then
    self.anim:SetSpeed(0)
    self.anim:SampleAnimationAtTime(showAniName, 0)
    self.anim:Play(showAniName)
    self.playAniDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.anim:SetSpeed(1)
      self.anim:Play(showAniName)
    end, delayShowTime)
  else
    self.anim:SetSpeed(1)
    self.anim:Play(showAniName)
  end
end

local function ClearAniTimer(self)
  if self.playAniDelayTimer then
    self.playAniDelayTimer:Stop()
    self.playAniDelayTimer = nil
  end
end

LWUIActivityAlarmClockDesItemRender.OnCreate = OnCreate
LWUIActivityAlarmClockDesItemRender.OnDestroy = OnDestroy
LWUIActivityAlarmClockDesItemRender.OnEnable = OnEnable
LWUIActivityAlarmClockDesItemRender.OnDisable = OnDisable
LWUIActivityAlarmClockDesItemRender.ComponentDefine = ComponentDefine
LWUIActivityAlarmClockDesItemRender.ComponentDestroy = ComponentDestroy
LWUIActivityAlarmClockDesItemRender.DataDefine = DataDefine
LWUIActivityAlarmClockDesItemRender.DataDestroy = DataDestroy
LWUIActivityAlarmClockDesItemRender.OnAddListener = OnAddListener
LWUIActivityAlarmClockDesItemRender.OnRemoveListener = OnRemoveListener
LWUIActivityAlarmClockDesItemRender.InitData = InitData
LWUIActivityAlarmClockDesItemRender.UpdateView = UpdateView
LWUIActivityAlarmClockDesItemRender.PlayAni = PlayAni
LWUIActivityAlarmClockDesItemRender.ClearAniTimer = ClearAniTimer
return LWUIActivityAlarmClockDesItemRender
