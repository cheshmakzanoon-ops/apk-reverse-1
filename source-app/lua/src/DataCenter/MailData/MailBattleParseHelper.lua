local MailBattleParseHelper = {}
local Localization = CS.GameEntry.Localization

local function DecodeMailPlayerStat(player, battlePointInfo)
  if player == nil then
    return false
  end
  if player.isFlat then
    return true
  end
  player.isFlat = true
  local battleServerId, battlePointId
  if battlePointInfo then
    battleServerId = battlePointInfo.battleServerId
    battlePointId = battlePointInfo.pointId
  end
  if player.maxSoldierCount == 0 then
    player.maxSoldierCount = player.maxSoldierPower
  end
  if player.soldierCountBeforeStart == 0 then
    player.soldierCountBeforeStart = player.soldierPowerBeforeStart
  end
  if player.effects then
    player.effectList = {}
    for _, v in ipairs(player.effects) do
      if v and v.effectId and v.value and v.value then
        player.effectList[v.effectId] = tonumber(v.value) or 0
      end
    end
  end
  if player.armyType == MailTargetType.DragonBuild then
    player.meta = DataCenter.DragonBuildTemplateManager:GetTemplate(player.contentId)
    if player.meta then
      player.pic = player.meta:GetDetailPath()
      player.name = Localization:GetString(player.meta.name)
      player.level = player.meta.level
    else
      Logger.LogError(string.format("BattleFieldBuild-BuildId cant find: type=1, id=%s", player.contentId))
      return false
    end
  elseif player.armyType == MailTargetType.WinterStormBuilding then
    player.meta = DataCenter.WinterStormTemplateManager:GetTemplate(player.contentId)
    if player.meta then
      player.pic = player.meta:GetDetailPath()
      player.name = Localization:GetString(player.meta.name)
      player.level = player.meta.level or 0
    else
      Logger.LogError(string.format("BattleFieldBuild-BuildId cant find: type=2, id=%s", player.contentId))
      return false
    end
  elseif player.armyType == MailTargetType.EpidemicBuild then
    player.meta = DataCenter.EpidemicBuildTemplateMgr:GetTemplate(player.contentId)
    if player.meta then
      player.pic = player.meta:GetDetailPath()
      player.name = Localization:GetString(player.meta.name)
      player.level = player.meta.level or 0
    else
      Logger.LogError(string.format("BattleFieldBuild-BuildId cant find: type=3, id=%s", player.contentId))
      return false
    end
  elseif player.armyType == MailTargetType.AllianceCity or player.armyType == MailTargetType.CityStronghold or player.armyType == MailTargetType.TradeStation or player.armyType == MailTargetType.SeasonBank or player.armyType == MailTargetType.SeasonOutpost then
    player.meta = DataCenter.AllianceCityTemplateManager:GetTemplate(player.contentId, battleServerId)
    if player.meta then
      player.pic = player.meta:GetIconPath(false)
      player.name = Localization:GetString(player.meta.name)
      player.level = player.meta.level
    else
      Logger.LogError(string.format("lw_worldcity cant find %s", player.contentId))
      return false
    end
  elseif player.armyType == MailTargetType.Monster then
    player.meta = DataCenter.MonsterTemplateManager:TryGetMonsterTemplate(player.contentId)
    if player.meta then
      local name
      if player.user then
        local abbr
        if player.user.allianceInfo then
          abbr = player.user.allianceInfo.alAbbr
        end
        local ownerName = UIUtil.FormatServerAllianceName(player.user.srcServerId, abbr, player.user.name, player.user.uid)
        name = Localization:GetString(player.meta.name, ownerName)
      else
        name = Localization:GetString(player.meta.name)
      end
      player.pic = UIUtil.GetFullPath(LoadPath.HeroIconsSmallPath, player.meta.pic)
      local level = Localization:GetString(GameDialogDefine.LEVEL_NUMBER, player.meta.level)
      player.name = level .. " " .. name
      player.level = player.meta.level
    else
      Logger.LogError(string.format("lw_world_monster cant find %s", player.contentId))
      return false
    end
  elseif player.armyType == MailTargetType.Army then
    if player.contentId == 0 then
      player.pic = ""
      player.name = Localization:GetString("310165")
    else
      player.meta = DataCenter.LWArmyTemplateManager:TryGetArmyTemplate(player.contentId)
      if player.meta == nil then
        player.meta = DataCenter.LWSeasonTowerArmyTemplateManager:TryGetArmyTemplate(player.contentId)
      end
      if player.meta then
        player.pic = UIUtil.GetFullPath(LoadPath.HeroIconsSmallPath, player.meta.army_icon)
        player.name = Localization:GetString(player.meta.name)
      else
        Logger.LogError(string.format("lw_army cant find %s", player.contentId))
        return false
      end
    end
  elseif player.armyType == MailTargetType.SeasonDesert then
    player.meta = DataCenter.DesertTemplateManager:GetTemplate(player.contentId)
    if player.meta then
      player.pic = string.format(LoadPath.SeasonDesert, player.meta.icon)
      if player.meta.level == 0 then
        player.name = Localization:GetString(player.meta.name)
      else
        player.name = Localization:GetString("140002", player.meta.level) .. " " .. Localization:GetString(player.meta.name)
      end
    else
      Logger.LogError(string.format("desert cant find %s", player.contentId))
      return false
    end
  elseif player.armyType == MailTargetType.SeasonBuilding then
    local level = player.contentId % BuildLevelCap
    local buildId = player.contentId - level
    player.meta = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
    if player.meta == nil then
      player.meta = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    end
    if player.meta then
      player.pic = player.meta:GetBuildIconOutCity()
      if level == nil or level == 0 then
        player.name = Localization:GetString(player.meta.name)
      else
        player.name = Localization:GetString("140002", level) .. " " .. Localization:GetString(player.meta.name)
      end
      player.level = level
    else
      Logger.LogError(string.format("desert cant find %s", player.contentId))
      return false
    end
  elseif player.armyType == MailTargetType.SeasonCenter then
    player.meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(player.contentId)
    if player.meta then
      player.pic = player.meta:GetIconPath()
      player.name = Localization:GetString(player.meta.name)
      player.level = 1
    else
      Logger.LogError(string.format("desert cant find %s", player.contentId))
      return false
    end
  elseif player.armyType == MailTargetType.Player then
    if player.user then
      player.uid = player.user.uid
      player.isActiveAnonymity = player.user.isActiveAnonymity
      local wolfEndTime = player.user.wolfEndTime
      if wolfEndTime and 0 < wolfEndTime then
        player.wolfEndTime = wolfEndTime
      end
      if player.isActiveAnonymity then
        player.name = Localization:GetString("season_mastery_173")
      else
        player.pic = player.user.pic
        player.picVer = player.user.picVer
        local abbr
        if player.user.allianceInfo then
          abbr = player.user.allianceInfo.alAbbr
        end
        player.name = UIUtil.FormatServerAllianceName(player.user.srcServerId, abbr, player.user.name, player.uid)
        player.abbrName = UIUtil.FormatAllianceAndName(abbr, player.user.name, player.uid)
        player.level = player.user.level
        player.headSkinId = player.user.headSkinId
        player.frameBg = DataCenter.DecorationDataManager:GetHeadFrame(player.user.headSkinId, 0, false)
      end
    else
      Logger.Log(string.format("\230\148\187\230\137\147\231\142\169\229\174\182\228\189\134\230\152\175\230\178\161\230\156\137\231\142\169\229\174\182\239\188\159"))
      return false
    end
  elseif player.armyType == MailTargetType.ZWL_BUILDING then
    player.meta = DataCenter.LandlordMgr:GetCityTemplate(player.contentId)
    if player.meta then
      player.pic = player.meta:GetIconPath(false)
      player.name = Localization:GetString(player.meta.name)
      player.level = player.meta.level
    else
      Logger.LogError(string.format("center_map_city cant find %s", player.contentId))
      return false
    end
  else
    Logger.LogError(string.format("old mail format not support"))
    return false
  end
  return true
