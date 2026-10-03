local DesertDataManager = BaseClass("DesertDataManager")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource

local function Startup(self)
end

local function __init(self)
  self.myDesertList = {}
  self.desertPointDic = {}
  self.seasonRewardList = nil
  self.selfAllianceSendList = {}
  self.sendGiftRecords = nil
  self.seasonBuildList = {}
  self.buildOccupyPointDic = {}
  self.timer = nil
  
  function self.timer_action(temp)
    self:CheckShowResourceRedDot()
  end
  
  self.desertFirstReward = {}
  self.desertRankInfo = {}
  self.forceRewardList = {}
  self.forceRank = 5000
  self.lastCollectTime = 0
end

local function __delete(self)
  self:DeleteTimer()
  self.timer_action = nil
  self.myDesertList = nil
  self.desertPointDic = nil
  self.seasonRewardList = nil
  self.selfAllianceSendList = nil
  self.sendGiftRecords = nil
  self.buildOccupyPointDic = nil
  self.desertFirstReward = nil
end

function DesertDataManager:OnEnterGame()
  if SeasonUtil.IsInSeasonDesertMode() then
    SFSNetwork.SendMessage(MsgDefines.UserGetAllDesert)
    SFSNetwork.SendMessage(MsgDefines.SeasonForceReward)
  end
end

local function InitDesertDataRequest(self, message)
  if message and message.world_desert_first_occupy then
    local desert = message.world_desert_first_occupy
    self.desertFirstReward = string.split(desert, ";")
  end
  if message and message.world_desert_collect_time ~= nil then
    self:SetLastCollectTime(message.world_desert_collect_time)
  end
end

local function UpdateDesertFirst(self, message)
  if message.world_desert_first_occupy then
    local desert = message.world_desert_first_occupy
    self.desertFirstReward = string.split(desert, ";")
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    local refreshTime = LuaEntry.DataConfig:TryGetNum("season1_desert", "k2", 300)
    if refreshTime <= 0 then
      refreshTime = 300
    end
    self.timer = TimerManager:GetInstance():GetTimer(refreshTime, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function GetShowResourceRedDot(self)
  local gasSpeed = self:GetSeasonResourceCollectSpeed(ResourceType.OBSIDIAN)
  local flintSpeed = self:GetSeasonResourceCollectSpeed(ResourceType.FLINT)
  local gasNum, flintNum, deltaTime = self:GetCanGatherResNum(gasSpeed, flintSpeed)
  local k8 = LuaEntry.DataConfig:TryGetNum("season1_desert", "k8")
  local showTime = k8 * 60
  if deltaTime >= showTime and (0 < gasNum or 0 < flintNum) then
    return true
  end
  return false
end

local function CheckShowResourceRedDot(self)
  EventManager:GetInstance():Broadcast(EventId.CheckGatherSeasonResRedDot)
end

local function UpdateAllDesertData(self, message)
  self.myDesertList = {}
  self.desertPointDic = {}
  if message.deserts ~= nil then
    local arr = message.deserts
    for k, v in pairs(arr) do
      self:UpdateOneDesertData(v)
    end
  end
  if message.crossDeserts ~= nil then
    local arr = message.crossDeserts
    for k, v in pairs(arr) do
      self:UpdateOneDesertData(v)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.InitSelfDesert)
  self:AddTimer()
  self:CheckShowResourceRedDot()
end

local function UpdateOneDesertData(self, message)
  local WorldDesertData = require("DataCenter.DesertData.WorldDesertData")
  local desertInfo = WorldDesertData.New()
  desertInfo:ParseData(message)
  desertInfo:SetOwnerUid(LuaEntry.Player.uid)
  if desertInfo.uuid ~= nil and desertInfo.level > 0 then
    self.myDesertList[desertInfo.uuid] = desertInfo
    if desertInfo.pointId ~= 0 then
      self.desertPointDic[desertInfo.pointId] = desertInfo
    end
    DataCenter.SeasonDataManager:UpdateDesertMaxLevel(desertInfo.level)
  elseif desertInfo.uuid ~= nil and desertInfo.level == 0 then
    if self.emptyDesertList == nil then
      self.emptyDesertList = {}
    end
    self.emptyDesertList[desertInfo.uuid] = desertInfo
  end
