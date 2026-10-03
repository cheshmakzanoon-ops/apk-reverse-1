local LWEffectOverviewItemTitle = BaseClass("LWEffectOverviewItemTitle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWEffectOverviewItemTitle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWEffectOverviewItemTitle:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWEffectOverviewItemTitle:ComponentDefine()
  self.name = self:AddComponent(UIText, "Content/name")
  self.value = self:AddComponent(UIText, "Content/value")
end

function LWEffectOverviewItemTitle:ComponentDestroy()
  self.name = nil
  self.value = nil
end

function LWEffectOverviewItemTitle:DataDefine()
end

function LWEffectOverviewItemTitle:DataDestroy()
end

function LWEffectOverviewItemTitle:Refresh(data)
  self.data = data
  local template = DataCenter.LWEffectOverviewManager:GetTemplate(self.data.id)
  if template then
    if table.count(template.effectSourceList) then
      local effectIdList = template:GetEffectIdListByEffectSourceType(template.effectSourceList[1])
      if table.count(effectIdList) > 0 then
        local totalValue = self.data:GetAllTotalValue()
        local describe, text = WorkerUtil.GetEffectText(effectIdList[1], totalValue, true)
        self.value:SetText(text)
      end
    end
    self.name:SetLocalText(template.name)
  end
end

return LWEffectOverviewItemTitle
