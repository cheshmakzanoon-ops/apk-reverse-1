local LWEffectOverviewManager = BaseClass("LWEffectOverviewManager")
local LWEffectOverviewTemplate = require("DataCenter.LWEffectOverviewData.LWEffectOverviewTemplate")
local LWEffectOverviewInfo = require("DataCenter.LWEffectOverviewData.LWEffectOverviewInfo")
local GovernmentTemplate = require("DataCenter.GovernmentManager.GovernmentTemplate")
local LWEffectSourceTypeCampTechLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeCampTechLogic")
local LWEffectSourceTypeAllianceTechLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeAllianceTechLogic")
local LWEffectSourceTypeBuildingLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBuildingLogic")
local LWEffectSourceTypeDroneLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeDroneLogic")
local LWEffectSourceTypeHonorWallLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeHonorWallLogic")
local LWEffectSourceTypeOccupiedCityLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeOccupiedCityLogic")
local LWEffectSourceTypeProfessionSpecializationLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeProfessionSpecializationLogic")
local LWEffectSourceTypeSeasonBuildingLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeSeasonBuildingLogic")
local LWEffectSourceTypeSuperMonthCardLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeSuperMonthCardLogic")
local LWEffectSourceTypeSurvivorLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeSurvivorLogic")
local LWEffectSourceTypeTechLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeTechLogic")
local LWEffectSourceTypeVipLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeVipLogic")
local LWEffectSourceTypeDecorationLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeDecorationLogic")
local LWEffectSourceTypeOfficesLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeOfficesLogic")
local LWEffectSourceTypeEquipLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeEquipLogic")
local LWEffectSourceTypeHeroSkillLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeHeroSkillLogic")
local LWEffectSourceTypeHeroUniqueWeaponLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeHeroUniqueWeaponLogic")
local LWEffectSourceTypeDominatorRankLevelLogic = require("DataCenter/LWEffectOverviewData/Logic/LWEffectSourceTypeDominatorRankLevelLogic")
local LWEffectSourceTypeDominatorTrainLevelLogic = require("DataCenter/LWEffectOverviewData/Logic/LWEffectSourceTypeDominatorTrainLevelLogic")
local LWEffectSourceTypeTacticalCardLogic = require("DataCenter/LWEffectOverviewData/Logic/LWEffectSourceTypeTacticalCardLogic")
local LWEffectSourceTypeServerLogic = require("DataCenter/LWEffectOverviewData/Logic/LWEffectSourceTypeServerLogic")

function LWEffectOverviewManager:__init()
  self.showData = nil
  self.templateDic = {}
  self.effectSourceType2ConfigIds = nil
  self.effectSourceType2InfoDict = nil
  self.effectSourceTypeLogicList = nil
  self.isVipActive = nil
  self:AddListener()
end

function LWEffectOverviewManager:__delete()
  self:RemoveListener()
  self.showData = nil
  self.templateDic = nil
  self.effectSourceType2ConfigIds = nil
  self.effectSourceType2InfoDict = nil
  self.effectSourceTypeLogicList = nil
  self.isVipActive = nil
end

function LWEffectOverviewManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA, self.SetDataDirtyAtBuildUpdate)
  EventManager:GetInstance():AddListener(EventId.BuildLevelUp, self.SetBuildingDirty)
  EventManager:GetInstance():AddListener(EventId.BuildStateChange, self.SetBuildingDirty)
  EventManager:GetInstance():AddListener(EventId.UPDATE_SCIENCE_DATA, self.SetTechDirty)
  EventManager:GetInstance():AddListener(EventId.AllianceTechnology, self.SetAllianceTechDirty)
  EventManager:GetInstance():AddListener(EventId.PutonCommonEquip, self.SetDroneDirty)
  EventManager:GetInstance():AddListener(EventId.PutoffCommonEquip, self.SetDroneDirty)
  EventManager:GetInstance():AddListener(EventId.CommonEquipDataChanged, self.SetDroneDirty)
  EventManager:GetInstance():AddListener(EventId.HeroHonorLevelUpgrade, self.SetHonorWallDirty)
  EventManager:GetInstance():AddListener(EventId.HeroLvUpSuccess, self.SetHonorWallDirty)
  EventManager:GetInstance():AddListener(EventId.HeroFragmentItemUpdate, self.SetHonorWallDirty)
  EventManager:GetInstance():AddListener(EventId.MyAlCityListChanged, self.SetOccupiedCityDirty)
  EventManager:GetInstance():AddListener(EventId.LWMasterySkillUp, self.SetProfessionSpecializationDirty)
  EventManager:GetInstance():AddListener(EventId.MasteryUseSkill, self.SetProfessionSpecializationDirty)
  EventManager:GetInstance():AddListener(EventId.LWUseSkill, self.SetTitleDirty)
  EventManager:GetInstance():AddListener(EventId.MonthCardInfoUpdated, self.SetSuperMonthCardDirty)
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.SetSuperMonthCardDirty)
  EventManager:GetInstance():AddListener(EventId.WorkerInfoUpdate, self.SetSurvivorDirty)
  EventManager:GetInstance():AddListener(EventId.BuildingHeroDispatching, self.SetSurvivorDirty)
  EventManager:GetInstance():AddListener(EventId.VipDataRefresh, self.SetVipDirty)
  EventManager:GetInstance():AddListener(EventId.UserSkinUpdate, self.SetDecorationDirty)
  EventManager:GetInstance():AddListener(EventId.UserCitySkinUpdate, self.SetDecorationDirty)
  EventManager:GetInstance():AddListener(EventId.KingdomPositionInfoUpdate, self.SetOfficesDirty)
  EventManager:GetInstance():AddListener(EventId.EquipDataUpdate, self.SetEquipDirty)
  EventManager:GetInstance():AddListener(EventId.HeroEquipInstall, self.SetEquipDirty)
  EventManager:GetInstance():AddListener(EventId.HeroEquipUninstall, self.SetEquipDirty)
  EventManager:GetInstance():AddListener(EventId.HeroEquipUpgrade, self.SetEquipDirty)
  EventManager:GetInstance():AddListener(EventId.HeroSkillUnlockBack, self.SetHeroSkillDirty)
  EventManager:GetInstance():AddListener(EventId.HeroWeaponStrengthenBack, self.SetHeroUniqueWeaponDirty)
  EventManager:GetInstance():AddListener(EventId.HeroWeaponResetBack, self.SetHeroUniqueWeaponDirty)
  EventManager:GetInstance():AddListener(EventId.HeroUniqueWeaponUpgrade, self.SetHeroUniqueWeaponDirty)
  EventManager:GetInstance():AddListener(EventId.EffectOverviewShowHeroChange, self.SetHeroDirty)
  EventManager:GetInstance():AddListener(EventId.DominatorRankUpgradeSuccess, self.SetDominatorRankLevelDirty)
  EventManager:GetInstance():AddListener(EventId.DominatorTrainUpgradeSuccess, self.SetDominatorTrainLevelDirty)
  EventManager:GetInstance():AddListener(EventId.TacticalCardDataChanged, self.SetTacticalCardDirty)
  EventManager:GetInstance():AddListener(EventId.ServerStatusChanged, self.SetServerDirty)
  EventManager:GetInstance():AddListener(EventId.RefreshCampScienceEffects, self.SetCampScienceDirty)
end

function LWEffectOverviewManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.SetDataDirtyAtBuildUpdate)
  EventManager:GetInstance():RemoveListener(EventId.BuildLevelUp, self.SetBuildingDirty)
  EventManager:GetInstance():RemoveListener(EventId.BuildStateChange, self.SetBuildingDirty)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_SCIENCE_DATA, self.SetTechDirty)
  EventManager:GetInstance():RemoveListener(EventId.AllianceTechnology, self.SetAllianceTechDirty)
  EventManager:GetInstance():RemoveListener(EventId.PutonCommonEquip, self.SetDroneDirty)
  EventManager:GetInstance():RemoveListener(EventId.PutoffCommonEquip, self.SetDroneDirty)
  EventManager:GetInstance():RemoveListener(EventId.CommonEquipDataChanged, self.SetDroneDirty)
  EventManager:GetInstance():RemoveListener(EventId.HeroHonorLevelUpgrade, self.SetHonorWallDirty)
  EventManager:GetInstance():RemoveListener(EventId.HeroLvUpSuccess, self.SetHonorWallDirty)
  EventManager:GetInstance():RemoveListener(EventId.HeroFragmentItemUpdate, self.SetHonorWallDirty)
  EventManager:GetInstance():RemoveListener(EventId.MyAlCityListChanged, self.SetOccupiedCityDirty)
  EventManager:GetInstance():RemoveListener(EventId.LWMasterySkillUp, self.SetProfessionSpecializationDirty)
  EventManager:GetInstance():RemoveListener(EventId.MasteryUseSkill, self.SetProfessionSpecializationDirty)
  EventManager:GetInstance():RemoveListener(EventId.LWUseSkill, self.SetTitleDirty)
  EventManager:GetInstance():RemoveListener(EventId.MonthCardInfoUpdated, self.SetSuperMonthCardDirty)
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.SetSuperMonthCardDirty)
  EventManager:GetInstance():RemoveListener(EventId.WorkerInfoUpdate, self.SetSurvivorDirty)
  EventManager:GetInstance():RemoveListener(EventId.BuildingHeroDispatching, self.SetSurvivorDirty)
  EventManager:GetInstance():RemoveListener(EventId.VipDataRefresh, self.SetVipDirty)
  EventManager:GetInstance():RemoveListener(EventId.UserSkinUpdate, self.SetDecorationDirty)
  EventManager:GetInstance():RemoveListener(EventId.UserCitySkinUpdate, self.SetDecorationDirty)
  EventManager:GetInstance():RemoveListener(EventId.KingdomPositionInfoUpdate, self.SetOfficesDirty)
  EventManager:GetInstance():RemoveListener(EventId.EquipDataUpdate, self.SetEquipDirty)
  EventManager:GetInstance():RemoveListener(EventId.HeroEquipInstall, self.SetEquipDirty)
  EventManager:GetInstance():RemoveListener(EventId.HeroEquipUninstall, self.SetEquipDirty)
  EventManager:GetInstance():RemoveListener(EventId.HeroEquipUpgrade, self.SetEquipDirty)
  EventManager:GetInstance():RemoveListener(EventId.HeroSkillUnlockBack, self.SetHeroSkillDirty)
  EventManager:GetInstance():RemoveListener(EventId.HeroWeaponStrengthenBack, self.SetHeroUniqueWeaponDirty)
  EventManager:GetInstance():RemoveListener(EventId.HeroWeaponResetBack, self.SetHeroUniqueWeaponDirty)
  EventManager:GetInstance():RemoveListener(EventId.HeroUniqueWeaponUpgrade, self.SetHeroUniqueWeaponDirty)
  EventManager:GetInstance():RemoveListener(EventId.EffectOverviewShowHeroChange, self.SetHeroDirty)
  EventManager:GetInstance():RemoveListener(EventId.DominatorRankUpgradeSuccess, self.SetDominatorRankLevelDirty)
  EventManager:GetInstance():RemoveListener(EventId.DominatorTrainUpgradeSuccess, self.SetDominatorTrainLevelDirty)
  EventManager:GetInstance():RemoveListener(EventId.TacticalCardDataChanged, self.SetTacticalCardDirty)
  EventManager:GetInstance():RemoveListener(EventId.ServerStatusChanged, self.SetServerDirty)
  EventManager:GetInstance():RemoveListener(EventId.RefreshCampScienceEffects, self.SetCampScienceDirty)
end

function LWEffectOverviewManager:GetTemplate(id)
  if self.templateDic[id] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_Effect_Overview, id)
    if oneTemplate ~= nil then
      local item = LWEffectOverviewTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.templateDic[item.id] = item
      end
    end
  end
  return self.templateDic[id]
end

function LWEffectOverviewManager:CheckCanShow()
  return true
end

function LWEffectOverviewManager:GetShowData()
  self:RefreshShowData()
  return self.showData
end

