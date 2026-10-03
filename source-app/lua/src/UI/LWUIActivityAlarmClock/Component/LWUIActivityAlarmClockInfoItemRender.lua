local base = UIBaseContainer
local LWUIActivityAlarmClockInfoItemRender = BaseClass("LWUIActivityAlarmClockInfoItemRender", base)
local CalendarAddBtnContent = require("UI.LWUIActivityAlarmClock.Component.CalendarAddBtnContent")
local showAniName = "LWUIActivityAlarmClockInfoItemRender_Open"
local hideAniName = "LWUIActivityAlarmClockInfoItemRender_Close"
local icon_path = "Content/Icon"
local subIcon_path = "Content/SubIcon"
local nameText_path = "Content/NameText"
local timeIconContent_path = "Content/HorLayout/TimeIconContent"
local timeText_path = "Content/HorLayout/TimeText"
local gotoBtn_path = "Content/GoToBtn"
local gotoBtnText_path = "Content/GoToBtn/GoToBtnText"
local anim_path = "Content"
local translateBtn_path = "Content/translateBtn"
local translateImg_path = "Content/translateBtn/translateImg"
local calendar_add_btn_content_path = "Content/HorLayout/CalendarAddBtnContent"
local ShowingState = {
  None = 0,
  Origin = 1,
  Translation = 2
}

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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.subIcon = self:AddComponent(UIImage, subIcon_path)
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.timeIconContent = self:AddComponent(UIBaseContainer, timeIconContent_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.gotoBtnText = self:AddComponent(UIText, gotoBtnText_path)
  self.anim = self:AddComponent(UIAnimator, anim_path)
  self.translateBtn = self:AddComponent(UIButton, translateBtn_path)
  self.translateImg = self:AddComponent(UIImage, translateImg_path)
  self.translateAnim = self:AddComponent(UISimpleAnimation, translateBtn_path)
  self.translateAnim:Stop()
  self.calendar_add_btn_content = self:AddComponent(CalendarAddBtnContent, calendar_add_btn_content_path)
  self.gotoBtnText:SetLocalText("450031")
  self.gotoBtn:SetOnClick(function()
    self:GoToBtnClick()
  end)
  self.translateBtn:SetOnClick(function()
    self:TranslateBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.subIcon = nil
  self.nameText = nil
  self.timeIconContent = nil
  self.timeText = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
  self.anim = nil
  self.translateBtn = nil
  self.translateImg = nil
  self.translateAnim = nil
  self.calendar_add_btn_content = nil
end

local function DataDefine(self)
  self.activityAlarmClockInfo = nil
  self.activityAlarmClockState = nil
  self.isShowServerTime = true
  self.isUpdate = false
end

local function DataDestroy(self)
  self.activityAlarmClockInfo = nil
  self.activityAlarmClockState = nil
  self.isShowServerTime = nil
  self.isUpdate = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorldAllianceMarkTranslateFinish, self.OnTranslateFinish)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.WorldAllianceMarkTranslateFinish, self.OnTranslateFinish)
  base.OnRemoveListener(self)
end

local function Update1000MS(self)
  if self.activityAlarmClockInfo == nil or not self.isUpdate then
    return
  end
  if self:NeedShowCutDownTime() then
    self:RefreshCutDownTimeShow()
  end
end

local function InitData(self, data, isShowServerTime, delayShowTime)
  self.activityAlarmClockInfo = data
  local template = self.activityAlarmClockInfo.template
  self.isShowServerTime = isShowServerTime
  local name = self.activityAlarmClockInfo:GetName()
  local iconPath = self.activityAlarmClockInfo:GetIconPath()
  self.nameText:SetText(name)
  if string.IsNullOrEmpty(iconPath) then
    local logDes = string.format("id: %s, param: %s, positionId: %s", self.activityAlarmClockInfo.id, self.activityAlarmClockInfo.param, self.activityAlarmClockInfo.positionId)
    if self.activityAlarmClockInfo.template and (self.activityAlarmClockInfo.template.type == ActivityAlarmClockType.AllyDrill or self.activityAlarmClockInfo.template.type == ActivityAlarmClockType.AllyDrillBooking) then
      local bossType = DataCenter.AllyDrillDataManager:GetBossType()
      logDes = string.format("%s, bossType: %s", logDes, bossType)
    end
    Logger.LogInfo("LWUIActivityAlarmClockInfoItemRender:InitData, iconPath is nil, logDes: " .. logDes)
    iconPath = "Assets/Main/Sprites/UI/UILWMainClock/zyf_hud_huodongtixing_07.png"
  end
  self.icon:LoadSprite(iconPath)
  if string.IsNullOrEmpty(template.sub_icon) then
    self.subIcon:SetActive(false)
  else
    self.subIcon:SetActive(true)
    self.subIcon:LoadSprite(template.sub_icon)
  end
  self.activityAlarmClockState = self.activityAlarmClockInfo:GetActivityAlarmClockState()
  self.isUpdate = self:NeedShowCutDownTime()
  self.timeIconContent:SetActive(self.isUpdate)
  self:RefreshTimeShow()
  self:ShowText()
  self:ShowCalendatBtnContent()
