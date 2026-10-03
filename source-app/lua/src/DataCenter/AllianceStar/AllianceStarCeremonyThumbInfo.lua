local AllianceStarCeremonyThumbInfo = BaseClass("AllianceStarCeremonyThumbInfo")

function AllianceStarCeremonyThumbInfo:__init()
  self.configId = nil
  self.uid = nil
  self.thumbsInfo = nil
  self.selfThumbs = nil
  self.isStar = nil
end

function AllianceStarCeremonyThumbInfo:__delete()
  self.configId = nil
  self.uid = nil
  self.thumbsInfo = nil
  self.selfThumbs = nil
  self.isStar = nil
end

function AllianceStarCeremonyThumbInfo:ParseData(configId, uid, thumbsInfo, selfThumbs, isStar)
  self.configId = configId
  self.uid = uid
  self.thumbsInfo = thumbsInfo
  self.selfThumbs = selfThumbs
  self.isStar = isStar
end

function AllianceStarCeremonyThumbInfo:ParseChangeData(thumbsInfo, selfThumbs)
  self.thumbsInfo = thumbsInfo
  self.selfThumbs = selfThumbs
end

return AllianceStarCeremonyThumbInfo
