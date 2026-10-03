local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeVipLogic = BaseClass("LWEffectSourceTypeVipLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeVipLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeVipLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeVipLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.Vip)
  local curVipTemplate = DataCenter.VIPManager:GetCurVipData()
  local isVipActive = false
  local vipInfo = DataCenter.VIPManager:GetVipData()
  if vipInfo and vipInfo:IsVIPActive() then
    isVipActive = true
  end
  if isVipActive and curVipTemplate ~= nil then
    local effectCount = table.count(curVipTemplate.effect)
    for i = 1, effectCount do
      local effectId = tonumber(curVipTemplate.effect[i].id)
      local effectValue = curVipTemplate.effect[i].value
      DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Vip, effectId, effectValue)
    end
  end
end

return LWEffectSourceTypeVipLogic