end

local function RefreshTimeShow(self)
  local timeStr = ""
  if self:NeedShowCutDownTime() then
    self:RefreshCutDownTimeShow()
  elseif self.activityAlarmClockState == ActivityAlarmClockState.NoOpen then
    if self.isShowServerTime then
      timeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(self.activityAlarmClockInfo.startTime, true)
    else
      timeStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.activityAlarmClockInfo.startTime, true, true)
    end
    self.timeText:SetText(timeStr)
  elseif self.activityAlarmClockState == ActivityAlarmClockState.End then
    self.view:RefreshActivityAlarmClockListView()
  end
end

local function RefreshCutDownTimeShow(self)
  local timeStr = ""
  local surplusTime = self.activityAlarmClockInfo.endTime - UITimeManager:GetInstance():GetServerTime()
  if surplusTime <= 0 then
    self.isUpdate = false
    timeStr = "00:00:00"
    self.view:RefreshActivityAlarmClockListView()
  else
    timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime)
  end
  self.timeText:SetText(timeStr)
end

local function GoToBtnClick(self)
  DataCenter.LWActivityAlarmClockManager:JumpTo(self.activityAlarmClockInfo)
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

local function TranslateBtnClick(self)
  if self.activityAlarmClockInfo and self.activityAlarmClockInfo.markData then
    local markData = self.activityAlarmClockInfo.markData
    if self.state == ShowingState.Origin then
      if string.IsNullOrEmpty(markData.translateMsg) and not markData.isTranslating and markData.tanslateFinish ~= 1 then
        self.translateImg:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/zyf_touxiangjiazai_icon1.png")
        self.translateAnim:Play("rotation")
        markData:DoTranslate()
      else
        self:ShowTranslation()
      end
    elseif self.state == ShowingState.Translation then
      self:ShowOrigin()
    end
  end
end

local function ShowText(self)
  if self.activityAlarmClockInfo and self.activityAlarmClockInfo.markData then
    local markData = self.activityAlarmClockInfo.markData
    self.state = ShowingState.None
    self.translateBtn:SetActive(true)
    local pos = self.gotoBtn:GetLocalPosition()
    self.gotoBtn:SetLocalPositionXYZ(pos.x, -26, pos.z)
    if string.IsNullOrEmpty(markData:GetTranslationMsg()) and not markData.isTranslating and markData.tanslateFinish ~= 1 then
      self:ShowOrigin()
    else
      self:ShowTranslation()
    end
  else
    self.translateBtn:SetActive(false)
    local pos = self.gotoBtn:GetLocalPosition()
    self.gotoBtn:SetLocalPositionXYZ(pos.x, 0, pos.z)
  end
end

local function ShowCalendatBtnContent(self)
  self.calendar_add_btn_content:SetActive(false)
  local template = self.activityAlarmClockInfo.template
  if template == nil then
    return
  end
  if template.calendar_id <= 0 then
    return
  end
  local startTime = 0
  local endTime = 0
  if self.activityAlarmClockInfo and self.activityAlarmClockInfo.startTime and self.activityAlarmClockInfo.endTime and 0 < self.activityAlarmClockInfo.startTime and 0 < self.activityAlarmClockInfo.endTime then
    startTime = toInt(self.activityAlarmClockInfo.startTime / 1000)
    endTime = toInt(self.activityAlarmClockInfo.endTime / 1000)
  end
  self.calendar_add_btn_content:SetActive(true)
  self.calendar_add_btn_content:SetDataWithDefautValue(template.calendar_id, startTime, endTime, CalendarSourcePath.Other)
  if self.activityAlarmClockInfo.template.type == ActivityAlarmClockType.AllianceMark then
    self.calendar_add_btn_content:SetTitleData(self.activityAlarmClockInfo:GetName())
  end
