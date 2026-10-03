local FormationMarchTimeMessage = BaseClass("FormationMarchTimeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function GetMaxCanAddSoldierNumLog(formationUuid)
  local curSoldiers = {}
  local curHeroes = {}
  local sfsObj = SFSObject.New()
  sfsObj:PutLong("uuid", formationUuid)
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    curSoldiers = formation.soldiers
    curHeroes = formation.heroes
    local formationArray = SFSArray.New()
    table.walk(curSoldiers, function(k, v)
      local obj = SFSObject.New()
      obj:PutUtfString("armyId", k)
      obj:PutInt("count", v)
      formationArray:AddSFSObject(obj)
    end)
    sfsObj:PutSFSArray("formations", formationArray)
    local heroArray = SFSArray.New()
    table.walk(curHeroes, function(k, v)
      local obj = SFSObject.New()
      obj:PutLong("heroUuid", k)
      obj:PutInt("index", v)
      heroArray:AddSFSObject(obj)
    end)
    sfsObj:PutSFSArray("heroInfos", heroArray)
    local logSfsObj = SFSObject.New()
    local asPlayerMaxSoldiers = LuaEntry.DataConfig:TryGetNum("building_base", "k5")
    logSfsObj:PutFloat("buildingBaseK5", asPlayerMaxSoldiers)
    local baseSize = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_SIZE)
    logSfsObj:PutFloat("userEffect40001", baseSize)
    local sizeEnhance = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_SIZE_ENHANCE)
    logSfsObj:PutFloat("userEffect40002", sizeEnhance)
    local finalAddNumByIndex = MarchUtil.GetFormationMaxNumByFormationIndex(formation.index)
    logSfsObj:PutFloat("formationArmyAddCountByIndex", finalAddNumByIndex)
    local heroLogArray = SFSArray.New()
    table.walk(curHeroes, function(k, v)
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
      if heroData ~= nil then
        local config = heroData:GetConfig()
        local rankId = heroData:GetRank()
        local rarity = config.rarity
        local heroId = config.id
        local heroLevel = heroData.level
        local quality = heroData.quality
        local num = GetTableData(TableName.NewHeroesLevelUp, heroLevel, "army_num" .. rarity)
        if num == nil then
          num = 0
        end
        local rankTroop = string.split(GetTableData(TableName.HeroMilitaryRankLv, rankId, "troop"), "|")[rarity]
        rankTroop = tonumber(rankTroop)
        if rankTroop == nil then
          rankTroop = 0
        end
        local starAddTroop = config.hero_star_troops[math.min(#config.hero_star_troops, quality)]
        if starAddTroop == nil then
          starAddTroop = 0
        end
        local heroBaseSize = heroData:GetEffectNum(EffectDefine.APS_FORMATION_SIZE)
        local heroSizeEnhance = heroData:GetEffectNum(EffectDefine.APS_FORMATION_SIZE_ENHANCE)
        local campAddEffect = LuaEntry.Effect:GetGameEffect(HeroUtils.GetExtraTroopByCamp(heroData.camp))
        local obj = SFSObject.New()
        obj:PutLong("heroUuid", k)
        obj:PutInt("heroId", heroId)
        obj:PutInt("heroRank", rankId)
        obj:PutInt("heroStar", quality)
        obj:PutInt("heroLevel", heroLevel)
        obj:PutFloat("heroLevelAdd", num)
        obj:PutFloat("heroRankAdd", rankTroop)
        obj:PutFloat("heroStarAdd", starAddTroop)
        obj:PutFloat("heroEffect40001", heroBaseSize)
        obj:PutFloat("heroEffect40002", heroSizeEnhance)
        obj:PutFloat("heroCampAdd", campAddEffect)
        heroLogArray:AddSFSObject(obj)
      end
    end)
    logSfsObj:PutSFSArray("heroArr", heroLogArray)
    local maxNum = MarchUtil.GetMaxCanAddSoldierNum(curHeroes, formation.index)
    logSfsObj:PutInt("maxSoldiers", maxNum)
    sfsObj:PutSFSObject("formationLog", logSfsObj)
  end
  return sfsObj
end

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj = GetMaxCanAddSoldierNumLog(uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

FormationMarchTimeMessage.OnCreate = OnCreate
FormationMarchTimeMessage.HandleMessage = HandleMessage
return FormationMarchTimeMessage
