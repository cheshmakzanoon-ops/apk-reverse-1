local UICampEffectOverviewCanFoldItemContent = BaseClass("UICampEffectOverviewCanFoldItemContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")

function UICampEffectOverviewCanFoldItemContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICampEffectOverviewCanFoldItemContent:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICampEffectOverviewCanFoldItemContent:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.name = self:AddComponent(UILWScienceDetailDesc, "Content/name")
  self.value = self:AddComponent(UIText, "Content/value")
end

function UICampEffectOverviewCanFoldItemContent:ComponentDestroy()
  self.root = nil
  self.name = nil
  self.value = nil
end

function UICampEffectOverviewCanFoldItemContent:Refresh(effectId, effectValue, funEffect)
  self.effectId = effectId
  local effectConfig = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(tonumber(effectId))
  self.name:SetText(Localization:GetString(effectConfig.name))
  if funEffect then
    self.value:SetText(effectValue)
  else
    local _, text = WorkerUtil.GetEffectText(effectId, tonumber(effectValue), true)
    self.value:SetText(text)
  end
end

return UICampEffectOverviewCanFoldItemContent
