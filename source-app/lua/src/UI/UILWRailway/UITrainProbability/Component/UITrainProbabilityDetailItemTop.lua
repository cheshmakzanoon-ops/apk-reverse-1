local UITrainProbabilityDetailItemTop = BaseClass("UITrainProbabilityDetailItemTop", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_text_path = "topContent/titleText"
local rate_text_path = "topContent/rateText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.rate_text = self:AddComponent(UIText, rate_text_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
end

local function ComponentDestroy(self)
  self.rate_text = nil
  self.title_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function UpdateItem(self, data)
  self.title_text:SetText(data.name)
  if not string.IsNullOrEmpty(data.rate) then
    local rateNum = tonumber(data.rate) or 0
    if 100 < rateNum then
      rateNum = 100
    end
    self.rate_text:SetText(rateNum .. "%")
  else
    self.rate_text:SetText("")
  end
end

UITrainProbabilityDetailItemTop.OnCreate = OnCreate
UITrainProbabilityDetailItemTop.OnDestroy = OnDestroy
UITrainProbabilityDetailItemTop.ComponentDefine = ComponentDefine
UITrainProbabilityDetailItemTop.ComponentDestroy = ComponentDestroy
UITrainProbabilityDetailItemTop.DataDefine = DataDefine
UITrainProbabilityDetailItemTop.DataDestroy = DataDestroy
UITrainProbabilityDetailItemTop.UpdateItem = UpdateItem
return UITrainProbabilityDetailItemTop
