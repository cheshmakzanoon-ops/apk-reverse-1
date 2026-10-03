local base = UIBaseContainer
local UIGhostreconFormationTopPanel = BaseClass("UIGhostreconFormationTopPanel", base)
local topText_path = "TopText"
local timeText_path = "Time/TimeText"

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
  self.topText = self:AddComponent(UIText, topText_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
end

local function ComponentDestroy(self)
  self.topText = nil
  self.timeText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, titleStr, time)
  self.topText:SetText(titleStr)
  self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
end

UIGhostreconFormationTopPanel.OnCreate = OnCreate
UIGhostreconFormationTopPanel.OnDestroy = OnDestroy
UIGhostreconFormationTopPanel.OnEnable = OnEnable
UIGhostreconFormationTopPanel.OnDisable = OnDisable
UIGhostreconFormationTopPanel.ComponentDefine = ComponentDefine
UIGhostreconFormationTopPanel.ComponentDestroy = ComponentDestroy
UIGhostreconFormationTopPanel.DataDefine = DataDefine
UIGhostreconFormationTopPanel.DataDestroy = DataDestroy
UIGhostreconFormationTopPanel.SetData = SetData
return UIGhostreconFormationTopPanel