end

local function DecodeLwBattlePlayerStat(player, playerOld, battlePointInfo)
  local status = DecodeMailPlayerStat(player, battlePointInfo)
  if playerOld and playerOld.armyType ~= nil and DecodeMailPlayerStat(playerOld, battlePointInfo) then
    player.old_pic = player.pic
    player.old_name = player.name
    player.old_level = player.level
    player.old_armyType = player.armyType
    player.armyType = playerOld.armyType
    player.pic = playerOld.pic
    player.name = playerOld.name
    player.level = playerOld.level
    player.meta = playerOld.meta
    if playerOld.armyType == MailTargetType.Player then
      player.uid = playerOld.uid
      player.picVer = playerOld.picVer
      player.abbrName = playerOld.abbrName
      player.frameBg = playerOld.frameBg
      player.headSkinId = playerOld.headSkinId
      player.isActiveAnonymity = playerOld.isActiveAnonymity
      player.wolfEndTime = playerOld.wolfEndTime
    end
  end
  return status
end

local function DecodeSingleLWBattleHero(heroUnit)
  if not heroUnit then
    return false
  end
  local isSuccess = true
  if not heroUnit.effects then
    return false
  end
  heroUnit.effect = {}
  for i = 1, #heroUnit.effects do
    if heroUnit.effects[i] then
      local effect = heroUnit.effects[i]
      local effectId = effect.effectId
      local value = effect.value
      heroUnit.effect[effectId] = value
    end
  end
  heroUnit.black = heroUnit.effect[HeroEffectDefine.HeroSoldierCapacity] or 1
  heroUnit.black = heroUnit.black == 0 and 1 or heroUnit.black
  heroUnit.red = heroUnit.maxSoldierCount
  heroUnit.green = heroUnit.soldierCount
  heroUnit.initHp = heroUnit.maxHp * heroUnit.red / heroUnit.black
  heroUnit.effects = nil
  heroUnit.skillLevels = {}
  for _, v in pairs(heroUnit.skillInfos) do
    heroUnit.skillLevels[v.skillId] = v.skillLv
  end
  heroUnit.weaponLevel = heroUnit.weaponLevel or 0
  heroUnit.weaponPower = heroUnit.weaponPower or 0
  heroUnit.heroInfo = DataCenter.HeroDataManager:GetHeroTemplateReadOnly(heroUnit.heroId, heroUnit.heroLevel, heroUnit.rankLv, heroUnit.skillLevels, heroUnit.weaponLevel, heroUnit.skillInfos, heroUnit.weaponStrengthen, heroUnit.awakenLv, heroUnit.heroSkinId)
  if heroUnit.stat and heroUnit.stat.damageNum and 0 < heroUnit.stat.damageNum then
    heroUnit.stat.critRate = (heroUnit.stat.critNum or 0) / heroUnit.stat.damageNum
  end
  heroUnit.heroInfo:UpdateUWUnitInfo(heroUnit.weaponStrengthen)
  if not heroUnit.heroInfo.meta then
    Logger.LogError("\232\139\177\233\155\132\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176\239\188\154" .. heroUnit.heroId)
    isSuccess = false
  end
  return isSuccess
