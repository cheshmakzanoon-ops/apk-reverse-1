local ProbabilityNoticeItemTopComponent = BaseClass("ProbabilityNoticeItemTopComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_text_path = "topContent/titleText"
local rate_text_path = "topContent/rateText"

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
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.probText = self:AddComponent(UIText, rate_text_path)
end

local function ComponentDestroy(self)
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

function ProbabilityNoticeItemTopComponent:ReInit(data)
  if not data then
    return
  end
  self.titleText:SetText(data.data)
  self.probText:SetText(string.percentage(data.prob, 1, 2))
end

ProbabilityNoticeItemTopComponent.OnCreate = OnCreate
ProbabilityNoticeItemTopComponent.OnDestroy = OnDestroy
ProbabilityNoticeItemTopComponent.OnEnable = OnEnable
ProbabilityNoticeItemTopComponent.OnDisable = OnDisable
ProbabilityNoticeItemTopComponent.ComponentDefine = ComponentDefine
ProbabilityNoticeItemTopComponent.ComponentDestroy = ComponentDestroy
ProbabilityNoticeItemTopComponent.DataDefine = DataDefine
ProbabilityNoticeItemTopComponent.DataDestroy = DataDestroy
ProbabilityNoticeItemTopComponent.OnAddListener = OnAddListener
ProbabilityNoticeItemTopComponent.OnRemoveListener = OnRemoveListener
return ProbabilityNoticeItemTopComponent
