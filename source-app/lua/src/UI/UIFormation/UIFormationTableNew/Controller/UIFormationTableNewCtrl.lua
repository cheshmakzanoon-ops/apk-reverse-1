local UIFormationTableNewCtrl = BaseClass("UIFormationTableNewCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFormationTableNew)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function SetCurIndex(self, index)
  self.curIndex = index
end

local function GetAtkImage(self)
  local imgStr = ""
  if self.targetType == MarchTargetType.ATTACK_MONSTER or self.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS or self.targetType == MarchTargetType.RALLY_FOR_BOSS or self.targetType == MarchTargetType.JOIN_RALLY and self.rallyType ~= nil and self.rallyType == MarchTargetType.RALLY_FOR_BOSS then
    imgStr = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_icon_attack.png"
  elseif self.targetType == MarchTargetType.ATTACK_CITY or self.targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or self.targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or self.targetType == MarchTargetType.ATTACK_BUILDING or self.targetType == MarchTargetType.ATTACK_ROAD or self.targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or self.targetType == MarchTargetType.ATTACK_THRONE or self.targetType == MarchTargetType.RALLY_FOR_CITY or self.targetType == MarchTargetType.RALLY_EPIDEMIC_CITY or self.targetType == MarchTargetType.RALLY_FOR_BUILDING or self.targetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY or self.targetType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or self.targetType == MarchTargetType.RALLY_CENTER_THRONE or self.targetType == MarchTargetType.RAINFOREST_THRONE_RALLY or self.targetType == MarchTargetType.RAINFOREST_THRONE_RALLY or self.targetType == MarchTargetType.RALLY_THRONE or self.targetType == MarchTargetType.RALLY_DRAGON_BUILDING or self.targetType == MarchTargetType.RALLY_EPIDEMIC_BUILDING or self.targetType == MarchTargetType.JOIN_RALLY and self.rallyType ~= nil and (self.rallyType == MarchTargetType.RALLY_FOR_BUILDING or self.rallyType == MarchTargetType.RALLY_FOR_CITY or self.rallyType == MarchTargetType.RALLY_EPIDEMIC_CITY or self.rallyType == MarchTargetType.RALLY_THRONE or self.rallyType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or self.rallyType == MarchTargetType.RALLY_CENTER_THRONE or self.rallyType == MarchTargetType.RAINFOREST_THRONE_RALLY or self.rallyType == MarchTargetType.RAINFOREST_THRONE_RALLY or self.rallyType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY) then
    imgStr = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_icon_city.png"
  elseif self.targetType == MarchTargetType.ATTACK_ARMY or self.targetType == MarchTargetType.ATTACK_ARMY_COLLECT or self.targetType == MarchTargetType.ASSISTANCE_BUILD or self.targetType == MarchTargetType.ASSISTANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or self.targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY or self.targetType == MarchTargetType.ASSISTANCE_THRONE or self.targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY or self.targetType == MarchTargetType.GO_WORM_HOLE or self.targetType == MarchTargetType.STATE or self.targetType == MarchTargetType.CROSS_SERVER_WORM or self.targetType == MarchTargetType.ASSISTANCE_DESERT or self.targetType == MarchTargetType.STATE or self.targetType == MarchTargetType.SAMPLE or self.targetType == MarchTargetType.EXPLORE or self.targetType == MarchTargetType.PICK_GARBAGE then
    imgStr = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_icon_IncreaseAttack.png"
  elseif self.targetType == MarchTargetType.COLLECT then
    local data = CS.SceneManager.World:GetResourcePointInfoByIndex(self.targetPoint)
    local resourceType = GetTableData(TableName.GatherResource, data.id, "resource_type")
    if resourceType == ResourceType.Oil then
      imgStr = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_icon_gas.png"
    elseif resourceType == ResourceType.Water then
      imgStr = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_icon_water.png"
    elseif resourceType == ResourceType.Metal then
      imgStr = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_icon_crystal.png"
    end
  end
  return imgStr
end

local function GetAtkValue(self)
  local value = 0
  if self.targetType == MarchTargetType.ATTACK_MONSTER or self.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS or self.targetType == MarchTargetType.RALLY_FOR_BOSS or self.targetType == MarchTargetType.JOIN_RALLY and self.rallyType ~= nil and self.rallyType == MarchTargetType.RALLY_FOR_BOSS then
    value = LuaEntry.Effect:GetGameEffect(EffectDefine.ATTACK_MONSTER)
    table.walk(self.curHeroes, function(v, k)
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
      if heroData ~= nil then
        value = value + heroData:GetEffectNum(EffectDefine.ATTACK_MONSTER)
      end
    end)
  elseif self.targetType == MarchTargetType.ATTACK_CITY or self.targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or self.targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or self.targetType == MarchTargetType.ATTACK_BUILDING or self.targetType == MarchTargetType.ATTACK_ROAD or self.targetType == MarchTargetType.ATTACK_THRONE or self.targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or self.targetType == MarchTargetType.RALLY_FOR_CITY or self.targetType == MarchTargetType.RALLY_EPIDEMIC_CITY or self.targetType == MarchTargetType.RALLY_FOR_BUILDING or self.targetType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or self.targetType == MarchTargetType.RALLY_CENTER_THRONE or self.targetType == MarchTargetType.RAINFOREST_THRONE_RALLY or self.targetType == MarchTargetType.RALLY_THRONE or self.targetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY or self.targetType == MarchTargetType.JOIN_RALLY and self.rallyType ~= nil and (self.rallyType == MarchTargetType.RALLY_FOR_BUILDING or self.rallyType == MarchTargetType.RALLY_FOR_CITY or self.rallyType == MarchTargetType.RALLY_EPIDEMIC_CITY or self.rallyType == MarchTargetType.RALLY_THRONE or self.rallyType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or self.rallyType == MarchTargetType.RALLY_CENTER_THRONE or self.rallyType == MarchTargetType.RAINFOREST_THRONE_RALLY or self.rallyType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY) then
    local cityWar = LuaEntry.DataConfig:TryGetNum("city_wall", "k7")
    local totalSoliderDestroyNum = 0
    table.walk(self.curSoldiers, function(k, v)
      local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
      if template ~= nil then
        local destory = template.destory
        totalSoliderDestroyNum = totalSoliderDestroyNum + destory * v
      end
    end)
    local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.SIEGE_DAMAGE_ADD_PERCENT)
    table.walk(self.curHeroes, function(v, k)
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
      if heroData ~= nil then
        effectNum = effectNum + heroData:GetEffectNum(EffectDefine.SIEGE_DAMAGE_ADD_PERCENT)
      end
    end)
    value = cityWar * totalSoliderDestroyNum * (effectNum / 100 + 1)
  elseif self.targetType == MarchTargetType.ATTACK_ARMY or self.targetType == MarchTargetType.ATTACK_ARMY_COLLECT or self.targetType == MarchTargetType.ASSISTANCE_BUILD or self.targetType == MarchTargetType.ASSISTANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or self.targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY or self.targetType == MarchTargetType.ASSISTANCE_THRONE or self.targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_DESERT or self.targetType == MarchTargetType.GO_WORM_HOLE or self.targetType == MarchTargetType.CROSS_SERVER_WORM or self.targetType == MarchTargetType.STATE or self.targetType == MarchTargetType.SAMPLE or self.targetType == MarchTargetType.EXPLORE or self.targetType == MarchTargetType.PICK_GARBAGE then
    value = LuaEntry.Effect:GetGameEffect(EffectDefine.WAR_ATTACK)
    table.walk(self.curHeroes, function(v, k)
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
      if heroData ~= nil then
        value = value + heroData:GetEffectNum(EffectDefine.WAR_ATTACK)
      end
    end)
    local atkAdd = MarchUtil.GetFormationAtkAddNumByFormationIndex(self.curIndex)
    value = value + atkAdd
  elseif self.targetType == MarchTargetType.COLLECT then
    local data = CS.SceneManager.World:GetResourcePointInfoByIndex(self.targetPoint)
    local resourceType = GetTableData(TableName.GatherResource, data.id, "resource_type")
    if resourceType == ResourceType.Oil then
      value = LuaEntry.Effect:GetGameEffect(EffectDefine.GAS_COLLECT_SPEED_PERCENT)
      table.walk(self.curHeroes, function(v, k)
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
        if heroData ~= nil then
          value = value + heroData:GetEffectNum(EffectDefine.GAS_COLLECT_SPEED_PERCENT)
        end
      end)
    elseif resourceType == ResourceType.Water then
      value = LuaEntry.Effect:GetGameEffect(EffectDefine.WATER_COLLECT_SPEED_PERCENT)
      table.walk(self.curHeroes, function(v, k)
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
        if heroData ~= nil then
          value = value + heroData:GetEffectNum(EffectDefine.WATER_COLLECT_SPEED_PERCENT)
        end
      end)
    elseif resourceType == ResourceType.Metal then
      value = LuaEntry.Effect:GetGameEffect(EffectDefine.CRYSTAL_COLLECT_SPEED_PERCENT)
      table.walk(self.curHeroes, function(v, k)
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
        if heroData ~= nil then
          value = value + heroData:GetEffectNum(EffectDefine.CRYSTAL_COLLECT_SPEED_PERCENT)
        end
      end)
    elseif resourceType == ResourceType.Food then
      value = LuaEntry.Effect:GetGameEffect(EffectDefine.MONEY_COLLECT_SPEED_PERCENT)
      table.walk(self.curHeroes, function(v, k)
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
        if heroData ~= nil then
          value = value + heroData:GetEffectNum(EffectDefine.MONEY_COLLECT_SPEED_PERCENT)
        end
      end)
    end
  end
  return value
