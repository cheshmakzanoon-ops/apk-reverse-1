local UITrainProbabilityDetailItemMiddle = BaseClass("UITrainProbabilityDetailItemMiddle", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.content = self:AddComponent(UIBaseContainer, "Content")
end

local function ComponentDestroy(self)
  self.content = nil
end

local function UpdateItem(self, data)
end

UITrainProbabilityDetailItemMiddle.OnCreate = OnCreate
UITrainProbabilityDetailItemMiddle.OnDestroy = OnDestroy
UITrainProbabilityDetailItemMiddle.ComponentDefine = ComponentDefine
UITrainProbabilityDetailItemMiddle.ComponentDestroy = ComponentDestroy
UITrainProbabilityDetailItemMiddle.UpdateItem = UpdateItem
return UITrainProbabilityDetailItemMiddle