end

local function GetSelfEmptyDesertDataByUuid(self, uuid)
  if self.emptyDesertList == nil then
    return nil
  end
  return self.emptyDesertList[uuid]
end

local function GetSelfDesertDataByUuid(self, uuid)
  return self.myDesertList[uuid]
end

local function GetAllMyDesert(self)
  return self.myDesertList
end

local function GetSelfSeverDesert(self)
  local selfServerId = LuaEntry.Player:GetSourceServerId()
  local selfCount = 0
  for k, v in pairs(self.myDesertList) do
    if v.serverId == selfServerId then
      selfCount = selfCount + 1
    end
  end
  return selfCount
end

local function GetOtherSeverDesert(self)
  local selfServerId = LuaEntry.Player:GetSourceServerId()
  local otherCount = 0
  for k, v in pairs(self.myDesertList) do
    if v.serverId ~= selfServerId then
      otherCount = otherCount + 1
    end
  end
  return otherCount
end

local function GetSortList(self, isOtherServer)
  local selfServerId = LuaEntry.Player:GetSourceServerId()
  local levelList = {}
  for k, v in pairs(self.myDesertList) do
    if isOtherServer ~= nil and isOtherServer == true then
      if v.serverId ~= selfServerId then
        levelList[v.level] = 1
      end
    elseif v.serverId == selfServerId then
      levelList[v.level] = 1
    end
  end
  return table.keys(levelList)
end

local function GetBuildListIds(self)
  local idList = {}
  for k, v in pairs(self.seasonBuildList) do
    idList[v.itemId] = 1
  end
  return table.keys(idList)
end

local function GetDesertMaxNum(self)
  local maxNum = LuaEntry.DataConfig:TryGetNum("season1_desert", "k1", 20)
  local addNum = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_SEASON_DESERT_NUM_ADD)
  local extraNum = 0
  local totalNum = addNum + maxNum + extraNum
  return toInt(totalNum)
end

local function CheckMyDesertNumIsFull(self)
  local maxNum = self:GetDesertMaxNum()
  local curNum = 0
  if CrossServerUtil:GetIsCrossServer() then
    curNum = self:GetOtherSeverDesert()
  else
    curNum = self:GetSelfSeverDesert()
  end
  return maxNum <= curNum
end

local function RemoveMyDesert(self, message)
  local uuid = message.uuid
  if uuid ~= nil then
    local desertInfo = self.myDesertList[uuid]
    if desertInfo ~= nil and desertInfo.point ~= 0 then
      self.desertPointDic[desertInfo.pointId] = nil
    end
    self.myDesertList[uuid] = nil
    if self.emptyDesertList ~= nil then
      self.emptyDesertList[uuid] = nil
    end
    WorldDesertEffectManager:GetInstance():RemoveOneEffect(uuid)
  end
end

local function CanBuildByPointId(self, pointId, buildId, isMoveCity)
  if SeasonUtil.IsInSeasonDesertMode() == false and CrossServerUtil:GetIsCrossServer() == false then
    return true
  end
  if buildId ~= BuildingTypes.FUN_BUILD_MAIN and buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB and buildId ~= BuildingTypes.WORM_HOLE_CROSS and BuildingUtils.IsInEdenSubwayGroup(buildId) == false then
    local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if buildDesTemplate ~= nil then
      local allianceCenterId = tonumber(buildDesTemplate.para1)
      if allianceCenterId ~= nil and 0 < allianceCenterId then
        local state = DataCenter.AllianceMineManager:IsPointInAllianceCenterRange(pointId, allianceCenterId)
        if state == true then
          local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(pointId)
          if worldTileInfo == nil then
            return true
          end
          local pointData = worldTileInfo:GetPointInfo()
          if pointData == nil then
            local desertInfo = worldTileInfo:GetWorldDesertInfo()
            if desertInfo == nil then
              return true
            end
            local playerType = desertInfo:GetPlayerType()
            if playerType == CS.PlayerType.PlayerNone or playerType == CS.PlayerType.PlayerSelf or playerType == CS.PlayerType.PlayerAlliance or playerType == CS.PlayerType.PlayerAllianceLeader then
              return true
            end
          end
        end
      end
    end
  else
    local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(pointId)
    if worldTileInfo == nil then
      return true
    end
    local pointData = worldTileInfo:GetPointInfo()
    if pointData == nil then
      local desertInfo = worldTileInfo:GetWorldDesertInfo()
      if desertInfo == nil then
        return true
      end
      local playerType = desertInfo:GetPlayerType()
      if playerType == CS.PlayerType.PlayerNone or playerType == CS.PlayerType.PlayerSelf then
        return true
      end
    elseif pointData.PointType == WorldPointType.WorldRuinPoint then
      local pb = PBController.ParsePbFromBytes(pointData.extraInfo, "protobuf.WorldRuinPointInfo")
      local now = UITimeManager:GetInstance():GetServerTime()
      if now >= pb.endTime * 1000 then
        return true
      end
    end
  end
  return false