end

local function GetDefImage(self)
  local imgStr = ""
  if self.targetType == MarchTargetType.ATTACK_MONSTER or self.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS or self.targetType == MarchTargetType.RALLY_FOR_BOSS or self.targetType == MarchTargetType.JOIN_RALLY and self.rallyType ~= nil and self.rallyType == MarchTargetType.RALLY_FOR_BOSS then
    imgStr = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_icon_defense.png"
  elseif self.targetType == MarchTargetType.ATTACK_CITY or self.targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or self.targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or self.targetType == MarchTargetType.ATTACK_BUILDING or self.targetType == MarchTargetType.ATTACK_ROAD or self.targetType == MarchTargetType.ATTACK_THRONE or self.targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or self.targetType == MarchTargetType.ATTACK_SERVER_THRONE_BUILDING or self.targetType == MarchTargetType.ATTACK_CENTER_THRONE or self.targetType == MarchTargetType.RAINFOREST_THRONE_ATTACK or self.targetType == MarchTargetType.RALLY_FOR_CITY or self.targetType == MarchTargetType.RALLY_EPIDEMIC_CITY or self.targetType == MarchTargetType.RALLY_FOR_BUILDING or self.targetType == MarchTargetType.RALLY_THRONE or self.targetType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or self.targetType == MarchTargetType.RALLY_CENTER_THRONE or self.targetType == MarchTargetType.RAINFOREST_THRONE_RALLY or self.targetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY or self.targetType == MarchTargetType.JOIN_RALLY and self.rallyType ~= nil and (self.rallyType == MarchTargetType.RALLY_FOR_BUILDING or self.rallyType == MarchTargetType.RALLY_FOR_CITY or self.rallyType == MarchTargetType.RALLY_EPIDEMIC_CITY or self.rallyType == MarchTargetType.RALLY_THRONE or self.rallyType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or self.rallyType == MarchTargetType.RALLY_CENTER_THRONE or self.rallyType == MarchTargetType.RAINFOREST_THRONE_RALLY or self.rallyType == MarchTargetType.RAINFOREST_THRONE_RALLY or self.rallyType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY) or self.targetType == MarchTargetType.COLLECT then
    imgStr = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_icon_load.png"
  elseif self.targetType == MarchTargetType.ATTACK_ARMY or self.targetType == MarchTargetType.ATTACK_ARMY_COLLECT or self.targetType == MarchTargetType.ASSISTANCE_BUILD or self.targetType == MarchTargetType.ASSISTANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or self.targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY or self.targetType == MarchTargetType.ASSISTANCE_THRONE or self.targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_SERVER_THRONE_BUILDING or self.targetType == MarchTargetType.ASSISTANCE_CENTER_THRONE or self.targetType == MarchTargetType.RAINFOREST_THRONE_ASSISTANCE or self.targetType == MarchTargetType.ASSISTANCE_DESERT or self.targetType == MarchTargetType.GO_WORM_HOLE or self.targetType == MarchTargetType.CROSS_SERVER_WORM or self.targetType == MarchTargetType.STATE or self.targetType == MarchTargetType.SAMPLE or self.targetType == MarchTargetType.EXPLORE or self.targetType == MarchTargetType.PICK_GARBAGE then
    imgStr = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_icon_Reduce-attack.png"
  end
  return imgStr
end

