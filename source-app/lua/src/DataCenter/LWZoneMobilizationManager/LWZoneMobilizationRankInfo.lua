local LWZoneMobilizationRankInfo = BaseClass("LWZoneMobilizationRankInfo")

function LWZoneMobilizationRankInfo:__init()
  self.personalRankDict = {}
  self.allianceRankDict = {}
  self.selfRankInfo = nil
  self.selfAllianceRankInfo = nil
end

function LWZoneMobilizationRankInfo:__delete()
  self.personalRankDict = nil
  self.allianceRankDict = nil
  self.selfRankInfo = nil
  self.selfAllianceRankInfo = nil
end

function LWZoneMobilizationRankInfo:RefreshData(message)
  self.allianceRankDict = {}
  if message.rankList then
    for i, v in pairs(message.rankList) do
      local allianceData
      if self.allianceRankDict[v.rank] == nil then
        allianceData = AllianceRankData.New()
        self.allianceRankDict[v.rank] = allianceData
      else
        allianceData = self.allianceRankDict[v.rank]
      end
      allianceData:ParseData(v)
      allianceData:SetRank(v.rank)
    end
  end
  if not LuaEntry.Player:IsInAlliance() then
    self.selfAllianceRankInfo = nil
  end
  if message.selfRank then
    local selfInfo = message.selfRank
    if self.selfAllianceRankInfo == nil then
      self.selfAllianceRankInfo = AllianceRankData.New()
    end
    self.selfAllianceRankInfo:ParseData(selfInfo)
    self.selfAllianceRankInfo:SetRank(selfInfo.rank)
  end
  self.personalRankDict = {}
  if message.alRankList then
    for i, v in pairs(message.alRankList) do
      local playerData
      if self.personalRankDict[v.rank] == nil then
        playerData = BasePlayerInfo.New()
        self.personalRankDict[v.rank] = playerData
      else
        playerData = self.personalRankDict[v.rank]
      end
      v.playerInfo.pic = v.playerInfo.headPic
      v.playerInfo.picVer = v.playerInfo.headPicVer
      playerData:ParseData(v.playerInfo)
      playerData.uid = v.uid
      playerData.score = v.score
      playerData.rank = v.rank
      playerData.memberR = v.r
    end
  end
  if not LuaEntry.Player:IsInAlliance() then
    self.selfRankInfo = nil
  end
  if message.alSelfRank then
    local selfInfo = message.alSelfRank
    if self.selfRankInfo == nil then
      self.selfRankInfo = BasePlayerInfo.New()
    end
    selfInfo.playerInfo.pic = selfInfo.playerInfo.headPic
    selfInfo.playerInfo.picVer = selfInfo.playerInfo.headPicVer
    self.selfRankInfo:ParseData(selfInfo.playerInfo)
    self.selfRankInfo.uid = selfInfo.uid
    self.selfRankInfo.score = selfInfo.score
    self.selfRankInfo.rank = selfInfo.rank
    self.selfRankInfo.memberR = selfInfo.r
  end
end

return LWZoneMobilizationRankInfo