end

local function CanPlaceAllianceBuildByPointId(self, pointId)
  if SeasonUtil.IsInSeasonDesertMode() or CrossServerUtil:GetIsCrossServer() == true then
    local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(pointId)
    if worldTileInfo == nil then
      return true
    end
    local pointData = worldTileInfo:GetPointInfo()
    if pointData == nil then
      local desertInfo = worldTileInfo:GetWorldDesertInfo()
      if desertInfo == nil then
        return true
      end
      local playerType = desertInfo:GetPlayerType()
      if playerType == CS.PlayerType.PlayerNone then
        return true
      end
    end
    return false
  end
  return true
end

local function CanPlaceEdenWormByPointId(self, pointId)
  if SeasonUtil.IsInSeasonDesertMode() and LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
    local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(pointId)
    if worldTileInfo ~= nil then
      local pointData = worldTileInfo:GetPointInfo()
      if pointData == nil then
        local desertInfo = worldTileInfo:GetWorldDesertInfo()
        if desertInfo ~= nil then
          local playerType = desertInfo:GetPlayerType()
          if playerType == CS.PlayerType.PlayerSelf then
            return true
          end
        end
      end
    end
  end
  return false
end

local function CanPlaceAllianceCenterByPointId(self, pointId)
  if SeasonUtil.IsInSeasonCityStrongholdMode() or SeasonUtil.IsInSeasonSnowMode() or SeasonUtil.IsInSeasonMummyMode() or SeasonUtil.IsInSeasonDarknessMode() then
    return true
  elseif SeasonUtil.IsInSeasonDesertMode() or CrossServerUtil:GetIsCrossServer() == true then
    local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(pointId)
    if worldTileInfo == nil then
      return true
    end
    local pointData = worldTileInfo:GetPointInfo()
    if pointData == nil then
      local desertInfo = worldTileInfo:GetWorldDesertInfo()
      if desertInfo == nil then
        return true
      end
      local playerType = desertInfo:GetPlayerType()
      if playerType == CS.PlayerType.PlayerNone or playerType == CS.PlayerType.PlayerSelf or playerType == CS.PlayerType.PlayerAlliance or playerType == CS.PlayerType.PlayerAllianceLeader then
        return true
      end
    end
  end
  return false
end

local function SetSelfAllianceSendList(self, message)
  self.selfAllianceSendList = {}
  if message.allianceMembers ~= nil then
    for k, v in pairs(message.allianceMembers) do
      self.selfAllianceSendList[v] = 1
    end
  end
end

local function GetSelfAllianceSendList(self)
  return self.selfAllianceSendList
end

local function InitDesertRewardList(self, message)
  local SeasonRewardList = require("DataCenter.DesertData.SeasonRewardList")
  self.seasonRewardList = SeasonRewardList.New()
  self.seasonRewardList:UpdateData(message)
end

local function GetSeasonRewardList(self)
  return self.seasonRewardList
end

local function GetSelfAllianceSeasonReward(self)
  if self.seasonRewardList ~= nil then
    return self.seasonRewardList:GetSelfAllianceReward()
  end
end

local function OnGetSelfRewardCallBack(self)
  if self.seasonRewardList ~= nil then
    self.seasonRewardList:GetSelfRewardCallBack()
  end
