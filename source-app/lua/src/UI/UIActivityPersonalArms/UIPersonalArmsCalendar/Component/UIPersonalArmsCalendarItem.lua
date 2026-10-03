local UIPersonalArmsCalendarItem = BaseClass("UIPersonalArmsCalendarItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIBaseContainer, "bg")
  self.weekText = self:AddComponent(UIText, "weekText")
  self.timeText = self:AddComponent(UIText, "timeText")
  self.nameText = self:AddComponent(UIText, "nameText")
end

local function ComponentDestroy(self)
  self.bg = nil
  self.weekText = nil
  self.timeText = nil
  self.nameText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, itemData, isServer)
  self:SetActive(true)
  self.bg:SetActive(itemData.isCur)
  if itemData.isShowWeek then
    self.weekText:SetLocalText(2000379, itemData.dayNum)
  else
    self.weekText:SetText("")
  end
  self.startTime = itemData.startTime
  self:RefreshTimeType(isServer)
  self.nameText:SetLocalText(itemData.name)
end

local function RefreshTimeType(self, isServer)
  if self.startTime then
    if isServer then
      local timeTxt = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(self.startTime)
      self.timeText:SetText(timeTxt)
    else
      local timeTxt = UITimeManager:GetInstance():TimeStampToTimeForLocalSimple(self.startTime)
      self.timeText:SetText(timeTxt)
    end
  end
end

UIPersonalArmsCalendarItem.OnCreate = OnCreate
UIPersonalArmsCalendarItem.OnDestroy = OnDestroy
UIPersonalArmsCalendarItem.ComponentDefine = ComponentDefine
UIPersonalArmsCalendarItem.ComponentDestroy = ComponentDestroy
UIPersonalArmsCalendarItem.DataDefine = DataDefine
UIPersonalArmsCalendarItem.DataDestroy = DataDestroy
UIPersonalArmsCalendarItem.SetData = SetData
UIPersonalArmsCalendarItem.RefreshTimeType = RefreshTimeType
return UIPersonalArmsCalendarItem
