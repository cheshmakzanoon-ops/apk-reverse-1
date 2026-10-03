local DetectEventTreasureClaimPlayerInfo = BaseClass("DetectEventTreasureClaimPlayerInfo")

function DetectEventTreasureClaimPlayerInfo:__init()
  self.uid = 0
  self.name = ""
  self.headPic = ""
  self.headPicVer = 0
  self.headSkinId = nil
  self.headSkinET = nil
  self.level = 0
  self.gender = 0
  self.costTime = 0
  self.isBigReward = false
  self.reward = nil
  self.bigRewardMultiple = nil
  self.hasLuckSiphonbuff = nil
  self.luckSiphonbuffSenderInfo = nil
end

function DetectEventTreasureClaimPlayerInfo:__delete()
  self.uid = nil
  self.name = nil
  self.headPic = nil
  self.headPicVer = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.level = nil
  self.gender = nil
  self.costTime = nil
  self.isBigReward = nil
  self.reward = nil
  self.bigRewardMultiple = nil
  self.hasLuckSiphonbuff = nil
  self.luckSiphonbuffSenderInfo = nil
end

function DetectEventTreasureClaimPlayerInfo:InitData(message)
  if message.uid then
    self.uid = message.uid
  end
  if message.name then
    self.name = message.name
  end
  if message.headPic then
    self.headPic = message.headPic
  end
  if message.headPicVer then
    self.headPicVer = message.headPicVer
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
  if message.costTime then
    self.costTime = message.costTime
  end
  if message.isBigReward then
    self.isBigReward = message.isBigReward == 1
  end
  if message.reward then
    self.reward = message.reward
  end
  if message.bigRewardMultiple then
    self.bigRewardMultiple = message.bigRewardMultiple
  end
  if message.hasLuckSiphonbuff ~= nil and message.hasLuckSiphonbuff then
    self.hasLuckSiphonbuff = true
  end
  if message.luckSiphonbuffSenderInfo then
    self.luckSiphonbuffSenderInfo = message.luckSiphonbuffSenderInfo
  end
end

return DetectEventTreasureClaimPlayerInfo
