local BuildHeroCountdownManager = BaseClass("BuildHeroCountdownManager", CEventable)
local BuildHeroCountdown = require("DataCenter.BuildManager.BuildHeroCountdown")
local Localization = CS.GameEntry.Localization

function BuildHeroCountdownManager:__init()
  self:RegisterEvent(EventId.HideCityDome, self.OnBeforeReleaseCity)
end

function BuildHeroCountdownManager:__delete()
  self:Clear()
  self.buildMap = nil
end

function BuildHeroCountdownManager:Startup()
end

function BuildHeroCountdownManager:OnBeforeReleaseCity()
  self:Clear()
end

function BuildHeroCountdownManager:Clear()
  if self.buildHeroMap then
    for _, v in pairs(self.buildHeroMap) do
      v:Delete()
    end
    self.buildHeroMap = nil
  end
end

function BuildHeroCountdownManager:AddBuild(buildUuid)
  if self.buildMap == nil then
    self.buildMap = {}
  end
  self.buildMap[buildUuid] = true
end

function BuildHeroCountdownManager:RemoveBuild(buildUuid)
  if self.buildMap then
    self.buildMap[buildUuid] = nil
    self:RemoveBuildHero(buildUuid)
  end
end

function BuildHeroCountdownManager:BuildInViewSignal(bUuid)
  if self.buildMap == nil or self.buildMap[bUuid] == nil then
    return
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil or buildData.itemId ~= BuildingTypes.LW_BUILD_HERO_COUNTDOWN then
    return
  end
  if self.buildHeroMap and self.buildHeroMap[bUuid] then
    local cur = self.buildHeroMap[bUuid]
    if cur.pointId == nil or buildData.pointId ~= cur.pointId then
      local hero_build_info = {
        pId = buildData.pointId,
        bId = buildData.itemId,
        heroId = buildData.fixCityHeroId,
        uuid = buildData.uuid
      }
      cur:Reset(hero_build_info)
    end
    return
  end
  local hero_build_info = {
    pId = buildData.pointId,
    bId = buildData.itemId,
    heroId = buildData.fixCityHeroId,
    uuid = buildData.uuid
  }
  self:AddBuildHero(hero_build_info)
end

function BuildHeroCountdownManager:AddBuildHero(build_info)
  if self.buildHeroMap == nil then
    self.buildHeroMap = {}
  end
  if build_info.heroId and self.buildHeroMap[build_info.uuid] == nil then
    self.buildHeroMap[build_info.uuid] = BuildHeroCountdown.New(build_info)
  end
end

function BuildHeroCountdownManager:RemoveBuildHero(buildUuid)
  if buildUuid and self.buildHeroMap and self.buildHeroMap[buildUuid] then
    self.buildHeroMap[buildUuid]:Destroy()
    self.buildHeroMap[buildUuid] = nil
  end
end

function BuildHeroCountdownManager:TryFixHero(buildUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
  if buildData == nil or buildData.itemId ~= BuildingTypes.LW_BUILD_HERO_COUNTDOWN then
    return
  end
  local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
  if buildData.fixCityHeroEndTime and curTime >= buildData.fixCityHeroEndTime then
    SFSNetwork.SendMessage(MsgDefines.FreeBuildingFixCityHero, buildUuid)
  else
    local last = UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(buildData.fixCityHeroEndTime - curTime)
    UIUtil.ShowTips(Localization:GetString("monopoly_event_tips_01", last))
  end
end

return BuildHeroCountdownManager
