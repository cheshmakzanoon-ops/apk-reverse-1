local ValentineSendGiftListData = BaseClass("ValentineSendGiftListData")
local DATA_CACHE_EXPIRE_TIME = 300
local SINGLE_REQ_DATA_COUNT = 20

local function __init(self)
  self:AddListener()
  self.activityId = 0
  self.scope = ValentineSendGiftScope.SelfServer
  self.gender = GenderFilterType.All
  self.dataList = {}
  self.lastUpdateTimestamp = 0
  self.maxPlayerDataNum = Mathf.Infinity
  self.uidMap = {}
end

local function __delete(self)
  self:RemoveListener()
  self.activityId = nil
  self.scope = nil
  self.gender = nil
  self.dataList = nil
  self.lastUpdateTimestamp = nil
  self.maxPlayerDataNum = nil
  self.uidMap = nil
end

local function AddListener(self)
end

local function RemoveListener(self)
end

function ValentineSendGiftListData:Init(activityId, scope, gender)
  self.activityId = activityId
  self.scope = scope
  self.gender = gender
end

function ValentineSendGiftListData:ReqData(startIndex, endIndex)
  local curTime = UITimeManager:GetInstance():GetServerTime() / 1000
  local isDataCacheExpired = curTime - self.lastUpdateTimestamp > DATA_CACHE_EXPIRE_TIME
  if not isDataCacheExpired and endIndex <= #self.dataList then
    return self.dataList
  end
  if isDataCacheExpired then
    self.maxPlayerDataNum = Mathf.Infinity
  end
  if startIndex >= self.maxPlayerDataNum then
    EventManager:GetInstance():Broadcast(EventId.ValentineSendGiftListDataFail)
    return
  end
  endIndex = math.min(endIndex, self.maxPlayerDataNum)
  if self.scope == ValentineSendGiftScope.SelfServer then
    SFSNetwork.SendMessage(MsgDefines.ValentineSendLocalRank, self.activityId, self.gender, startIndex, endIndex)
  elseif self.scope == ValentineSendGiftScope.ZoneServer then
    SFSNetwork.SendMessage(MsgDefines.ValentineSendGroupRank, self.activityId, self.gender, startIndex, endIndex)
  elseif self.scope == ValentineSendGiftScope.Alliance then
    SFSNetwork.SendMessage(MsgDefines.ValentineSendAllianceRank, self.activityId, self.gender)
  end
end

function ValentineSendGiftListData:UpdateData(startIndex, endIndex, data, npcArr)
  if (not data or #data <= 0) and (not npcArr or #npcArr <= 0) then
    EventManager:GetInstance():Broadcast(EventId.ValentineSendGiftListDataFail)
    self.maxPlayerDataNum = table.count(self.dataList)
    return
  end
  if self.dataList and 0 < #self.dataList then
    local count = #self.dataList
    for i = count, 1, -1 do
      local player = self.dataList[i]
      if player.npcId and 0 < player.npcId then
        table.remove(self.dataList, i)
      end
    end
  end
  if data and 0 < #data then
    local index = 1
    for i = startIndex, endIndex do
      local player = data[index]
      if player then
        local isExit = self.uidMap[player.playerUid]
        if not isExit then
          table.insert(self.dataList, player)
          self.uidMap[player.playerUid] = true
        else
          for j = 1, #self.dataList do
            local cache = self.dataList[j]
            if cache.playerUid == player.playerUid then
              self.dataList[j] = player
              break
            end
          end
        end
      end
      index = index + 1
    end
  end
  if self.dataList then
    table.sort(self.dataList, function(a, b)
      return a.playerRank < b.playerRank
    end)
  end
  if npcArr and 0 < #npcArr then
    table.sort(npcArr, function(a, b)
      return a.rank < b.rank
    end)
    for i, v in ipairs(npcArr) do
      local npc = v
      if npc and npc.rank <= #self.dataList then
        local npcData = DataCenter.ValentineDataManager:UpdateNpcData(npc)
        if not npcData:IsComplete() then
          table.insert(self.dataList, npc.rank, npc)
        end
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ValentineSendGiftListDataUpdate, self.dataList)
  self.lastUpdateTimestamp = UITimeManager:GetInstance():GetServerTime() / 1000
end

function ValentineSendGiftListData:GetDataByIndex(targetIndex)
  if #self.dataList <= 0 then
    return nil
  end
  if targetIndex > #self.dataList then
    local startIndex = #self.dataList + 1
    local endIndex = startIndex + SINGLE_REQ_DATA_COUNT - 1
    self:ReqData(startIndex, endIndex)
    return nil
  end
  return self.dataList[targetIndex]
end

ValentineSendGiftListData.__init = __init
ValentineSendGiftListData.__delete = __delete
ValentineSendGiftListData.AddListener = AddListener
ValentineSendGiftListData.RemoveListener = RemoveListener
return ValentineSendGiftListData
