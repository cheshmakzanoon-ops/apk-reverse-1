local AllianceStorageManager = BaseClass("AllianceStorageManager")
local StorageContent = {
  RewardType.ALLIANCE_POINT,
  RewardType.SAPPHIRE
}

function AllianceStorageManager:__init()
  self.resInfoDic = {}
  self.recordList = {}
end

function AllianceStorageManager:__delete()
  self.resInfoDic = nil
  self.recordList = nil
end

function AllianceStorageManager:GetAlStorageContent()
  return StorageContent
end

function AllianceStorageManager:UpdateStorageInfo(t)
  if t.money then
    self.resInfoDic[RewardType.FOOD] = t.money
  end
  if t.electricity then
    self.resInfoDic[RewardType.ELECTRICITY] = t.electricity
  end
  if t.crystal then
    self.resInfoDic[RewardType.METAL] = self.crystal
  end
  if t.sapphire then
    self.resInfoDic[RewardType.SAPPHIRE] = t.sapphire
  end
  if t.lastRefreshTime then
    self.lastRefreshTime = t.lastRefreshTime
  end
  if t.storeLogArr then
    self.recordList = {}
    table.walk(t.storeLogArr, function(k, v)
      local info = AllianceStorageRecordData.New()
      info:ParseData(v)
      table.insert(self.recordList, info)
    end)
  end
  table.sort(self.recordList, function(a, b)
    return a.time > b.time
  end)
  EventManager:GetInstance():Broadcast(EventId.OnRecvAllianceStorageInfo)
end

function AllianceStorageManager:CheckAllianceStorage()
  if not LuaEntry.Player:IsInAlliance() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GetAllianceStorageInfo)
end

function AllianceStorageManager:GetResCountByRewardType(rewardType)
  if rewardType == RewardType.ALLIANCE_POINT then
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    return data and data.alliancePoint or 0
  else
    return self.resInfoDic[rewardType] or 0
  end
end

function AllianceStorageManager:GetStorageRecords()
  return self.recordList
end

return AllianceStorageManager
