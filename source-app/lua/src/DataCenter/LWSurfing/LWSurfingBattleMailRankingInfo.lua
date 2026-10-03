local LWSurfingBattleMailRankingInfo = BaseClass("LWSurfingBattleMailRankingInfo")

function LWSurfingBattleMailRankingInfo:__init()
  self.rank = 0
  self.score = 0
  self.uid = ""
  self.name = ""
  self.headPic = ""
  self.headPicVer = 0
  self.headSkinId = nil
  self.headSkinET = nil
end

function LWSurfingBattleMailRankingInfo:__delete()
  self.rank = nil
  self.uid = nil
  self.name = nil
  self.headPic = nil
  self.headPicVer = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.score = nil
end

function LWSurfingBattleMailRankingInfo:InitData(message)
  if message.rank then
    self.rank = message.rank
  end
  if message.uid then
    self.uid = message.uid
  end
  if message.name then
    self.name = message.name
  end
  if message.pic then
    self.headPic = message.pic
  end
  if message.picver then
    self.headPicVer = message.picver
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
end

return LWSurfingBattleMailRankingInfo
