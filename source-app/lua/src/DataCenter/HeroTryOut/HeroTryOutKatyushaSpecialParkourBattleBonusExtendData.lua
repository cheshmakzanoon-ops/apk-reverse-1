local HeroTryOutKatyushaSpecialParkourBattleBonusExtendData = BaseClass("HeroTryOutKatyushaSpecialParkourBattleBonusExtendData")
local TIME_LINE_ASSET_PATH = "Assets/Main/Prefabs/PrefabsIncrement/Character/Hero/Katyusha/A_Hero_Katyusha_firstshow_Timeline.prefab"
local DEFAULT_HERO_ID = 50009

function HeroTryOutKatyushaSpecialParkourBattleBonusExtendData:__init()
  self.plotGroupId = 0
  self.plotGroupIdBeforeTimeline = 0
  self.heroId = 0
  self.heroLevel = 0
  self.heroRank = 0
  self.timelineAssetPath = ""
  self.monopolyPlacealityIdDict = {}
  self.monopolyPlacealityNewIdDict = {}
end

function HeroTryOutKatyushaSpecialParkourBattleBonusExtendData:__delete()
  self.plotGroupId = nil
  self.plotGroupIdBeforeTimeline = nil
  self.heroId = nil
  self.heroLevel = nil
  self.heroRank = nil
  self.timelineAssetPath = nil
  self.monopolyPlacealityIdDict = nil
  self.monopolyPlacealityNewIdDict = nil
end

function HeroTryOutKatyushaSpecialParkourBattleBonusExtendData:InitData()
  self.plotGroupId = LuaEntry.DataConfig:TryGetNum("herokim_timeline_control", "k1", 0)
  self.heroLevel = LuaEntry.DataConfig:TryGetNum("herokim_timeline_control", "k3", 0)
  self.heroRank = LuaEntry.DataConfig:TryGetNum("herokim_timeline_control", "k4", 0)
  self.heroId = LuaEntry.DataConfig:TryGetNum("herokim_timeline_control", "k8", DEFAULT_HERO_ID)
  self.timelineAssetPath = TIME_LINE_ASSET_PATH
  local monopolyPlacealityIdPair1 = LuaEntry.DataConfig:TryGetStr("herokim_timeline_control", "k9", "")
  if not string.IsNullOrEmpty(monopolyPlacealityIdPair1) then
    local monopolyPlacealityIdPair1Spls = string.split(monopolyPlacealityIdPair1, ";")
    if #monopolyPlacealityIdPair1Spls == 2 then
      self.monopolyPlacealityIdDict[tonumber(monopolyPlacealityIdPair1Spls[1])] = tonumber(monopolyPlacealityIdPair1Spls[2])
      self.monopolyPlacealityNewIdDict[tonumber(monopolyPlacealityIdPair1Spls[2])] = true
    end
  end
  local monopolyPlacealityIdPair2 = LuaEntry.DataConfig:TryGetStr("herokim_timeline_control", "k10", "")
  if not string.IsNullOrEmpty(monopolyPlacealityIdPair2) then
    local monopolyPlacealityIdPair2Spls = string.split(monopolyPlacealityIdPair2, ";")
    if #monopolyPlacealityIdPair2Spls == 2 then
      self.monopolyPlacealityIdDict[tonumber(monopolyPlacealityIdPair2Spls[1])] = tonumber(monopolyPlacealityIdPair2Spls[2])
      self.monopolyPlacealityNewIdDict[tonumber(monopolyPlacealityIdPair2Spls[2])] = true
    end
  end
  self.plotGroupIdBeforeTimeline = LuaEntry.DataConfig:TryGetNum("herokim_timeline_control", "k12", 0)
end

function HeroTryOutKatyushaSpecialParkourBattleBonusExtendData:GetMonopolyPlacealityIdDict()
  return self.monopolyPlacealityIdDict
end

function HeroTryOutKatyushaSpecialParkourBattleBonusExtendData:GetMonopolyPlacealityNewIdDict()
  return self.monopolyPlacealityNewIdDict
end

return HeroTryOutKatyushaSpecialParkourBattleBonusExtendData
