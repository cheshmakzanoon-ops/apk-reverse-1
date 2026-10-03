local UITrainProbabilityDetailItemBottom = BaseClass("UITrainProbabilityDetailItemBottom", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function UpdateItem(self)
end

UITrainProbabilityDetailItemBottom.OnCreate = OnCreate
UITrainProbabilityDetailItemBottom.OnDestroy = OnDestroy
UITrainProbabilityDetailItemBottom.ComponentDefine = ComponentDefine
UITrainProbabilityDetailItemBottom.ComponentDestroy = ComponentDestroy
UITrainProbabilityDetailItemBottom.DataDefine = DataDefine
UITrainProbabilityDetailItemBottom.DataDestroy = DataDestroy
UITrainProbabilityDetailItemBottom.UpdateItem = UpdateItem
return UITrainProbabilityDetailItemBottom
