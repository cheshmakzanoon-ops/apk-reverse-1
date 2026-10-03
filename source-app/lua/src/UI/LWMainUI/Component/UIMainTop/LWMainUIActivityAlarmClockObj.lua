local base = UIBaseContainer
local LWMainUIActivityAlarmClockObj = BaseClass("LWMainUIActivityAlarmClockObj", base)
local Localization = CS.GameEntry.Localization
local closeY = 30
local icon_path = "Icon"
local closeBtn_path = "CloseBtn"
local desText_path = "DesText"
local subIcon_path = "SubIcon"
local jumpToBtn_path = "JumpToBtn"
local simpleAnim_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.desText = self:AddComponent(UIText, desText_path)
  self.subIcon = self:AddComponent(UIImage, subIcon_path)
  self.jumpToBtn = self:AddComponent(UIEventTrigger, jumpToBtn_path)
  self.simpleAnim = self:AddComponent(UISimpleAnimation, simpleAnim_path)
  self.closeBtn:SetOnClick(function()
    self:CloseBtnClick()
  end)
  self.jumpToBtn:OnPointerClick(function(eventData)
    self:JumpToBtnClick(eventData)
  end)
  self.jumpToBtn:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.jumpToBtn:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.jumpToBtn:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.closeBtn = nil
  self.desText = nil
  self.subIcon = nil
  self.jumpToBtn = nil
  self.simpleAnim = nil
end

local function DataDefine(self)
  self.curShowActivityAlarmClockInfo = nil
  self.isUpdate = false
  self.isShow = false
  self.name = ""
  self.dragPosY = nil
  self.inAnimTimer = nil
  self.outAnimTimer = nil
  self.intAnimFinshReInit = false
end

local function DataDestroy(self)
  self.curShowActivityAlarmClockInfo = nil
  self.isUpdate = nil
  self.isShow = nil
  self.name = nil
  self.dragPosY = nil
  self.inAnimTimer = nil
  self.outAnimTimer = nil
  self.intAnimFinshReInit = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceQuitOK, self.OnAllianceQuitSuccess)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceQuitOK, self.OnAllianceQuitSuccess)
  base.OnRemoveListener(self)
end

local function OnAllianceQuitSuccess(self)
  self.isUpdate = false
  self:SetActiveState(false)
end

local function Update1000MS(self)
  if not self.isUpdate then
    return
  end
  if self.curShowActivityAlarmClockInfo then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.curShowActivityAlarmClockInfo.showMainUITopStartTime and curTime <= self.curShowActivityAlarmClockInfo.showMainUITopEndTime then
      self:ShowView()
    elseif self.isShow then
      self:CloseBtnClick()
    end
  end
end

local function ReInit(self, data)
  self.curShowActivityAlarmClockInfo = data
  self.isUpdate = true
  self.dragPosY = nil
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self:SetCurActivityAlarmClockInfo()
  if self.curShowActivityAlarmClockInfo and curTime >= self.curShowActivityAlarmClockInfo.showMainUITopStartTime and curTime <= self.curShowActivityAlarmClockInfo.showMainUITopEndTime then
    self:ShowView()
  else
    self:SetActiveState(false)
  end
end

local function ShowView(self)
  if not self.isShow then
    DataCenter.LWSoundManager:PlaySound(90116, false)
    self:SetActiveState(true)
    self:RefreshTimeView()
    if not self.inAnimTimer or not not self.inAnimTimer:IsOver() then
      local _, inTime = self.simpleAnim:PlayAnimationReturnTime("in")
      self.inAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      end, inTime)
    end
  else
    self:RefreshTimeView()
  end
end

local function SetActiveState(self, isShow)
  self.isShow = isShow
  self.gameObject:SetActive(isShow)
end

local function SetCurActivityAlarmClockInfo(self)
  if not self.curShowActivityAlarmClockInfo then
    return
  end
  local template = self.curShowActivityAlarmClockInfo.template
  if template then
    self.name = self.curShowActivityAlarmClockInfo:GetName()
    local iconPath = self.curShowActivityAlarmClockInfo:GetIconPath()
    self.icon:LoadSprite(iconPath)
    if string.IsNullOrEmpty(template.sub_icon) then
      self.subIcon:SetActive(false)
    else
      self.subIcon:LoadSprite(template.sub_icon)
    end
  end
end

