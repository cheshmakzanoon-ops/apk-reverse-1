local StageFeatureBuildingManager = BaseClass("StageFeatureBuildingManager")
local StageFeatureBuildingTemplate = require("DataCenter.StageFeatureBuildingManager.StageFeatureBuildingTemplate")

local function __init(self)
  self.buildingDic = {}
  self.featureDic = {}
  self.scoreDic = {}
  self.reward = {}
  self.rewardStageId = {}
  self.reqs = {}
  self.rewardShow = nil
  self.AddListener(self)
end

local function __delete(self)
  self.RemoveListener(self)
  self.buildingDic = nil
  self.featureDic = nil
  self.scoreDic = nil
  self.reward = nil
  self.rewardStageId = nil
  self.rewardShow = nil
  self:ClearReqs()
  self:ClearAllDelayTimers()
end

local function Startup()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():AddListener(EventId.BeforeReleaseCity, self.OnReleaseCity)
  EventManager:GetInstance():AddListener(EventId.BUILD_IN_VIEW, self.OnBuildInView)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():RemoveListener(EventId.BeforeReleaseCity, self.OnReleaseCity)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_IN_VIEW, self.OnBuildInView)
end

function StageFeatureBuildingManager:ClearReqs()
  if self.reqs and next(self.reqs) then
    for i = 1, table.count(self.reqs) do
      if self.reqs[i] then
        self.reqs[i]:Destroy()
      end
    end
    self.reqs = {}
  end
end

local function OnEnterCity()
  local self = DataCenter.StageFeatureBuildingManager
  if self.MysteryEnteredBuilding then
    local template = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(self.StageFeatureId)
    if self.MysteryRewardPointId ~= nil then
      local wPos = SceneUtils.TileToWorld(SceneUtils.IndexToTilePos(self.MysteryRewardPointId), ForceChangeScene.City)
      CS.SceneManager.World:Lookat(wPos)
      if template.dissolve and not string.IsNullOrEmpty(template.dissolve) then
        local mysteryEffHandle = CS.GameEntry.Resource:InstantiateAsync(template.dissolve)
        mysteryEffHandle:completed("+", function(handle)
          if not handle or handle.isError then
            return
          end
          handle.gameObject:SetActive(true)
          handle.gameObject.transform:Set_position(wPos.x, wPos.y, wPos.z)
          self:CreateDelayTimer(function()
            if not IsNull(handle) then
              for i, v in ipairs(self.reqs) do
                if v == handle then
                  table.remove(self.reqs, i)
                  break
                end
              end
              handle:Destroy()
            end
          end, 4)
        end)
        table.insert(self.reqs, mysteryEffHandle)
      end
      if template.victory and not string.IsNullOrEmpty(template.victory) then
        local mysteryEffHandle2 = CS.GameEntry.Resource:InstantiateAsync(template.victory)
        mysteryEffHandle2:completed("+", function(handle)
          if not handle or handle.isError then
            return
          end
          handle.gameObject:SetActive(true)
          handle.gameObject.transform:Set_position(wPos.x - 1, wPos.y + 2.5, wPos.z - 1)
          handle.gameObject.transform.localScale = Vector3.one * 2
          self:CreateDelayTimer(function()
            if not IsNull(handle) then
              for i, v in ipairs(self.reqs) do
                if v == handle then
                  table.remove(self.reqs, i)
                  break
                end
              end
              handle:Destroy()
            end
          end, 4)
        end)
        table.insert(self.reqs, mysteryEffHandle2)
      end
      self.MysteryEnteredBuilding = nil
      self.MysteryRewardPointId = nil
      self.StageFeatureId = nil
    elseif self.MysteryRewardUpgradeLv ~= nil then
      local data = DataCenter.BuildManager:GetBuildingDataByUuid(self.MysteryEnteredBuilding)
      local wPos = SceneUtils.TileToWorld(SceneUtils.IndexToTilePos(data.pointId), ForceChangeScene.City)
      CS.SceneManager.World:Lookat(wPos)
    else
      local data = DataCenter.BuildManager:GetBuildingDataByUuid(self.MysteryEnteredBuilding)
      local wPos = SceneUtils.TileToWorld(SceneUtils.IndexToTilePos(data.pointId), ForceChangeScene.City)
      CS.SceneManager.World:Lookat(wPos)
      self.MysteryEnteredBuilding = nil
    end
  end
  if self.rewardShow then
    DataCenter.RewardManager:ShowCommonReward(self.rewardShow)
    self.rewardShow = nil
  end
end

