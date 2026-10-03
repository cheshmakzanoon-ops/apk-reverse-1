local MailScoutParseHelper = {}

local function DecodeHero(formation)
  local isSuccess = true
  if not formation then
    return false
  end
  local heroes = formation.hero
  for k, unit in pairs(heroes) do
    local heroUnit = unit
    if heroUnit.effects and #heroUnit.effects > 0 then
      heroUnit.effect = {}
      for i = 1, #heroUnit.effects do
        if heroUnit.effects[i] then
          local effect = heroUnit.effects[i]
          local effectId = effect.effectId
          local value = effect.value
          heroUnit.effect[effectId] = value
        end
      end
      heroUnit.effects = nil
      heroUnit.equipPower = heroUnit.effect[HeroEffectDefine.HeroPowerEquip] or 0
      heroUnit.skillPower = heroUnit.effect[HeroEffectDefine.HeroPowerSkill] or 0
      heroUnit.weaponPower = heroUnit.effect[HeroEffectDefine.HeroUniqueWeaponPower] or 0
      heroUnit.skillLevels = {}
      for _, v in pairs(heroUnit.skillInfos) do
        heroUnit.skillLevels[v.skillId] = v.skillLv
      end
      heroUnit.weaponLevel = heroUnit.weaponLevel or {value = 0}
      local awakenLv = heroUnit.awakenLv and heroUnit.awakenLv.value or 0
      local heroSkinId = heroUnit.heroSkinId and heroUnit.heroSkinId.value or 0
      heroUnit.heroInfo = DataCenter.HeroDataManager:GetHeroTemplateReadOnly(heroUnit.heroId.value, heroUnit.heroLevel.value, heroUnit.heroRankLevel.value, heroUnit.skillLevels, heroUnit.weaponLevel.value, heroUnit.skillInfos, heroUnit.weaponStrengthen, awakenLv, heroSkinId)
      heroUnit.heroInfo:UpdateUWUnitInfo(heroUnit.weaponStrengthen)
      if not heroUnit.heroInfo.meta then
        Logger.LogError("\232\139\177\233\155\132\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176\239\188\154" .. heroUnit.heroId)
        isSuccess = false
        break
      end
    end
  end
  return isSuccess
end

local function DecodeTacticalWeapon(weapon)
  local isSuccess = true
  local weaponUnit = weapon
  if weaponUnit.effects and #weaponUnit.effects > 0 then
    weaponUnit.effect = {}
    for _, v in pairs(weaponUnit.effects) do
      weaponUnit.effect[v.effectId] = v.value
    end
    weaponUnit.effects = nil
    weaponUnit.skinId = weaponUnit.skinId or 0
    weaponUnit.weaponInfo = TacticalWeaponInfo.New()
    local result = weaponUnit.weaponInfo:CreateFromTemplate(weaponUnit.id, weaponUnit.level)
    if not result then
      Logger.LogError("\230\136\152\230\156\175\230\173\166\229\153\168\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176\239\188\154" .. weaponUnit.heroId)
      isSuccess = false
      return isSuccess
    end
    weaponUnit.skillchipSets = {}
    weaponUnit.unlockedSets = {}
    for _, v in pairs(weaponUnit.chipGroups) do
      local setData = v
      local index = setData.group
      local map = {}
      weaponUnit.skillchipSets[index] = map
      weaponUnit.unlockedSets[#weaponUnit.unlockedSets + 1] = index
      for _, chip in pairs(setData.skillChipInfos) do
        local skillChipTemplate = DataCenter.TWSkillChipTemplateManager:GetTemplate(chip.cfgId)
        if skillChipTemplate then
          local slot = skillChipTemplate.skill_type
          map[slot] = chip
        end
      end
    end
    table.sort(weaponUnit.unlockedSets, function(a, b)
      return a < b
    end)
  end
  return isSuccess
end

local function DecodePlayerEffect(extData)
  if not extData then
    return
  end
  local army = extData.army
  if not army then
    return
  end
  local target = army.target
  if not target then
    return
  end
  local playerEffects = target.effects
  if not playerEffects then
    return
  end
  local playerEffect = {}
  for i = 1, #playerEffects do
    if playerEffects[i] then
      local effect = playerEffects[i]
      local effectId = effect.effectId
      local value = effect.value
      playerEffect[effectId] = value
    end
  end
  target.effect = playerEffect
end

MailScoutParseHelper.DecodeHero = DecodeHero
MailScoutParseHelper.DecodeTacticalWeapon = DecodeTacticalWeapon
MailScoutParseHelper.DecodePlayerEffect = DecodePlayerEffect
return MailScoutParseHelper
