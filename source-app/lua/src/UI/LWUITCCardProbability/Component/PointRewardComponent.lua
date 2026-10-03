local PointRewardComponent = BaseClass("PointRewardComponent", UIBaseContainer)
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
  self.pointText = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
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

function PointRewardComponent:ReInit(data)
  if not data then
    return
  end
  self.pointText:SetText(data.data)
  local preferredValues = self.pointText.unity_tmpro:GetPreferredValues()
  self:SetSizeDeltaY(preferredValues.y)
end

PointRewardComponent.OnCreate = OnCreate
PointRewardComponent.OnDestroy = OnDestroy
PointRewardComponent.OnEnable = OnEnable
PointRewardComponent.OnDisable = OnDisable
PointRewardComponent.ComponentDefine = ComponentDefine
PointRewardComponent.ComponentDestroy = ComponentDestroy
PointRewardComponent.DataDefine = DataDefine
PointRewardComponent.DataDestroy = DataDestroy
PointRewardComponent.OnAddListener = OnAddListener
PointRewardComponent.OnRemoveListener = OnRemoveListener
return PointRewardComponent
