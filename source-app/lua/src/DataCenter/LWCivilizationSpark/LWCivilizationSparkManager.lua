local LWCivilizationSparkManager = BaseClass("LWCivilizationSparkManager", CEventable)
local LWCivilizationSparkTemplate = require("DataCenter.LWCivilizationSpark.LWCivilizationSparkTemplate")
local LWCivilizationSparkBuild = require("DataCenter.LWCivilizationSpark.LWCivilizationSparkBuild")
local Resource = CS.GameEntry.Resource

function LWCivilizationSparkManager:__init()
  self.sparkUpgradeLevel = 0
  self.templateDict = {}
  self.playedTimelines = {}
  self.build = LWCivilizationSparkBuild.New()
  self:AddListener()
end

function LWCivilizationSparkManager:__delete()
  self.sparkUpgradeLevel = nil
  self.templateDict = nil
  self.playedTimelines = nil
  if self.debugGrid ~= nil then
    self.debugGrid:Destroy()
    self.debugGrid = nil
  end
  if self.build then
    self.build:Delete()
    self.build = nil
  end
end

function LWCivilizationSparkManager:AddListener()
  self:RegisterEvent(EventId.BeforeReleaseCity, self.OnBeforeReleaseCity)
  self:RegisterEvent(EventId.BUILD_IN_VIEW, self.OnBuildInViewSignal)
  self:RegisterEvent(EventId.BUILD_OUT_VIEW, self.OnBuildOutViewSignal)
end

function LWCivilizationSparkManager:InitData(message)
  if not DataCenter.LWCivilizationSparkExtend:UseCivilizationSparkGuide() then
    return
  end
  if message.sparkUpgrade then
    self.sparkUpgradeLevel = message.sparkUpgrade
    self.build:PlayLoopAnim(self:GetLevel())
  end
end

function LWCivilizationSparkManager:UpdateData(message)
  if not DataCenter.LWCivilizationSparkExtend:UseCivilizationSparkGuide() then
    return
  end
  if message.sparkUpgrade then
    local sparkUpgradeLevel = message.sparkUpgrade
    if sparkUpgradeLevel ~= self.sparkUpgradeLevel then
      self.sparkUpgradeLevel = sparkUpgradeLevel
      self.build:PlayInAnim(self:GetLevel())
    end
  end
end

function LWCivilizationSparkManager:GetBattleStartEffect()
  local battleStartEffect = {}
  for id = 1, self:GetLevel() do
    local template = self:GetTemplate(id)
    if template.triggerList then
      for i, v in ipairs(template.triggerList) do
        table.insert(battleStartEffect, v)
      end
    end
  end
  return battleStartEffect
end

function LWCivilizationSparkManager:GetFormationPosMaxAddNum()
  local formationPosMaxAddNum = 0
  for id = 1, self:GetLevel() do
    local template = self:GetTemplate(id)
    if template.soldierLimitUp then
      formationPosMaxAddNum = formationPosMaxAddNum + template.soldierLimitUp
    end
  end
  return formationPosMaxAddNum
end

function LWCivilizationSparkManager:GetBuildInfo()
  local build = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_CIVILIZATION_SPARK)[1]
  if build then
    return build
  end
end

function LWCivilizationSparkManager:GetLevel()
  return self.sparkUpgradeLevel
end

function LWCivilizationSparkManager:GetBattleStartTriggerList(enterType)
  if enterType == PVEEnterType.Monopoly or enterType == PVEEnterType.TowerupJeepAdventure then
    return self:GetBattleStartEffect()
  end
  return nil
end

function LWCivilizationSparkManager:GetFormationPosMaxAdd(enterType)
  if enterType == PVEEnterType.Monopoly or enterType == PVEEnterType.TowerupJeepAdventure then
    return self:GetFormationPosMaxAddNum()
  end
  return 0
end

function LWCivilizationSparkManager:GetTemplate(id)
  local template = self.templateDict[id]
  if template == nil then
    local cfg = LocalController:instance():tryGetLine(LuaEntry.Player:GetABTestTableName(TableName.LW_CIVILIZATION_SPARK), tonumber(id))
    if cfg then
      template = LWCivilizationSparkTemplate.New()
      template:InitData(cfg)
      self.templateDict[id] = template
    end
  end
  return template
end

function LWCivilizationSparkManager:OnBeforeReleaseCity()
  self.build:Clear()
end

function LWCivilizationSparkManager:OnBuildInViewSignal(bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil or buildData.itemId ~= BuildingTypes.LW_CIVILIZATION_SPARK then
    return
  end
  self.build:Clear()
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
  if cityObj then
    self.build:BindGameObject(cityObj, self:GetLevel(), bUuid)
  end
end

function LWCivilizationSparkManager:OnBuildOutViewSignal(bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil or buildData.itemId ~= BuildingTypes.LW_CIVILIZATION_SPARK then
    return
  end
  if self.build then
    self.build:Clear()
  end
end

function LWCivilizationSparkManager:GetLandId()
  return 1003
end

function LWCivilizationSparkManager:SetTimelineIsPlayed(timelineType, isPlayed)
  self.playedTimelines[timelineType] = isPlayed
end

function LWCivilizationSparkManager:GetTimelineIsPlayed(timelineType)
  return self.playedTimelines[timelineType]
end

function LWCivilizationSparkManager:GetBuildPos()
  local itemId = BuildingTypes.LW_CIVILIZATION_SPARK
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(itemId)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(itemId)
  local worldPointPos = BuildingUtils.GetBuildModelCenterVec(buildData.pointId, template.tileX, template.tileY)
  return worldPointPos
end

function LWCivilizationSparkManager:CheckCanUpgrade()
  if self:GetLevel() == 0 then
    return false
  end
  local template = DataCenter.LWCivilizationSparkManager:GetTemplate(self:GetLevel())
  local upgradeNeed = template.upgradeNeed
  if upgradeNeed and upgradeNeed[2] then
    local needItemId = upgradeNeed[1]
    local needItemCount = upgradeNeed[2]
    local curItemCount = DataCenter.ItemData:GetItemCount(needItemId)
    return needItemCount <= curItemCount
  end
  return false
end

function LWCivilizationSparkManager:RefreshDebugGrid(show)
  self.showDebugGrid = show
  if show then
    if self.debugGrid == nil then
      self.debugGrid = Resource:InstantiateAsync("Assets/Main/Prefabs/LWCivilizationSpark/DebugGrid.prefab")
    end
  elseif self.debugGrid ~= nil then
    self.debugGrid:Destroy()
    self.debugGrid = nil
  end
end

return LWCivilizationSparkManager