end

local function ShowOrigin(self)
  self.state = ShowingState.Origin
  self.translateAnim:Stop()
  self.translateImg:LoadSprite("Assets/Main/Sprites/UI/UILWMainClock/lyp_liaotian_fanyi.png")
  self.nameText:SetText(self.activityAlarmClockInfo:GetName())
end

local function ShowTranslation(self)
  self.state = ShowingState.Translation
  self.translateAnim:Stop()
  self.translateImg:LoadSprite("Assets/Main/Sprites/UI/UILWMainClock/lyp_liaotian_fanyi_duihao.png")
  self.nameText:SetText(self.activityAlarmClockInfo.markData:GetTranslationMsg())
end

local function OnTranslateFinish(self, markData)
  if self.activityAlarmClockInfo and self.activityAlarmClockInfo.markData then
    local data = self.activityAlarmClockInfo.markData
    local translateMsg = markData:GetTranslationMsg()
    if markData and data.type == markData.type and not string.IsNullOrEmpty(translateMsg) and markData.createTime == data.createTime then
      self:ShowTranslation()
    end
  end
end

local function NeedShowCutDownTime(self)
  local needShow = false
  if self.activityAlarmClockState == ActivityAlarmClockState.Doing or self.activityAlarmClockInfo.template and self.activityAlarmClockInfo.template.type == ActivityAlarmClockType.AllyDrillBooking then
    needShow = true
  end
  return needShow
end

LWUIActivityAlarmClockInfoItemRender.OnCreate = OnCreate
LWUIActivityAlarmClockInfoItemRender.OnDestroy = OnDestroy
LWUIActivityAlarmClockInfoItemRender.OnEnable = OnEnable
LWUIActivityAlarmClockInfoItemRender.OnDisable = OnDisable
LWUIActivityAlarmClockInfoItemRender.ComponentDefine = ComponentDefine
LWUIActivityAlarmClockInfoItemRender.ComponentDestroy = ComponentDestroy
LWUIActivityAlarmClockInfoItemRender.DataDefine = DataDefine
LWUIActivityAlarmClockInfoItemRender.DataDestroy = DataDestroy
LWUIActivityAlarmClockInfoItemRender.OnAddListener = OnAddListener
LWUIActivityAlarmClockInfoItemRender.OnRemoveListener = OnRemoveListener
LWUIActivityAlarmClockInfoItemRender.Update1000MS = Update1000MS
LWUIActivityAlarmClockInfoItemRender.InitData = InitData
LWUIActivityAlarmClockInfoItemRender.RefreshTimeShow = RefreshTimeShow
LWUIActivityAlarmClockInfoItemRender.RefreshCutDownTimeShow = RefreshCutDownTimeShow
LWUIActivityAlarmClockInfoItemRender.GoToBtnClick = GoToBtnClick
LWUIActivityAlarmClockInfoItemRender.PlayAni = PlayAni
LWUIActivityAlarmClockInfoItemRender.ClearAniTimer = ClearAniTimer
LWUIActivityAlarmClockInfoItemRender.TranslateBtnClick = TranslateBtnClick
LWUIActivityAlarmClockInfoItemRender.ShowText = ShowText
LWUIActivityAlarmClockInfoItemRender.ShowCalendatBtnContent = ShowCalendatBtnContent
LWUIActivityAlarmClockInfoItemRender.ShowOrigin = ShowOrigin
LWUIActivityAlarmClockInfoItemRender.ShowTranslation = ShowTranslation
LWUIActivityAlarmClockInfoItemRender.OnTranslateFinish = OnTranslateFinish
LWUIActivityAlarmClockInfoItemRender.NeedShowCutDownTime = NeedShowCutDownTime
return LWUIActivityAlarmClockInfoItemRender
