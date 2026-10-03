local SeasonDigGameOpenPushMessage = BaseClass("SeasonDigGameOpenPushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  local isSelfClick = not t.playerInfo or t.playerInfo.uid == LuaEntry.Player.uid
  local needUpdateState = isSelfClick
  if t.reward or t.resource then
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
  if t.rewardState then
    local map = DataCenter.DiggingDataManager:GetMapDataByUuid(t.uuid)
    needUpdateState = needUpdateState or map and map.type == SeasonDigGameType.Single
    if map and needUpdateState then
      map:UpdateRewardState(t.rewardState)
    end
    DataCenter.DiggingDataManager:UpdateMapRedCount(true)
  end
  local mapData = DataCenter.DiggingDataManager.curMapData
  if not mapData or mapData.uuid ~= t.uuid then
    return
  end
  local brickInfo = {
    pos = t.pos,
    blockInfo = t.blockInfo
  }
  mapData.brickDic[t.pos] = brickInfo
  if t.blockInfo then
    local blockInfo = DataCenter.DiggingDataManager:GetBlock(t.blockInfo.bid, mapData.blockInfo)
    local levelConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(mapData.mapConfigId)
    local config = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(t.blockInfo.bid)
    if levelConfig and config then
      local get = DataCenter.DiggingDataManager:CheckBlockGet(t.blockInfo.pos, mapData.brickDic, levelConfig.num_width, config.size_width, config.size_height)
      t.blockInfo.get = get
      if blockInfo then
        blockInfo.get = get
      else
        table.insert(mapData.blockInfo, t.blockInfo)
      end
    end
    if mapData.type == SeasonDigGameType.Single then
      t.playerInfo = nil
    end
  else
  end
  if t.playerInfo then
    brickInfo.playerInfo = t.playerInfo
  end
  if needUpdateState and t.rewardState and mapData.rewardState ~= t.rewardState then
    mapData.rewardState = t.rewardState
  end
  DataCenter.DiggingDataManager:OnOpenBrick(t, isSelfClick)
end

local function GetTestData(self, uuid, uid, pos, type_)
  local mapData = DataCenter.DiggingDataManager.__Cache[uuid]
  if mapData == nil then
    return
  end
  local t = {}
  t.uuid = uuid
  t.pos = pos
  t.isBlock = 0
  if mapData.type == SeasonDigGameType.Single then
    for k, v in pairs(mapData.personalOpenInfo) do
      if v == pos then
        return
      end
    end
  else
    for k, v in pairs(mapData.allianceOpenInfo) do
      if v.pos == pos then
        return
      end
    end
    local selfInfo = LuaEntry.Player
    t.playerInfo = {
      uid = selfInfo.uid,
      name = selfInfo.name,
      pic = selfInfo.pic,
      picVer = selfInfo.picVer
    }
  end
  local getBlock = false
  local levelConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(mapData.mapConfigId)
  local width = levelConfig.num_width
  local height = levelConfig.num_height
  local x, y = DataCenter.DiggingDataManager:GetPosByIndex(pos, width)
  for k, v in pairs(mapData.blockInfo) do
    local config = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(v.bid)
    local blockWidth = config.size_width
    local blockHeight = config.size_height
    local targetX, targetY = DataCenter.DiggingDataManager:GetPosByIndex(v.pos, width)
    if targetX < x + 1 and x < targetX + blockWidth and targetY < y + 1 and y < targetY + blockHeight then
      getBlock = true
      t.isBlock = 1
      t.blockInfo = v
      break
    end
  end
  if mapData.type == SeasonDigGameType.Single then
    table.insert(mapData.personalOpenInfo, pos)
  else
    table.insert(mapData.allianceOpenInfo, {
      pos = pos,
      playerInfo = t.playerInfo
    })
  end
  if mapData.type == SeasonDigGameType.Single then
    if mapData.uid ~= LuaEntry.Player.uid then
      t.reward = {
        [1] = {
          type = RewardType.GOODS,
          value = {
            uuid = "5497731772507372",
            count = 6545,
            itemId = "200201",
            otherPara = "",
            para1 = "1",
            para2 = "1",
            para3 = "300",
            rewardAdd = 10,
            use = "0"
          }
        }
      }
    elseif mapData.rewardState == 0 then
      getBlock = true
      local brickDic = {}
      for k, v in pairs(mapData.personalOpenInfo) do
        brickDic[v] = {pos = v}
      end
      for k, v in pairs(mapData.blockInfo) do
        local config = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(v.bid)
        local blockWidth = config.size_width
        local blockHeight = config.size_height
        if not DataCenter.DiggingDataManager:CheckBlockGet(v.pos, brickDic, width, blockWidth, blockHeight) then
          getBlock = false
          break
        end
      end
      if getBlock then
        t.rewardState = 2
      end
    end
  elseif mapData.type == SeasonDigGameType.Alliance then
    if getBlock then
      if mapData.rewardState == 0 then
        t.rewardState = 2
      end
    else
      t.reward = {
        [1] = {
          type = RewardType.GOODS,
          value = {
            uuid = "5497731772507372",
            count = 6545,
            itemId = "200202",
            otherPara = "",
            para1 = "1",
            para2 = "1",
            para3 = "300",
            rewardAdd = 10,
            use = "0"
          }
        }
      }
      t.rewardState = 1
    end
  end
  if t.rewardState then
    mapData.rewardState = t.rewardState
  end
  return t
end

SeasonDigGameOpenPushMessage.GetTestData = GetTestData
SeasonDigGameOpenPushMessage.OnCreate = OnCreate
SeasonDigGameOpenPushMessage.HandleMessage = HandleMessage
return SeasonDigGameOpenPushMessage