function LWEffectOverviewManager:RefreshShowData()
  if self.showData == nil then
    self:InitShowData()
  end
  if self.effectSourceTypeLogicList == nil then
    self:InitEffectSourceTypeLogicData()
  end
  local isVipActive = false
  local vipInfo = DataCenter.VIPManager:GetVipData()
  if vipInfo and vipInfo:IsVIPActive() then
    isVipActive = true
  end
  if self.isVipActive ~= isVipActive then
    self.isVipActive = isVipActive
    self:SetVipDirty()
  end
  for i, v in pairs(self.effectSourceTypeLogicList) do
    self.effectSourceTypeLogicList[i]:RefreshData()
  end
end

function LWEffectOverviewManager:SetHeroSkillDirty()
end

function LWEffectOverviewManager:SetAllianceTechDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.AllianceTech] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.AllianceTech]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetTechDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Tech] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Tech]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetBuildingDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Building] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Building]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetDataDirtyAtBuildUpdate()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList then
    if self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Building] then
      self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Building]:SetDirty()
    end
    if self.effectSourceTypeLogicList[EffectOverviewSourcePoint.SeasonBuilding] then
      self.effectSourceTypeLogicList[EffectOverviewSourcePoint.SeasonBuilding]:SetDirty()
    end
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetVipDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Vip] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Vip]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetDroneDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Drone] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Drone]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetHonorWallDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.HonorWall] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.HonorWall]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetOccupiedCityDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.OccupiedCity] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.OccupiedCity]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetProfessionSpecializationDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.ProfessionSpecialization] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.ProfessionSpecialization]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetTitleDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Title] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Title]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetSuperMonthCardDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.SuperMonthCard] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.SuperMonthCard]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetSurvivorDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Survivor] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Survivor]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetDecorationDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList then
    if self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Decoration] then
      self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Decoration]:SetDirty()
    end
    if self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Drone] then
      self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Drone]:SetDirty()
    end
    if self.effectSourceTypeLogicList[EffectOverviewSourcePoint.SeasonBuilding] then
      self.effectSourceTypeLogicList[EffectOverviewSourcePoint.SeasonBuilding]:SetDirty()
    end
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetOfficesDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Offices] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Offices]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetEquipDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Equip] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Equip]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetHeroSkillDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.HeroSkill] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.HeroSkill]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetHeroUniqueWeaponDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.HeroUniqueWeapon] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.HeroUniqueWeapon]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetHeroDirty()
  DataCenter.LWEffectOverviewManager:SetEquipDirty()
  DataCenter.LWEffectOverviewManager:SetHeroSkillDirty()
  DataCenter.LWEffectOverviewManager:SetHeroUniqueWeaponDirty()
end

function LWEffectOverviewManager:SetDominatorRankLevelDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.DominatorRankLevel] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.DominatorRankLevel]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetDominatorTrainLevelDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.DominatorTrainLevel] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.DominatorTrainLevel]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetDominatorDirty()
  DataCenter.LWEffectOverviewManager:SetDominatorRankLevelDirty()
  DataCenter.LWEffectOverviewManager:SetDominatorTrainLevelDirty()
end

function LWEffectOverviewManager:SetTacticalCardDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.TacticalCard] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.TacticalCard]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetServerDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Server] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Server]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:SetCampScienceDirty()
  local self = DataCenter.LWEffectOverviewManager
  if self.effectSourceTypeLogicList and self.effectSourceTypeLogicList[EffectOverviewSourcePoint.CampScience] then
    self.effectSourceTypeLogicList[EffectOverviewSourcePoint.CampScience]:SetDirty()
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewDataDirty)
  end
end

