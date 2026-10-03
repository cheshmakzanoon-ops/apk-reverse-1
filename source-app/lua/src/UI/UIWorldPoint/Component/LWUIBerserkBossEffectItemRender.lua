local base = UIBaseContainer
local LWUIBerserkBossEffectItemRender = BaseClass("LWUIBerserkBossEffectItemRender", base)
local bg_path = "Bg"
local desText_path = "HorLayout/DesText"
local valueText_path = "HorLayout/ValueText"

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
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.desText = self:AddComponent(UIText, desText_path)
  self.valueText = self:AddComponent(UIText, valueText_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.desText = nil
  self.valueText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function InitData(self, index, data)
  self.bg:SetActive(index % 2 ~= 0)
  local describe, text = WorkerUtil.GetEffectText(data.effectId, data.effectValue, true)
  self.desText:SetText(describe)
  self.valueText:SetText(text)
end

LWUIBerserkBossEffectItemRender.OnCreate = OnCreate
LWUIBerserkBossEffectItemRender.OnDestroy = OnDestroy
LWUIBerserkBossEffectItemRender.OnEnable = OnEnable
LWUIBerserkBossEffectItemRender.OnDisable = OnDisable
LWUIBerserkBossEffectItemRender.ComponentDefine = ComponentDefine
LWUIBerserkBossEffectItemRender.ComponentDestroy = ComponentDestroy
LWUIBerserkBossEffectItemRender.DataDefine = DataDefine
LWUIBerserkBossEffectItemRender.DataDestroy = DataDestroy
LWUIBerserkBossEffectItemRender.InitData = InitData
return LWUIBerserkBossEffectItemRender
