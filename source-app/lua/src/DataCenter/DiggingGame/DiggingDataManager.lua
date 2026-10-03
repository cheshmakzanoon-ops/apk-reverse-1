local DiggingDataManager = BaseClass("DiggingDataManager")
local DiggingInfoData = require("DataCenter.DiggingGame.DiggingInfoData")

function DiggingDataManager:__init()
  self.activityId = nil
  self.useItemId = 0
  self.helpNumMax = 0
  self.helpRewardId = nil
  self.shardTimeCd = 0
  self.mapList = nil
  self.curMapData = nil
  self.redNum = 0
  self:AddListener()
end

function DiggingDataManager:__delete()
  self.activityId = nil
  self:RemoveListener()
end

function DiggingDataManager:Startup()
end

function DiggingDataManager:AddListener()
end

function DiggingDataManager:RemoveListener()
end

function DiggingDataManager:InitData(data)
  self.activityId = data.id
  local activity = self:GetActivityData()
  if activity then
    self.useItemId = activity.para_1 and tonumber(activity.para_1) or 0
    self.helpNumMax = activity.para_2 and tonumber(activity.para_2) or 0
    self.helpRewardId = activity.para_3 and tonumber(activity.para_3) or 0
    self.shardTimeCd = activity.para_4 and tonumber(activity.para_4) * 1000 or 0
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonDigActivityInfo)
end

function DiggingDataManager:GetConfigData(configId)
end

function DiggingDataManager:GetConfigDataByServerId(serverId)
end

function DiggingDataManager:IsActive(includePrepare)
  return SeasonUtil.IsSeasonActivityOpen(self.activityId, SeasonMapType.Mummy, includePrepare)
end

function DiggingDataManager:GetActivityData(includePrepare)
  if not self:IsActive(includePrepare) then
    return
  end
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
end

function DiggingDataManager:GetActivityGroup()
  local activityData = self:GetActivityData()
  if not activityData then
    return
  end
  return activityData.para and tonumber(activityData.para) or 0
end

function DiggingDataManager:GetMapList()
  return self.mapList or {}
end

function DiggingDataManager:GetMapDataByUuid(uuid)
  if not self.mapList then
    return
  end
  for i, v in ipairs(self.mapList) do
    if v.uuid == uuid then
      return v
    end
  end
end

function DiggingDataManager:UpdateMapRedCount(forceChange)
  local count = 0
  if self.mapList then
    for i, v in ipairs(self.mapList) do
      if 0 < v.redNum then
        count = count + 1
      end
    end
  end
  if forceChange or self.redNum ~= count then
    self.redNum = count
    EventManager:GetInstance():Broadcast(EventId.DiggingGameRedUpdate)
  end
  return count
end

function DiggingDataManager:GetRedCount()
  return self.redNum
end

function DiggingDataManager:GetPosByIndex(pos, numWidth)
  local x = (pos - 1) % numWidth
  local y = math.floor((pos - 1) / numWidth)
  return x, y
end

function DiggingDataManager:GetIndexByPos(x, y, numWidth)
  return y * numWidth + x + 1
end

function DiggingDataManager:GetBlock(blockId, blockInfo)
  for i, v in ipairs(blockInfo) do
    if v.bid == blockId then
      return v
    end
  end
  return nil
end

function DiggingDataManager:GetBlockByPos(pos, blockInfo, numWidth)
  local blockConfig
  local x, y = self:GetPosByIndex(pos, numWidth)
  for i, v in ipairs(blockInfo) do
    blockConfig = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(v.bid)
    if blockConfig then
      local bx, by = self:GetPosByIndex(v.pos, numWidth)
      if x >= bx and x < bx + blockConfig.size_width and y >= by and y < by + blockConfig.size_height then
        return v
      end
    end
  end
  return false
end

function DiggingDataManager:GetBrickListByBlock(pos, brickDic, numWidth, bid)
  local brickList = {}
  local blockConfig = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(bid)
  if not blockConfig then
    return brickList
  end
  local x, y = self:GetPosByIndex(pos, numWidth)
  for i = x, x + blockConfig.size_width - 1 do
    for j = y, y + blockConfig.size_height - 1 do
      local index = self:GetIndexByPos(i, j, numWidth)
      local brick = brickDic[index]
      if brick then
        table.insert(brickList, brick)
      end
    end
  end
  return brickList
end

function DiggingDataManager:CheckBlockGet(pos, brickDic, numWidth, sizeWidth, sizeHeight)
  if not pos or not brickDic then
    return false
  end
  local x, y = self:GetPosByIndex(pos, numWidth)
  for i = x, x + sizeWidth - 1 do
    for j = y, y + sizeHeight - 1 do
      local index = self:GetIndexByPos(i, j, numWidth)
      if not brickDic[index] then
        return false
      end
    end
  end
  return true
end

function DiggingDataManager:CheckDigPosIsBlock(pos, brickDic, numWidth, sizeWidth, sizeHeight, digPos)
  if not pos or not brickDic then
    return false
  end
  local x, y = self:GetPosByIndex(pos, numWidth)
  for i = x, x + sizeWidth - 1 do
    for j = y, y + sizeHeight - 1 do
      local index = self:GetIndexByPos(i, j, numWidth)
      if index == digPos then
        return true
      end
    end
  end
  return false