function LWEffectOverviewManager:InitEffectSourceTypeLogicData()
  self.effectSourceTypeLogicList = {}
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Tech] = LWEffectSourceTypeTechLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Drone] = LWEffectSourceTypeDroneLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.HonorWall] = LWEffectSourceTypeHonorWallLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Vip] = LWEffectSourceTypeVipLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Building] = LWEffectSourceTypeBuildingLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.AllianceTech] = LWEffectSourceTypeAllianceTechLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.OccupiedCity] = LWEffectSourceTypeOccupiedCityLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.ProfessionSpecialization] = LWEffectSourceTypeProfessionSpecializationLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.SeasonBuilding] = LWEffectSourceTypeSeasonBuildingLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.SuperMonthCard] = LWEffectSourceTypeSuperMonthCardLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Survivor] = LWEffectSourceTypeSurvivorLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Decoration] = LWEffectSourceTypeDecorationLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Offices] = LWEffectSourceTypeOfficesLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Equip] = LWEffectSourceTypeEquipLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.HeroSkill] = LWEffectSourceTypeHeroSkillLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.HeroUniqueWeapon] = LWEffectSourceTypeHeroUniqueWeaponLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.DominatorRankLevel] = LWEffectSourceTypeDominatorRankLevelLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.DominatorTrainLevel] = LWEffectSourceTypeDominatorTrainLevelLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.TacticalCard] = LWEffectSourceTypeTacticalCardLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.Server] = LWEffectSourceTypeServerLogic.New()
  self.effectSourceTypeLogicList[EffectOverviewSourcePoint.CampScience] = LWEffectSourceTypeCampTechLogic.New()
end

function LWEffectOverviewManager:InitShowData()
  self.showData = {}
  self.effectSourceType2ConfigIds = {}
  self.effectSourceType2InfoDict = {}
  self.templateMapByType = {}
  LocalController:instance():visitTable(TableName.LW_Effect_Overview, function(id, lineData)
    local item = LWEffectOverviewInfo.New()
    local template = self:GetTemplate(id)
    item:InitData(template)
    self:InitShowDataCache(item, template)
  end)
end

function LWEffectOverviewManager:InitShowDataCache(item, template)
  self.showData[item.id] = item
  if self.templateMapByType[template.type] == nil then
    self.templateMapByType[template.type] = {}
  end
  table.insert(self.templateMapByType[template.type], item)
  local effectSourceList = template.effectSourceList
  local count = table.count(effectSourceList)
  for i = 1, count do
    local effectSourceType = effectSourceList[i]
    local effectIdList = template:GetEffectIdListByEffectSourceType(effectSourceType)
    for j = 1, table.count(effectIdList) do
      local effectId = effectIdList[j]
      if self.effectSourceType2InfoDict[effectSourceType] == nil then
        self.effectSourceType2InfoDict[effectSourceType] = {}
      end
      if self.effectSourceType2InfoDict[effectSourceType][effectId] == nil then
        self.effectSourceType2InfoDict[effectSourceType][effectId] = {}
      end
      table.insert(self.effectSourceType2InfoDict[effectSourceType][effectId], item.id)
    end
    if self.effectSourceType2ConfigIds[effectSourceType] == nil then
      self.effectSourceType2ConfigIds[effectSourceType] = {}
    end
    table.insert(self.effectSourceType2ConfigIds[effectSourceType], item.id)
  end
end

function LWEffectOverviewManager:RefreshHeroSkillData()
end

function LWEffectOverviewManager:RefreshAllianceTechData()
end

function LWEffectOverviewManager:RefreshTechData()
end

function LWEffectOverviewManager:RefreshBuildingData()
end

function LWEffectOverviewManager:IsHeroInCity(curHeroData)
  if curHeroData == nil then
    return false
  end
  local inSquad1 = DataCenter.BuildHeroManager:CheckHeroSquad(curHeroData.uuid, 1)
  local inSquad2 = DataCenter.BuildHeroManager:CheckHeroSquad(curHeroData.uuid, 2)
  local inSquad3 = DataCenter.BuildHeroManager:CheckHeroSquad(curHeroData.uuid, 3)
  local inSquad4 = DataCenter.BuildHeroManager:CheckHeroSquad(curHeroData.uuid, 4)
  if inSquad1 or inSquad2 or inSquad3 or inSquad4 then
    return true
  end
  if DataCenter.BuildHeroManager:HasBuildHero(curHeroData.heroId) then
    return true
  end
  return false
end

function LWEffectOverviewManager:ResetEffectSourceTotalValue(effectOverviewSourcePoint)
  if self.effectSourceType2ConfigIds[effectOverviewSourcePoint] then
    local configIds = self.effectSourceType2ConfigIds[effectOverviewSourcePoint]
    for i = 1, table.count(configIds) do
      local showData = self.showData[configIds[i]]
      if showData then
        showData:ResetEffectSourceTotalData(effectOverviewSourcePoint)
      end
    end
  end
end

