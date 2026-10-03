local SeasonAllianceLootRewardData = BaseClass("SeasonAllianceLootRewardData")
local Localization = CS.GameEntry.Localization

function SeasonAllianceLootRewardData:__init()
  self.uuid = nil
  self.sender = nil
  self.receiver = nil
  self.time = nil
  self.eventId = nil
  self.type = 2
  self.count = 0
end

function SeasonAllianceLootRewardData:__delete()
  self.uuid = nil
  self.sender = nil
  self.receiver = nil
  self.time = nil
  self.eventId = nil
  self.count = 0
end

function SeasonAllianceLootRewardData:ParseMsg(message)
  if message.uuid then
    self.uuid = message.uuid
  end
  if message.sender then
    self.sender = message.sender
  end
  if message.receiver then
    self.receiver = message.receiver
  end
  if message.event_id then
    self.eventId = message.event_id
  end
  if message.time then
    self.time = message.time
  end
  if message.count then
    self.count = message.count
  end
end

function SeasonAllianceLootRewardData:GetSenderName()
  return UIUtil.FormatAllianceAndName(self.sender.abbr, self.sender.name)
end

function SeasonAllianceLootRewardData:GetReceiverName()
  return UIUtil.FormatAllianceAndName(self.receiver.abbr, self.receiver.name)
end

function SeasonAllianceLootRewardData:GetRankName()
  local heroEventMeta = LocalController:instance():getLine(TableName.HeroEvent, self.eventId)
  if heroEventMeta then
    return Localization:GetString(heroEventMeta.name)
  end
  return ""
end

function SeasonAllianceLootRewardData:GetSenderHeadInfo()
  return {
    uid = self.sender.uid,
    pic = self.sender.headPic,
    picVer = self.sender.headPicVer,
    headSkinId = self.sender.headSkinId,
    headSkinET = self.sender.headSkinET
  }
end

return SeasonAllianceLootRewardData