end

local function SetSendGiftRecords(self, message)
  if message.records ~= nil then
    self.sendGiftRecords = message.records
  end
end

local function GetSendGiftRecords(self)
  return self.sendGiftRecords
end

local function SetSelfAllianceRewardPackageRestNum(self, packageId, restNum)
  if self.seasonRewardList ~= nil then
    self.seasonRewardList:SetSelfAllianceRewardPackageRestNum(packageId, restNum)
  end
end

local function GetSelfPackageId(self)
  if self.seasonRewardList ~= nil then
    return self.seasonRewardList:GetSelfPackageId()
  end
end

local function GetSelfRewardData(self)
  if self.seasonRewardList ~= nil then
    return self.seasonRewardList:GetSelfRewardData()
  end
end

local function UpdateSeasonBuildList(self, worldBuildData)
  if worldBuildData.isWorldBuild ~= true or SeasonUtil.IsInSeasonDesertMode() == false then
    return
  end
  local one = self.seasonBuildList[worldBuildData.uuid]
  if one == nil then
    if worldBuildData.state ~= BuildingStateType.FoldUp then
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(worldBuildData.itemId)
      if buildTemplate ~= nil and (buildTemplate.tab_type == UIBuildListTabType.SeasonBuild or BuildingUtils.IsInEdenSubwayGroup(worldBuildData.itemId) == true) then
        local vecPos = SceneUtils.IndexToTilePos(worldBuildData.pointId, ForceChangeScene.World)
        local list = BuildingUtils.GetAllNeighborsPos4(vecPos, buildTemplate.tileX, buildTemplate.tileY)
        if list ~= nil then
          local oneData = {}
          local rangeList = {}
          for k, v in pairs(list) do
            local pointId = SceneUtils.TilePosToIndex(v, ForceChangeScene.World)
            self.buildOccupyPointDic[pointId] = worldBuildData.itemId
            table.insert(rangeList, pointId)
          end
          oneData.level = worldBuildData.level
          oneData.pointId = worldBuildData.pointId
          oneData.posV2 = vecPos
          oneData.tileList = rangeList
          oneData.itemId = worldBuildData.itemId
          self.seasonBuildList[worldBuildData.uuid] = oneData
          if SceneUtils.GetIsInWorld() then
            local pointId = oneData.pointId
            local effectPathPut = "Assets/Main/Prefabs/World/Saiji/Eff_saiji_dsj_dikuai_fangzhi.prefab"
            local request = ResourceManager:InstantiateAsync(effectPathPut)
            if request then
              request:completed("+", function(req)
                if request.isError then
                  return
                end
                if request.gameObject then
                  request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
                  request.gameObject:SetActive(true)
                  request.gameObject.transform.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
                end
              end)
            end
          end
        end
      end
    end
  elseif worldBuildData.state == BuildingStateType.FoldUp then
    local vecPos = SceneUtils.IndexToTilePos(worldBuildData.pointId, ForceChangeScene.World)
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(worldBuildData.itemId)
    if buildTemplate ~= nil and (buildTemplate.tab_type == UIBuildListTabType.SeasonBuild or BuildingUtils.IsInEdenSubwayGroup(worldBuildData.itemId) == true) then
      local list = BuildingUtils.GetAllNeighborsPos4(vecPos, buildTemplate.tileX, buildTemplate.tileY)
      if list ~= nil then
        for k, v in pairs(list) do
          local pointId = SceneUtils.TilePosToIndex(v, ForceChangeScene.World)
          self.buildOccupyPointDic[pointId] = nil
        end
      end
    end
    self.seasonBuildList[worldBuildData.uuid] = nil
  elseif one then
    one.level = worldBuildData.level
  end
end

local function RemoveSeasonBuild(self, bUuid)
  if SeasonUtil.IsInSeasonDesertMode() == false then
    return
  end
  local item = self.seasonBuildList[bUuid]
  if item ~= nil then
    for k, v in pairs(item.tileList) do
      self.buildOccupyPointDic[v] = nil
    end
  end
  self.seasonBuildList[bUuid] = nil
end

