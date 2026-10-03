local base = ArmyFormationInfo
local HeroTryOutArmyFormationInfo = BaseClass("HeroTryOutArmyFormationInfo", ArmyFormationInfo)

function HeroTryOutArmyFormationInfo:__init(heroTryOutId)
  base.__init(self)
  self.heroTryOutId = heroTryOutId
  self.allHeroDataDict = nil
  self.tacticalWeaponInfo = nil
  local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.heroTryOutId)
  if tryOutTemplate ~= nil and tryOutTemplate.lattice_type > 0 then
    self.formationSpecialType = tryOutTemplate.lattice_type
  end
end

function HeroTryOutArmyFormationInfo:__delete()
  base.__delete(self)
  self.heroTryOutId = nil
  self.allHeroDataDict = nil
  self.tacticalWeaponInfo = nil
end

function HeroTryOutArmyFormationInfo:TryInitAllHeroData()
  if self.allHeroDataDict ~= nil then
    return
  end
  self.allHeroDataDict = {}
  local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.heroTryOutId)
  if tryOutTemplate == nil then
    return
  end
  local armyTemplateList = tryOutTemplate:GetSelfArmyTemplateList()
  for _, armyTemplate in pairs(armyTemplateList) do
    for i = 1, ArmyFormationSlot.Dominator do
      local armyData = armyTemplate.line_up[i]
      if armyData and armyData.heroData then
        local heroData = HeroInfo.New()
        heroData:UpdateFromTemplate(armyData.heroData.metaId, armyData.heroData.level, armyData.heroData.rank, nil, nil, nil, armyData.heroData.awakenLv, nil)
        heroData.uuid = armyData.heroData.metaId * 1000
        heroData.isTryOutHero = armyData.heroData.metaId == tryOutTemplate.hero_id
        self.allHeroDataDict[heroData.uuid] = heroData
      end
    end
  end
end

function HeroTryOutArmyFormationInfo:GetAllHeroDataDict()
  self:TryInitAllHeroData()
  return self.allHeroDataDict
end

function HeroTryOutArmyFormationInfo:GetHeroDataByUuid(uuid)
  self:TryInitAllHeroData()
  return self.allHeroDataDict[uuid]
end

function HeroTryOutArmyFormationInfo:GetUuidByHeroId(heroId)
  self:TryInitAllHeroData()
  for uuid, heroData in pairs(self.allHeroDataDict) do
    if heroData.heroId == heroId then
      return uuid
    end
  end
end

function HeroTryOutArmyFormationInfo:GetHeroIdByUuid(uuid)
  self:TryInitAllHeroData()
  local heroData = self.allHeroDataDict[uuid]
  if heroData then
    return heroData.heroId
  end
end

function HeroTryOutArmyFormationInfo:GetAllLocalHerosForServer()
  local heros = self:GetLocalAllHeroes()
  if heros == nil then
    return nil
  end
  local heroArray = SFSArray.New()
  table.walk(heros, function(k, v)
    local key = k
    local heroId = self:GetHeroIdByUuid(v)
    local obj = SFSObject.New()
    obj:PutInt("heroId", heroId)
    obj:PutInt("index", key)
    heroArray:AddSFSObject(obj)
  end)
  return heroArray
end

function HeroTryOutArmyFormationInfo:GetLocalHeroesCapacity()
  local ret = 0
  for k, v in pairs(self.localHeroes) do
    local heroData = self:GetHeroDataByUuid(k)
    if heroData then
      ret = ret + heroData.power
    end
  end
  return ret
end

function HeroTryOutArmyFormationInfo:ResetLocalData()
  base.ResetLocalData(self)
  self.localChipSetId = 0
  self.localDominatorUuid = 0
end

function HeroTryOutArmyFormationInfo:GetTacticalWeaponInfo()
  if self.tacticalWeaponInfo == nil then
    local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.heroTryOutId)
    if tryOutTemplate ~= nil and tryOutTemplate.uav_id > 0 then
      self.tacticalWeaponInfo = TacticalWeaponInfo.New()
      local initProperties, skillInfoList
      local armyTemplateList = tryOutTemplate:GetSelfArmyTemplateList()
      for _, armyTemplate in pairs(armyTemplateList) do
        if armyTemplate.uav_property ~= nil or armyTemplate.uav_skill ~= nil then
          if armyTemplate.uav_property ~= nil then
            initProperties = armyTemplate.uav_property
          end
          if armyTemplate.uav_skill ~= nil then
            skillInfoList = {}
            for skillId, skillLevel in pairs(armyTemplate.uav_skill) do
              local skillInfo = SkillInfo.New()
              skillInfo:CreateFromTemplate(skillId, true, skillLevel)
              table.insert(skillInfoList, skillInfo)
            end
          end
          break
        end
      end
      self.tacticalWeaponInfo:CreateFromTemplate(tryOutTemplate.uav_id, tryOutTemplate.uav_level, nil, initProperties, skillInfoList)
    end
  end
  return self.tacticalWeaponInfo
end

return HeroTryOutArmyFormationInfo
