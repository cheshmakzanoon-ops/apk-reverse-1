local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeDroneLogic = BaseClass("LWEffectSourceTypeDroneLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeDroneLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeDroneLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeDroneLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.Drone)
  local effects = DataCenter.CommonEquipDataManager:CollectEquipsEffectByOwnerUid(CommonEquipType.SquadEquip, BuildingTypes.LW_BUILD_TACTICAL_CENTER)
  for k, v in pairs(effects) do
    local effectId = k
    local effectValue = v
    DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Drone, effectId, effectValue)
  end
  local ownSkinIds = DataCenter.DecorationDataManager:GetOwnTacticalWeaponSkin()
  for i = 1, table.count(ownSkinIds) do
    local skinId = ownSkinIds[i]
    local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
    if template ~= nil then
      for k, v in pairs(template.ownEffect) do
        local effectId = v.key
        local effectValue = v.value
        DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Drone, effectId, effectValue)
      end
    end
    local data = DataCenter.DecorationDataManager:GetSkinDataById(skinId)
    if data ~= nil and data:IsWear() then
      for _, v in pairs(template.wearEffect) do
        local effectId = v.key
        local effectValue = v.value
        DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Drone, effectId, effectValue)
      end
    end
  end
end

return LWEffectSourceTypeDroneLogic