local function GetDesertDataForShow(self)
  return self.desertPointDic
end

local function GetBuildIdByDesertPointId(self, pointId)
  return self.buildOccupyPointDic[pointId]
end

local function GetSelfDesertForceNum(self)
  local totalNum = 0
  local dic = DataCenter.DesertDataManager:GetAllMyDesert()
  if dic ~= nil then
    for k, v in pairs(dic) do
      totalNum = totalNum + v.force
    end
  end
  return totalNum
end

local function GetSeasonBuildList(self)
  return self.seasonBuildList
end

local function GetRewardByStageAndSubStage(self, index, subIndex, topRank)
  if self.seasonRewardList ~= nil then
    return self.seasonRewardList:GetRewardByStageAndSubStage(index, subIndex, topRank)
  end
  return nil
end

local function GetRewardListByStage(self, index, topRank)
  if self.seasonRewardList ~= nil then
    return self.seasonRewardList:GetRewardListByStage(index, topRank)
  end
  return {}
end

local function GetRewardMap(self, topRank)
  if self.seasonRewardList ~= nil then
    return self.seasonRewardList:GetRewardMap(topRank)
  end
  return {}
end

function DesertDataManager:GetDesertDataByPoint(pointIndex)
  return self.desertPointDic[pointIndex]
end

function DesertDataManager:GetDesertByLevel(level)
  if self.myDesertList ~= nil then
    for k, v in pairs(self.myDesertList) do
      if v.level == level then
        return v
      end
    end
  end
end

function DesertDataManager:GetBlockDesertWorldPos()
  if self.myDesertList ~= nil then
    local pos
    for k, v in pairs(self.myDesertList) do
      for x = 1, -1, -1 do
        for y = 1, -1, -1 do
          pos = SceneUtils.GetIndexByOffset(v.pointId, x, y, ForceChangeScene.World)
          local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(pos)
          if worldTileInfo ~= nil then
            local pointData = worldTileInfo:GetPointInfo()
            if pointData == nil then
              local desertInfo = worldTileInfo:GetWorldDesertInfo()
              if desertInfo ~= nil then
                local playerType = desertInfo:GetPlayerType()
                if playerType == CS.PlayerType.PlayerNone then
                  return SceneUtils.TileIndexToWorld(pos, ForceChangeScene.World)
                end
              end
            end
          end
        end
      end
    end
  end
end

function DesertDataManager:GetOwnDesertCountByLevel(level)
  local result = 0
  if self.myDesertList ~= nil then
    for k, v in pairs(self.myDesertList) do
      if v.level == level then
        result = result + 1
      end
    end
  end
  return result
end

local function GetNearestMyDesertPointId(self)
  local result
  local dis = IntMaxValue
  local selfPos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
  if self.myDesertList ~= nil then
    for k, v in pairs(self.myDesertList) do
      local worldPos = SceneUtils.IndexToTilePos(v.pointId, ForceChangeScene.World)
      local tmpDis = Vector2.Distance(selfPos, worldPos)
      if dis > tmpDis then
        dis = tmpDis
        result = v.pointId
      end
    end
  end
  return result
end

local function CheckIsSelfDesert(self, targetUuid)
  if self.desertPointDic[targetUuid] then
    return true
  end
  return false
end

local function CheckDesertFirstReward(self, lv)
  if self.desertFirstReward then
    for i = 1, table.count(self.desertFirstReward) do
      if self.desertFirstReward[i] ~= "" and lv == tonumber(self.desertFirstReward[i]) then
        return true
      end
    end
  end
  return false
end

local function GetDesertReward(self, desertId, lv, ownerUid)
  local firstRewardStr = GetTableData(TableName.Desert, desertId, "first_showreward")
  local trainRewardStr = GetTableData(TableName.Desert, desertId, "train_showreward")
  local showRewardStr = GetTableData(TableName.Desert, desertId, "showreward")
  local rewardList = {}
  local isFirst = 0
  local isFirstReward = self:CheckDesertFirstReward(lv)
  if isFirstReward and ownerUid == LuaEntry.Player.uid then
    rewardList = string.split(trainRewardStr, "|")
  elseif isFirstReward and ownerUid ~= LuaEntry.Player.uid then
    rewardList = string.split(showRewardStr, "|")
  elseif not isFirstReward then
    local firstList = string.split(firstRewardStr, "|")
    isFirst = table.count(firstList)
    rewardList = DataCenter.RewardManager:ConcatRewardList({firstRewardStr, showRewardStr}, nil)
  end
  return rewardList, isFirst