end

local function DecodeLwBattleHero(units)
  local isSuccess = true
  local toDeleteIndex = {}
  for k, unit in pairs(units) do
    local unitType = unit.unitType
    if unitType == BattleUnitType.Hero or unitType == BattleUnitType.Pet or unitType == BattleUnitType.Dominator then
      local heroUnit = unit
      if heroUnit.effects and #heroUnit.effects > 0 then
        if not DecodeSingleLWBattleHero(heroUnit) then
          isSuccess = false
          break
        end
      elseif not heroUnit.effect then
        table.insert(toDeleteIndex, k)
      end
    end
  end
  for i = 1, #toDeleteIndex do
    units[toDeleteIndex[i]] = nil
  end
  return isSuccess
end

local function DecodeLwBattleDominator(units)
  local isSuccess = true
  local toDeleteIndex = {}
  for k, unit in pairs(units) do
    local unitType = unit.unitType
    if unitType == BattleUnitType.Dominator then
      local heroUnit = unit
      if heroUnit.effects and #heroUnit.effects > 0 then
        if not heroUnit then
          return false
        end
        if not heroUnit.effects then
          return false
        end
        heroUnit.effect = {}
        for i = 1, #heroUnit.effects do
          if heroUnit.effects[i] then
            local effect = heroUnit.effects[i]
            local effectId = effect.effectId
            local value = effect.value
            heroUnit.effect[effectId] = value
          end
        end
        heroUnit.black = heroUnit.effect[HeroEffectDefine.HeroSoldierCapacity] or 1
        heroUnit.black = heroUnit.black == 0 and 1 or heroUnit.black
        heroUnit.red = heroUnit.maxSoldierCount
        heroUnit.green = heroUnit.soldierCount
        heroUnit.initHp = heroUnit.maxHp * heroUnit.red / heroUnit.black
        heroUnit.effects = nil
        heroUnit.skillLevels = {}
        for _, v in pairs(heroUnit.skillInfos) do
          heroUnit.skillLevels[v.skillId] = v.skillLv
        end
        heroUnit.weaponLevel = heroUnit.weaponLevel or 0
        heroUnit.weaponPower = heroUnit.weaponPower or 0
        heroUnit.heroInfo = DataCenter.HeroDataManager:GetHeroTemplateReadOnly(heroUnit.heroId, heroUnit.heroLevel, heroUnit.rankLv, heroUnit.skillLevels, heroUnit.weaponLevel, heroUnit.skillInfos)
        if heroUnit.stat and heroUnit.stat.damageNum and 0 < heroUnit.stat.damageNum then
          heroUnit.stat.critRate = (heroUnit.stat.critNum or 0) / heroUnit.stat.damageNum
        end
        if not heroUnit.heroInfo.meta then
          Logger.LogError("\232\139\177\233\155\132\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176\239\188\154" .. heroUnit.heroId)
          isSuccess = false
        end
      elseif not heroUnit.effect then
        table.insert(toDeleteIndex, k)
      end
    end
  end
  for i = 1, #toDeleteIndex do
    units[toDeleteIndex[i]] = nil
  end
  return isSuccess
