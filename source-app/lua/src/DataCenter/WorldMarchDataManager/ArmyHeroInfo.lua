local ArmyHeroInfo = BaseClass("ArmyHeroInfo")

local function __init(self)
  self.heroId = 0
  self.heroUuid = 0
  self.heroLevel = 0
  self.heroQuality = 0
  self.index = 0
  self.rankLv = 0
  self.stage = 0
  self.skillInfos = {}
  self.awakenLv = 0
  self.skinId = 0
end

local function __delete(self)
  self.heroId = nil
  self.heroUuid = nil
  self.heroLevel = nil
  self.heroQuality = nil
  self.index = nil
  self.rankLv = nil
  self.stage = nil
  self.skillInfos = nil
  self.awakenLv = nil
  self.skinId = nil
end

local function UpdateHeroInfo(self, proto)
  if proto == nil then
    return
  end
  self.heroId = proto.heroId
  self.heroUuid = proto.heroUuid
  self.heroLevel = proto.heroLevel
  self.heroQuality = proto.heroQuality
  self.index = proto.index
  self.rankLv = proto.rankLv
  self.stage = proto.stage
  self.skillInfos = proto.skillInfos
  self.awakenLv = proto.awakenLv
  self.skinId = proto.heroSkinId
end

local function GetIsAllSKillReachMax(self)
  local unlockNum = 0
  local totalLv = 0
  for k, v in pairs(self.skillInfos) do
    if 0 < v.skillLv then
      unlockNum = unlockNum + 1
      totalLv = totalLv + v.skillLv
    end
  end
  if totalLv >= unlockNum * 5 and unlockNum == table.count(self.skillInfos) then
    return true
  end
  return false
end

ArmyHeroInfo.__init = __init
ArmyHeroInfo.__delete = __delete
ArmyHeroInfo.UpdateHeroInfo = UpdateHeroInfo
ArmyHeroInfo.GetIsAllSKillReachMax = GetIsAllSKillReachMax
return ArmyHeroInfo