local function OnBuildInView(uuid)
  local self = DataCenter.StageFeatureBuildingManager
  if self.MysteryRewardUpgradeLv ~= nil and uuid == self.MysteryEnteredBuilding then
    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    local wPos = SceneUtils.TileToWorld(SceneUtils.IndexToTilePos(buildingData.pointId), ForceChangeScene.City)
    CS.SceneManager.World:Lookat(wPos)
    local build = CS.SceneManager.World:GetObjectByPointId(buildingData.pointId)
    if build ~= nil then
      if self.MysteryRewardUpgradeLv == 1 then
        local treasure1 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure1")
        treasure1.gameObject:SetActive(false)
        local treasure2 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure2")
        treasure2.gameObject:SetActive(true)
        local treasure3 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure3")
        treasure3.gameObject:SetActive(false)
        local eff = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/Eff_shenmiguanqia_baoxiang")
        eff.gameObject:SetActive(true)
        local eff1 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/Eff_shenmiguanqia_baoxiang_01")
        eff1.gameObject:SetActive(false)
      elseif self.MysteryRewardUpgradeLv == 2 then
        local treasure1 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure1")
        treasure1.gameObject:SetActive(false)
        local treasure2 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure2")
        treasure2.gameObject:SetActive(false)
        local treasure3 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure3")
        treasure3.gameObject:SetActive(true)
        local eff = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/Eff_shenmiguanqia_baoxiang")
        eff.gameObject:SetActive(false)
        local eff1 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/Eff_shenmiguanqia_baoxiang_01")
        eff1.gameObject:SetActive(true)
      end
    end
    self.MysteryEnteredBuilding = nil
    self.StageFeatureId = nil
    self.MysteryRewardUpgradeLv = nil
  else
    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    local build = CS.SceneManager.World:GetObjectByPointId(buildingData.pointId)
    if buildingData.itemId == BuildingTypes.LW_BUILD_TREASURE_CHEST then
      if buildingData.specialStagePassedIds and #buildingData.specialStagePassedIds > 0 then
        if #buildingData.specialStagePassedIds == 1 then
          local treasure1 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure1")
          treasure1.gameObject:SetActive(false)
          local treasure2 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure2")
          treasure2.gameObject:SetActive(true)
          local treasure3 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure3")
          treasure3.gameObject:SetActive(false)
        elseif #buildingData.specialStagePassedIds == 2 then
          local treasure1 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure1")
          treasure1.gameObject:SetActive(false)
          local treasure2 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure2")
          treasure2.gameObject:SetActive(false)
          local treasure3 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure3")
          treasure3.gameObject:SetActive(true)
        end
      else
        local treasure1 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure1")
        if treasure1 then
          treasure1.gameObject:SetActive(true)
        end
        local treasure2 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure2")
        if treasure2 then
          treasure2.gameObject:SetActive(false)
        end
        local treasure3 = build.cityBuilding.transform:Find("ModelGo/Normal/buildParent/A_build_mystery_treasure3")
        if treasure3 then
          treasure3.gameObject:SetActive(false)
        end
      end
    end
  end
end

local function OnReleaseCity()
  local self = DataCenter.StageFeatureBuildingManager
  self:ClearReqs()
  self:ClearAllDelayTimers()
end

local function GetTableName(self)
  if self.useTableName == nil then
    if LuaEntry.Player ~= nil then
      self.useTableName = LuaEntry.Player:GetABTestTableName(TableName.LW_StageFeatureBuilding)
    else
      self.useTableName = TableName.LW_StageFeatureBuilding
    end
  end
  return self.useTableName
end

local function UpdateData(self, stageId, time, reward)
  self.reward = reward
  self.rewardStageId = stageId
end

local function GetStageFeatureBuildingTemplate(self, _id)
  if self.buildingDic[_id] == nil then
    local oneTemplate = LocalController:instance():getLine(self:GetTableName(), tostring(_id))
    if oneTemplate ~= nil then
      local item = StageFeatureBuildingTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.buildingDic[item.id] = item
      end
    end
  end
  return self.buildingDic[_id]
end