end

local function SetDesertRankList(self, message)
  if message.selfRanking then
    self.desertRankInfo.selfRanking = message.selfRanking
  end
  if message.serverRanking then
    self.desertRankInfo.rankList = {}
    local list = message.serverRanking
    for i = 1, table.count(list) do
      local param = {}
      param.country = list[i].country
      param.headSkinET = list[i].headSkinET
      param.monthCardEndTime = list[i].monthCardEndTime
      param.allianceName = list[i].alliancename
      param.pic = list[i].pic
      param.picVer = list[i].picVer
      param.allianceId = list[i].allianceId
      param.uid = list[i].uid
      param.headSkinId = list[i].headSkinId
      param.name = list[i].name
      param.rank = list[i].rank
      param.force = list[i].force
      param.allianceAbbr = list[i].abbr
      table.insert(self.desertRankInfo.rankList, param)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.DesertForceRank)
end

local function GetDesertRankList(self)
  return self.desertRankInfo
end

local function RefreshForceReward(self, arr)
  local ForceReward = require("DataCenter.DesertData.ForceReward")
  self.forceRewardList = {}
  if arr ~= nil then
    for k, v in pairs(arr) do
      local oneData = ForceReward.New()
      oneData:UpdateData(v)
      if oneData.rewardTime > 0 then
        if self.forceRewardList[oneData.rewardTime] == nil then
          self.forceRewardList[oneData.rewardTime] = {}
        end
        table.insert(self.forceRewardList[oneData.rewardTime], oneData)
      end
    end
  end
end

local function GetForceRewardList(self)
  return self.forceRewardList
end

local function RefreshHasOldCrystal(self, hasOldCrystal)
  self.hasOldCrystal = hasOldCrystal
end

local function GetHasOldCrystal(self)
  return self.hasOldCrystal
end

local function RefreshHasOldMoney(self, hasOldMoney)
  self.hasOldMoney = hasOldMoney
end

local function GetHasOldMoney(self)
  return self.hasOldMoney
end

local function GetSelfForceRank(self)
  return self.forceRank
end

local function SetSelfForceRank(self, rank)
  self.forceRank = rank
end

local function SetLastCollectTime(self, time)
  self.lastCollectTime = time
end

local function GetLastCollectTime(self)
  return self.lastCollectTime
end

local function GetSeasonResourceCollectSpeed(self, resourceType)
  local totalNum = 0
  local dic = self:GetAllMyDesert()
  if dic ~= nil then
    for k, v in pairs(dic) do
      if v and v.desert_res_type_table then
        totalNum = totalNum + (v.desert_res_type_table[resourceType] or 0)
      end
    end
    if totalNum ~= 0 then
      if resourceType == ResourceType.OBSIDIAN then
        totalNum = totalNum * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.SEASON_WEEK_CARD_FLINT_ADD_PERCENT30305) / 100)
      elseif resourceType == ResourceType.FLINT then
        totalNum = totalNum * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.FLINT_GATHER_ADD_PERCENT30232) / 100)
      end
    end
  end
  totalNum = totalNum * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.SEASON_DESERT_RES_94015))
  return totalNum
end