end

local function DecodePlayerEffect(player)
  if player.effects then
    player.effectsDic = {}
    for _, v in pairs(player.effects) do
      player.effectsDic[v.effectId] = v.value
    end
    player.effects = nil
  end
end

local function HasPlayerEffect(player)
  return player.effects and table.count(player.effects) > 0 or player.effectsDic and 0 < table.count(player.effectsDic)
end

local function DecodeScienceEffect(player)
  local progress = player.progress
  if not progress then
    return false
  end
  if progress.scienceEffects then
    progress.sciEffectsDic = {}
    for _, v in pairs(progress.scienceEffects) do
      progress.sciEffectsDic[v.id] = v.val
    end
    progress.scienceEffects = nil
  end
end

local function HasScienceEffect(player)
  local progress = player.progress
  if not progress then
    return false
  end
  return progress.scienceEffects and table.count(progress.scienceEffects) > 0 or progress.sciEffectsDic and 0 < table.count(progress.sciEffectsDic)
end

function MailBattleParseHelper.DecodeDecoEffect(player)
  local progress = player.progress
  if not progress then
    return false
  end
  if progress.decoEffects then
    progress.decoEffectsDic = {}
    for _, v in pairs(progress.decoEffects) do
      local id = v.id
      if id == 75950 then
        id = 75949
      end
      local val = 0
      if progress.decoEffectsDic[id] then
        val = progress.decoEffectsDic[id]
      end
      progress.decoEffectsDic[id] = val + v.val
    end
    progress.decoEffects = nil
  end