local function GetDefValue(self)
  local value = 0
  if self.targetType == MarchTargetType.ATTACK_MONSTER or self.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS or self.targetType == MarchTargetType.RALLY_FOR_BOSS or self.targetType == MarchTargetType.JOIN_RALLY and self.rallyType ~= nil and self.rallyType == MarchTargetType.RALLY_FOR_BOSS then
    value = LuaEntry.Effect:GetGameEffect(EffectDefine.DEFENCE_MONSTER)
    table.walk(self.curHeroes, function(v, k)
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
      if heroData ~= nil then
        value = value + heroData:GetEffectNum(EffectDefine.DEFENCE_MONSTER)
      end
    end)
  elseif self.targetType == MarchTargetType.ATTACK_CITY or self.targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or self.targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or self.targetType == MarchTargetType.ATTACK_BUILDING or self.targetType == MarchTargetType.ATTACK_ROAD or self.targetType == MarchTargetType.ATTACK_THRONE or self.targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or self.targetType == MarchTargetType.RALLY_FOR_CITY or self.targetType == MarchTargetType.RALLY_EPIDEMIC_CITY or self.targetType == MarchTargetType.RALLY_FOR_BUILDING or self.targetType == MarchTargetType.RALLY_THRONE or self.targetType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or self.targetType == MarchTargetType.RALLY_CENTER_THRONE or self.targetType == MarchTargetType.RAINFOREST_THRONE_RALLY or self.targetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY or self.targetType == MarchTargetType.JOIN_RALLY and self.rallyType ~= nil and (self.rallyType == MarchTargetType.RALLY_FOR_BUILDING or self.rallyType == MarchTargetType.RALLY_FOR_CITY or self.rallyType == MarchTargetType.RALLY_EPIDEMIC_CITY or self.rallyType == MarchTargetType.RALLY_THRONE or self.rallyType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or self.rallyType == MarchTargetType.RALLY_CENTER_THRONE or self.rallyType == MarchTargetType.RAINFOREST_THRONE_RALLY or self.rallyType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY) or self.targetType == MarchTargetType.COLLECT then
    local totalSoliderLoadNum = 0
    table.walk(self.curSoldiers, function(k, v)
      local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
      if template ~= nil then
        local load = template.load
        totalSoliderLoadNum = totalSoliderLoadNum + load * v
      end
    end)
    local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.ARMY_CARRY_WEIGHT_ADD_PERCENT)
    table.walk(self.curHeroes, function(v, k)
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
      if heroData ~= nil then
        effectNum = effectNum + heroData:GetEffectNum(EffectDefine.ARMY_CARRY_WEIGHT_ADD_PERCENT)
      end
    end)
    local addValue = MarchUtil.GetFormationAddWeightPercentByFormationIndex(self.curIndex)
    local addNum = MarchUtil.GetFormationAddWeightNumByFormationIndex(self.curIndex)
    local careerValue = LuaEntry.Effect:GetGameEffect(EffectDefine.CAREER_COLLECT_ADD_PERCENT)
    local attackCityAdd = 0
    if self.targetType == MarchTargetType.ATTACK_CITY or self.targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or self.targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or self.targetType == MarchTargetType.RALLY_FOR_CITY or self.targetType == MarchTargetType.RALLY_EPIDEMIC_CITY or self.targetType == MarchTargetType.JOIN_RALLY and self.rallyType ~= nil and (self.rallyType == MarchTargetType.RALLY_FOR_CITY or self.rallyType == MarchTargetType.RALLY_EPIDEMIC_CITY) then
      attackCityAdd = LuaEntry.Effect:GetGameEffect(EffectDefine.CAREER_ATTACK_CITY_COLLECT_ADD_PERCENT)
    end
    value = totalSoliderLoadNum * (careerValue / 100 + effectNum / 100 + addValue / 100 + attackCityAdd / 100 + 1) + addNum
  elseif self.targetType == MarchTargetType.ATTACK_ARMY or self.targetType == MarchTargetType.ATTACK_ARMY_COLLECT or self.targetType == MarchTargetType.ASSISTANCE_BUILD or self.targetType == MarchTargetType.ASSISTANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or self.targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY or self.targetType == MarchTargetType.ASSISTANCE_THRONE or self.targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_DESERT or self.targetType == MarchTargetType.ASSISTANCE_SERVER_THRONE_BUILDING or self.targetType == MarchTargetType.ASSISTANCE_CENTER_THRONE or self.targetType == MarchTargetType.RAINFOREST_THRONE_ASSISTANCE or self.targetType == MarchTargetType.GO_WORM_HOLE or self.targetType == MarchTargetType.CROSS_SERVER_WORM or self.targetType == MarchTargetType.STATE or self.targetType == MarchTargetType.SAMPLE or self.targetType == MarchTargetType.EXPLORE or self.targetType == MarchTargetType.PICK_GARBAGE then
    value = LuaEntry.Effect:GetGameEffect(EffectDefine.WAR_DEFENCE)
    table.walk(self.curHeroes, function(v, k)
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
      if heroData ~= nil then
        value = value + heroData:GetEffectNum(EffectDefine.WAR_DEFENCE)
      end
    end)
    local defAdd = MarchUtil.GetFormationDefAddNumByFormationIndex(self.curIndex)
    value = value + defAdd
  end
  return value
end

local function GetDefDes(self)
  local value = ""
  if self.targetType == MarchTargetType.ATTACK_MONSTER or self.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS or self.targetType == MarchTargetType.RALLY_FOR_BOSS or self.targetType == MarchTargetType.JOIN_RALLY and self.rallyType ~= nil and self.rallyType == MarchTargetType.RALLY_FOR_BOSS then
    value = Localization:GetString("150204")
  elseif self.targetType == MarchTargetType.ATTACK_CITY or self.targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or self.targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or self.targetType == MarchTargetType.ATTACK_BUILDING or self.targetType == MarchTargetType.ATTACK_ROAD or self.targetType == MarchTargetType.ATTACK_THRONE or self.targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or self.targetType == MarchTargetType.RALLY_FOR_CITY or self.targetType == MarchTargetType.RALLY_EPIDEMIC_CITY or self.targetType == MarchTargetType.RALLY_FOR_BUILDING or self.rallyType == MarchTargetType.RALLY_THRONE or self.targetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY or self.targetType == MarchTargetType.JOIN_RALLY and self.rallyType ~= nil and (self.rallyType == MarchTargetType.RALLY_FOR_BUILDING or self.rallyType == MarchTargetType.RALLY_FOR_CITY or self.rallyType == MarchTargetType.RALLY_EPIDEMIC_CITY or self.rallyType == MarchTargetType.RALLY_THRONE or self.rallyType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY) or self.targetType == MarchTargetType.COLLECT then
    value = Localization:GetString("150205")
  elseif self.targetType == MarchTargetType.ATTACK_ARMY or self.targetType == MarchTargetType.ATTACK_ARMY_COLLECT or self.targetType == MarchTargetType.ASSISTANCE_BUILD or self.targetType == MarchTargetType.ASSISTANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or self.targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY or self.targetType == MarchTargetType.ASSISTANCE_THRONE or self.targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_DESERT or self.targetType == MarchTargetType.GO_WORM_HOLE or self.targetType == MarchTargetType.CROSS_SERVER_WORM or self.targetType == MarchTargetType.STATE or self.targetType == MarchTargetType.SAMPLE or self.targetType == MarchTargetType.EXPLORE or self.targetType == MarchTargetType.PICK_GARBAGE then
    value = Localization:GetString("150208")
  end
  return value
end

local function GetAtkDes(self)
  local value = ""
  if self.targetType == MarchTargetType.ATTACK_MONSTER or self.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS or self.targetType == MarchTargetType.RALLY_FOR_BOSS or self.targetType == MarchTargetType.JOIN_RALLY and self.rallyType ~= nil and self.rallyType == MarchTargetType.RALLY_FOR_BOSS then
    value = Localization:GetString("150203")
  elseif self.targetType == MarchTargetType.ATTACK_CITY or self.targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or self.targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or self.targetType == MarchTargetType.ATTACK_BUILDING or self.targetType == MarchTargetType.ATTACK_ROAD or self.targetType == MarchTargetType.ATTACK_THRONE or self.targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or self.targetType == MarchTargetType.RALLY_FOR_CITY or self.targetType == MarchTargetType.RALLY_EPIDEMIC_CITY or self.targetType == MarchTargetType.RALLY_FOR_BUILDING or self.rallyType == MarchTargetType.RALLY_THRONE or self.targetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY or self.targetType == MarchTargetType.JOIN_RALLY and self.rallyType ~= nil and (self.rallyType == MarchTargetType.RALLY_FOR_BUILDING or self.rallyType == MarchTargetType.RALLY_THRONE or self.rallyType == MarchTargetType.RALLY_DRAGON_BUILDING or self.rallyType == MarchTargetType.RALLY_EPIDEMIC_BUILDING or self.rallyType == MarchTargetType.RALLY_FOR_CITY or self.rallyType == MarchTargetType.RALLY_EPIDEMIC_CITY or self.rallyType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY) then
    value = Localization:GetString("150206")
  elseif self.targetType == MarchTargetType.ATTACK_ARMY or self.targetType == MarchTargetType.ATTACK_ARMY_COLLECT or self.targetType == MarchTargetType.ASSISTANCE_BUILD or self.targetType == MarchTargetType.ASSISTANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or self.targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY or self.targetType == MarchTargetType.ASSISTANCE_THRONE or self.targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_DESERT or self.targetType == MarchTargetType.GO_WORM_HOLE or self.targetType == MarchTargetType.CROSS_SERVER_WORM or self.targetType == MarchTargetType.STATE or self.targetType == MarchTargetType.EXPLORE or self.targetType == MarchTargetType.PICK_GARBAGE then
    value = Localization:GetString("150207")
  elseif self.targetType == MarchTargetType.COLLECT then
    local data = CS.SceneManager.World:GetResourcePointInfoByIndex(self.targetPoint)
    local resourceType = GetTableData(TableName.GatherResource, data.id, "resource_type")
    if resourceType == ResourceType.Oil then
      value = Localization:GetString("150200")
    elseif resourceType == ResourceType.Water then
      value = Localization:GetString("150201")
    elseif resourceType == ResourceType.Metal then
      value = Localization:GetString("150202")
    end
  end
  return value