local function GetCanGatherResNum(self, totalGasSpeed, totalFlintSpeed, totalMetalSpeed, totalFoodSpeed)
  local time = self:GetLastCollectTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = (curTime - time) / 1000
  local gasNum = 0
  local flintNum = 0
  local metalNum = 0
  local foodNum = 0
  local k7 = LuaEntry.DataConfig:TryGetNum("season1_desert", "k7", 600)
  local maxTime = k7 * 60
  local k2 = LuaEntry.DataConfig:TryGetNum("season1_desert", "k2", 300)
  local minTime = k2
  if deltaTime > maxTime then
    deltaTime = maxTime
  end
  if minTime > deltaTime then
    deltaTime = 0
  end
  if 0 < deltaTime then
    gasNum = deltaTime * totalGasSpeed / 3600
    flintNum = deltaTime * totalFlintSpeed / 3600
    if totalMetalSpeed == nil and totalFoodSpeed == nil then
      return gasNum, flintNum, deltaTime
    end
    if totalMetalSpeed ~= nil then
      metalNum = deltaTime * totalMetalSpeed / 3600
      if totalFoodSpeed == nil then
        return gasNum, flintNum, metalNum, deltaTime
      end
    end
    if totalFoodSpeed ~= nil then
      foodNum = deltaTime * totalFoodSpeed / 3600
      if totalMetalSpeed == nil then
        return gasNum, flintNum, foodNum, deltaTime
      end
    end
    return gasNum, flintNum, metalNum, foodNum, deltaTime
  end
  return 0, 0, 0, 0, 0
end

local function GetRewardRed(self)
  local num = 0
  local data = self:GetSelfAllianceSeasonReward()
  if data ~= nil then
    local isSelfLeader = DataCenter.AllianceBaseDataManager:IsSelfLeader()
    if not isSelfLeader then
      local activityInfo = DataCenter.RobotWarsManager:GetActivityInfo()
      local selfData = self:GetSelfRewardData()
      if 0 < activityInfo.selfRewardStatus and selfData ~= nil and selfData.selfStatus == 1 then
        num = 1
      end
    end
  end
  return num
end

local function GiveUp(self, uuid, desertId, data, callback)
  local template = DataCenter.DesertTemplateManager:GetTemplate(desertId)
  local name = ""
  if data.level and data.level ~= 0 then
    name = Localization:GetString("science_condition", data.level, Localization:GetString(template.name))
  else
    name = Localization:GetString("110245")
  end
  local tilePos = SceneUtils.IndexToTilePos(data.pointId, ForceChangeScene.World)
  local posStr = "(" .. tostring(tilePos.x) .. "," .. tostring(tilePos.y) .. ")"
  if data.serverId then
    posStr = "#" .. data.serverId .. posStr
  end
  local msg = Localization:GetString("110239", name, posStr)
  UIUtil.TryShowConfirm(TodayNoSecondConfirmType.UserGiveUpDesert, msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    SFSNetwork.SendMessage(MsgDefines.UserGiveUpDesert, uuid, data.serverId)
    if callback then
      callback()
    end
  end, function()
  end, nil, nil, false, nil, nil)
end

local function CancelGiveUp(self, uuid, desertId, data, callback)
  SFSNetwork.SendMessage(MsgDefines.UserCancelGiveUpDesert, uuid, data.serverId)
  if callback then
    callback()
  end
end

local function GetLevelDifference(self, idA, idB)
  local levelA, levelB = 0, 0
  local templateA = DataCenter.DesertTemplateManager:GetTemplate(idA)
  if templateA then
    levelA = templateA.desert_level
  end
  local templateB = DataCenter.DesertTemplateManager:GetTemplate(idB)
  if templateB then
    levelB = templateB.desert_level
  end
  return math.abs(levelA - levelB)
end