local function RefreshTimeView(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local surplusTime = self.curShowActivityAlarmClockInfo.showMainUITopEndTime - curTime
  if surplusTime <= 0 then
    self:CloseBtnClick()
  else
    local template = self.curShowActivityAlarmClockInfo.template
    if template then
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime)
      if template.type == ActivityAlarmClockType.KingdomPosition then
        self.desText:SetLocalText(template.timer_dialog, timeStr, self.name)
      elseif template.type == ActivityAlarmClockType.AllianceTrain then
        self.desText:SetLocalText(template.timer_dialog, timeStr)
      elseif template.type == ActivityAlarmClockType.AllianceStar then
        self.desText:SetLocalText(template.timer_dialog, timeStr)
      elseif template.type == ActivityAlarmClockType.Meteorite then
        self.desText:SetLocalText(template.timer_dialog, timeStr)
      elseif template.type == ActivityAlarmClockType.KillZombie then
        self.desText:SetLocalText(template.timer_dialog, timeStr)
      elseif template.type == ActivityAlarmClockType.MonsterInvasion then
        self.desText:SetLocalText(template.timer_dialog, timeStr)
      elseif template.type == ActivityAlarmClockType.QueenOfBlood then
        self.desText:SetLocalText(template.timer_dialog, timeStr)
      elseif template.type == ActivityAlarmClockType.AllyDrillBooking then
        self.desText:SetLocalText(template.timer_dialog, timeStr)
      elseif template.type == ActivityAlarmClockType.S0AllianceBossBattle then
        self.desText:SetLocalText(template.timer_dialog, timeStr)
      else
        self.desText:SetLocalText(template.timer_dialog, self.name, timeStr)
      end
    else
      self.desText:SetText("")
    end
  end
end

local function InnerClose(self)
  self.isUpdate = false
  self:SetActiveState(false)
  self.dragPosY = nil
  DataCenter.LWActivityAlarmClockManager:RecordLocalAlarmClockData(self.curShowActivityAlarmClockInfo)
  DataCenter.LWActivityAlarmClockManager:RemoveNeedShowMainUITopAlarmClock(self.curShowActivityAlarmClockInfo)
  local newInfo = DataCenter.LWActivityAlarmClockManager:GetNeedShowMainUITopAlarmClockData()
  if newInfo then
    self:ReInit(newInfo)
  else
    self.curShowActivityAlarmClockInfo = nil
  end
end

local function CloseBtnClick(self)
  if not self.outAnimTimer or not not self.outAnimTimer:IsOver() then
    local _, outTime = self.simpleAnim:PlayAnimationReturnTime("out")
    self.outAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      InnerClose(self)
    end, outTime)
  end
end

local function JumpToBtnClick(self)
  if self:IsPlayAnim() then
    return
  end
  if self.isUpdate and self.dragPosY == nil then
    DataCenter.LWActivityAlarmClockManager:JumpTo(self.curShowActivityAlarmClockInfo)
  end
end

local function OnBeginDrag(self, eventData)
  if self:IsPlayAnim() then
    return
  end
  if self.isUpdate then
    self.dragPosY = eventData.position.y
  end
end

local function OnEndDrag(self, eventData)
  if self:IsPlayAnim() then
    return
  end
  self.dragPosY = nil
end

local function OnDrag(self, eventData)
  if self:IsPlayAnim() then
    return
  end
  if self.isUpdate and self.dragPosY and eventData.position.y - self.dragPosY >= closeY then
    self:CloseBtnClick()
  end
end

local function IsPlayAnim(self)
  local isPlay = false
  if not (not self.inAnimTimer or self.inAnimTimer:IsOver()) or self.outAnimTimer and not self.outAnimTimer:IsOver() then
    isPlay = true
  end
  return isPlay
end

LWMainUIActivityAlarmClockObj.OnCreate = OnCreate
LWMainUIActivityAlarmClockObj.OnDestroy = OnDestroy
LWMainUIActivityAlarmClockObj.OnEnable = OnEnable
LWMainUIActivityAlarmClockObj.OnDisable = OnDisable
LWMainUIActivityAlarmClockObj.ComponentDefine = ComponentDefine
LWMainUIActivityAlarmClockObj.ComponentDestroy = ComponentDestroy
LWMainUIActivityAlarmClockObj.DataDefine = DataDefine
LWMainUIActivityAlarmClockObj.DataDestroy = DataDestroy
LWMainUIActivityAlarmClockObj.OnAddListener = OnAddListener
LWMainUIActivityAlarmClockObj.OnRemoveListener = OnRemoveListener
LWMainUIActivityAlarmClockObj.OnAllianceQuitSuccess = OnAllianceQuitSuccess
LWMainUIActivityAlarmClockObj.Update1000MS = Update1000MS
LWMainUIActivityAlarmClockObj.ReInit = ReInit
LWMainUIActivityAlarmClockObj.ShowView = ShowView
LWMainUIActivityAlarmClockObj.SetActiveState = SetActiveState
LWMainUIActivityAlarmClockObj.RefreshTimeView = RefreshTimeView
LWMainUIActivityAlarmClockObj.CloseBtnClick = CloseBtnClick
LWMainUIActivityAlarmClockObj.JumpToBtnClick = JumpToBtnClick
LWMainUIActivityAlarmClockObj.OnBeginDrag = OnBeginDrag
LWMainUIActivityAlarmClockObj.OnEndDrag = OnEndDrag
LWMainUIActivityAlarmClockObj.OnDrag = OnDrag
LWMainUIActivityAlarmClockObj.IsPlayAnim = IsPlayAnim
LWMainUIActivityAlarmClockObj.SetCurActivityAlarmClockInfo = SetCurActivityAlarmClockInfo
return LWMainUIActivityAlarmClockObj