end

local function GetMaxNum(self)
  local heroes = {}
  table.walk(self.curHeroes, function(k, v)
    if v ~= nil then
      heroes[v] = k
    end
  end)
  local asPlayerMaxSoldiers = MarchUtil.GetMaxCanAddSoldierNum(heroes, self.curIndex)
  return asPlayerMaxSoldiers
end

local function CheckMaxSoliderNum(self)
  local totalSoliderNum = self:GetTotalSoldierNum()
  local maxNum = self.maxNum
  if totalSoliderNum > maxNum then
    local totalNum = 0
    local curSoldiers = {}
    table.walksort(self.curSoldiers, function(leftKey, rightKey)
      local aData = DataCenter.ArmyManager:FindArmy(leftKey)
      local bData = DataCenter.ArmyManager:FindArmy(rightKey)
      if aData.level ~= bData.level then
        return aData.level > bData.level
      end
      return aData.id > bData.id
    end, function(k, v)
      if 0 < v then
        local addNum = math.min(maxNum - totalNum, v)
        if 0 < addNum then
          curSoldiers[k] = addNum
          totalNum = totalNum + addNum
        end
      end
    end)
    self.curSoldiers = curSoldiers
    EventManager:GetInstance():Broadcast(EventId.ArmyFormationSave)
  end
end

local function InitData(self, formationUuid, marchTargetType, pointIndex, uuid, index, backHome, startPointId, rallyType, needAutoFix, guideChangeHeroUuid, guideTargetHeroUuid, isMarch, directionWaitResult, targetServerId, destroyTimeIndex)
  self.currentFormationUuid = 0
  self.targetType = tonumber(marchTargetType) or -1
  self.targetPoint = tonumber(pointIndex) or -1
  self.targetUuid = tonumber(uuid) or 0
  self.timeIndex = tonumber(index) or -1
  self.autoBackHome = tonumber(backHome) or 1
  self.uuid = formationUuid
  self.startPointId = tonumber(startPointId) or -1
  self.rallyType = tonumber(rallyType) or nil
  self.needAutoFix = tonumber(needAutoFix) or 1
  self.guideChangeHeroUuid = tonumber(guideChangeHeroUuid) or nil
  self.guideTargetHeroUuid = tonumber(guideTargetHeroUuid) or nil
  self.isMarch = tonumber(isMarch) or 0
  self.directionWaitResult = directionWaitResult or false
  self.targetServerId = tonumber(targetServerId) or -1
  self.destroyTimeIndex = tonumber(destroyTimeIndex) or 1
  if self.needAutoFix == 1 then
    if self.targetType == MarchTargetType.COLLECT then
      local data = CS.SceneManager.World:GetResourcePointInfoByIndex(self.targetPoint)
      local resourceType = GetTableData(TableName.GatherResource, data.id, "resource_type")
      DataCenter.ArmyFormationDataManager:AutoAddHeroForCollect(self.uuid, resourceType)
    else
      DataCenter.ArmyFormationDataManager:AutoAddHero(self.uuid)
    end
    if self:NeedTakeArmy() then
      DataCenter.ArmyFormationDataManager:AutoAddSoldier(self.uuid)
    else
    end
  end
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
  local soldiers = formation.soldiers
  local heroes = formation.heroes
  self:SetCurIndex(formation.index)
  local buildId = MarchUtil.GetFormationBuildNameByIndex(formation.index)
  self.formationUnLockIndex = {}
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    Logger.Log("para 1", buildTemplate.para1)
    local vecPara1 = string.split(buildTemplate.para1, "|")
    for k, v in ipairs(vecPara1) do
      local vec1 = string.split(v, ";")
      if 2 <= #vec1 then
        self.formationUnLockIndex[tonumber(vec1[1])] = tonumber(vec1[2])
      end
    end
  end
  self.curHeroes = {}
  self.curSoldiers = {}
  self.initHeroes = {}
  table.walk(soldiers, function(k, v)
    self.curSoldiers[k] = v
  end)
  table.walk(heroes, function(k, v)
    self.curHeroes[v] = k
  end)
  if self.needAutoFix ~= 1 then
    table.walk(heroes, function(k, v)
      self.initHeroes[v] = k
    end)
  end
  self.maxNum = self:GetMaxNum()
  local freeSoldiers = DataCenter.ArmyFormationDataManager:GetArmyUnFormationList()
  self.maxSoldiers = {}
  table.walksort(freeSoldiers, function(leftKey, rightKey)
    local aData = DataCenter.ArmyManager:FindArmy(leftKey)
    local bData = DataCenter.ArmyManager:FindArmy(rightKey)
    if aData.level ~= bData.level then
      return aData.level > bData.level
    end
    return aData.id > bData.id
  end, function(k, v)
    if 0 < v then
      self.maxSoldiers[k] = v
    end
  end)
  if self.targetType == MarchTargetType.ATTACK_MONSTER then
    if CS.SceneManager:IsInCity() then
      local monsterData = DataCenter.CityPointDataManager:GetPointDataByUuid(self.targetUuid)
      if monsterData ~= nil then
        local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterData.itemId)
        if monster ~= nil then
          self.targetPower = monster.recommend_power
        end
      end
    else
      local marchInfo = CS.SceneManager.World:GetMarch(self.targetUuid)
      if marchInfo ~= nil then
        local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(marchInfo.monsterId)
        if monster ~= nil then
          self.targetPower = monster.recommend_power
        end
      end
    end
  end
end

local function GetCurHeroData(self)
  return self.curHeroes
end

local function GetMaxHeroNum(self)
  return MarchUtil.GetMaxHeroValueByFormationIndex(self.curIndex)
end

local function GetCurCampData(self)
  local curHeroes = {}
  table.walk(self.curHeroes, function(k, v)
    if v ~= 0 then
      curHeroes[v] = k
    end
  end)
  return MarchUtil.GetCampAddParam(curHeroes)
end

local function GetCampRestraintData(self)
  local heroIdList = {}
  table.walk(self.curHeroes, function(k, v)
    local tempHeroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
    if tempHeroData ~= nil then
      table.insert(heroIdList, tempHeroData.heroId)
    end
  end)
  return MarchUtil.GetRestraintCampAndValue(heroIdList)
end

local function GetCurrentHeroDataList(self, camp)
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroBySort()
  local heroes = table.values(allHeroes)
  table.sort(heroes, function(heroA, heroB)
    if heroA.rarity ~= heroB.rarity then
      return heroA.rarity < heroB.rarity
    end
    if heroA.level ~= heroB.level then
      return heroA.level > heroB.level
    end
    if heroA.quality ~= heroB.quality then
      return heroA.quality > heroB.quality
    end
    if heroA.camp ~= heroB.camp then
      return heroA.camp < heroB.camp
    end
    return heroA.heroId < heroB.heroId
  end)
  local result = {}
  for _, heroData in pairs(heroes) do
    if camp ~= nil and -1 < camp then
      local targetCamp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
      if targetCamp == camp then
        table.insert(result, heroData.uuid)
      end
    else
      table.insert(result, heroData.uuid)
    end
  end
  return result
