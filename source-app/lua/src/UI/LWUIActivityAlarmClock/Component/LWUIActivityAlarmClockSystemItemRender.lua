local base = UIBaseContainer
local LWUIActivityAlarmClockSystemItemRender = BaseClass("LWUIActivityAlarmClockSystemItemRender", base)

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
  self.tipText = self:AddComponent(UIText, "Content/TipText")
end

local function ComponentDestroy(self)
  self.tipText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function InitData(self, systemType)
  self.systemType = systemType
  if self.systemType == ActivityAlarmClockSystemType.DayFree then
    self.tipText:SetLocalText("activity_clock_empty")
  end
end

LWUIActivityAlarmClockSystemItemRender.OnCreate = OnCreate
LWUIActivityAlarmClockSystemItemRender.OnDestroy = OnDestroy
LWUIActivityAlarmClockSystemItemRender.OnEnable = OnEnable
LWUIActivityAlarmClockSystemItemRender.OnDisable = OnDisable
LWUIActivityAlarmClockSystemItemRender.ComponentDefine = ComponentDefine
LWUIActivityAlarmClockSystemItemRender.ComponentDestroy = ComponentDestroy
LWUIActivityAlarmClockSystemItemRender.DataDefine = DataDefine
LWUIActivityAlarmClockSystemItemRender.DataDestroy = DataDestroy
LWUIActivityAlarmClockSystemItemRender.OnAddListener = OnAddListener
LWUIActivityAlarmClockSystemItemRender.OnRemoveListener = OnRemoveListener
LWUIActivityAlarmClockSystemItemRender.InitData = InitData
return LWUIActivityAlarmClockSystemItemRender