function LWEffectOverviewManager:RefreshEffectSourceTotalValue(effectOverviewSourcePoint, effectId, effectValue, data)
  if self.effectSourceType2InfoDict[effectOverviewSourcePoint][effectId] then
    local configIdList = self.effectSourceType2InfoDict[effectOverviewSourcePoint][effectId]
    for i = 1, table.count(configIdList) do
      local showData = self.showData[configIdList[i]]
      if showData then
        showData:RefreshEffectSourceTotalData(effectOverviewSourcePoint, effectId, effectValue, data)
      end
    end
  end
end

function LWEffectOverviewManager:RefreshOfficeTotalValue(effectOverviewSourcePoint, effectId, effectValue, data)
  if self.effectSourceType2InfoDict[effectOverviewSourcePoint][effectId] then
    local configIdList = self.effectSourceType2InfoDict[effectOverviewSourcePoint][effectId]
    for i = 1, table.count(configIdList) do
      local showData = self.showData[configIdList[i]]
      if showData then
        showData:RefreshEffectSourceTotalData(effectOverviewSourcePoint, effectId, effectValue, data)
      end
    end
  end
end

function LWEffectOverviewManager:IsContainsSourcePointData(effectOverviewSourcePoint, effectId)
  if self.effectSourceType2InfoDict[effectOverviewSourcePoint] then
    return self.effectSourceType2InfoDict[effectOverviewSourcePoint][effectId] ~= nil
  end
  return false
end

function LWEffectOverviewManager:GetEffectDataByEffectOverviewSourcePoint(effectOverviewSourcePoint)
  if self.effectSourceType2InfoDict[effectOverviewSourcePoint] then
    return self.effectSourceType2InfoDict[effectOverviewSourcePoint]
  end
  return nil
end

function LWEffectOverviewManager:GetEffectValueByEffectOverviewSourcePointAndEffectId(templateId, effectOverviewSourcePoint, effectId)
  local data = self:GetShowDataByConfigId(templateId)
  if not data then
    return 0
  end
  return data:GetEffectValueDataBySourceTypeAndEffectId(effectOverviewSourcePoint, effectId)
end

function LWEffectOverviewManager:GetTemplateListByType(templateType)
  if self.templateMapByType[templateType] then
    return self.templateMapByType[templateType]
  end
  return nil
end

function LWEffectOverviewManager:GetShowDataByConfigId(configId)
  if self.showData[configId] then
    return self.showData[configId]
  end
  return nil
end

function LWEffectOverviewManager:GetUnlockEffectSourceList(templateId)
  local unlockList = {}
  local template = self:GetTemplate(templateId)
  for i = 1, table.count(template.effectSourceList) do
    local effectSourceType = template.effectSourceList[i]
    if effectSourceType == EffectOverviewSourcePoint.SeasonBuilding then
      if SeasonUtil.IsInSeason() then
        table.insert(unlockList, effectSourceType)
      end
    elseif effectSourceType == EffectOverviewSourcePoint.ProfessionSpecialization then
      local masteryData = DataCenter.MasteryManager:GetData()
      if masteryData and masteryData.home_id > 0 then
        table.insert(unlockList, effectSourceType)
      end
    elseif effectSourceType == EffectOverviewSourcePoint.HeroUniqueWeapon then
      local showHeroUuid = DataCenter.HeroDataManager:GetShowHeroUuidCache()
      if showHeroUuid == nil then
        return unlockList
      end
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(showHeroUuid)
      if heroData == nil then
        return unlockList
      end
      if heroData:IsUniqueWeaponOpen() then
        table.insert(unlockList, effectSourceType)
      end
    elseif effectSourceType == EffectOverviewSourcePoint.TacticalCard then
      local functionOpen = TacticalCardUtil.IsFunctionOpen()
      if functionOpen then
        table.insert(unlockList, effectSourceType)
      end
    elseif effectSourceType == EffectOverviewSourcePoint.Title then
      if DataCenter.PlayerInfoDataManager.hasAddAttrTitle then
        table.insert(unlockList, effectSourceType)
      end
    else
      table.insert(unlockList, effectSourceType)
    end
  end
  return unlockList
end

return LWEffectOverviewManager