end

local function GetHeroDataByUuid(self, heroUuid)
  local data = {}
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  local heroConfig = heroData:GetConfig()
  local camp = heroConfig.camp
  local rarity = heroConfig.rarity
  data.hero_rarity = HeroUtils.GetRarityIconName(rarity, true)
  data.rankId = heroData:GetRank()
  data.heroUuid = heroUuid
  data.heroId = heroData.heroId
  data.qualityIndex = heroData.quality
  data.isWaken = heroData:IsWakeUp()
  data.quality = HeroUtils.GetQualityBgInTroopsByPath(rarity, data.isWaken)
  data.icon = HeroUtils.GetHeroBodyByHeroId(heroData.heroId)
  data.level = heroData.level
  data.camp = HeroUtils.GetCampIconPath(camp)
  data.index = 0
  data.isInMarch = false
  data.rarity = rarity
  if heroData.state == ArmyFormationState.March then
    data.isInMarch = true
  end
  data.isSelect = false
  data.isLock = false
  data.formIndex = 0
  local formData = DataCenter.ArmyFormationDataManager:GetFormationFormDataByHeroUuid(heroUuid)
  if formData ~= nil then
    data.formIndex = formData.index
  end
  local inMarchHeroId = DataCenter.HeroDataManager:GetHeroIdListInMarch()
  if inMarchHeroId[heroData.heroId] ~= nil then
    data.isLock = true
  else
    table.walk(self.curHeroes, function(k, v)
      if v == heroUuid then
        data.index = k
        data.isSelect = true
      else
        local tempHeroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
        if tempHeroData ~= nil and tempHeroData.heroId == heroData.heroId then
          data.isLock = true
        end
      end
    end)
  end
  return data
end

local function SelectHeroByUuid(self, heroUuid)
  local tempIndex = 0
  local maxHeroNum = self:GetMaxHeroNum()
  for i = 1, maxHeroNum do
    if tempIndex <= 0 and self.curHeroes[i] == nil then
      tempIndex = i
    end
  end
  if 0 < tempIndex then
    self.curHeroes[tempIndex] = heroUuid
    self.maxNum = self:GetMaxNum()
    self:OnOneKeyFillClick()
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil then
      EventManager:GetInstance():Broadcast(EventId.OnSelectHeroSelect, heroData.heroId)
    end
    self:ShowChangeHeroWarning(heroUuid)
  else
  end
end

local function ShowChangeHeroWarning(self, heroUuid)
  local data = DataCenter.ArmyFormationDataManager:GetFormationFormDataByHeroUuid(heroUuid)
  if data ~= nil then
    local index = data.index
    if index ~= self.curIndex then
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData ~= nil then
        UIUtil.ShowTips(Localization:GetString("150214", heroData:GetName(), index, self.curIndex))
      end
    end
  end
end

local function OnDeleteHeroByIndex(self, index)
  if self.curHeroes[index] ~= nil then
    local uuid = 0
    uuid = self.curHeroes[index]
    self.curHeroes[index] = nil
    local tempHeroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
    if tempHeroData ~= nil then
      EventManager:GetInstance():Broadcast(EventId.OnCancelHeroSelect, tempHeroData.heroId)
    end
    self.maxNum = self:GetMaxNum()
    self:CheckMaxSoliderNum()
  end
end

local function GetCurrentSoliderDataList(self)
  local list = {}
  if self:NeedTakeArmy() == false then
    return list
  end
  table.walk(self.curSoldiers, function(k, v)
    local oneData = {}
    oneData.armyId = k
    oneData.name = ""
    oneData.icon = ""
    oneData.level = 1
    oneData.count = v
    local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
    if template ~= nil then
      oneData.icon = string.format(LoadPath.SoldierIcons, template.icon)
      oneData.name = Localization:GetString(template.name)
      oneData.level = template.level
    end
    table.insert(list, oneData)
  end)
  table.sort(list, function(a, b)
    if a.level ~= b.level then
      return a.level > b.level
    end
    return a.armyId > b.armyId
  end)
  return list
end

local function GetSoliderState(self)
  local oneData = {}
  oneData.curNum = self:GetTotalSoldierNum()
  oneData.maxNum = self.maxNum
  return oneData
end

local function GetCurrentSoldierNum(self, armyId)
  local num = 0
  if self.curSoldiers[armyId] ~= nil and 0 < self.curSoldiers[armyId] then
    num = self.curSoldiers[armyId]
  end
  return num
end

local function SetCurrentSoldierNum(self, armyId, num)
  if 0 < num then
    self.curSoldiers[armyId] = num
  else
    self.curSoldiers[armyId] = nil
  end
end

local function GetTotalSoldierNum(self)
  local count = 0
  table.walk(self.curSoldiers, function(k, v)
    count = count + v
  end)
  return count
end

local function GetMaxSoldierNum(self)
  local count = 0
  table.walk(self.maxSoldiers, function(k, v)
    count = count + v
  end)
  return count
end

local function CheckMax(self, armyId, num)
  local oneMaxNum = self.maxSoldiers[armyId]
  local oneCurrentNum = self:GetCurrentSoldierNum(armyId)
  local currentTotalNum = self:GetTotalSoldierNum()
  local restNum = currentTotalNum - oneCurrentNum
  local checkMax = math.min(oneMaxNum, num)
  local totalRest = self.maxNum - restNum
  local final = math.min(totalRest, checkMax)
  if final < 0 then
    final = 0
  end
  return final
end

local function GetCanAddHeroNum(self)
  local heroList = {}
  for k, v in pairs(self.curHeroes) do
    if v ~= nil and v ~= 0 then
      heroList[v] = k
    end
  end
  return MarchUtil.GetCanAddHeroNum(heroList, self.curIndex)
end

local function GetIsHeroInCurFormation(self, uuid)
  local isIn = false
  for k, v in pairs(self.curHeroes) do
    if v == uuid then
      return true
    end
  end
  return false
end

local function SaveHeroData(self)
  local heroData = {}
  table.walk(self.curHeroes, function(k, v)
    if v ~= nil and 0 < v then
      heroData[v] = k
    end
  end)
  DataCenter.ArmyFormationDataManager:SetArmyFormationHero(self.uuid, heroData)
end

local function OnFormationSave(self)
  local hasHero = false
  local hasSolider = false
  table.walk(self.curSoldiers, function(k, v)
    if 0 < v then
      hasSolider = true
    end
  end)
  table.walk(self.curHeroes, function(k, v)
    if 0 < v then
      hasHero = true
    end
  end)
  if hasSolider or self:NeedTakeArmy() == false then
    if hasHero == false then
      if CS.SceneManager:IsInCity() then
        self:CloseSelf()
        return
      end
      local tempFormationTable = {}
      tempFormationTable.uuid = self.uuid
      tempFormationTable.index = self.curIndex
      tempFormationTable.soldiers = {}
      tempFormationTable.ownerUid = LuaEntry.Player.uid
      tempFormationTable.heroes = {}
      DataCenter.ArmyFormationDataManager:RefreshFormationModelToJson(tempFormationTable)
      DataCenter.ArmyFormationDataManager:AutoClearFormationData(self.uuid)
      EventManager:GetInstance():Broadcast(EventId.ArmyFormationSave)
      self:CloseSelf()
    else
      local tempFormationTable = {}
      tempFormationTable.uuid = self.uuid
      tempFormationTable.index = self.curIndex
      tempFormationTable.soldiers = self.curSoldiers
      tempFormationTable.ownerUid = LuaEntry.Player.uid
      tempFormationTable.heroes = {}
      local count = 0
      table.walksort(self.curHeroes, function(leftKey, rightKey)
        return leftKey < rightKey
      end, function(k, v)
        if v ~= nil then
          count = count + 1
          tempFormationTable.heroes[v] = count
        end
      end)
      DataCenter.ArmyFormationDataManager:RefreshFormationModelToJson(tempFormationTable)
      EventManager:GetInstance():Broadcast(EventId.ArmyFormationSave)
      self:CloseSelf()
    end
  else
    self:CloseSelf()
  end
