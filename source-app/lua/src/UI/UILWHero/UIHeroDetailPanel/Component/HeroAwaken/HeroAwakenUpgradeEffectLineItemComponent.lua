local base = require("UI/UILWHero/UIHeroDetailPanel/Component/UIHeroPreviewLine")
local HeroAwakenUpgradeEffectLineItemComponent = BaseClass("HeroAwakenUpgradeEffectLineItemComponent", base)
local Localization = CS.GameEntry.Localization

function HeroAwakenUpgradeEffectLineItemComponent:ComponentDefine()
  base.ComponentDefine(self)
  self.compEffUiHeroawakenSaoguang = self:AddComponent(UIVfx, "Eff_ui_heroawaken_saoguang")
end

function HeroAwakenUpgradeEffectLineItemComponent:ComponentDestroy()
  self.compEffUiHeroawakenSaoguang = nil
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  base.ComponentDestroy(self)
end

function HeroAwakenUpgradeEffectLineItemComponent:PlayVfx(delay)
  local function Play()
    if self.compEffUiHeroawakenSaoguang then
      if CommonUtil.IsArabic() then
        self.compEffUiHeroawakenSaoguang:PlayByOnce(VfxAssets.HeroAwakenLineEffectArabic)
      else
        self.compEffUiHeroawakenSaoguang:PlayByOnce(VfxAssets.HeroAwakenLineEffect)
      end
    end
  end
  
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if not delay or delay <= 0 then
    Play()
  else
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      Play()
    end, delay)
  end
end

function HeroAwakenUpgradeEffectLineItemComponent:ReInit(data, index)
  self:SetName(data.title or "")
  if data.nextValue and data.nextValue ~= data.curValue then
    self:SetData(HeroUtils.GetFormattedPropertyValue(data.effectId, data.curValue), HeroUtils.GetFormattedPropertyValue(data.effectId, data.nextValue), index + 1)
    self.valueText:SetAlignment(CS.TMPro.TextAlignmentOptions.MidlineRight)
  else
    self:SetData(HeroUtils.GetFormattedPropertyValue(data.effectId, data.curValue), nil, index + 1)
    self.valueText:SetAlignment(CS.TMPro.TextAlignmentOptions.Midline)
  end
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

return HeroAwakenUpgradeEffectLineItemComponent
