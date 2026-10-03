local OffSeasonDiggingDataManager = BaseClass("OffSeasonDiggingDataManager")
local DiggingInfoData = require("DataCenter.OffSeasonDiggingGame.OffSeasonDiggingInfoData")
local Localization = CS.GameEntry.Localization

function OffSeasonDiggingDataManager:__init()
  self.activityId = nil
  self.mapList = nil
  self.curMapData = nil
  self.redNum = 0
end

function OffSeasonDiggingDataManager:__delete()
  self.activityId = nil
end

function OffSeasonDiggingDataManager:InitData(data)
  self.activityId = data.id
  SFSNetwork.SendMessage(MsgDefines.OffSeasonDigActivityInfo)
end

function OffSeasonDiggingDataManager:IsActive()
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data then
    return DataCenter.ActivityListDataManager:CheckIsSend(data)
  end
  return false
end

function OffSeasonDiggingDataManager:GetActivityData()
  if not self:IsActive() then
    return
  end
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
end

function OffSeasonDiggingDataManager:OpenMainUI()
  if not self:IsActive() then
    UIUtil.ShowTipsId("parkour_260_no_treasure")
    return
  end
  local strTitle = Localization:GetString("activity_parkour_name")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.activityId, strTitle)
end

function OffSeasonDiggingDataManager:GetMapList()
  return self.mapList or {}
end

function OffSeasonDiggingDataManager:GetMapDataByUuid(uuid)
  if not self.mapList then
    return
  end
  for i, v in ipairs(self.mapList) do
    if v.uuid == uuid then
      return v
    end
  end
end

function OffSeasonDiggingDataManager:UpdateMapRedCount(forceChange)
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

function OffSeasonDiggingDataManager:GetRedCount()
  return self.redNum
end

function OffSeasonDiggingDataManager:GetPosByIndex(pos, numWidth)
  local x = (pos - 1) % numWidth
  local y = math.floor((pos - 1) / numWidth)
  return x, y
end

function OffSeasonDiggingDataManager:GetIndexByPos(x, y, numWidth)
  return y * numWidth + x + 1
end

function OffSeasonDiggingDataManager:GetBlock(blockId, blockInfo)
  for i, v in ipairs(blockInfo) do
    if v.bid == blockId then
      return v
    end
  end
  return nil
end

function OffSeasonDiggingDataManager:GetBlockByPos(pos, blockInfo, numWidth)
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

function OffSeasonDiggingDataManager:GetBrickListByBlock(pos, brickDic, numWidth, bid)
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

function OffSeasonDiggingDataManager:CheckBlockGet(pos, brickDic, numWidth, sizeWidth, sizeHeight)
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

function OffSeasonDiggingDataManager:CheckDigPosIsBlock(pos, brickDic, numWidth, sizeWidth, sizeHeight, digPos)
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

function OffSeasonDiggingDataManager:OpenDiggingMap(uuid)
  if uuid == nil then
    return
  end
  if self.lastClickTime ~= nil and UITimeManager:GetInstance():GetServerTime() - self.lastClickTime < 300 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.OffSeasonDigGameInfo, uuid)
end

function OffSeasonDiggingDataManager:OpenBrick(uuid, pos)
  local mapData = self.curMapData
  if not mapData or mapData.uuid ~= uuid then
    return false
  end
  if self.lastClickTime ~= nil and UITimeManager:GetInstance():GetServerTime() - self.lastClickTime < 50 then
    return true
  end
  if mapData.rewardState and mapData.rewardState > 0 then
    UIUtil.ShowTipsId("parkour_260_desc26")
    return false
  end
  SFSNetwork.SendMessage(MsgDefines.OffSeasonDigGameOpen, uuid, pos)
  return true
end

function OffSeasonDiggingDataManager:OnMapListUpdate(message)
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

function OffSeasonDiggingDataManager:OnOpenBrick(t, isSelfClick)
  if isSelfClick then
    self.lastClickTime = UITimeManager:GetInstance():GetServerTime()
  end
  EventManager:GetInstance():Broadcast(EventId.DiggingGameOpen, t)
end

function OffSeasonDiggingDataManager:OnGetReward(message)
  if message.reward or message.resource then
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.RewardManager:ShowCommonReward(message)
  end
  local mapData = self.curMapData
  if mapData and mapData.uuid == message.uuid then
    mapData.rewardState = 2
  end
  self:UpdateMapRedCount()
  EventManager:GetInstance():Broadcast(EventId.DiggingGameMapDataGetReward, message.uuid)
end

return OffSeasonDiggingDataManager