end

function MailBattleParseHelper.HasDecoEffect(player)
  local progress = player.progress
  if not progress then
    return false
  end
  return progress.decoEffects and table.count(progress.decoEffects) > 0 or progress.decoEffectsDic and 0 < table.count(progress.decoEffectsDic)
end

local function DecodeLwBattleWeapon(units)
  local isSuccess = true
  for _, unit in pairs(units) do
    if unit.unitType ~= nil and unit.unitType == BattleUnitType.TacticalWeapon then
      local weaponUnit = unit
      if weaponUnit.effects and #weaponUnit.effects > 0 then
        weaponUnit.effect = {}
        for _, v in pairs(weaponUnit.effects) do
          weaponUnit.effect[v.effectId] = v.value
        end
        weaponUnit.black = weaponUnit.effect[HeroEffectDefine.HeroSoldierCapacity] or 1
        weaponUnit.black = weaponUnit.black == 0 and 1 or weaponUnit.black
        weaponUnit.red = weaponUnit.maxSoldierCount
        weaponUnit.green = weaponUnit.soldierCount
        weaponUnit.initHp = weaponUnit.maxHp * weaponUnit.red / weaponUnit.black
        weaponUnit.effects = nil
        weaponUnit.skillLevels = {}
        for _, v in pairs(weaponUnit.skillInfos) do
          weaponUnit.skillLevels[v.skillId] = v.skillLv
        end
        weaponUnit.skinId = weaponUnit.skinId or 0
        weaponUnit.weaponInfo = TacticalWeaponInfo.New()
        local result = weaponUnit.weaponInfo:CreateFromTemplate(weaponUnit.heroId, weaponUnit.heroLevel)
        if not result then
          Logger.LogError("\230\136\152\230\156\175\230\173\166\229\153\168\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176\239\188\154" .. weaponUnit.heroId)
          isSuccess = false
          break
        end
        weaponUnit.skillChips = {}
        if weaponUnit.skillChipInfos then
          for _, v in pairs(weaponUnit.skillChipInfos) do
            local skillChipInfo = TWSkillChipInfo.New()
            skillChipInfo:CreateFromTemplate(v.cfgId, v.lv, v.star)
            weaponUnit.skillChips[skillChipInfo:GetType()] = skillChipInfo
          end
        end
        if weaponUnit.stat and weaponUnit.damageNum and 0 < weaponUnit.damageNum then
          weaponUnit.stat.critRate = (weaponUnit.stat.critNum or 0) / weaponUnit.damageNum
        end
      end
    end
  end
  return isSuccess
end