end

local function CheckIsChangeHero(self)
  local isChange = false
  if table.count(self.initHeroes) == table.count(self.curHeroes) then
    for k, v in pairs(self.initHeroes) do
      if isChange == false and (self.curHeroes[k] == nil or self.curHeroes[k] ~= v) then
        isChange = true
      end
    end
  else
    isChange = true
  end
  return isChange
end

local function OnStartClick(self)
  if self.targetType >= 0 then
    local showGuide = self.directionWaitResult
    local hasHero = false
    local hasSolider = false
    table.walk(self.curSoldiers, function(k, v)
      if 0 < v then
        hasSolider = true
      end
    end)
    table.walk(self.curHeroes, function(k, v)
      if 0 < v then
        hasHero = true
      end
    end)
    if hasHero and (hasSolider or self:NeedTakeArmy() == false) then
      local tempFormationTable = {}
      tempFormationTable.uuid = self.uuid
      tempFormationTable.index = self.curIndex
      tempFormationTable.soldiers = self.curSoldiers
      tempFormationTable.ownerUid = LuaEntry.Player.uid
      tempFormationTable.heroes = {}
      local count = 0
      table.walksort(self.curHeroes, function(leftKey, rightKey)
        return leftKey < rightKey
      end, function(k, v)
        if v ~= nil then
          count = count + 1
          tempFormationTable.heroes[v] = count
        end
      end)
      DataCenter.ArmyFormationDataManager:RefreshFormationModelToJson(tempFormationTable)
      self:SaveHeroData()
      DataCenter.ArmyFormationDataManager:SetArmyFormationSoldier(self.uuid, self.curSoldiers)
      local sfsObj = SFSObject.New()
      sfsObj:PutLong("uuid", self.uuid)
      local formationArray = SFSArray.New()
      table.walk(self.curSoldiers, function(k, v)
        local obj = SFSObject.New()
        obj:PutUtfString("armyId", k)
        obj:PutInt("count", v)
        formationArray:AddSFSObject(obj)
      end)
      sfsObj:PutSFSArray("formations", formationArray)
      local heroArray = SFSArray.New()
      table.walk(self.curHeroes, function(k, v)
        local obj = SFSObject.New()
        obj:PutLong("heroUuid", v)
        obj:PutInt("index", k)
        heroArray:AddSFSObject(obj)
      end)
      sfsObj:PutSFSArray("heroInfos", heroArray)
      local dataObj = sfsObj
      local pos = 0
      pos = LuaEntry.Player:GetMainWorldPos()
      if CrossServerUtil:GetIsCrossServer() then
        local crossBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
        if crossBuildData ~= nil then
          pos = crossBuildData.pointId
        end
      end
      if self.targetType == MarchTargetType.ATTACK_MONSTER then
        local needShow = Setting:GetPrivateInt("SHOW_ADD_SOLDIER", 0)
        if needShow <= 0 then
          local totalPower = MarchUtil.GetFormationPower(tempFormationTable.heroes, tempFormationTable.soldiers, tempFormationTable.index, MarchUtil.GetCampAddParam(tempFormationTable.heroes))
          local targetPower = 0
          local targetLevel = 0
          local marchInfo = CS.SceneManager.World:GetMarch(self.targetUuid)
          if marchInfo ~= nil and marchInfo:GetMarchType() ~= NewMarchType.CHALLENGE_BOSS and marchInfo:GetMarchType() ~= NewMarchType.PUZZLE_BOSS then
            local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(marchInfo.monsterId)
            if monster ~= nil then
              targetPower = tonumber(monster.recommend_power)
              targetLevel = tonumber(monster.level)
              if monster.power_tip == 1 then
                targetPower = 0
              end
            end
          end
          local percent = (totalPower - targetPower) / math.max(1, targetPower)
          if percent < 0 then
            local k2 = LuaEntry.DataConfig:TryGetNum("res_lack", "k2")
            local configOpenState = LuaEntry.DataConfig:CheckSwitch("detect_monster")
            if configOpenState then
              UIUtil.ShowMessage(Localization:GetString("121010"), 1, nil, nil, nil, nil, function(needSellConfirm)
                if needSellConfirm == false then
                  Setting:SetPrivateInt("SHOW_ADD_SOLDIER", 1)
                else
                  Setting:SetPrivateInt("SHOW_ADD_SOLDIER", 0)
                end
              end, 121009)
            else
              UIUtil.ShowSecondMessage(Localization:GetString("121009"), Localization:GetString("121010"), 1, 150122, "", function()
                MarchUtil.StartMarch(self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, 0, self.uuid, self.autoBackHome, dataObj, pos, self.targetServerId)
                self:CloseSelf()
              end, function(needSellConfirm)
                if needSellConfirm == false then
                  Setting:SetPrivateInt("SHOW_ADD_SOLDIER", 1)
                else
                  Setting:SetPrivateInt("SHOW_ADD_SOLDIER", 0)
                end
              end)
            end
            if showGuide == true then
              EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 0)
            end
            return
          end
        end
        local heroUuid = 0
        local heroName = ""
        local heroNameList = {}
        local isReachBreakLimit = false
        local isReachLevelLimit = false
        local show = Setting:GetPrivateInt("UIShowHeroWarning", 0)
        if show <= 0 and showGuide == false and self.curHeroes then
          table.walk(self.curHeroes, function(v, k)
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
            if heroData ~= nil then
              if heroUuid == 0 and isReachBreakLimit == false and isReachLevelLimit == false then
                if heroData:IsReachBreakLimit() == true then
                  isReachBreakLimit = true
                  heroUuid = k
                elseif heroData:IsReachLevelLimit() == true then
                  isReachLevelLimit = true
                  heroUuid = k
                end
              end
              if heroData:IsReachBreakLimit() == true or heroData:IsReachLevelLimit() == true then
                table.insert(heroNameList, heroData:GetName())
              end
            end
          end)
        end
        if heroUuid ~= 0 and (isReachBreakLimit == true or isReachLevelLimit == true) and showGuide == false then
          local total = #heroNameList
          local num = 0
          table.walk(heroNameList, function(k, v)
            num = num + 1
            if num < total then
              heroName = heroName .. "<color=#ff0000>" .. v .. "</color>" .. ","
            else
              heroName = heroName .. "<color=#ff0000>" .. v .. "</color>"
            end
          end)
          local content = Localization:GetString("161022", heroName)
          local targetType = self.targetType
          local targetPoint = self.targetPoint
          local targetUuid = self.targetUuid
          local timeIndex = self.timeIndex
          local uuid = self.uuid
          local autoBackHome = self.autoBackHome
          local targetServer = self.targetServerId
          UIUtil.ShowSecondMessage(Localization:GetString("100378"), content, 2, "161030", "161023", function()
            MarchUtil.StartMarch(targetType, targetPoint, targetUuid, timeIndex, 0, uuid, autoBackHome, dataObj, pos, targetServer)
          end, function(needSellConfirm)
            if needSellConfirm == false then
              Setting:SetPrivateInt("UIShowHeroWarning", 1)
            else
              Setting:SetPrivateInt("UIShowHeroWarning", 0)
            end
          end, function()
            if isReachBreakLimit == true then
              local heroList = {}
              table.insert(heroList, heroUuid)
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroInfo, 1, heroUuid, heroList)
            elseif isReachLevelLimit == true then
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvance)
            end
          end)
        else
          if showGuide == true then
            EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 1)
          end
          MarchUtil.StartMarch(self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, 0, self.uuid, self.autoBackHome, dataObj, pos, self.targetServerId)
        end
      else
        local monster, assemblyMarchMax
        if self.targetType == MarchTargetType.RALLY_FOR_BOSS then
          local marchInfo = CS.SceneManager.World:GetMarch(self.targetUuid)
          if marchInfo ~= nil then
            local monsterId = marchInfo.monsterId
            monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
            assemblyMarchMax = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALLIANCE_TEAM_MAX_ARMY)
          end
        elseif self.targetType == MarchTargetType.JOIN_RALLY then
          local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.targetUuid)
          assemblyMarchMax = data.assemblyMarchMax
          monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(data.targetUid)
          if not DataCenter.BuildManager:IsExistBuildByTypeLv(BuildingTypes.FUN_BUILD_SMITHY, 1) then
            GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_SMITHY)
            return
          end
        end
        if (self.targetType == MarchTargetType.RALLY_FOR_BOSS or self.targetType == MarchTargetType.JOIN_RALLY) and monster ~= nil then
          local pow = monster.recommend_power / assemblyMarchMax * 0.8
          local totalPower = MarchUtil.GetFormationPower(tempFormationTable.heroes, tempFormationTable.soldiers, tempFormationTable.index, MarchUtil.GetCampAddParam(tempFormationTable.heroes))
          if pow > totalPower then
            UIUtil.ShowMessage(Localization:GetString("141079"), 2, "", "", function()
              MarchUtil.StartMarch(self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, 0, self.uuid, self.autoBackHome, dataObj, pos, self.targetServerId)
              self:CloseSelf()
            end)
            return
          end
        end
        if self.targetType == MarchTargetType.RALLY_FOR_BOSS then
          local time = self:GetCostTime()
          local timeLimit = LuaEntry.DataConfig:TryGetNum("assembly_monster_toplimit", "k2")
          if 0 < timeLimit and time > timeLimit * 60 then
            UIUtil.ShowMessage(Localization:GetString("110203", timeLimit), 2, GameDialogDefine.CANCEL, "400027", function()
              self:CloseSelf()
            end, function()
              MarchUtil.StartMarch(self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, 0, self.uuid, self.autoBackHome, dataObj, pos, self.targetServerId)
              self:CloseSelf()
            end)
            return
          end
        end
        MarchUtil.StartMarch(self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, 0, self.uuid, self.autoBackHome, dataObj, pos, self.targetServerId, self.destroyTimeIndex)
      end
      self:CloseSelf()
    else
      if showGuide == true then
        EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 0)
      end
      UIUtil.ShowTipsId(GameDialogDefine.ADD_SOLDIER)
    end
  else
    UIUtil.ShowTipsId(120090)
  end
