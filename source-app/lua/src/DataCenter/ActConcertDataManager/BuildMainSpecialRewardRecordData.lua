local BuildMainSpecialRewardRecordData = BaseClass("BuildMainSpecialRewardRecordData")

function BuildMainSpecialRewardRecordData:__init()
  self.playerUid = 0
  self.statusId = 0
  self.endTimestamp = 0
end

function BuildMainSpecialRewardRecordData:ParseData(param)
  if param == nil then
    return
  end
  if param.playerUid then
    self.playerUid = param.playerUid
  end
  if param.statusId then
    self.statusId = param.statusId
  end
  if param.endTimestamp then
    self.endTimestamp = param.endTimestamp
  end
end

return BuildMainSpecialRewardRecordData
