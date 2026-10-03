local base = UIBaseContainer
local ActCalendarEventItem = BaseClass("ActCalendarEventItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local BAR_POS_OFFSET = -2
local BAR_ORIGIN_WIDTH = 110
local BAR_DELTA_WIDTH = 112
local NAME_ORIGIN_WIDTH = 94
local NAME_DELTA_WIDTH = 110
local DELAY_SHOW_DElTA = 0.02
local DELAY_SHOW_NEW = 0.2
local QUEST_ENTRY_ROLLING_SPD = 60
local QUEST_ENTRY_ROLLING_DELAY = 2
local QUEST_ENTRY_ROLLING_HOLD = 2
local CUR_DAY_INDEX = DataCenter.ActCalendarManager.CUR_DAY_INDEX
local WEEK_DAYS = DataCenter.ActCalendarManager.WEEK_DAYS

function ActCalendarEventItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActCalendarEventItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActCalendarEventItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textActName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnTimeBar = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnTimeBar:SetOnClick(function()
    self:OnBtnTimeBarClick()
  end)
  self.compRedDotFlag = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compNewFlag = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.animatorNewFlag = self.viewSkin:AddComponent(self, UIAnimator, 6)
  self.canvasGroup = self.viewSkin:AddComponent(self, UICanvasGroup, 7)
  self.compNameMask = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.imgTimeBarIcon = self.viewSkin:AddComponent(self, UIImage, 9)
  self.compTimeBar = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compRedDotFlag:SetActive(false)
  self.animatorNewFlag:SetActive(false)
  self.ani = self:AddComponent(UISimpleAnimation, "")
  self.canvasGroup:SetAlpha(0)
  self.newFlagAni = self:AddComponent(UISimpleAnimation, "timeBar/flagNode/newFlag")
  self.textActName:SetAnchoredPositionXY(0, 0)
end

function ActCalendarEventItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textActName = nil
  self.btnTimeBar = nil
  self.compRedDotFlag = nil
  self.compNewFlag = nil
  self.animatorNewFlag = nil
  self.canvasGroup = nil
  self.compNameMask = nil
  self.imgTimeBarIcon = nil
  self.compTimeBar = nil
end

function ActCalendarEventItem:DataDefine()
end

function ActCalendarEventItem:DataDestroy()
  self.data = nil
  if self.delayShowAni then
    self.delayShowAni:Stop()
    self.delayShowAni = nil
  end
  if self.delayShowNewFlag then
    self.delayShowNewFlag:Stop()
    self.delayShowNewFlag = nil
  end
  if self.txtTweenSeq then
    self.txtTweenSeq:Kill()
    self.txtTweenSeq = nil
  end
end

function ActCalendarEventItem:SetData(data)
  self.data = data
  self:_setLanguageAdapt()
  self:_setBarPos()
  self:_setBarSize()
  self:_setBarBg()
  self:_setNameSize()
  self:_setIcon()
  self:_setName()
  self:_refreshRedDot()
end

function ActCalendarEventItem:PlayShowAni()
  if self.delayShowAni then
    self.delayShowAni:Stop()
  end
  self.delayShowAni = TimerManager:GetInstance():DelayInvoke(function()
    self.ani:Play("show")
    self:_setNewFlag()
  end, self:_getDelayTime())
end

function ActCalendarEventItem:GetHeight()
  return self.rectTransform:GetSizeDelta().y
end

function ActCalendarEventItem:_setLanguageAdapt()
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.imgTimeBarIcon:SetLocalScaleXYZ(-1, 1, 1)
  else
    self.imgTimeBarIcon:SetLocalScaleXYZ(1, 1, 1)
  end
end

function ActCalendarEventItem:_setBarPos()
  local beginTime = self.data:GetBegin()
  local weekBeginTime = DataCenter.ActCalendarManager:GetWeekBegin()
  if DataCenter.ActCalendarManager:IsBeforeWeekBegin(beginTime) then
    beginTime = weekBeginTime
  end
  local offset = (beginTime - weekBeginTime) / 86400000
  local x = BAR_POS_OFFSET + offset * BAR_DELTA_WIDTH
  local y = self.compTimeBar:GetAnchoredPositionY()
  self.compTimeBar:SetAnchoredPositionXY(x, y)
end

function ActCalendarEventItem:_setBarSize()
  local days = self.data:GetDurationDays()
  local subDays = 0
  if DataCenter.ActCalendarManager:IsBeforeWeekBegin(self.data:GetBegin()) then
    subDays = DataCenter.ActCalendarManager:GetDurationDays(self.data:GetBegin(), DataCenter.ActCalendarManager:GetWeekBegin())
  end
  if days - subDays > DataCenter.ActCalendarManager.WEEK_DAYS then
    days = DataCenter.ActCalendarManager.WEEK_DAYS + subDays + 1
  end
  local barWidth = BAR_ORIGIN_WIDTH
  if days and 1 < days then
    barWidth = BAR_ORIGIN_WIDTH + BAR_DELTA_WIDTH * (days - subDays - 1)
  end
  if barWidth <= 0 then
    Logger.LogError("\228\184\141\232\175\165\230\142\168\233\128\129\228\184\128\228\184\170\229\183\178\231\187\143\231\187\147\230\157\159\231\154\132\230\180\187\229\138\168")
    barWidth = BAR_ORIGIN_WIDTH
  end
  local sizeDelta = self.compTimeBar:GetSizeDelta()
  sizeDelta.x = barWidth
  self.compTimeBar:SetSizeDelta(sizeDelta)
end

function ActCalendarEventItem:_setBarBg()
  local bgFullName = string.format(LoadPath.ActCalendar, self.data.calendarColor)
  self.imgTimeBarIcon:LoadSpriteAsync(bgFullName)
end

function ActCalendarEventItem:_setNameSize()
  local days
  if DataCenter.ActCalendarManager:IsLaterWeekEnd(self.data:GetEnd()) then
    days = DataCenter.ActCalendarManager:GetToWeekEndDays(self.data:GetBegin())
  elseif DataCenter.ActCalendarManager:IsBeforeWeekBegin(self.data:GetBegin()) then
    days = DataCenter.ActCalendarManager:GetDurationDays(DataCenter.ActCalendarManager:GetWeekBegin(), self.data:GetEnd())
  else
    days = self.data:GetDurationDays()
  end
  local nameWidth = 0
  if days and 1 < days then
    nameWidth = NAME_ORIGIN_WIDTH + NAME_DELTA_WIDTH * (days - 2)
  end
  self.compNameMask:SetActive(0 < nameWidth)
  if 0 < nameWidth then
    local sizeDelta = self.compNameMask:GetSizeDelta()
    sizeDelta.x = nameWidth
    self.compNameMask:SetSizeDelta(sizeDelta)
    self.textActName:SetSizeDelta(sizeDelta)
  end
  self.textActName:SetLocalText(self.data.name)
  local rawWidth = self.textActName:GetWidth()
  if nameWidth < rawWidth and 0 < nameWidth then
    local sizeDelta = self.textActName:GetSizeDelta()
    sizeDelta.x = rawWidth
    self.textActName:SetSizeDelta(sizeDelta)
    if self.txtTweenSeq then
      self.txtTweenSeq:Kill()
    end
    self.txtTweenSeq = UIUtil.SetTMPHorseRaceLamp(self.textActName, nameWidth, QUEST_ENTRY_ROLLING_DELAY, QUEST_ENTRY_ROLLING_SPD, QUEST_ENTRY_ROLLING_HOLD, self.textActName.transform)
  end
end

function ActCalendarEventItem:_setName()
  self.textActName:SetLocalText(self.data.name)
end

function ActCalendarEventItem:_setIcon()
  local iconFullName = string.format(LoadPath.ActCalendar, self.data.calendarIcon)
  self.imgIcon:LoadSpriteAsync(iconFullName)
end

function ActCalendarEventItem:_setNewFlag()
  if self.data.isNew and not DataCenter.ActCalendarManager:GetLocalNewFlagRecord(self.data.aid) then
    if self.delayShowNewFlag then
      self.delayShowNewFlag:Stop()
    end
    self.delayShowNewFlag = TimerManager:GetInstance():DelayInvoke(function()
      self.newFlagAni:SetActive(true)
      self.newFlagAni:Play("show")
    end, DELAY_SHOW_NEW)
  end
end

function ActCalendarEventItem:_refreshRedDot()
  self.compRedDotFlag:SetActive(false)
  if not self.data.isNew or DataCenter.ActCalendarManager:GetLocalNewFlagRecord(self.data.aid) then
    local actBeginZeroTimestamp = UITimeManager:GetInstance():GetTodayZeroServerTime(self.data:GetBegin() * 0.001)
    actBeginZeroTimestamp = math.floor(actBeginZeroTimestamp * 1000 + 0.5)
    local nowZeroTimestamp = UITimeManager:GetInstance():GetTodayZero()
    if actBeginZeroTimestamp <= nowZeroTimestamp and not DataCenter.ActCalendarManager:GetLocalRedDotRecord(self.data.aid) then
      self.compRedDotFlag:SetActive(true)
    end
  end
end

function ActCalendarEventItem:_getDelayTime()
  local sortGroup = DataCenter.ActCalendarManager:GetGroupDataSortList()
  if not sortGroup then
    return
  end
  
  local function __getDataSortIndex()
    local index = 0
    for i, groupData in ipairs(sortGroup) do
      if groupData and groupData.list then
        for j, data in ipairs(groupData.list) do
          if self.data.aid == data.aid then
            return index
          end
          index = index + 1
        end
      end
    end
    return index
  end
  
  local delayTime = DELAY_SHOW_DElTA + __getDataSortIndex() * DELAY_SHOW_DElTA
  return delayTime
end

function ActCalendarEventItem:OnBtnTimeBarClick()
  self:_openTips()
  self:_changeFlagStatus()
end

function ActCalendarEventItem:_changeFlagStatus()
  self.newFlagAni:SetActive(false)
  self.compRedDotFlag:SetActive(false)
  DataCenter.ActCalendarManager:SetLocalNewFlagRecord(self.data.aid)
  local curTimeStamp = UITimeManager:GetInstance():GetServerTime()
  if curTimeStamp >= self.data:GetBegin() then
    DataCenter.ActCalendarManager:SetLocalRedDotRecord(self.data.aid)
  end
end

function ActCalendarEventItem:_openTips()
  Logger.Log("[ ActCalendar ]   \230\180\187\229\138\168id:" .. self.data.aid)
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.alignObject = self.imgIcon
  param.width = 580
  if CommonUtil.IsArabicAutoMirrorOpen() then
    param.xPosFix = -50
  else
    param.xPosFix = 50
  end
  param.yPosFix = -50
  param.customData = self.data
  param.xPadding = 40
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActCalendarBubbleTips, {anim = true}, param)
end

return ActCalendarEventItem
