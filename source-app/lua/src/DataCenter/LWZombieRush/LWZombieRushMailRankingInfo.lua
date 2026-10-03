local LWZombieRushMailRankingInfo = BaseClass("LWZombieRushMailRankingInfo")

function LWZombieRushMailRankingInfo:__init()
  self.rank = 0
  self.uid = ""
  self.name = ""
  self.headPic = ""
  self.headPicVer = 0
  self.headSkinId = nil
  self.headSkinET = nil
  self.score = 0
  self.power = 0
  self.perfect = false
end

function LWZombieRushMailRankingInfo:__delete()
  self.rank = nil
  self.uid = nil
  self.name = nil
  self.headPic = nil
  self.headPicVer = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.score = nil
  self.power = nil
  self.perfect = false
end

function LWZombieRushMailRankingInfo:InitData(message)
  if message.rank then
    self.rank = message.rank
  end
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
  if message.score then
    self.score = message.score
  end
  if message.power then
    self.power = message.power
  end
  if message.perfect then
    self.perfect = message.perfect
  end
end

return LWZombieRushMailRankingInfo