local function OnEnterBattle(self, buildUuid)
  PostEventLog.Track(PostEventLog.Defines.NewbiesMysteryTreasureBattleEnter)
  self.MysteryEnteredBuilding = buildUuid
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
  self.StageFeatureId = tonumber(buildingData.specialStageId)
  local template = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(self.StageFeatureId)
  if self.featureDic[buildUuid] == nil then
    if #template.winType == 1 then
      local param = {}
      param.buildUuid = buildUuid
      param.featureId = template.id
      param.type = tonumber(template.caty[1])
      param.enterType = PVEEnterType.StageFeatureBuilding
      local stageId = template.stages[1]
      param.levelId = stageId
      self.StageId = stageId
      self.featureDic[buildUuid] = param
      if param.type ~= 0 then
        DataCenter.LWBattleManager:Enter(param)
      else
        DataCenter.ZombieBattleManager:Enter(param)
      end
    elseif buildingData.specialStagePassedIds and 0 < #buildingData.specialStagePassedIds then
      for i = 1, #template.stages do
        local find = false
        local stageId = template.stages[i]
        for _, value in ipairs(buildingData.specialStagePassedIds) do
          if stageId == value then
            find = true
          end
        end
        if not find then
          local param = {}
          param.buildUuid = buildUuid
          param.featureId = template.id
          param.type = tonumber(template.caty[i])
          param.enterType = PVEEnterType.StageFeatureBuilding
          local stageId = template.stages[i]
          param.levelId = stageId
          self.StageId = stageId
          self.featureDic[buildUuid] = param
          if param.type ~= 0 then
            DataCenter.LWBattleManager:Enter(param)
            break
          end
          DataCenter.ZombieBattleManager:Enter(param)
          break
        end
      end
    else
      local param = {}
      param.buildUuid = buildUuid
      param.featureId = template.id
      param.type = tonumber(template.caty[1])
      param.enterType = PVEEnterType.StageFeatureBuilding
      local stageId = template.stages[1]
      param.levelId = stageId
      self.StageId = stageId
      self.featureDic[buildUuid] = param
      if param.type ~= 0 then
        DataCenter.LWBattleManager:Enter(param)
      else
        DataCenter.ZombieBattleManager:Enter(param)
      end
    end
  else
    local param = self.featureDic[buildUuid]
    local idx = table.indexof(template.stages, param.levelId)
    if idx < #template.stages then
      local stageId = template.stages[idx + 1]
      param.levelId = stageId
      self.StageId = stageId
    end
    if param.type ~= 0 then
      DataCenter.LWBattleManager:Destroy()
      DataCenter.LWBattleManager:Enter(param)
    else
      DataCenter.ZombieBattleManager:Destroy()
      DataCenter.ZombieBattleManager:Enter(param)
    end
  end
end

local function OnExitBattle(self, buildUuid)
  if self.featureDic[buildUuid] then
    self.featureDic[buildUuid] = nil
  end
  if self.scoreDic[buildUuid] then
    self.scoreDic[buildUuid] = nil
  end
end

local function SaveScore(self, buildUuid, num)
  if self.scoreDic then
    if self.scoreDic[buildUuid] == nil then
      self.scoreDic[buildUuid] = 0
    end
    self.scoreDic[buildUuid] = self.scoreDic[buildUuid] + num
  end
end

local function GetScore(self, buildUuid)
  if self.scoreDic and self.scoreDic[buildUuid] ~= nil then
    return self.scoreDic[buildUuid]
  end
  return 0
end

function StageFeatureBuildingManager:CreateDelayTimer(callback, delay, timerName)
  if self.delayTimers == nil then
    self.delayTimers = {}
  end
  timerName = timerName or "timer_" .. tostring(#self.delayTimers + 1)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimers[timerName] then
      self.delayTimers[timerName] = nil
    end
    callback()
  end, delay)
  self.delayTimers[timerName] = timer
  return timer
end

function StageFeatureBuildingManager:ClearAllDelayTimers()
  if self.delayTimers then
    for name, timer in pairs(self.delayTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.delayTimers = {}
  end
end

StageFeatureBuildingManager.Startup = Startup
StageFeatureBuildingManager.__init = __init
StageFeatureBuildingManager.__delete = __delete
StageFeatureBuildingManager.AddListener = AddListener
StageFeatureBuildingManager.RemoveListener = RemoveListener
StageFeatureBuildingManager.OnEnterCity = OnEnterCity
StageFeatureBuildingManager.OnReleaseCity = OnReleaseCity
StageFeatureBuildingManager.OnBuildInView = OnBuildInView
StageFeatureBuildingManager.GetTableName = GetTableName
StageFeatureBuildingManager.GetStageFeatureBuildingTemplate = GetStageFeatureBuildingTemplate
StageFeatureBuildingManager.OnEnterBattle = OnEnterBattle
StageFeatureBuildingManager.OnExitBattle = OnExitBattle
StageFeatureBuildingManager.SaveScore = SaveScore
StageFeatureBuildingManager.GetScore = GetScore
StageFeatureBuildingManager.UpdateData = UpdateData
return StageFeatureBuildingManager