local function DecodeShowScience(progress1, progress2)
  if progress1 == nil or progress2 == nil then
    local science1 = progress1 and progress1.science or {}
    local science2 = progress2 and progress2.science or {}
    return science1, science2
  end
  if progress1 and progress1.showScience or progress2 and progress2.showScience then
    local showScience1 = progress1 and progress1.showScience or {}
    local showScience2 = progress2 and progress2.showScience or {}
    return showScience1, showScience2
  end
  progress1.showScience = DeepCopy(progress1.science)
  progress2.showScience = DeepCopy(progress2.science)
  local k3s = LuaEntry.DataConfig:TryGetStr("battle_report_tech", "k3")
  local k3Techs = string.split(k3s, ";")
  local fillScience = {}
  for i = 1, #k3Techs do
    local techId = tonumber(k3Techs[i])
    local hasAdd = false
    if progress1 and progress1.science then
      for i = 1, #progress1.science do
        local science = progress1.science[i]
        if science.scienceTabId == techId then
          fillScience[science.scienceTabId] = {
            index = i,
            science = science,
            add2 = true
          }
          hasAdd = true
          break
        end
      end
    end
    if progress2 and progress2.science then
      for i = 1, #progress2.science do
        local science = progress2.science[i]
        if science.scienceTabId == techId then
          if hasAdd then
            fillScience[science.scienceTabId] = nil
            break
          end
          fillScience[science.scienceTabId] = {
            index = i,
            science = science,
            add1 = true
          }
          break
        end
      end
    end
  end
  for scienceId, info in pairs(fillScience) do
    local index = info.index
    local science = info.science
    local addTo
    if info.add1 then
      addTo = progress1.showScience
    elseif info.add2 then
      addTo = progress2.showScience
    end
    if addTo then
      local newScience = DeepCopy(science)
      newScience.progress = 0
      if index > #addTo then
        table.insert(addTo, newScience)
      else
        table.insert(addTo, index, newScience)
      end
    end
  end
  return progress1.showScience, progress2.showScience
end

local function AccumulateOtherEffectDic(dic, effectId, val)
  local eid = tonumber(effectId)
  if not eid then
    return
  end
  dic[eid] = (dic[eid] or 0) + (tonumber(val) or 0)
end

function MailBattleParseHelper.DecodeOtherEffect(player)
  local progress = player.progress
  if not progress then
    return false
  end
  local isNewOtherPower = BattleReportUtil.IsNewOtherPower(player)
  if isNewOtherPower then
    if progress.otherEffects then
      progress.otherEffectsRaw = DeepCopy(progress.otherEffects)
      progress.otherEffectsDic = {}
      for _, tab in pairs(progress.otherEffects) do
        if tab.effects then
          for _, effect in pairs(tab.effects) do
            AccumulateOtherEffectDic(progress.otherEffectsDic, effect.id, effect.val)
          end
        end
      end
    end
  elseif progress.extraEffects then
    progress.otherEffectsDic = {}
    progress.otherEffectsRaw = {
      {
        tabType = 0,
        effects = {}
      }
    }
    for _, v in pairs(progress.extraEffects) do
      AccumulateOtherEffectDic(progress.otherEffectsDic, v.id, v.val)
      table.insert(progress.otherEffectsRaw[1].effects, {
        id = v.id,
        val = v.val
      })
    end
  end
  progress.extraEffects = nil
  progress.otherEffects = nil
end

function MailBattleParseHelper.HasOtherEffect(player)
  local progress = player.progress
  if not progress then
    return false
  end
  return progress.otherEffects and table.count(progress.otherEffects) > 0 or progress.otherEffectsDic and 0 < table.count(progress.otherEffectsDic)
end

local function IsWerewolf(player)
  return player and player.wolfEndTime and UITimeManager:GetInstance():GetServerTime() < tonumber(player.wolfEndTime)
end

MailBattleParseHelper.DecodeLwBattlePlayerStat = DecodeLwBattlePlayerStat
MailBattleParseHelper.DecodeSingleLWBattleHero = DecodeSingleLWBattleHero
MailBattleParseHelper.DecodeLwBattleHero = DecodeLwBattleHero
MailBattleParseHelper.DecodeLwBattleWeapon = DecodeLwBattleWeapon
MailBattleParseHelper.DecodeLwBattleDominator = DecodeLwBattleDominator
MailBattleParseHelper.DecodePlayerEffect = DecodePlayerEffect
MailBattleParseHelper.HasPlayerEffect = HasPlayerEffect
MailBattleParseHelper.DecodeScienceEffect = DecodeScienceEffect
MailBattleParseHelper.HasScienceEffect = HasScienceEffect
MailBattleParseHelper.DecodeShowScience = DecodeShowScience
MailBattleParseHelper.IsWerewolf = IsWerewolf
return MailBattleParseHelper
