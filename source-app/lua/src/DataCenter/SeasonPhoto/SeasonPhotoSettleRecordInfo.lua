local SeasonPhotoSettleRecordInfo = BaseClass("SeasonPhotoSettleRecordInfo")

function SeasonPhotoSettleRecordInfo:__init()
  self.season = 0
  self.allianceId = ""
  self.settleType = 0
  self.recordTime = 0
  self.modifyPicTime = 0
  self.commentTime = 0
end

function SeasonPhotoSettleRecordInfo:__delete()
  self.season = nil
  self.allianceId = nil
  self.settleType = nil
  self.recordTime = nil
  self.modifyPicTime = nil
  self.commentTime = nil
end

function SeasonPhotoSettleRecordInfo:UpdateData(message)
  if message == nil then
    return
  end
  if message.season ~= nil then
    self.season = message.season
  end
  if message.allianceId ~= nil then
    self.allianceId = message.allianceId
  end
  if message.settleType ~= nil then
    self.settleType = message.settleType
  end
  if message.recordTime ~= nil then
    self.recordTime = message.recordTime
  end
  if message.modifyPicTime ~= nil then
    self.modifyPicTime = message.modifyPicTime
  end
  if message.commentTime ~= nil then
    self.commentTime = message.commentTime
  end
  self.id = DataCenter.SeasonPhotoManager:GetPhotoId(self.season, self.allianceId)
end

return SeasonPhotoSettleRecordInfo
