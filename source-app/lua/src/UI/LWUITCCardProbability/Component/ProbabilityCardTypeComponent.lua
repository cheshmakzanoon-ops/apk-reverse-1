local ProbabilityCardTypeComponent = BaseClass("ProbabilityCardTypeComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_text_path = "titleText"

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
  self.cardTypeText = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
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

function ProbabilityCardTypeComponent:ReInit(data)
  if not data then
    return
  end
  self.cardTypeText:SetText(data.data)
  local preferredValues = self.cardTypeText.unity_tmpro:GetPreferredValues()
  self:SetSizeDeltaY(preferredValues.y)
end

ProbabilityCardTypeComponent.OnCreate = OnCreate
ProbabilityCardTypeComponent.OnDestroy = OnDestroy
ProbabilityCardTypeComponent.OnEnable = OnEnable
ProbabilityCardTypeComponent.OnDisable = OnDisable
ProbabilityCardTypeComponent.ComponentDefine = ComponentDefine
ProbabilityCardTypeComponent.ComponentDestroy = ComponentDestroy
ProbabilityCardTypeComponent.DataDefine = DataDefine
ProbabilityCardTypeComponent.DataDestroy = DataDestroy
ProbabilityCardTypeComponent.OnAddListener = OnAddListener
ProbabilityCardTypeComponent.OnRemoveListener = OnRemoveListener
return ProbabilityCardTypeComponent