end

function DiggingDataManager:GetBlockSize(sizeTile)
  return 140 * sizeTile + (sizeTile - 1) * 2
end

function DiggingDataManager:GetGridSize(width, height)
  local maxSize = math.max(width, height)
  return (225 - (maxSize - 1) * 5) / maxSize
end

function DiggingDataManager:OpenDiggingMap(uuid, uid_, type_)
  if uuid == nil then
    return
  end
  if self.lastClickTime ~= nil and UITimeManager:GetInstance():GetServerTime() - self.lastClickTime < 300 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonDigGameInfo, uuid, type_, uid_)
end

function DiggingDataManager:OpenBrick(uuid, uid, pos, type_)
  local mapData = self.curMapData
  if not mapData or mapData.uuid ~= uuid then
    return false
  end
  if self.lastClickTime ~= nil and UITimeManager:GetInstance():GetServerTime() - self.lastClickTime < 50 then
    return true
  end
  if type_ == SeasonDigGameType.Single then
    if mapData.rewardState and mapData.rewardState > 0 then
      UIUtil.ShowTipsId("season_activity_1000070_desc28")
      return false
    end
    local own = DataCenter.ItemData:GetItemCount(self.useItemId)
    if own <= 0 then
      LWResourceLackUtil:GotoGoodsItemLack(self.useItemId, 1)
      UIUtil.ShowTipsId("season_activity_1000070_desc34")
      return false
    end
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.DiggingGameUseItem, CS.GameEntry.Localization:GetString("season_activity_1000070_desc33"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.SeasonDigGameOpen, uuid, uid, pos, type_)
    end, function()
    end, nil, nil, false, nil, nil)
  else
    if mapData.rewardState and mapData.rewardState > 0 then
      UIUtil.ShowTipsId("season_activity_1000070_desc26")
      return false
    end
    SFSNetwork.SendMessage(MsgDefines.SeasonDigGameOpen, uuid, uid, pos, type_)
  end
  return true
end

function DiggingDataManager:ShareMap(uuid, mapConfigId, uid, endTime)
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < self.shardTime + self.shardTimeCd then
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString("season_activity_1000070_desc29", math.ceil((self.shardTime + self.shardTimeCd - now) / 1000)))
    return
  end
  if self.helpNum >= self.helpNumMax then
    UIUtil.ShowTipsId("season_activity_1000070_desc27")
    return
  end
  local map = DataCenter.DiggingDataManager:GetMapDataByUuid(uuid)
  if not map then
    return
  end
  local share_param = {}
  share_param.postType = PostType.DiggingGameShareSingle
  share_param.uuid = uuid
  share_param.uid = uid
  share_param.mapConfigId = mapConfigId
  share_param.endTime = endTime
  share_param.tipText = "season_activity_1000070_desc18"
  local chatData = {}
  chatData.post = share_param.postType
  chatData.postType = share_param.postType
  chatData.param = share_param
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, chatData)
end

function DiggingDataManager:OnMapListUpdate(message)
  self.helpNum = message.helpNum or 0
  self.shardTime = message.shardTime or 0
  self.mapList = {}
  if message.mapList then
    for i, v in ipairs(message.mapList) do
      local data = DiggingInfoData.New()
      data:UpdateData(v)
      self.mapList[i] = data
    end
  end
  table.sort(self.mapList, function(a, b)
    if a.order ~= b.order then
      return a.order < b.order
    end
    return a.endTime < b.endTime
  end)
  EventManager:GetInstance():Broadcast(EventId.DiggingGameMapListInfo)
  self:UpdateMapRedCount()
end

function DiggingDataManager:OnOpenBrick(t, isSelfClick)
  if isSelfClick then
    self.lastClickTime = UITimeManager:GetInstance():GetServerTime()
  end
  EventManager:GetInstance():Broadcast(EventId.DiggingGameOpen, t)
end

function DiggingDataManager:OnGetReward(message)
  if message.reward or message.resource then
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.RewardManager:ShowCommonReward(message)
  end
  local mapData = self.curMapData
  if mapData and mapData.uuid == message.uuid then
    mapData.rewardState = 2
  end
  local map = self:GetMapDataByUuid(message.uuid)
  if map then
    map:UpdateRewardState(2)
    if map.type == SeasonDigGameType.Single and self.mapList then
      for i, v in ipairs(self.mapList) do
        if v.uuid == message.uuid then
          table.remove(self.mapList, i)
          EventManager:GetInstance():Broadcast(EventId.DiggingGameMapListInfo)
          break
        end
      end
    end
  end
  self:UpdateMapRedCount()
  EventManager:GetInstance():Broadcast(EventId.DiggingGameMapDataGetReward, message.uuid)
end

function DiggingDataManager:SetShareTime(shareTime)
  self.shardTime = shareTime or 0
end

return DiggingDataManager
