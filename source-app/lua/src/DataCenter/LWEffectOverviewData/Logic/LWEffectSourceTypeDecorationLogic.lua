local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeDecorationLogic = BaseClass("LWEffectSourceTypeDecorationLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeDecorationLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeDecorationLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeDecorationLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.Decoration)
  local allDecoration = DataCenter.DecorationDataManager:GetAllActiveDecoration()
  for k, decorationId in ipairs(allDecoration) do
    local data = DataCenter.DecorationDataManager:GetSkinDataById(decorationId)
    if data then
      local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
      if template and (template.type == DecorationType.DecorationType_Main_City or template.type == DecorationType.DecorationType_Head_Frame or template.type == DecorationType.DecorationType_Main_Effect) then
        if data:IsWear() then
          for i, v in pairs(template.wearEffect) do
            local effectId = v.key
            local effectValue = v.value
            DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Decoration, effectId, effectValue)
          end
        end
        for i, v in pairs(template.ownEffect) do
          local effectId = v.key
          local effectValue = v.value
          DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Decoration, effectId, effectValue)
        end
      end
    end
  end
end

return LWEffectSourceTypeDecorationLogic
