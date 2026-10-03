local LWFireworkGiftRecordPlayerInfo = BaseClass("LWFireworkGiftRecordPlayerInfo")

function LWFireworkGiftRecordPlayerInfo:__init()
  self.uid = 0
  self.name = ""
  self.pic = ""
  self.picVer = 0
  self.headSkinId = nil
  self.headSkinET = nil
  self.level = 0
  self.gender = 0
  self.time = 0
  self.isDouble = false
  self.rewardInfo = nil
end

function LWFireworkGiftRecordPlayerInfo:__delete()
  self.uid = nil
  self.name = nil
  self.pic = nil
  self.picVer = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.level = nil
  self.gender = nil
  self.time = nil
  self.isDouble = nil
  self.rewardInfo = nil
end

function LWFireworkGiftRecordPlayerInfo:InitData(message)
  if message.uid then
    self.uid = message.uid
  end
  if message.name then
    self.name = message.name
  end
  if message.pic then
    self.pic = message.pic
  end
  if message.picVer then
    self.picVer = message.picVer
  end
  if message.headSkinId then
    self.headSkinId = message.headSkinId
  end
  if message.headSkinET then
    self.headSkinET = message.headSkinET
  end
  if message.level then
    self.level = message.level
  end
  if message.gender then
    self.gender = message.gender
  end
  if message.time then
    self.time = message.time
  end
  if message.isDouble then
    self.isDouble = message.isDouble
  end
  if message.rewardInfo then
    self.rewardInfo = message.rewardInfo
  end
end

return LWFireworkGiftRecordPlayerInfo
