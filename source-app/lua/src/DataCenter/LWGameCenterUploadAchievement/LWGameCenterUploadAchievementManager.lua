local LWGameCenterUploadAchievementManager = BaseClass("LWGameCenterUploadAchievementManager", CEventable)

function LWGameCenterUploadAchievementManager:__init()
  self:RegisterEvent(EventId.PlayerPowerInfoUpdated, self.UploadHistoryMaxPowerAchievement)
  self:RegisterEvent(EventId.GF_building_upgrade_done, self.BaseBuildingUpgradeRefreshUploadData)
  self:RegisterEvent(EventId.GF_get_new_hero, self.OnGetNewHeroData)
  self.uploadPowerInterval = 30
  self.preUploadPowerTime = Time.realtimeSinceStartup - self.uploadPowerInterval
  self.monikaHeroId = 40020
end

function LWGameCenterUploadAchievementManager:__delete()
  self.preUploadPowerTime = nil
  self.uploadPowerInterval = nil
  self.monikaHeroId = nil
end

function LWGameCenterUploadAchievementManager:InitData(message)
  if message.vip ~= nil and message.vip.vipInfo then
    local vipInfo = message.vip.vipInfo
    local loginDays = vipInfo.loginDays
    self:UploadLoginDaysAchievement(loginDays)
  end
  if message.playerInfo and message.playerInfo.playerMaxPower then
    local playerMaxPower = message.playerInfo.playerMaxPower
    self:UploadHistoryMaxPowerAchievement(playerMaxPower)
  end
  if message.building_new then
    local buildingData = message.building_new
    for k, v in pairs(buildingData) do
      if v.bId ~= nil then
        local buildingId = v.bId
        if buildingId == BuildingTypes.FUN_BUILD_MAIN then
          local buildingLevel = v.lv
          self:UploadBaseBuildingLevelAchievement(buildingLevel)
        end
      end
    end
  end
  if message.userHero ~= nil then
    local ownMonicaHero = false
    local heroData = message.userHero
    for k, v in pairs(heroData) do
      if v.heroId ~= nil then
        local heroId = tonumber(v.heroId)
        if heroId == self.monikaHeroId then
          ownMonicaHero = true
          break
        end
      end
    end
    self:UploadOwnMonikaHeroAchievement(ownMonicaHero)
  end
end

function LWGameCenterUploadAchievementManager:UploadLoginDaysAchievement(days)
  local percentValue_1 = 1 <= days and 100 or 0
  local percentValue_30 = 30 <= days and 100 or days / 30 * 100
  local percentValue_150 = 150 <= days and 100 or days / 150 * 100
  local percentValue_365 = 365 <= days and 100 or days / 365 * 100
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.LoginDaysAchievement, 1), percentValue_1)
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.LoginDaysAchievement, 30), percentValue_30)
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.LoginDaysAchievement, 150), percentValue_150)
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.LoginDaysAchievement, 365), percentValue_365)
end

function LWGameCenterUploadAchievementManager:BaseBuildingUpgradeRefreshUploadData(buildingInfo)
  if buildingInfo and buildingInfo:IsMainBuilding() then
    self:UploadBaseBuildingLevelAchievement(buildingInfo.level)
  end
end

function LWGameCenterUploadAchievementManager:UploadBaseBuildingLevelAchievement(buildingLevel)
  local percentValue_1 = 1 <= buildingLevel and 100 or 0
  local percentValue_20 = 20 <= buildingLevel and 100 or buildingLevel / 20 * 100
  local percentValue_30 = 30 <= buildingLevel and 100 or buildingLevel / 30 * 100
  local percentValue_35 = 35 <= buildingLevel and 100 or buildingLevel / 35 * 100
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.BaseLevelAchievement, 1), percentValue_1)
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.BaseLevelAchievement, 20), percentValue_20)
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.BaseLevelAchievement, 30), percentValue_30)
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.BaseLevelAchievement, 35), percentValue_35)
end

function LWGameCenterUploadAchievementManager:UploadHistoryMaxPowerAchievement()
  local curTime = Time.realtimeSinceStartup
  local differenceTime = curTime - self.preUploadPowerTime
  if differenceTime < self.uploadPowerInterval then
    return
  end
  self.preUploadPowerTime = curTime
  local finalPower = math.max(LuaEntry.Player.playerMaxPower, LuaEntry.Player.power)
  local percentValue_50k = 50000.0 <= finalPower and 100 or finalPower / 50000.0 * 100
  local percentValue_100m = 1.0E8 <= finalPower and 100 or finalPower / 1.0E8 * 100
  local percentValue_300m = 3.0E8 <= finalPower and 100 or finalPower / 3.0E8 * 100
  local percentValue_500m = 5.0E8 <= finalPower and 100 or finalPower / 5.0E8 * 100
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.HistoryMaxPowerAchievement, "50k"), percentValue_50k)
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.HistoryMaxPowerAchievement, "100m"), percentValue_100m)
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.HistoryMaxPowerAchievement, "300m"), percentValue_300m)
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.HistoryMaxPowerAchievement, "500m"), percentValue_500m)
end

function LWGameCenterUploadAchievementManager:UploadStageFeatureChapterAchievement(finishCount)
  local percentValue_30 = 30 <= finishCount and 100 or finishCount / 30 * 100
  local percentValue_40 = 40 <= finishCount and 100 or finishCount / 40 * 100
  local percentValue_48 = 48 <= finishCount and 100 or finishCount / 48 * 100
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.StageFeatureChapterAchievement, 30), percentValue_30)
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.StageFeatureChapterAchievement, 40), percentValue_40)
  CS.LastWarSocialBridge.ReportAchievement(string.format(GameCenterUploadDataName.StageFeatureChapterAchievement, 48), percentValue_48)
end

function LWGameCenterUploadAchievementManager:OnGetNewHeroData(newHeroInfo)
  if newHeroInfo and newHeroInfo.heroId == self.monikaHeroId then
    self:UploadOwnMonikaHeroAchievement(true)
  end
end

function LWGameCenterUploadAchievementManager:UploadOwnMonikaHeroAchievement(ownMonicaHero)
  local percentValue = ownMonicaHero and 100 or 0
  CS.LastWarSocialBridge.ReportAchievement(GameCenterUploadDataName.OwnMonikaHero, percentValue)
end

return LWGameCenterUploadAchievementManager