end

local function ClearFormation(self)
  DataCenter.ArmyFormationDataManager:AutoClearFormationData(self.uuid)
end

local function GetCostTime(self)
  local speed = 1
  local distance = Vector3.Distance(SceneUtils.TileIndexToWorld(self.startPointId), SceneUtils.TileIndexToWorld(self.targetPoint))
  local k1 = LuaEntry.DataConfig:TryGetNum("armyspeed", "k1")
  local detectEvent = DataCenter.RadarCenterDataManager:GetDetectEventInfoByPointId(self.targetPoint)
  local k7 = 1
  if detectEvent ~= nil then
    k7 = LuaEntry.DataConfig:TryGetNum("armyspeed", "k7")
    if k7 == 0 then
      k7 = 1
    end
    speed = CS.SceneManager.World.TileSize * k1 * k7
  else
    local addEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.ARMY_SPEED_ADD)
    for k, v in pairs(self.curHeroes) do
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
      if heroData ~= nil then
        addEffect = addEffect + heroData:GetEffectNum(EffectDefine.ARMY_SPEED_ADD)
      end
      local indexAdd = MarchUtil.GetFormationSpeedAddByIndex(self.curIndex)
      local joinAddSpeed = 0
      local joinRallyForBossSpeed = 0
      if self.targetType == MarchTargetType.JOIN_RALLY then
        joinAddSpeed = LuaEntry.Effect:GetGameEffect(EffectDefine.CAREER_JOIN_TEAM_SPEED_ADD_PERCENT)
        if self.rallyType == MarchTargetType.RALLY_FOR_BOSS then
          joinRallyForBossSpeed = LuaEntry.DataConfig:TryGetNum("armyspeed", "k5")
        end
      end
      local alScienceEff = 0
      if self.targetType == MarchTargetType.ASSISTANCE_BUILD or self.targetType == MarchTargetType.ASSISTANCE_THRONE or self.targetType == MarchTargetType.ASSISTANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or self.targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY or self.targetType == MarchTargetType.ASSISTANCE_DESERT or self.targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY then
        alScienceEff = LuaEntry.Effect:GetGameEffect(EffectDefine.ASSIST_SPEED_ADD)
      end
      speed = CS.SceneManager.World.TileSize * k1 * (1 + addEffect / 100 + indexAdd / 100 + joinAddSpeed / 100 + alScienceEff / 100 + joinRallyForBossSpeed)
    end
  end
  local time = distance / speed
  return time
end

local function GetArmyIdList(self)
  if self:NeedTakeArmy() == false then
    return {}
  end
  return table.keys(self.maxSoldiers)
end

local function GetArmyData(self, armyId)
  local oneData = {}
  oneData.name = ""
  oneData.armyId = armyId
  oneData.maxNum = self.maxSoldiers[armyId]
  oneData.icon = ""
  oneData.level = 0
  local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
  if template ~= nil then
    oneData.icon = string.format(LoadPath.SoldierIcons, template.icon)
    oneData.name = Localization:GetString(template.name)
    oneData.level = template.level
  end
  return oneData
end

local function OnOneKeyFillClick(self)
  if self:NeedTakeArmy() == false then
    return
  end
  self.curSoldiers = {}
  table.walksort(self.maxSoldiers, function(leftKey, rightKey)
    local aData = DataCenter.ArmyManager:FindArmy(leftKey)
    local bData = DataCenter.ArmyManager:FindArmy(rightKey)
    if aData.level ~= bData.level then
      return aData.level > bData.level
    end
    return aData.id > bData.id
  end, function(k, v)
    local num = self:CheckMax(k, v)
    self:SetCurrentSoldierNum(k, num)
  end)
end

local function OnOneKeyClearClick(self)
  self.curSoldiers = {}
  table.walk(self.maxSoldiers, function(k, v)
    self:SetCurrentSoldierNum(k, 0)
  end)
end

local function OnSaveClick(self)
  DataCenter.ArmyFormationDataManager:SetArmyFormationSoldier(self.uuid, self.curSoldiers)
  EventManager:GetInstance():Broadcast(EventId.ArmyFormationSave)
