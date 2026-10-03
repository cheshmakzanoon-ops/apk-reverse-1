local OffSeasonDigGameOpenPushMessage = BaseClass("OffSeasonDigGameOpenPushMessage", SFSBaseMessage)
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
    local map = DataCenter.OffSeasonDiggingDataManager:GetMapDataByUuid(t.uuid)
    needUpdateState = needUpdateState or map and map.type == SeasonDigGameType.Single
    if map and needUpdateState then
      map:UpdateRewardState(t.rewardState)
    end
    DataCenter.OffSeasonDiggingDataManager:UpdateMapRedCount(true)
  end
  local mapData = DataCenter.OffSeasonDiggingDataManager.curMapData
  if not mapData or mapData.uuid ~= t.uuid then
    return
  end
  local brickInfo = {
    pos = t.pos,
    blockInfo = t.blockInfo
  }
  mapData.brickDic[t.pos] = brickInfo
  if t.blockInfo then
    local blockInfo = DataCenter.OffSeasonDiggingDataManager:GetBlock(t.blockInfo.bid, mapData.blockInfo)
    local levelConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(mapData.mapConfigId)
    local config = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(t.blockInfo.bid)
    if levelConfig and config then
      local get = DataCenter.OffSeasonDiggingDataManager:CheckBlockGet(t.blockInfo.pos, mapData.brickDic, levelConfig.num_width, config.size_width, config.size_height)
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
  DataCenter.OffSeasonDiggingDataManager:OnOpenBrick(t, isSelfClick)
end

OffSeasonDigGameOpenPushMessage.OnCreate = OnCreate
OffSeasonDigGameOpenPushMessage.HandleMessage = HandleMessage
return OffSeasonDigGameOpenPushMessage