DesertDataManager.__init = __init
DesertDataManager.__delete = __delete
DesertDataManager.InitDesertDataRequest = InitDesertDataRequest
DesertDataManager.UpdateDesertFirst = UpdateDesertFirst
DesertDataManager.UpdateAllDesertData = UpdateAllDesertData
DesertDataManager.CheckMyDesertNumIsFull = CheckMyDesertNumIsFull
DesertDataManager.GetSelfDesertDataByUuid = GetSelfDesertDataByUuid
DesertDataManager.GetSelfEmptyDesertDataByUuid = GetSelfEmptyDesertDataByUuid
DesertDataManager.UpdateOneDesertData = UpdateOneDesertData
DesertDataManager.RemoveMyDesert = RemoveMyDesert
DesertDataManager.Startup = Startup
DesertDataManager.CanBuildByPointId = CanBuildByPointId
DesertDataManager.GetSendGiftRecords = GetSendGiftRecords
DesertDataManager.SetSendGiftRecords = SetSendGiftRecords
DesertDataManager.OnGetSelfRewardCallBack = OnGetSelfRewardCallBack
DesertDataManager.GetSeasonRewardList = GetSeasonRewardList
DesertDataManager.InitDesertRewardList = InitDesertRewardList
DesertDataManager.GetSelfAllianceSendList = GetSelfAllianceSendList
DesertDataManager.SetSelfAllianceSendList = SetSelfAllianceSendList
DesertDataManager.SetSelfAllianceRewardPackageRestNum = SetSelfAllianceRewardPackageRestNum
DesertDataManager.GetSelfAllianceSeasonReward = GetSelfAllianceSeasonReward
DesertDataManager.GetSelfPackageId = GetSelfPackageId
DesertDataManager.GetAllMyDesert = GetAllMyDesert
DesertDataManager.GetDesertMaxNum = GetDesertMaxNum
DesertDataManager.RemoveSeasonBuild = RemoveSeasonBuild
DesertDataManager.UpdateSeasonBuildList = UpdateSeasonBuildList
DesertDataManager.GetDesertDataForShow = GetDesertDataForShow
DesertDataManager.GetSeasonBuildList = GetSeasonBuildList
DesertDataManager.GetSelfRewardData = GetSelfRewardData
DesertDataManager.GetRewardByStageAndSubStage = GetRewardByStageAndSubStage
DesertDataManager.GetRewardListByStage = GetRewardListByStage
DesertDataManager.GetSortList = GetSortList
DesertDataManager.GetBuildListIds = GetBuildListIds
DesertDataManager.CanPlaceAllianceBuildByPointId = CanPlaceAllianceBuildByPointId
DesertDataManager.DeleteTimer = DeleteTimer
DesertDataManager.AddTimer = AddTimer
DesertDataManager.GetNearestMyDesertPointId = GetNearestMyDesertPointId
DesertDataManager.CheckIsSelfDesert = CheckIsSelfDesert
DesertDataManager.CheckDesertFirstReward = CheckDesertFirstReward
DesertDataManager.GetDesertReward = GetDesertReward
DesertDataManager.SetDesertRankList = SetDesertRankList
DesertDataManager.GetDesertRankList = GetDesertRankList
DesertDataManager.RefreshForceReward = RefreshForceReward
DesertDataManager.RefreshHasOldCrystal = RefreshHasOldCrystal
DesertDataManager.GetHasOldCrystal = GetHasOldCrystal
DesertDataManager.RefreshHasOldMoney = RefreshHasOldMoney
DesertDataManager.GetHasOldMoney = GetHasOldMoney
DesertDataManager.GetForceRewardList = GetForceRewardList
DesertDataManager.SetSelfForceRank = SetSelfForceRank
DesertDataManager.GetSelfForceRank = GetSelfForceRank
DesertDataManager.SetLastCollectTime = SetLastCollectTime
DesertDataManager.GetLastCollectTime = GetLastCollectTime
DesertDataManager.GetSeasonResourceCollectSpeed = GetSeasonResourceCollectSpeed
DesertDataManager.GetCanGatherResNum = GetCanGatherResNum
DesertDataManager.CheckShowResourceRedDot = CheckShowResourceRedDot
DesertDataManager.GetShowResourceRedDot = GetShowResourceRedDot
DesertDataManager.GetSelfDesertForceNum = GetSelfDesertForceNum
DesertDataManager.GetSelfSeverDesert = GetSelfSeverDesert
DesertDataManager.GetOtherSeverDesert = GetOtherSeverDesert
DesertDataManager.CanPlaceAllianceCenterByPointId = CanPlaceAllianceCenterByPointId
DesertDataManager.GetRewardMap = GetRewardMap
DesertDataManager.GetRewardRed = GetRewardRed
DesertDataManager.GiveUp = GiveUp
DesertDataManager.CancelGiveUp = CancelGiveUp
DesertDataManager.GetLevelDifference = GetLevelDifference
DesertDataManager.CanPlaceEdenWormByPointId = CanPlaceEdenWormByPointId
DesertDataManager.GetBuildIdByDesertPointId = GetBuildIdByDesertPointId
return DesertDataManager