end

local function GetCostStaminaByTargetType(self, type)
  return MarchUtil.GetCostStaminaByTargetType(type, self.rallyType, self.uuid)
end

local function GetFormationPower(self)
  local curHeroes = {}
  table.walk(self.curHeroes, function(k, v)
    if v ~= 0 then
      curHeroes[v] = k
    end
  end)
  local campData = self:GetCurCampData()
  if self.targetType == MarchTargetType.EXPLORE then
    local info = CS.SceneManager.World:GetPointInfoByUuid(self.targetUuid)
    if info ~= nil then
      return MarchUtil.GetExploreFormationPower(curHeroes, info.eventId, self.curIndex, campData)
    end
  end
  return MarchUtil.GetFormationPower(curHeroes, self.curSoldiers, self.curIndex, campData)
end

local function GetTargetPower(self)
  return self.targetPower
end

local function NeedTakeArmy(self)
  return self.targetType ~= MarchTargetType.EXPLORE
end

local function GetScienceIdByUnlock(self, index)
  Logger.Log("GetScienceIdByUnlockIndex", index)
  if self.formationUnLockIndex[index] ~= nil then
    Logger.Log("GetScienceIdByUnlock", self.formationUnLockIndex[index])
    return self.formationUnLockIndex[index]
  end
end

local function OnChangeMarchInGuide(self)
  local hasHero = false
  local hasSolider = false
  table.walk(self.curSoldiers, function(k, v)
    if 0 < v then
      hasSolider = true
    end
  end)
  table.walk(self.curHeroes, function(k, v)
    if 0 < v then
      hasHero = true
    end
  end)
  if hasHero and hasSolider then
    local tempFormationTable = {}
    tempFormationTable.uuid = self.uuid
    tempFormationTable.index = self.curIndex
    tempFormationTable.soldiers = self.curSoldiers
    tempFormationTable.ownerUid = LuaEntry.Player.uid
    tempFormationTable.heroes = {}
    local count = 0
    table.walksort(self.curHeroes, function(leftKey, rightKey)
      return leftKey < rightKey
    end, function(k, v)
      if v ~= nil then
        count = count + 1
        tempFormationTable.heroes[v] = count
      end
    end)
    DataCenter.ArmyFormationDataManager:RefreshFormationModelToJson(tempFormationTable)
    local sfsObj = SFSObject.New()
    sfsObj:PutLong("uuid", self.uuid)
    local formationArray = SFSArray.New()
    table.walk(self.curSoldiers, function(k, v)
      local obj = SFSObject.New()
      obj:PutUtfString("armyId", k)
      obj:PutInt("count", v)
      formationArray:AddSFSObject(obj)
    end)
    sfsObj:PutSFSArray("formations", formationArray)
    local heroArray = SFSArray.New()
    table.walk(self.curHeroes, function(k, v)
      local obj = SFSObject.New()
      obj:PutLong("heroUuid", v)
      obj:PutInt("index", k)
      heroArray:AddSFSObject(obj)
    end)
    sfsObj:PutSFSArray("heroInfos", heroArray)
    DataCenter.GuideCityManager:SetFormationParam(sfsObj)
    self:CloseSelf()
    EventManager:GetInstance():Broadcast(EventId.CreateFormationUuid, self.uuid)
    DataCenter.GuideCityManager:StartMoveCityTroop(self.targetPoint)
  else
    UIUtil.ShowTipsId(GameDialogDefine.ADD_SOLDIER)
  end
end

UIFormationTableNewCtrl.GetCurrentSoldierNum = GetCurrentSoldierNum
UIFormationTableNewCtrl.CheckMax = CheckMax
UIFormationTableNewCtrl.GetArmyIdList = GetArmyIdList
UIFormationTableNewCtrl.GetArmyData = GetArmyData
UIFormationTableNewCtrl.OnOneKeyFillClick = OnOneKeyFillClick
UIFormationTableNewCtrl.OnOneKeyClearClick = OnOneKeyClearClick
UIFormationTableNewCtrl.CloseSelf = CloseSelf
UIFormationTableNewCtrl.Close = Close
UIFormationTableNewCtrl.InitData = InitData
UIFormationTableNewCtrl.GetTotalSoldierNum = GetTotalSoldierNum
UIFormationTableNewCtrl.SetCurrentSoldierNum = SetCurrentSoldierNum
UIFormationTableNewCtrl.GetSoliderState = GetSoliderState
UIFormationTableNewCtrl.GetCurrentSoliderDataList = GetCurrentSoliderDataList
UIFormationTableNewCtrl.OnDeleteHeroByIndex = OnDeleteHeroByIndex
UIFormationTableNewCtrl.SelectHeroByUuid = SelectHeroByUuid
UIFormationTableNewCtrl.GetHeroDataByUuid = GetHeroDataByUuid
UIFormationTableNewCtrl.GetCurrentHeroDataList = GetCurrentHeroDataList
UIFormationTableNewCtrl.GetMaxNum = GetMaxNum
UIFormationTableNewCtrl.OnDeleteHeroByIndex = OnDeleteHeroByIndex
UIFormationTableNewCtrl.GetCurHeroData = GetCurHeroData
UIFormationTableNewCtrl.GetCurCampData = GetCurCampData
UIFormationTableNewCtrl.SetCurIndex = SetCurIndex
UIFormationTableNewCtrl.OnStartClick = OnStartClick
UIFormationTableNewCtrl.ClearFormation = ClearFormation
UIFormationTableNewCtrl.GetCostTime = GetCostTime
UIFormationTableNewCtrl.SaveHeroData = SaveHeroData
UIFormationTableNewCtrl.OnSaveClick = OnSaveClick
UIFormationTableNewCtrl.GetMaxHeroNum = GetMaxHeroNum
UIFormationTableNewCtrl.GetCostStaminaByTargetType = GetCostStaminaByTargetType
UIFormationTableNewCtrl.GetFormationPower = GetFormationPower
UIFormationTableNewCtrl.GetTargetPower = GetTargetPower
UIFormationTableNewCtrl.GetAtkValue = GetAtkValue
UIFormationTableNewCtrl.GetDefValue = GetDefValue
UIFormationTableNewCtrl.GetAtkDes = GetAtkDes
UIFormationTableNewCtrl.GetDefDes = GetDefDes
UIFormationTableNewCtrl.NeedTakeArmy = NeedTakeArmy
UIFormationTableNewCtrl.GetAtkImage = GetAtkImage
UIFormationTableNewCtrl.GetDefImage = GetDefImage
UIFormationTableNewCtrl.GetCanAddHeroNum = GetCanAddHeroNum
UIFormationTableNewCtrl.GetIsHeroInCurFormation = GetIsHeroInCurFormation
UIFormationTableNewCtrl.CheckMaxSoliderNum = CheckMaxSoliderNum
UIFormationTableNewCtrl.GetMaxSoldierNum = GetMaxSoldierNum
UIFormationTableNewCtrl.GetScienceIdByUnlock = GetScienceIdByUnlock
UIFormationTableNewCtrl.OnChangeMarchInGuide = OnChangeMarchInGuide
UIFormationTableNewCtrl.OnFormationSave = OnFormationSave
UIFormationTableNewCtrl.ShowChangeHeroWarning = ShowChangeHeroWarning
UIFormationTableNewCtrl.CheckIsChangeHero = CheckIsChangeHero
UIFormationTableNewCtrl.GetCampRestraintData = GetCampRestraintData
return UIFormationTableNewCtrl
