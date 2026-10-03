local Localization = CS.GameEntry.Localization
local HeroUtils = {}
local EatForbidReason = {
  QualityNotMatch = 0,
  HeroIdNotMatch = 1,
  CampNotMatch = 2,
  CanNotMoreThanMasterQuality = 3
}
local HeroStateType = {
  HeroStateType_NORMAL = 1,
  HeroStateType_TEST = 3,
  HeroStateType_NPC = 4
}
local HeroTypeTip = {
  [HeroType.Tank] = 430706,
  [HeroType.Missile] = 430707,
  [HeroType.Aircraft] = 430708
}
local HeroJobTip = {
  [HeroJob.Defense] = 150003,
  [HeroJob.exportation] = 150004,
  [HeroJob.subsidiary] = 150005
}
local QualitySmallIcons = {
  "ui_quality_green1",
  "ui_quality_blue1",
  "ui_quality_blue2",
  "ui_quality_purple1",
  "ui_quality_purple2",
  "ui_quality_orange1",
  "ui_quality_orange2",
  "ui_quality_red1",
  "ui_quality_red2",
  "ui_quality_gold1",
  "ui_quality_gold2",
  "ui_quality_cai1",
  "ui_quality_cai2"
}
local raritySmallIcons = {
  "ui_quality_cai1",
  "ui_quality_green1",
  "ui_quality_blue1",
  "ui_quality_purple1",
  "ui_quality_orange1"
}
local qualitySmallIcons = {
  "cfm_yingxiong_touxiangkuang_fang_1",
  "cfm_yingxiong_touxiangkuang_fang_2",
  "cfm_yingxiong_touxiangkuang_fang_3",
  "cfm_yingxiong_touxiangkuang_fang_4",
  "cfm_yingxiong_touxiangkuang_fang_5"
}
local rarityToMaxStar
local rarityBigIcons = {
  "ui_quality_green_big",
  "ui_quality_green_big",
  "ui_quality_blue_big",
  "ui_quality_purple_big",
  "ui_quality_orange_big"
}
local qualityBigIcons = {
  "grey_potrait@2x",
  "green_potrait@2x",
  "blue_potrait@2x",
  "purple_potrait@2x",
  "orange_potrait@2x"
}
local qualityLevelBg = {
  "cfm_biandui_dichen_tiao1",
  "cfm_biandui_dichen_tiao2",
  "cfm_biandui_dichen_tiao3",
  "cfm_biandui_dichen_tiao4",
  "cfm_biandui_dichen_tiao5"
}
local rarityBigMasks = {
  "ui_quality_mask_green_big",
  "ui_quality_mask_green_big",
  "ui_quality_mask_blue_big",
  "ui_quality_mask_purple_big",
  "ui_quality_mask_orange_big"
}
local QualityBigIcons = {
  "ui_quality_green_big",
  "ui_quality_blue_big",
  "ui_quality_blue_big",
  "ui_quality_purple_big",
  "ui_quality_purple_big",
  "ui_quality_orange_big",
  "ui_quality_orange_big",
  "ui_quality_red_big",
  "ui_quality_red_big",
  "ui_quality_gold_big",
  "ui_quality_gold_big",
  "ui_quality_cai_big",
  "ui_quality_cai_big"
}

local function GetStarNumByQuality(quality)
  if quality == 1 or quality % 2 == 0 then
    return 0
  end
  return 1
end

local function GetQualityIconPath(quality, useBig)
  if useBig then
    return string.format(LoadPath.HeroCommonPath, qualityBigIcons[quality])
  end
  return string.format(LoadPath.HeroCommonPath, qualitySmallIcons[quality])
end

local function GetMaxStarByRarity(rarity)
  if rarityToMaxStar == nil then
    rarityToMaxStar = {}
    LocalController:instance():visitTable(HeroUtils.GetHeroXmlName(), function(id, lineData)
      rarityToMaxStar[lineData.rarity] = lineData.max_quality_level
    end)
  end
  if rarityToMaxStar[rarity] ~= nil then
    return rarityToMaxStar[rarity]
  end
  return 11
end

local function GetMaxStarLevel(heroId)
  if HeroUtils.heroStarLevel == nil then
    HeroUtils.heroStarLevel = {}
  end
  if HeroUtils.heroStarLevel[heroId] == nil then
    local lv = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "max_star_level")
    HeroUtils.heroStarLevel[heroId] = lv
  end
  return HeroUtils.heroStarLevel[heroId]
end

local function GetRarityIconPath(rarity, useBig, isWaken)
  if useBig then
    if isWaken then
      return string.format(LoadPath.HeroListPath, rarityBigIcons[#rarityBigIcons])
    end
    return string.format(LoadPath.HeroListPath, rarityBigIcons[rarity])
  end
  if isWaken then
    return string.format(LoadPath.HeroIconsSmallPath, raritySmallIcons[#raritySmallIcons])
  end
  return LoadPath.HeroIconsSmallPath .. raritySmallIcons[rarity]
end

local function GetRarityMaskPath(rarity, useBig, isWaken)
  if isWaken then
    return string.format(LoadPath.HeroListPath, rarityBigMasks[#rarityBigMasks])
  end
  return string.format(LoadPath.HeroListPath, rarityBigMasks[rarity])
end

local function GetCircleQualityIconPath(rarity, isWaken)
  return "Assets/Main/Sprites/LWLod/lyp_daditu_qipao_zhezhao.png"
end

local function GetTroopQualityIconPath(rarity, isWaken)
  local qualityIcons = {
    "cfm_yingxiong_touxiangkuang_fang_1",
    "cfm_yingxiong_touxiangkuang_fang_2",
    "cfm_yingxiong_touxiangkuang_fang_3",
    "cfm_yingxiong_touxiangkuang_fang_4",
    "cfm_yingxiong_touxiangkuang_fang_5"
  }
  local iconNames = qualityIcons[rarity]
  if isWaken ~= nil and isWaken == true then
    iconNames = qualityIcons[1]
  end
  iconNames = iconNames or qualityIcons[1]
  local path = LoadPath.HeroCommonPath
  return string.format(path, iconNames)
end

local function GetQualityBgPath(quality)
  local qualityIcons = {
    "UIHeroInfo_bg_quality_green",
    "UIHeroInfo_bg_quality_blue",
    "UIHeroInfo_bg_quality_blue",
    "UIHeroInfo_bg_quality_purple",
    "UIHeroInfo_bg_quality_purple",
    "UIHeroInfo_bg_quality_orange",
    "UIHeroInfo_bg_quality_orange",
    "UIHeroInfo_bg_quality_red",
    "UIHeroInfo_bg_quality_red",
    "UIHeroInfo_bg_quality_gold",
    "UIHeroInfo_bg_quality_gold",
    "UIHeroInfo_bg_quality_cai",
    "UIHeroInfo_bg_quality_cai"
  }
  local iconNames = qualityIcons[quality]
  assert(iconNames ~= nil, "iconNames is nil! quality:" .. quality)
  return string.format(LoadPath.HeroDetailPath, iconNames)
end

local function GetQualityBgInTroopsByPath(rarity, isWaken)
  local qualityIcons = {
    "UITroops_img_heroquality_orange",
    "UITroops_img_heroquality_pur",
    "UITroops_img_heroquality_blue",
    "UITroops_img_heroquality_green",
    "UITroops_img_heroquality_multicolor"
  }
  local iconNames = qualityIcons[rarity]
  if isWaken ~= nil and isWaken == true then
    iconNames = qualityIcons[#qualityIcons]
  end
  return string.format(LoadPath.UITroopsNew, iconNames)
end

local function GetRarityIconName(rarity, useBig)
  local prefix = useBig and "UI_Icon_Rarity_Big_" or "UI_Icon_Rarity_"
  return string.format(useBig and LoadPath.HeroDetailPath or LoadPath.HeroListPath, prefix .. rarity)
end

local function GetHeroIconPath(heroModelId, iconType, skinId)
  iconType = iconType ~= nil and iconType or HeroIconType.small_icon
  skinId = checknumber(skinId)
  local useSkin = table.hasvalue(HeroUtils.SkinSupportHeroIconTypeList, iconType) and 0 < skinId
  if useSkin then
    heroModelId = GetTableData(TableName.LW_HERO_SKIN, skinId, "apperance_id")
  end
  local path = ""
  local iconName = ""
  local fileEnd = ""
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(heroModelId)
  if iconType == nil or iconType == HeroIconType.small_icon then
    path = LoadPath.HeroIconsSmallPath
    iconName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "queue_icon_path")
    fileEnd = ".png"
  elseif iconType == HeroIconType.half_portrait then
    path = LoadPath.HeroIconsBigPath
    iconName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "half_icon_path")
    fileEnd = ".png"
  elseif iconType == HeroIconType.pose_icon_path then
    path = LoadPath.LWHeroBodyPath
    iconName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "pose_icon_path")
    fileEnd = ".png"
  elseif iconType == HeroIconType.spine_path then
    iconName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  elseif iconType == HeroIconType.recruit_preview_icon then
    path = LoadPath.LWHeroRecruitPreviewIconPath
    iconName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "gacha_preview_pic")
    fileEnd = ".png"
  elseif iconType == HeroIconType.pvp_hero_awaken_icon then
    return GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "pvp_awaken_icon_path")
  end
  return UIUtil.GetFullPath(path, iconName, fileEnd)
end

local function GetHeroBubbleBGPath(heroId)
  local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
  if config ~= nil and config.rarity == HeroUtils.RarityType.S then
    return string.format(LoadPath.UIBuildBubble, "bubble_bg_orange")
  end
  return string.format(LoadPath.UIBuildBubble, "bubble_bg_purple")
end

local function GetHeroIconRoundPath(heroId, skinId)
  local appearance = GetTableData(TableName.LW_Hero, heroId, "appearance")
  return HeroUtils.GetHeroIconPath(appearance, HeroIconType.small_icon, skinId)
end

local function GetCampIconPath(camp)
  return string.format(LoadPath.HeroListPath, "ui_camp_" .. camp)
end

local function GetCampCircleImgPath(camp)
  return string.format(LoadPath.HeroListPath, "hero_faction_" .. camp)
end

local function GetCampNameAndDesc(camp)
  camp = tonumber(camp)
  local nameKey = {
    "158005",
    "158002",
    "158003",
    "150190"
  }
  local descKey = {
    "150185",
    "150187",
    "150189",
    "150191"
  }
  return Localization:GetString(nameKey[camp + 1]), Localization:GetString(descKey[camp + 1])
end

local function GetLevelUpNeedExp(level)
  local template = DataCenter.HeroLevelTemplateManager:GetTemplate(level)
  if template then
    return template.next_exp
  end
  return 0
end

local function GetLevelUpCostResources(level)
  local template = DataCenter.HeroLevelTemplateManager:GetTemplate(level)
  if template then
    return template.resource
  end
  return {}
end

local function GetTotalCostGold(curMaxLevel)
  local total = 0
  for k = 1, curMaxLevel - 1 do
    local template = DataCenter.HeroLevelTemplateManager:GetTemplate(k)
    if template then
      total = total + template.coins
    end
  end
  return total
end

local function GetHeroBodyByHeroId(modelId)
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(modelId)
  return GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "pose_icon_path")
end

local function GetTagsByHeroId(heroId)
  local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
  local tags = config.hero_tag
  if type(tags) ~= "table" then
    tags = string.split(config.hero_tag, "|")
  end
  local ret = {}
  for _, v in ipairs(tags) do
    table.insert(ret, tonumber(v))
  end
  return ret
end

local function GetCampByHeroId(heroId)
  local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
  return tonumber(config.camp) or -1
end

local function GetTagIconAndName(tag)
  local line = LocalController:instance():getLine(TableName.NewHeroesTag, tag)
  local icon = line.pic
  if icon == "" then
    icon = "UIHeroInfo_icon_tag_default"
  end
  local iconPath = string.format(LoadPath.HeroDetailPath, icon)
  local name = Localization:GetString(line.name)
  local desc = Localization:GetString(line.desc)
  return iconPath, name, desc
end

local function GetQualityName(quality)
  local nameKey = GetTableData(TableName.NewHeroesQuality, quality, "name")
  assert(nameKey ~= nil, "qualityName is nil! quality:" .. quality)
  return Localization:GetString(nameKey)
end

local function GetRarityName(rarity)
  local names = {
    "156010",
    "156011",
    "156012"
  }
  local nameKey = names[rarity]
  assert(nameKey ~= nil, "RarityName is nil! rarity:" .. rarity)
  return Localization:GetString(nameKey)
end

local function GetNextMaxLevelByQuality(heroId, quality, level)
  local currentMaxLv = HeroUtils.GetMaxLevelByQuality(heroId, quality)
  local index = quality
  local max = quality + 12
  while index < max do
    local maxLv = HeroUtils.GetMaxLevelByQuality(heroId, index)
    if currentMaxLv < maxLv and level < maxLv then
      return index
    end
    index = index + 1
  end
  return -1
end

local function GetMaxLevelByQuality(heroId, quality)
  return DataCenter.HeroLevelTemplateManager:GetUnconditionalMaxLv()
end

local function GetMaxLevelWithScienceLimit()
  return DataCenter.HeroLevelTemplateManager:GetMaxReachableLevel()
end

local function GetHeroFinalLevel(heroId)
  return tonumber(GetTableData(HeroUtils.GetHeroXmlName(), heroId, "max_level"))
end

local function GetHeroNameByConfigId(heroConfigId)
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroConfigId)
  if heroTemplate ~= nil then
    return heroTemplate.name
  end
  return ""
end

local function GetPointConfig(heroConfigId)
  local feature = GetTableData(HeroUtils.GetHeroXmlName(), heroConfigId, "feature")
  if type(feature) == "table" then
    local atkPoint = feature[1] or 1
    local defPoint = feature[2] or 1
    local armyPoint = feature[3] or 1
    return atkPoint, defPoint, armyPoint
  end
  local array = string.split(feature, ";")
  local atkPoint = array[1] ~= "" and tonumber(array[1]) or 1
  local defPoint = array[2] ~= "" and tonumber(array[2]) or 1
  local armyPoint = array[3] ~= "" and tonumber(array[3]) or 1
  return atkPoint, defPoint, armyPoint
end

local function GetArmyLimit(level, rankId, rarity, heroId, quality)
  local num = GetTableData(TableName.NewHeroesLevelUp, level, "army_num" .. rarity)
  assert(num ~= nil and num ~= "", "GetArmyLimit Config 'army_num' not exist! level:" .. level)
  local rankTroop = string.split(GetTableData(TableName.HeroMilitaryRankLv, rankId, "troop"), "|")[rarity]
  rankTroop = tonumber(rankTroop)
  if rankTroop ~= nil then
    num = num + rankTroop
  end
  local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
  local starAddTroop = config.hero_star_troops[math.min(#config.hero_star_troops, quality)]
  if starAddTroop ~= nil then
    num = num + starAddTroop
  end
  return tonumber(num)
end

local function GetConfigQuality(heroConfigId, curQuality)
  local advanceType = GetTableData(HeroUtils.GetHeroXmlName(), heroConfigId, "advanc_type")
  return tonumber(advanceType) + curQuality
end

local function GetMaxAttrForHeroMap(heroId, quality, level, beyondTime)
  local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
  local maxQuality = quality or config.max_quality_level
  local maxLevel = level or HeroUtils.GetHeroFinalLevel(heroId)
  local beyondTimes = beyondTime or HeroUtils.GetBeyondTimesByLevel(maxLevel)
  local maxRankId = config.max_rank_level
  return HeroUtils.GetHeroAttr(heroId, maxQuality, maxLevel, beyondTimes, maxRankId)
end

local function GetHeroSkillCount(heroId)
  local skillArray = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "skill")
  if type(skillArray) ~= "table" then
    skillArray = string.split(skillArray, "|")
  end
  return #skillArray
end

local function GetSkillUpgradeItemAndNum(heroId, level)
  local costItem = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "skill_levelup_item")
  local costArray = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "skill_levelup_num")
  if type(costArray) ~= "table" then
    costArray = string.split(costArray, "|")
  end
  local costNum = tonumber(costArray[math.min(level, #costArray)])
  return costItem, costNum
end

local function GetHeroFirstSkillId(heroId)
  local skillArray = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "skill")
  if type(skillArray) ~= "table" then
    skillArray = string.split(skillArray, "|")
  end
  if table.count(skillArray) > 0 then
    return skillArray[1]
  end
end

local function GetHeroSkillDamage(skillId, skillLv)
  local damage = 0
  if 0 < skillLv then
    local str = GetTableData(TableName.SkillTab, skillId, "damage")
    if str ~= nil then
      local arr = string.split(str, "|")
      if 0 < #arr then
        local index = math.min(skillLv, #arr)
        local num = tonumber(arr[index])
        if num ~= nil then
          damage = num / 100
        end
      end
    end
  end
  return damage
end

local function GetArkGradeIcon(arkGrade, big)
  if arkGrade < 1 then
    arkGrade = 1
  end
  local spritePath = big and LoadPath.HeroDetailPath or LoadPath.HeroListPath
  local fix = big and "HeroDetail_ark_grade_" or "ui_icon_skill_ark"
  return string.format(spritePath, fix .. arkGrade)
end

local function GetArkLines(heroId)
  local skillCount = GetHeroSkillCount(heroId)
  local lines = {}
  LocalController:instance():visitTable(TableName.HeroArkCore, function(id, lineData)
    local type = lineData:getValue("core_type")
    if skillCount == type then
      table.insert(lines, id)
    end
  end)
  return lines
end

local function GetArkIdAndGrade(heroId, totalLevel)
  local lineDataList = HeroUtils.GetArkLines(heroId)
  local id, grade = 0, 0
  for k, v in ipairs(lineDataList) do
    local condition = GetTableData(TableName.HeroArkCore, v, "condition")
    if totalLevel >= condition then
      id = v
      grade = k
    end
  end
  return id, grade
end

local function GetSkillIcon(skillId)
  local skillIcon = GetTableData(TableName.SkillTab, skillId, "icon")
  return LoadPath.SkillIconsPath .. skillIcon
end

local function GetSkillBigIcon(skillId)
  local skillIcon = GetTableData(TableName.SkillTab, skillId, "icon")
  return LoadPath.SkillIconsPath .. skillIcon
end

local function GetJigsawCost(itemId)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if template.type == GOODS_TYPE.GOODS_TYPE_98 then
    return tonumber(template.para2)
  end
  return tonumber(template.para1)
end

local function GetSkillDescStr(skillId, skillLevel)
  local descKey = GetTableData(TableName.SkillTab, skillId, "des")
  local effect_des = GetTableData(TableName.SkillTab, skillId, "effect_des")
  local effect_num_des = GetTableData(TableName.SkillTab, skillId, "effect_num_des")
  local array1 = string.split(effect_des, "|")
  local effectNumList = {}
  for _, v in ipairs(array1) do
    local array2 = string.split(v, ";")
    table.insert(effectNumList, array2)
  end
  local curLvEffect = effectNumList[math.max(skillLevel, 1)]
  local skillType = GetTableData(TableName.SkillTab, skillId, "type")
  local finalSkillDesc
  local para1 = GetTableData(TableName.SkillTab, skillId, "para1")
  if not string.IsNullOrEmpty(para1) then
    local originSkillName = Localization:GetString(para1)
    finalSkillDesc = Localization:GetString(descKey, originSkillName, SafeUnpack(curLvEffect))
  elseif skillType == 16 then
    local health_enable = GetTableData(TableName.SkillTab, skillId, "health_enable")
    local healthVec1 = string.split(health_enable, "|")
    if healthVec1 ~= nil and skillLevel <= table.count(healthVec1) then
      if skillLevel == 0 then
        skillLevel = 1
      end
      local healthVec2 = string.split(healthVec1[skillLevel], ";")
      if healthVec2 ~= nil and table.count(healthVec2) == 2 then
        local small = toInt(healthVec2[1])
        local big = toInt(healthVec2[2])
        if 100 <= big then
          finalSkillDesc = Localization:GetString(descKey, tostring(small) .. "%", SafeUnpack(curLvEffect))
        else
          finalSkillDesc = Localization:GetString(descKey, tostring(big) .. "%", SafeUnpack(curLvEffect))
        end
      end
    end
  else
    finalSkillDesc = Localization:GetString(descKey, SafeUnpack(curLvEffect))
  end
  local finalEffectDesc = ""
  local array3 = string.split(effect_num_des, "|")
  for effectIndex, effectNum in ipairs(array3) do
    local effectNameKey = GetTableData(TableName.EffectNumDesc, effectNum, "des")
    local effectNameStr = string.format("<color=#EA935F><size=16>%s:</size></color>  ", Localization:GetString(effectNameKey, ""))
    local effectValueStr = "<color=#CCA37F99>"
    for k, v in ipairs(effectNumList) do
      local colorStart = k == skillLevel and "<color=#D06832>" or ""
      local colorEnd = k == skillLevel and "</color>" or ""
      effectValueStr = effectValueStr .. string.format((k == 1 and "" or " / ") .. "%s%s%s", colorStart, v[effectIndex], colorEnd)
    end
    effectValueStr = effectValueStr .. "</color>" .. (effectIndex < #array3 and "\n" or "")
    finalEffectDesc = finalEffectDesc .. effectNameStr .. effectValueStr
  end
  return finalSkillDesc, finalEffectDesc
end

local function GetHeroDebrisBgByColor(color, isFg)
  local colorPath = "green_"
  if color == ItemColor.GREEN then
    colorPath = "green_"
  elseif color == ItemColor.BLUE then
    colorPath = "blue_"
  elseif color == ItemColor.PURPLE then
    colorPath = "purple_"
  elseif color == ItemColor.ORANGE then
    colorPath = "orange_"
  end
  local ret = "Assets/Main/Sprites/ItemIcons/img_hero_debris_" .. colorPath .. (isFg and "fg" or "bg")
  return ret
end

local function GetBeyondTimesByLevel(curMaxLevel)
  return 0
end

local function GetQualityColorStr(quality)
  local colorStr = GetTableData(TableName.NewHeroesQuality, quality, "color")
  assert(colorStr ~= nil, "GetQualityColorStr colorStr is nil! quality:" .. quality)
  return colorStr
end

local function GetRarityColorStr(rarity, isWaken)
  if isWaken then
    return "#f9ebd2"
  end
  local colors = {
    "#fa8843",
    "#a66cf0",
    "#5fa3ed",
    "#94e138"
  }
  if rarity > table.count(colors) then
    return colors[1]
  end
  return colors[rarity]
end

local function GetMilitaryRankIcon(rankId)
  if rankId == 0 then
    rankId = 1
  end
  local rankIcon = GetTableData(TableName.HeroMilitaryRankLv, rankId, "icon")
  return string.format(LoadPath.HeroDetailPath, rankIcon)
end

local function GetMilitaryRankName(rankId)
  return GetTableData(TableName.HeroMilitaryRankLv, rankId, "name")
end

local function GetHeroAttr(heroId, quality, level, beyondTimes, rankId)
  local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
  local starAddAttack = config.hero_star_attack[math.min(#config.hero_star_attack, quality)]
  local starAddDefence = config.hero_star_defens[math.min(#config.hero_star_defens, quality)]
  local rarityAddAtt = GetTableData(TableName.NewHeroesLevelUp, level, "lv_attr_atk" .. config.rarity)
  local rarityAddDef = GetTableData(TableName.NewHeroesLevelUp, level, "lv_attr_def" .. config.rarity)
  local attack = config.base_attack + config.attr_attack * rarityAddAtt + starAddAttack + config.special_attr_attack * beyondTimes
  local defence = config.base_defens + config.attr_defens * rarityAddDef + starAddDefence + config.special_attr_defens * beyondTimes
  local rankAtk = string.split(GetTableData(TableName.HeroMilitaryRankLv, rankId, "atk"), "|")[config.rarity]
  local rankDef = string.split(GetTableData(TableName.HeroMilitaryRankLv, rankId, "def"), "|")[config.rarity]
  rankAtk = tonumber(rankAtk)
  if rankAtk ~= nil then
    attack = attack + rankAtk
  end
  rankDef = tonumber(rankDef)
  if rankDef ~= nil then
    defence = defence + rankDef
  end
  return attack, defence
end

local function GetHeroStarDialog(star)
  local starDialog = {
    "163161",
    "163171",
    "163162",
    "163163",
    "163164",
    "163165",
    "163166",
    "163167",
    "163168",
    "163169",
    "163170"
  }
  if star > #starDialog then
    return starDialog[1]
  end
  return starDialog[star]
end

local function GetHeroNameColorByRarity(rarity, isWaken)
  if isWaken then
    return Color.New(1.0, 0.7372549019607844, 0.27058823529411763, 1)
  end
  local colors = {
    Color.New(1.0, 0.7372549019607844, 0.27058823529411763, 1),
    Color.New(0.8117647058823529, 0.38823529411764707, 1.0, 1),
    Color.New(0.4588235294117647, 0.8627450980392157, 0.9254901960784314, 1),
    Color.New(0.5607843137254902, 0.8901960784313725, 0.20392156862745098, 1)
  }
  if rarity > table.count(colors) then
    return colors[1]
  end
  return colors[rarity]
end

local function GetLvColor(rarity, isWaken)
  if isWaken then
    return Color.New(0.9764705882352941, 0.9215686274509803, 0.8235294117647058, 1)
  end
  local colors = {
    Color.New(1, 1, 1, 1),
    Color.New(0.8666666666666667, 1.0, 0.8313725490196079, 1),
    Color.New(0.7372549019607844, 0.9176470588235294, 0.9607843137254902, 1),
    Color.New(0.9372549019607843, 0.6666666666666666, 1.0, 1),
    Color.New(0.9764705882352941, 0.9215686274509803, 0.8235294117647058, 1)
  }
  if rarity > table.count(colors) then
    return colors[1]
  end
  return colors[rarity]
end

local PageBgAlpha = {
  [0] = 1.0,
  [1] = 0.9019607843137255,
  [2] = 1.0,
  [3] = 0.39215686274509803
}

local function GetCampPageBgPath(camp)
  local bgPath = string.format(LoadPath.HeroDetailPath, "UIHeroInfo_bg_page" .. (camp == 3 and 2 or 1))
  local alpha = PageBgAlpha[camp]
  return bgPath, alpha
end

local function GetRankIdByLvAndStage(heroId, curLv, curStage)
  local maxRankId = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "max_rank_level")
  for rankId = 1, maxRankId do
    local level = GetTableData(TableName.HeroMilitaryRankLv, rankId, "level")
    if curLv == level then
      return rankId
    end
  end
  return 0
end

local function GetIsWakeUp(rarity, skillDic)
  if rarity == HeroUtils.RarityType.S and skillDic ~= nil then
    local unlockNum = 0
    local totalLv = 0
    for k, v in pairs(skillDic) do
      if v.skillLv ~= nil and 0 < v.skillLv then
        unlockNum = unlockNum + 1
        totalLv = totalLv + v.skillLv
      elseif v.level ~= nil and 0 < v.level then
        unlockNum = unlockNum + 1
        totalLv = totalLv + v.level
      end
    end
    if totalLv >= unlockNum * HeroUtils.SkillLevelLimit and unlockNum == table.count(skillDic) then
      return true
    end
  end
  return false
end

local function GetHeroRestraintType(camp)
  if camp == HeroCamp.MAFIA then
    return HeroCamp.ZELOT
  elseif camp == HeroCamp.ZELOT then
    return HeroCamp.UNION
  elseif camp == HeroCamp.UNION then
    return HeroCamp.MAFIA
  end
  return -1
end

local function GetHeroBeRestraintType(camp)
  if camp == HeroCamp.MAFIA then
    return HeroCamp.UNION
  elseif camp == HeroCamp.ZELOT then
    return HeroCamp.MAFIA
  elseif camp == HeroCamp.UNION then
    return HeroCamp.ZELOT
  end
  return -1
end

local function GetHeroRestraintEffectType(camp)
  if camp == HeroCamp.MAFIA then
    return EffectDefine.ADD_CAMP_RESTRAINT_35229
  elseif camp == HeroCamp.ZELOT then
    return EffectDefine.ADD_CAMP_RESTRAINT_35230
  elseif camp == HeroCamp.UNION then
    return EffectDefine.ADD_CAMP_RESTRAINT_35228
  end
  return -1
end

local HeroAllCamps = {
  HeroCamp.NEW_HUMAN,
  HeroCamp.MAFIA,
  HeroCamp.UNION,
  HeroCamp.ZELOT
}
local RarityType = {
  S = 1,
  A = 2,
  B = 3,
  C = 4
}
local AniConfig = {
  appearDuration = 0.15,
  firstFlipDelay = 0.5,
  flipInterval = 0.1
}

local function GetPosterRarityPath(rarity, isBg, isWaken)
  if isWaken then
    if isBg then
      return LoadPath.HeroIconsSmallPath .. "ui_poster_cai_bg"
    end
    return LoadPath.HeroIconsSmallPath .. "ui_poster_cai_fg"
  end
  local poster = {
    "ui_poster_orange",
    "ui_poster_purple",
    "ui_poster_blue",
    "ui_poster_green"
  }
  local iconName = poster[rarity] .. (isBg and "_bg" or "_fg")
  return LoadPath.HeroIconsSmallPath .. iconName
end

local function GetPosterSelectRarityPath(rarity, isBg, isWaken)
  if isWaken then
    if isBg then
      return LoadPath.HeroIconsSmallPath .. "ui_poster_cai_bg"
    end
    return LoadPath.HeroIconsSmallPath .. "ui_poster_cai_fg"
  end
  local poster = {
    "UIheroupgrade_img_org",
    "UIheroupgrade_img_pur",
    "UIheroupgrade_img_blue",
    "UIheroupgrade_img_green"
  }
  local iconName = poster[rarity] .. (isBg and "02" or "01")
  return LoadPath.HeroIconsSmallPath .. iconName
end

local function GetPosterAddRarityPath(rarity)
  local poster = {
    "UIheroupgrade_img_addorg",
    "UIheroupgrade_img_addpur",
    "UIheroupgrade_img_addblue",
    "UIheroupgrade_img_addgreen"
  }
  local iconName = poster[rarity]
  return LoadPath.HeroIconsSmallPath .. iconName
end

local function GetExtraAtkByCamp(camp)
  local eff
  if camp == HeroCamp.NEW_HUMAN then
    eff = EffectDefine.ADD_NEW_HUMAN_HERO_ATK
  elseif camp == HeroCamp.MAFIA then
    eff = EffectDefine.ADD_MAFIA_HERO_ATK
  elseif camp == HeroCamp.UNION then
    eff = EffectDefine.ADD_UNION_HERO_ATK
  elseif camp == HeroCamp.ZELOT then
    eff = EffectDefine.ADD_ZEALOT_HERO_ATK
  else
    return 0
  end
  return eff
end

local function GetExtraDefByCamp(camp)
  local eff
  if camp == HeroCamp.NEW_HUMAN then
    eff = EffectDefine.ADD_NEW_HUMAN_HERO_DEF
  elseif camp == HeroCamp.MAFIA then
    eff = EffectDefine.ADD_MAFIA_HERO_DEF
  elseif camp == HeroCamp.UNION then
    eff = EffectDefine.ADD_UNION_HERO_DEF
  elseif camp == HeroCamp.ZELOT then
    eff = EffectDefine.ADD_ZEALOT_HERO_DEF
  else
    return 0
  end
  return eff
end

local function GetExtraTroopByCamp(camp)
  local eff
  if camp == HeroCamp.NEW_HUMAN then
    eff = EffectDefine.ADD_NEW_HUMAN_HERO_TRP
  elseif camp == HeroCamp.MAFIA then
    eff = EffectDefine.ADD_MAFIA_HERO_TRP
  elseif camp == HeroCamp.UNION then
    eff = EffectDefine.ADD_UNION_HERO_TRP
  elseif camp == HeroCamp.ZELOT then
    eff = EffectDefine.ADD_ZEALOT_HERO_TRP
  else
    return 0
  end
  return eff
end

local function GetHeroXmlName(self)
  local configOpenState = LuaEntry.DataConfig:CheckSwitch("ABtest_aps_new_heroes")
  if configOpenState then
    return TableName.NewHeroesB
  end
  return TableName.NewHeroes
end

local function GetLWHeroXmlName(self)
  return TableName.LW_Hero
end

local function GetHeroDebrisIds()
  if HeroUtils.heroDebrisIds == nil then
    HeroUtils.heroDebrisIds = {}
    local k4 = LuaEntry.DataConfig:TryGetStr("free_heroes", "k4")
    local vec = string.split(k4, ";")
    for _, v in ipairs(vec) do
      table.insert(HeroUtils.heroDebrisIds, toInt(v))
    end
  end
  return HeroUtils.heroDebrisIds
end

local function GetGoldHeroDebrisId()
  if HeroUtils.goldHeroDebrisId == nil then
    HeroUtils.goldHeroDebrisId = LuaEntry.DataConfig:TryGetNum("free_heroes", "k5")
  end
  return HeroUtils.goldHeroDebrisId
end

local function GetSkillMedalId()
  if HeroUtils.skillMedalId == nil then
    local allDatas = DataCenter.HeroDataManager:GetAllHeroList()
    for _, heroData in pairs(allDatas) do
      local costMedalId, costItemNum = HeroUtils.GetSkillUpgradeItemAndNum(heroData.heroId, 1)
      HeroUtils.skillMedalId = costMedalId
      break
    end
  end
  return HeroUtils.skillMedalId
end

local function GetHeroBagLimit()
  if HeroUtils.heroBagLimit == nil then
    HeroUtils.heroBagLimit = LuaEntry.DataConfig:TryGetNum("hero_attribute", "k6")
  end
  return HeroUtils.heroBagLimit
end

local function InitAllCommonHeroDebris()
  if HeroUtils.heroCommonDebrisIds == nil then
    HeroUtils.heroCommonDebrisIds = {}
    local k4 = LuaEntry.DataConfig:TryGetStr("hero_attribute", "k7")
    local vec = string.split(k4, "|")
    for _, v in ipairs(vec) do
      HeroUtils.heroCommonDebrisIds[v] = 1
    end
  end
end

local function GetAllCommonHeroDebris()
  HeroUtils.InitAllCommonHeroDebris()
  return HeroUtils.heroCommonDebrisIds
end

local function IsCommonHeroDebris(itemId)
  HeroUtils.InitAllCommonHeroDebris()
  return HeroUtils.heroCommonDebrisIds[itemId] == 1
end

local function GetHeroStarAndProgress(quality)
  if HeroUtils.starConfig == nil then
    local str = LuaEntry.DataConfig:TryGetStr("hero_attribute", "k4")
    HeroUtils.starConfig = string.split(str, "|")
  end
  if HeroUtils.starConfig == nil or #HeroUtils.starConfig == 0 then
    return 0, 0
  end
  local preQuality = 1
  for k, v in ipairs(HeroUtils.starConfig) do
    local tmp = toInt(v)
    if quality < tmp then
      return k - 1, quality - preQuality
    end
    preQuality = tmp
  end
  return #HeroUtils.starConfig, 5
end

local function GetHireHeroDataByBattleBuff(battleBuffId)
  local line = LocalController:instance():getLine(TableName.BattleBuff, battleBuffId)
  if line == nil then
    return nil
  end
  local type = tonumber(line:getValue("type"))
  if type ~= BattleBuffType.HireHero then
    return nil
  end
  local str = line:getValue("buffId")
  local spls = string.split(str, "|")
  if #spls ~= 4 then
    return nil
  end
  local heroData = HeroInfo.New()
  heroData.isHired = true
  heroData.battleBuffId = battleBuffId
  heroData.totalCount = tonumber(line:getValue("time"))
  heroData.heroId = tonumber(spls[1])
  heroData.level = tonumber(spls[2])
  heroData.quality = tonumber(spls[3])
  heroData.skillLevels = {}
  local ss = string.split(spls[4], ";")
  for i, s in ipairs(ss) do
    heroData.skillLevels[i] = tonumber(s)
  end
  heroData.config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroData.heroId)
  heroData.rank = 1
  heroData.beyondTimes = HeroUtils.GetBeyondTimesByLevel(heroData.level)
  heroData.rarity = tonumber(heroData.config:getValue("rarity"))
  heroData.atk, heroData.def = HeroUtils.GetHeroAttr(heroData.heroId, heroData.quality, heroData.level, heroData.beyondTimes, heroData.rank)
  heroData.army = HeroUtils.GetArmyLimit(heroData.level, heroData.rank, heroData.rarity, heroData.heroId, heroData.quality)
  heroData.name = heroData.config:getValue("name")
  heroData.camp = tonumber(heroData.config:getValue("camp"))
  heroData.state = ArmyFormationState.Free
  heroData.isMaster = true
  heroData:UpdateInfo({}, true)
  local battleBuff = DataCenter.BattleLevel:GetBattleBuffById(battleBuffId)
  if battleBuff then
    heroData.uuid = battleBuff.uuid
    heroData.usedCount = battleBuff.ct
    heroData.restCount = heroData.totalCount - heroData.usedCount
  end
  return heroData
end

local function GetHeroStarCost(quality, heroId)
  local str = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "hero_star_cost")
  if string.IsNullOrEmpty(str) then
    return nil
  end
  local vec = string.split(str, "|")
  if quality > #vec then
    return nil
  end
  return toInt(vec[quality])
end

local function GetHeroStarCostByHeroData(heroData)
  if heroData == nil or heroData.config == nil or heroData.config.hero_star_cost == nil then
    return nil
  end
  if heroData.config.heroStarCostArr == nil then
    heroData.config.heroStarCostArr = string.split(heroData.config.hero_star_cost, "|")
  end
  if #heroData.config.heroStarCostArr < heroData.quality then
    return nil
  end
  return toInt(heroData.config.heroStarCostArr[heroData.quality])
end

local function IsReachStarLimit(heroData)
  return heroData.quality >= toInt(heroData.config.max_star_level)
end

local function GetHeroDebrisIdByHeroId(heroId)
  if HeroUtils.heroDebrisIds == nil then
    HeroUtils.heroDebrisIds = {}
  end
  if HeroUtils.heroDebrisIds[heroId] == nil then
    local str = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "hero_pieces")
    local vec = string.split(str, "|")
    if #vec == 2 then
      HeroUtils.heroDebrisIds[heroId] = toInt(vec[1])
    else
      Logger.LogError("hero config hero_pieces wrong:" .. heroId)
    end
  end
  return HeroUtils.heroDebrisIds[heroId]
end

local function GetCommonExchangeItemId(heroId)
  if HeroUtils.commonExchangeItemId == nil then
    HeroUtils.commonExchangeItemId = {}
  end
  if HeroUtils.commonExchangeItemId[heroId] == nil then
    local type99Items = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_99)
    for _, v in ipairs(type99Items) do
      if toInt(v.para2) == heroId then
        HeroUtils.commonExchangeItemId[heroId] = toInt(v.para4)
        break
      end
    end
  end
  return HeroUtils.commonExchangeItemId[heroId]
end

local function GetHeroSkillAndUpgradeRedPointLevelCondition()
  if HeroUtils.skillLvRedPointCondition == nil then
    local k7 = LuaEntry.DataConfig:TryGetStr("free_heroes", "k7")
    local vec = string.split(k7, "|")
    if table.count(vec) == 2 then
      HeroUtils.upgradeRedPointCondition = toInt(vec[1])
      HeroUtils.skillLvRedPointCondition = toInt(vec[2])
    else
      HeroUtils.skillLvRedPointCondition = 0
      HeroUtils.upgradeRedPointCondition = 0
    end
  end
  return HeroUtils.skillLvRedPointCondition, HeroUtils.upgradeRedPointCondition
end

local function HeroIsCanDebrisExchange(heroId)
  if HeroUtils.CanNotDebrisExchange == nil then
    HeroUtils.CanNotDebrisExchange = {}
    local k8 = LuaEntry.DataConfig:TryGetStr("free_heroes", "k8")
    HeroUtils.CanNotDebrisExchange[toInt(k8)] = 1
  end
  return HeroUtils.CanNotDebrisExchange[toInt(heroId)] == nil
end

local function SortHeroUuidsByRarityLevelPower(heroUuids)
  local list = DeepCopy(heroUuids)
  table.sort(list, function(heroUuidA, heroUuidB)
    local heroDataA = DataCenter.HeroDataManager:GetHeroByUuid(heroUuidA)
    local heroDataB = DataCenter.HeroDataManager:GetHeroByUuid(heroUuidB)
    if heroDataA.rarity ~= heroDataB.rarity then
      return heroDataA.rarity < heroDataB.rarity
    elseif heroDataA.level ~= heroDataB.level then
      return heroDataA.level > heroDataB.level
    elseif heroDataA.power ~= heroDataB.power then
      return heroDataA.power > heroDataB.power
    else
      return heroDataA.heroId < heroDataB.heroId
    end
  end)
  return list
end

local function GetHeroSpecialBgByQuality(quality)
  return ""
end

local function GetHeroQualityTagImg(quality)
  if quality == 1 then
    return string.format(LoadPath.HeroCommonPath, "hero_tag_grey.png")
  elseif quality == 2 then
    return string.format(LoadPath.HeroCommonPath, "hero_tag_green.png")
  elseif quality == 3 then
    return string.format(LoadPath.HeroCommonPath, "hero_tag_blue.png")
  elseif quality == 4 then
    return string.format(LoadPath.HeroCommonPath, "hero_tag_purple.png")
  elseif quality == 5 then
    return string.format(LoadPath.HeroCommonPath, "hero_tag_orange.png")
  else
    return string.format(LoadPath.HeroCommonPath, "hero_tag_grey.png")
  end
end

local function GetHeroRadarValues(heroData)
  local result = {}
  if heroData == nil then
    return result
  end
  local proValue = heroData.baseProductivity / GetTableData(TableName.Hero_pentagon, heroData.quality, "maxPro")
  if 1 < proValue then
    proValue = 1
  end
  local strValue = heroData.baseStrength / GetTableData(TableName.Hero_pentagon, heroData.quality, "maxStr")
  if 1 < strValue then
    strValue = 1
  end
  local agiValue = heroData.baseAgility / GetTableData(TableName.Hero_pentagon, heroData.quality, "maxAgi")
  if 1 < agiValue then
    agiValue = 1
  end
  local vitValue = heroData.baseVitality / GetTableData(TableName.Hero_pentagon, heroData.quality, "maxVit")
  if 1 < vitValue then
    vitValue = 1
  end
  local tradeValue = heroData.baseTrade / GetTableData(TableName.Hero_pentagon, heroData.quality, "maxTra")
  if 1 < tradeValue then
    tradeValue = 1
  end
  table.insert(result, proValue)
  table.insert(result, strValue)
  table.insert(result, agiValue)
  table.insert(result, vitValue)
  table.insert(result, tradeValue)
  return result
end

local function GetHeroBaseValueTable(heroData)
  local result = {}
  if heroData == nil then
    return result
  end
  table.insert(result, {
    152001,
    math.floor(heroData:GetHeroProperty(HeroEffectDefine.Strength)),
    true
  })
  table.insert(result, {
    152003,
    math.floor(heroData:GetHeroProperty(HeroEffectDefine.Agility)),
    true
  })
  table.insert(result, {
    152002,
    math.floor(heroData:GetHeroProperty(HeroEffectDefine.Vitality)),
    true
  })
  table.insert(result, {
    152004,
    math.floor(heroData:GetHeroProperty(HeroEffectDefine.Produce)),
    false
  })
  table.insert(result, {
    152005,
    math.floor(heroData:GetHeroProperty(HeroEffectDefine.Trade)),
    false
  })
  return result
end

local function GetHeroPropertyNameId(propertyId)
  local effectNumberTemplate = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(propertyId)
  if effectNumberTemplate == nil then
    return ""
  end
  return effectNumberTemplate:GetNameKey()
end

local function GetFormattedValue(formatType, value, containsSymbol)
  local resultValue = value
  if containsSymbol == nil then
    containsSymbol = true
  end
  if formatType == 1 then
    return string.format("%.2f%%", resultValue * 100)
  elseif formatType == 2 then
    if containsSymbol then
      return string.format("+%.2f%%", math.abs(resultValue * 100))
    else
      return string.format("%.2f%%", math.abs(resultValue * 100))
    end
  elseif formatType == 3 then
    if containsSymbol then
      return string.format("-%.2f%%", math.abs(resultValue * 100))
    else
      return string.format("%.2f%%", math.abs(resultValue * 100))
    end
  elseif formatType == 4 then
    local time = ""
    local hour = math.modf(resultValue / 3600)
    local minute = math.modf(resultValue / 60) % 60
    local second = math.floor(resultValue % 60)
    if hour ~= 0 then
      time = time .. hour .. Localization:GetString(100166)
    end
    if minute ~= 0 then
      time = time .. minute .. Localization:GetString(100165)
    end
    if second ~= 0 then
      time = time .. second .. Localization:GetString(372115)
    end
    if string.IsNullOrEmpty(time) then
      time = 0 .. Localization:GetString(372115)
    end
    return time
  elseif formatType == 5 then
    return string.format("%.2f", resultValue)
  elseif formatType == 6 then
    return string.GetFormattedStr(math.floor(resultValue))
  elseif formatType == 7 then
    return string.format("%d%%", math.floor(resultValue * 100))
  elseif formatType == 8 then
    return string.format("%.1f%%", Mathf.RoundTo(resultValue, 0) / 10000 * 100)
  elseif formatType == 9 then
    local name = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, resultValue)
    return name
  elseif formatType == 0 then
    if containsSymbol or containsSymbol == nil then
      return "+" .. tostring(math.modf(resultValue))
    else
      return tostring(math.modf(resultValue))
    end
  elseif formatType == 10 then
    return string.format("%d", math.floor(resultValue))
  else
    return string.format("%d", math.floor(resultValue))
  end
end

local function GetFormattedPropertyValue(propertyId, value, containsSymbol)
  local effectNumberTempalte = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(propertyId)
  local resultValue = value
  if containsSymbol == nil then
    containsSymbol = true
  end
  return GetFormattedValue(effectNumberTempalte ~= nil and effectNumberTempalte.type or 1, resultValue, containsSymbol)
end

local function GetHeroChangedPropertyParam(heroData, effect)
  local param = {}
  param.nameId = HeroUtils.GetHeroPropertyNameId(effect)
  param.value = math.floor(heroData:GetHeroPrevProperty(effect))
  param.newValue = math.floor(heroData:GetHeroProperty(effect))
  return param
end

local function GetHeroUpgradeChangedPropertyTable(heroData)
  local result = {}
  if heroData == nil then
    return result
  end
  local strengthParam = HeroUtils.GetHeroChangedPropertyParam(heroData, HeroEffectDefine.Strength)
  table.insert(result, strengthParam)
  local agileParam = HeroUtils.GetHeroChangedPropertyParam(heroData, HeroEffectDefine.Agility)
  table.insert(result, agileParam)
  local vitalityParam = HeroUtils.GetHeroChangedPropertyParam(heroData, HeroEffectDefine.Vitality)
  table.insert(result, vitalityParam)
  local produceParam = HeroUtils.GetHeroChangedPropertyParam(heroData, HeroEffectDefine.Produce)
  table.insert(result, produceParam)
  local tradeParam = HeroUtils.GetHeroChangedPropertyParam(heroData, HeroEffectDefine.Trade)
  table.insert(result, tradeParam)
  local phyAtkParam = HeroUtils.GetHeroChangedPropertyParam(heroData, HeroEffectDefine.PhysicalAttack_Result)
  table.insert(result, phyAtkParam)
  local magAtkParam = HeroUtils.GetHeroChangedPropertyParam(heroData, HeroEffectDefine.MagicAttack_Result)
  table.insert(result, magAtkParam)
  local hpParam = HeroUtils.GetHeroChangedPropertyParam(heroData, HeroEffectDefine.HealPoint_Result)
  table.insert(result, hpParam)
  local phyDefParam = HeroUtils.GetHeroChangedPropertyParam(heroData, HeroEffectDefine.PhysicalDefense_Result)
  table.insert(result, phyDefParam)
  local magDefParam = HeroUtils.GetHeroChangedPropertyParam(heroData, HeroEffectDefine.MagicDefense_Result)
  table.insert(result, magDefParam)
  return result
end

local function GetHeroWeaponBgByQuality(quality)
  if quality == 1 then
    return "Assets/Main/Sprites/UI/UIHeroDetail/img_heroweaponstrenghth_tag01.png"
  elseif quality == 2 then
    return "Assets/Main/Sprites/UI/UIHeroDetail/img_heroweaponstrenghth_tag02.png"
  elseif quality == 3 then
    return "Assets/Main/Sprites/UI/UIHeroDetail/img_heroweaponstrenghth_tag03.png"
  elseif quality == 4 then
    return "Assets/Main/Sprites/UI/UIHeroDetail/img_heroweaponstrenghth_tag04.png"
  elseif quality == 5 then
    return "Assets/Main/Sprites/UI/UIHeroDetail/img_heroweaponstrenghth_tag05.png"
  else
    return "Assets/Main/Sprites/UI/UIHeroDetail/img_heroweaponstrenghth_tag01.png"
  end
end

local function GetWeaponSpecialBg(quality)
  return ""
end

local function AutoSetHeroesSupply(heroesUuid)
  local supplyCount = DataCenter.ResourceItemDataManager:GetCountByItemId(ResourceItemId.Supply)
  local needSupplyMax = 0
  local supplyList = {}
  if supplyCount <= 0 then
    return supplyList
  end
  local heroesHp = {}
  for __, v in pairs(heroesUuid) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
    if heroData ~= nil then
      local hp = heroData:GetMaxHp()
      needSupplyMax = needSupplyMax + hp
      heroesHp[v] = hp
    end
  end
  if needSupplyMax <= 0 then
    return supplyList
  end
  local avgPercent = supplyCount / needSupplyMax
  if 1 < avgPercent then
    avgPercent = 1
  end
  local remainSupply = supplyCount
  for __, v in pairs(heroesUuid) do
    supplyList[v] = math.floor(heroesHp[v] * avgPercent)
    remainSupply = remainSupply - supplyList[v]
  end
  if 0 < remainSupply then
    for __, v in pairs(heroesUuid) do
      local canAddHp = heroesHp[v] - supplyList[v]
      local addSupply = math.min(remainSupply, canAddHp)
      supplyList[v] = supplyList[v] + addSupply
      remainSupply = remainSupply - addSupply
      if remainSupply <= 0 then
        break
      end
    end
  end
  return supplyList
end

local heroQaulityColors = {
  [1] = Color.New(0.694, 0.745, 0.773, 1),
  [2] = Color.New(0.389, 0.808, 0.224, 1),
  [3] = Color.New(0.22, 0.769, 1, 1),
  [4] = Color.New(0.808, 0.349, 1, 1),
  [5] = Color.New(1, 0.667, 0.22, 1)
}

local function GetHeroQualityColor(quality)
  return heroQaulityColors[quality]
end

function HeroUtils.IsUseGoldTypeIconByDailyPackageType(contentType)
  if contentType == DailyPackageType.HeroUniqueWeapon or contentType == DailyPackageType.HeroAwaken then
    return true
  end
  return false
end

local function GetHeroTypeIcon(type, hasUniqueWeapon, isAwakened)
  if type == nil or type <= 0 then
    return ""
  end
  if isAwakened then
    return string.format("Assets/Main/Sprites/UI/UILWHeroAwaken/UILWHeroAwakenCommon/FX_juexing_biaoji_zhiye_%d.png", type)
  elseif hasUniqueWeapon then
    return string.format("Assets/Main/Sprites/UI/UIHeroCommon/lrb_yingxiongzhuanwu_zhiye_%d.png", type)
  else
    return string.format("Assets/Main/Sprites/UI/UIHeroCommon/cfm_yingxiong_bingzhong_%d.png", type)
  end
end

local function GetHeroJobIcon(job, iconType)
  if job == nil then
    return ""
  end
  if iconType == 1 or iconType == nil then
    if job == 1 then
      return "Assets/Main/Sprites/UI/UIHeroCommon/lyp_yingxiong_tubiao_roudun.png"
    elseif job == 2 then
      return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_biandui_tubiao_zhandou.png"
    elseif job == 3 then
      return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_biandui_tubiao_fuzhu.png"
    end
  elseif job == 1 then
    return "Assets/Main/Sprites/UI/UIHeroCommon/cfm_yingxiong_tubiao_roudun.png"
  elseif job == 2 then
    return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_yingxiong_tubiao_zhandou.png"
  elseif job == 3 then
    return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_yingxiong_tubiao_fuzhu.png"
  end
  return ""
end

local function GetWorkerBgByQuality(quality)
  return string.format("Assets/Main/Sprites/UI/UIWorker/cfm_tongyong_gongren_touxiangkuang_%d.png", quality)
end

local function GetLevelBg(quality)
  local bgPath = ""
  if qualityLevelBg[quality] == nil then
    bgPath = qualityLevelBg[1]
  else
    bgPath = qualityLevelBg[quality]
  end
  return string.format(LoadPath.HeroCommonPath, bgPath)
end

local function GetHeroTypeText(heroType)
  if heroType == nil or heroType <= 0 then
    return ""
  end
  return 430706 + (heroType - 1)
end

local function GetFormationBgByQuality(quality)
  if quality == 1 then
    return "Assets/Main/Sprites/UI/UIMain/LWMainMarch/dl_zhujiemian_chuzheng_chudui_gray.png"
  elseif quality == 2 then
    return "Assets/Main/Sprites/UI/UIMain/LWMainMarch/dl_zhujiemian_chuzheng_chudui_lv.png"
  elseif quality == 3 then
    return "Assets/Main/Sprites/UI/UIMain/LWMainMarch/dl_zhujiemian_chuzheng_chudui_lan.png"
  elseif quality == 4 then
    return "Assets/Main/Sprites/UI/UIMain/LWMainMarch/dl_zhujiemian_chuzheng_chudui_zi.png"
  elseif quality == 5 then
    return "Assets/Main/Sprites/UI/UIMain/LWMainMarch/dl_zhujiemian_chuzheng_chudui_cheng.png"
  else
    return "Assets/Main/Sprites/UI/UIMain/LWMainMarch/dl_zhujiemian_chuzheng_chuduidi.png"
  end
end

local function GetEquipSlotSprite(slotIndex)
  if slotIndex == 1 then
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_zhanbaoi_zhuangbeikuang_01.png"
  elseif slotIndex == 2 then
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_zhanbaoi_zhuangbeikuang_04.png"
  elseif slotIndex == 3 then
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_zhanbaoi_zhuangbeikuang_03.png"
  else
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_zhanbaoi_zhuangbeikuang_02.png"
  end
end

local function GetCampEffectType(curHeroes)
  local campDic = {}
  for i, heroUuid in pairs(curHeroes) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil then
      if campDic[heroData.heroType] then
        campDic[heroData.heroType] = campDic[heroData.heroType] + 1
      else
        campDic[heroData.heroType] = 1
      end
    else
      Logger.LogError("heroData is nil")
    end
  end
  local max = 0
  local too = 0
  for i, count in pairs(campDic) do
    if count > max then
      max = count
    end
  end
  if max == 3 then
    for i, count in pairs(campDic) do
      if count > too and count < max then
        too = count
      end
    end
  end
  local type = 0
  if 3 <= max then
    if 5 <= max then
      type = 4
    elseif 4 <= max then
      type = 3
    elseif 3 <= max and 2 <= too then
      type = 2
    else
      type = 1
    end
  end
  return type
end

local function GetCampEffectTypeByHeroInfos(curHeroInfos)
  local campDic = {}
  for i, heroData in pairs(curHeroInfos) do
    if campDic[heroData.heroType] then
      campDic[heroData.heroType] = campDic[heroData.heroType] + 1
    else
      campDic[heroData.heroType] = 1
    end
  end
  local max = 0
  local too = 0
  for i, count in pairs(campDic) do
    if count > max then
      max = count
    end
  end
  if max == 3 then
    for i, count in pairs(campDic) do
      if count > too and count < max then
        too = count
      end
    end
  end
  local type = 0
  if 3 <= max then
    if 5 <= max then
      type = 4
    elseif 4 <= max then
      type = 3
    elseif 3 <= max and 2 <= too then
      type = 2
    else
      type = 1
    end
  end
  return type
end

local function GetCampEffectConfig(curHeroes)
  local type = GetCampEffectType(curHeroes)
  return DataCenter.CampEffectManager:GetTemplate(type)
end

local function GetCampEffectConfigByHeroInfos(heroInfos)
  local type = GetCampEffectTypeByHeroInfos(heroInfos)
  return DataCenter.CampEffectManager:GetTemplate(type)
end

local function GetFormationBuffInfoList(curHeroes)
  local info = {}
  info.cfgList = DataCenter.CampEffectManager:GetAllTemplate()
  info.type = GetCampEffectType(curHeroes)
  local temp
  if info.type ~= 0 then
    for i, tempInfo in pairs(info.cfgList) do
      if tempInfo.camp_type == info.type then
        tempInfo.isShow = true
        info.icon = tempInfo.icon
        temp = tempInfo
      end
    end
  end
  return info
end

local function GetFormationBuffInfoListByHeroInfos(curHeroInfos)
  local info = {}
  info.cfgList = DataCenter.CampEffectManager:GetAllTemplate()
  info.type = GetCampEffectTypeByHeroInfos(curHeroInfos)
  local temp
  if info.type ~= 0 then
    for i, tempInfo in pairs(info.cfgList) do
      if tempInfo.camp_type == info.type then
        tempInfo.isShow = true
        info.icon = tempInfo.icon
        temp = tempInfo
      end
    end
  end
  return info
end

local function GetHeroTipInfoTextByType(type)
  if type == nil then
    return
  end
  return HeroTypeTip[type]
end

local function GetHeroTipInfoTextByJob(type)
  if type == nil then
    return
  end
  return HeroJobTip[type]
end

local function SortFormationHeros(curHeroes)
  local typeDic = {}
  local heroInfo
  for i, heroId in pairs(curHeroes) do
    heroInfo = DataCenter.HeroDataManager:GetHeroByUuid(heroId)
    if heroInfo ~= nil then
      if typeDic[heroInfo.heroType] then
        typeDic[heroInfo.heroType].count = typeDic[heroInfo.heroType].count + 1
      else
        typeDic[heroInfo.heroType] = {}
        typeDic[heroInfo.heroType].type = heroInfo.heroType
        typeDic[heroInfo.heroType].count = 1
      end
    else
      Logger.LogError("heroInfo is nil")
    end
  end
  local list = {}
  for i, v in pairs(typeDic) do
    table.insert(list, v)
  end
  table.sort(list, function(a, b)
    if a.count > b.count then
      return true
    elseif a.count == b.count and a.type < b.type then
      return true
    end
  end)
  return list
end

local function SortFormationHerosByHeroInfos(curHeroInfos)
  local typeDic = {}
  for i, heroInfo in pairs(curHeroInfos) do
    if typeDic[heroInfo.heroType] then
      typeDic[heroInfo.heroType].count = typeDic[heroInfo.heroType].count + 1
    else
      typeDic[heroInfo.heroType] = {}
      typeDic[heroInfo.heroType].type = heroInfo.heroType
      typeDic[heroInfo.heroType].count = 1
    end
  end
  local list = {}
  for i, v in pairs(typeDic) do
    table.insert(list, v)
  end
  table.sort(list, function(a, b)
    if a.count > b.count then
      return true
    elseif a.count == b.count and a.type < b.type then
      return true
    end
  end)
  return list
end

local function GenerateHeroDataList(condition, heroIdsList, forSeason)
  local heroItemsEnough = {}
  local heroItemsNotEnough = {}
  local day = UITimeManager:GetInstance():GetOpenServerDayByOpenServerZero()
  local type99Items = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_99)
  table.walk(type99Items, function(k, v)
    local itemId = toInt(v.id)
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    local heroId = toInt(itemTemplate.para2)
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
    local hasHero = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)
    if (condition == 0 or heroTemplate.type == condition) and (not heroIdsList or table.indexof(heroIdsList, heroId) ~= false) then
      local count = DataCenter.ItemData:GetItemCount(itemId)
      local showIt = forSeason or heroTemplate.showInHeroList == true and (day >= heroTemplate.showDays or 0 < count)
      if string.IsNullOrEmpty(hasHero) and showIt then
        local flag = true
        local promoteId = DataCenter.HeroDataManager:GetHeroPromoteId(itemTemplate.para2)
        if promoteId then
          local promotedHero = DataCenter.HeroDataManager:GetHeroByHeroId(promoteId)
          if promotedHero then
            flag = false
          end
        end
        if flag then
          local need = HeroUtils.GetJigsawCost(itemId)
          count = DataCenter.ItemData:GetItemCount(itemId)
          if need <= count then
            table.insert(heroItemsEnough, itemId)
          else
            table.insert(heroItemsNotEnough, itemId)
          end
        end
      end
    end
  end)
  
  local function SortHero(heroConfigA, heroConfigB)
    if heroConfigA == nil or heroConfigB == nil then
      return false
    end
    if heroConfigA.quality ~= heroConfigB.quality then
      return heroConfigA.quality > heroConfigB.quality
    end
    if heroConfigA.heroId ~= heroConfigB.heroId then
      return heroConfigA.heroId < heroConfigB.heroId
    end
    return false
  end
  
  table.sort(heroItemsEnough, function(k, v)
    local item1 = DataCenter.ItemTemplateManager:GetItemTemplate(k)
    local heroConfigA = DataCenter.HeroTemplateManager:GetTemplate(toInt(item1.para2))
    local item2 = DataCenter.ItemTemplateManager:GetItemTemplate(v)
    local heroConfigB = DataCenter.HeroTemplateManager:GetTemplate(toInt(item2.para2))
    return SortHero(heroConfigA, heroConfigB)
  end)
  table.sort(heroItemsNotEnough, function(k, v)
    local item1 = DataCenter.ItemTemplateManager:GetItemTemplate(k)
    local heroConfigA = DataCenter.HeroTemplateManager:GetTemplate(toInt(item1.para2))
    local item2 = DataCenter.ItemTemplateManager:GetItemTemplate(v)
    local heroConfigB = DataCenter.HeroTemplateManager:GetTemplate(toInt(item2.para2))
    return SortHero(heroConfigA, heroConfigB)
  end)
  local heroList = {}
  local newHeroList = {}
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  local temp = {}
  for _, heroData in pairs(allHeroes) do
    if (not heroIdsList or table.indexof(heroIdsList, heroData.heroId) ~= false) and (condition == 0 or heroData.heroType == condition) then
      local uuid = heroData.uuid
      local isNew = DataCenter.HeroDataManager:IsNewHero(uuid)
      if isNew then
        table.insert(newHeroList, uuid)
      else
        table.insert(heroList, uuid)
      end
      temp[uuid] = heroData
    end
  end
  local tmp = {}
  
  local function sortHero(heroList)
    table.sort(heroList, function(uuid1, uuid2)
      local heroA = temp[uuid1]
      local heroB = temp[uuid2]
      local isHeroAwakenedA = heroA:IsHeroAwakened()
      local isHeroAwakenedB = heroB:IsHeroAwakened()
      local isHeroCanUnlockAwakenA = not isHeroAwakenedA and heroA:IsHeroAwakenCanUpgrade(true)
      local isHeroCanUnlockAwakenB = not isHeroAwakenedB and heroB:IsHeroAwakenCanUpgrade(true)
      if isHeroCanUnlockAwakenA ~= isHeroCanUnlockAwakenB then
        return isHeroCanUnlockAwakenA
      end
      if isHeroAwakenedA ~= isHeroAwakenedB then
        return isHeroAwakenedA
      end
      if heroA.quality ~= heroB.quality then
        return heroA.quality > heroB.quality
      end
      if heroA.power ~= heroB.power then
        return heroA.power > heroB.power
      end
      local needShowRedA = tmp[uuid1]
      if needShowRedA == nil then
        needShowRedA = DataCenter.HeroDataManager:IsHeroNeedRedPoint(heroA.uuid)
        tmp[uuid1] = needShowRedA
      end
      local needShowRedB = tmp[uuid2]
      if needShowRedB == nil then
        needShowRedB = DataCenter.HeroDataManager:IsHeroNeedRedPoint(heroB.uuid)
        tmp[uuid2] = needShowRedB
      end
      if needShowRedA ~= needShowRedB then
        if needShowRedA then
          return true
        else
          return false
        end
      end
      return heroA.uuid < heroB.uuid
    end)
  end
  
  sortHero(heroList)
  sortHero(newHeroList)
  local index = 1
  table.walk(heroItemsEnough, function(k, v)
    table.insert(heroList, index, v)
    index = index + 1
  end)
  table.walk(newHeroList, function(k, v)
    table.insert(heroList, index, v)
    index = index + 1
  end)
  table.walk(heroItemsNotEnough, function(k, v)
    table.insert(heroList, v)
  end)
  return heroList
end

local function GetFormattedPropertyValueColored(self, effectId, value)
  if not effectId or not value then
    return ""
  end
  local result = HeroUtils.GetFormattedPropertyValue(effectId, value)
  local type = DataCenter.EffectNumberTemplateManager:GetEffectNumberType(effectId)
  if type == 1 then
    if 0 < value then
      result = "<color=#5FEF87>" .. result .. "</color>"
    else
      result = "<color=#F53C3D>" .. result .. "</color>"
    end
  elseif type == 2 then
    result = "<color=#5FEF87>" .. result .. "</color>"
  elseif type == 3 then
    result = "<color=#F53C3D>" .. result .. "</color>"
  elseif type == 4 then
    result = "<color=#5FEF87>" .. result .. "</color>"
  elseif type == 6 then
    result = "<color=#5FEF87>" .. result .. "</color>"
  end
  return result
end

function HeroUtils.HasDetialStatFromMailHeroStat(heroStat, isDamage)
  if not heroStat then
    return false
  end
  local loopStats = isDamage and MAIL_DAMAGEPAGE_DAMAGE_STAT or MAIL_DAMAGEPAGE_TAKEN_DAMAGE_STAT
  for statName, info in pairs(loopStats) do
    if heroStat[statName] and 0 < heroStat[statName] then
      return true
    end
  end
  return false
end

function HeroUtils.GetDetialStatFromMailHeroStat(heroStat, isDamage)
  local str = ""
  if not heroStat then
    return ""
  end
  local stats = {}
  local loopStats = isDamage and MAIL_DAMAGEPAGE_DAMAGE_STAT or MAIL_DAMAGEPAGE_TAKEN_DAMAGE_STAT
  for statName, info in pairs(loopStats) do
    local key = info.key
    local order = info.order
    if heroStat[statName] and 0 < heroStat[statName] then
      table.insert(stats, {
        name = key,
        value = string.GetFormattedStr2(heroStat[statName]),
        order = order
      })
    end
  end
  table.sort(stats, function(a, b)
    return a.order < b.order
  end)
  if 0 < #stats then
    for i = 1, #stats do
      if i ~= 1 then
        str = string.format("%s\n", str)
      end
      str = string.format("%s%s: %s", str, UIUtil.GetString("", stats[i].name), stats[i].value)
    end
  end
  return str
end

function HeroUtils.HasDetailStatFromMailTacticalStat(heroStat, isDamage)
  if not heroStat then
    return false
  end
  if isDamage then
    return heroStat.skillDamageMap and table.count(heroStat.skillDamageMap) > 0
  else
    return heroStat.skillInjuredMap and 0 < table.count(heroStat.skillInjuredMap)
  end
  return false
end

function HeroUtils.GetDetailStatFromMailTacticalStat(heroStat, isDamage)
  local str = ""
  if not heroStat then
    return ""
  end
  
  local function calFunc(normalSkillAndChipArr)
    local ret = ""
    local index = 1
    for _, info in ipairs(normalSkillAndChipArr) do
      local name = info.name
      local val = info.value
      local damageValue = string.GetFormattedStr2(val)
      if index ~= 1 then
        ret = string.format("%s\n", ret)
      end
      ret = string.format("%s%s: %s", ret, name, damageValue)
      index = index + 1
    end
    return ret
  end
  
  local mapInfo = isDamage and heroStat.skillDamageMap or heroStat.skillInjuredMap
  local chipMap = {}
  local normalSkillAndChipArr = {}
  for skillId, value in pairs(mapInfo) do
    local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    if not skillMeta then
      Logger.LogError(string.format("[GetDetailStatFromMailTacticalStat]not find skillId:%s", skillId))
    else
      local chipId = skillMeta.source_group
      if chipId <= 0 then
        do
          local info = {}
          info.id = chipId
          info.name = Localization:GetString(skillMeta.name)
          info.value = value
          table.insert(normalSkillAndChipArr, info)
        end
      else
        local chipMeta = DataCenter.TWSkillChipTemplateManager:GetTemplate(chipId)
        if not chipMeta then
          Logger.LogError(string.format("[GetDetailStatFromMailTacticalStat]chipId:%s is not find config", chipId))
        elseif chipMap[chipId] then
          chipMap[chipId].value = chipMap[chipId].value + value
        else
          local data = {}
          data.id = chipId
          data.name = Localization:GetString(chipMeta.name)
          data.value = value
          chipMap[chipId] = data
        end
      end
    end
  end
  for _, v in pairs(chipMap) do
    table.insert(normalSkillAndChipArr, v)
  end
  table.sort(normalSkillAndChipArr, function(a, b)
    return a.id < b.id
  end)
  str = calFunc(normalSkillAndChipArr)
  return str
end

function HeroUtils.HeroEffectEqualType(type, val1, val2)
  if type == 0 then
    return math.abs(val1 - val2) < 0.1
  elseif type == 1 then
    return math.abs(val1 - val2) < 0.001
  elseif type == 2 or type == 3 then
    return math.abs(val1 - val2) < 0.001
  else
    return val1 == val2
  end
end

function HeroUtils.HeroEffectEqual(id, val1, val2)
  if id <= 0 then
    return val1 == val2
  end
  local type = DataCenter.EffectNumberTemplateManager:GetEffectNumberType(id)
  return HeroUtils.HeroEffectEqualType(type, val1, val2)
end

local DEFAULT_HYPER_TEXT_COLOR = "#FFAC40"

function HeroUtils.ProcessHyperText(text, color, changeColor)
  if not text then
    return ""
  end
  color = color or DEFAULT_HYPER_TEXT_COLOR
  local modifyColor = changeColor == nil or changeColor
  if modifyColor then
    local modifiedText = string.gsub(text, "<link=", string.format("<color=%s><u><link=", color))
    modifiedText = string.gsub(modifiedText, "</link>", "</link></u></color>")
    return modifiedText
  else
    local modifiedText = string.gsub(text, "<link=", "<u><link=")
    modifiedText = string.gsub(modifiedText, "</link>", "</link></u>")
    return modifiedText
  end
end

local function CanHeroUpgradeMultipleLevels(heroData, targetLevels, ignoreCityLevelLimit, customCityLevelLimitLevel)
  targetLevels = targetLevels or 5
  if not heroData or targetLevels <= 0 then
    return false
  end
  local heroLevel = heroData.level
  if not ignoreCityLevelLimit then
    local atLeastLevel = customCityLevelLimitLevel and customCityLevelLimitLevel or targetLevels
    local heroLevelLimit = DataCenter.BuildManager.MainLv * DataCenter.HeroParamDataManager.heroLevelLimitByCityLevel
    local gapLimit = heroLevelLimit - heroLevel
    if atLeastLevel > gapLimit then
      return false
    end
  end
  local totalExpNeeded = 0
  for lv = heroLevel, heroLevel + targetLevels - 1 do
    totalExpNeeded = totalExpNeeded + HeroUtils.GetLevelUpNeedExp(lv)
  end
  local hasExpCount = DataCenter.ResourceItemDataManager:GetHeroExpCount()
  local canUpgrade = totalExpNeeded <= hasExpCount
  return canUpgrade
end

local function CanTeamHeroesUpgrade(team, needUpgradeCount)
  if not team or needUpgradeCount > #team then
    return false
  end
  local heroLevelLimit = DataCenter.BuildManager.MainLv * DataCenter.HeroParamDataManager.heroLevelLimitByCityLevel
  for _, heroUnit in pairs(team) do
    local heroData = heroUnit.hero
    if not heroData or heroLevelLimit > heroData.level then
      return false
    end
  end
  local totalExpNeeded = 0
  local heroesProcessed = 0
  for _, heroUnit in pairs(team) do
    if needUpgradeCount <= heroesProcessed then
      break
    end
    local heroData = heroUnit.hero
    local heroLevel = heroData.level
    local heroExpNeeded = 0
    for lv = heroLevel, heroLevel + 4 do
      heroExpNeeded = heroExpNeeded + HeroUtils.GetLevelUpNeedExp(lv)
    end
    totalExpNeeded = totalExpNeeded + heroExpNeeded
    heroesProcessed = heroesProcessed + 1
  end
  local hasExpCount = DataCenter.ResourceItemDataManager:GetHeroExpCount()
  local canUpgrade = totalExpNeeded <= hasExpCount
  return canUpgrade
end

local function CanTeamSSRHeroesUpgradeStar(team)
  local upgradeOnceHeroes = {}
  local upgradeFullHeroes = {}
  for _, heroUnit in pairs(team) do
    local heroData = heroUnit.hero
    if heroData and heroData.quality == HeroQualityType.Genius then
      if heroData:CanUpgradeToNextStar() then
        table.insert(upgradeFullHeroes, heroData)
      elseif heroData:CanUpMilitaryRank() then
        table.insert(upgradeOnceHeroes, heroData)
      end
    end
  end
  local canUpgrade = 0 < #upgradeOnceHeroes or 0 < #upgradeFullHeroes
  return canUpgrade, upgradeOnceHeroes, upgradeFullHeroes
end

function HeroUtils.AutoFillArmyFormationNew(squadData, tryHeroesUuidToDataMap)
  if squadData == nil then
    return 0, nil
  end
  local heroDataList = {}
  for _, heroData in pairs(DataCenter.HeroDataManager:GetAllHeroList()) do
    table.insert(heroDataList, heroData)
  end
  if tryHeroesUuidToDataMap then
    for _, heroData in pairs(tryHeroesUuidToDataMap) do
      table.insert(heroDataList, heroData)
    end
  end
  table.sort(heroDataList, function(a, b)
    if a.quality ~= b.quality then
      return a.quality > b.quality
    end
    if a.power ~= b.power then
      return a.power > b.power
    end
    return a.heroId > b.heroId
  end)
  local useTotalHeroCount, heroChangeCount = 0, 0
  local frontRowHeroCount, backRowHeroCount = 0, 0
  local totalHeroCount = table.length(heroDataList)
  local tankTypeCount, airplaneTypeCount, missileTypeCount = 0, 0, 0
  local usedHeroMap = {}
  local heroFormationMap = {}
  for i, heroInfo in ipairs(heroDataList) do
    if heroInfo.heroJob then
      if frontRowHeroCount == 2 or backRowHeroCount == 3 then
        break
      end
      local targetSlotIndex = 0
      local isFront = false
      if heroInfo.heroJob == 1 then
        if heroFormationMap[1] == nil then
          targetSlotIndex = 1
        elseif heroFormationMap[2] == nil then
          targetSlotIndex = 2
        end
        isFront = true
      elseif heroFormationMap[4] == nil then
        targetSlotIndex = 4
      elseif heroFormationMap[3] == nil then
        targetSlotIndex = 3
      elseif heroFormationMap[5] == nil then
        targetSlotIndex = 5
      end
      if 0 < targetSlotIndex then
        heroFormationMap[targetSlotIndex] = heroInfo.uuid
        usedHeroMap[heroInfo.uuid] = true
        useTotalHeroCount = useTotalHeroCount + 1
        if heroInfo.heroType then
          if heroInfo.heroType == 1 then
            tankTypeCount = tankTypeCount + 1
          elseif heroInfo.heroType == 2 then
            missileTypeCount = missileTypeCount + 1
          else
            airplaneTypeCount = airplaneTypeCount + 1
          end
        end
        if isFront then
          frontRowHeroCount = frontRowHeroCount + 1
        else
          backRowHeroCount = backRowHeroCount + 1
        end
        local localHeroUuid = squadData:GetLocalHeroAtSlotIndex(targetSlotIndex)
        if heroInfo.uuid ~= localHeroUuid then
          heroChangeCount = heroChangeCount + 1
        end
      end
    end
  end
  if totalHeroCount > useTotalHeroCount then
    local isFrontRowPriority = frontRowHeroCount ~= 2 and true or false
    local maxCount = math.max(tankTypeCount, airplaneTypeCount, missileTypeCount)
    local heroTypePriority = 0
    if maxCount == tankTypeCount then
      heroTypePriority = heroTypePriority | 1
    end
    if maxCount == missileTypeCount then
      heroTypePriority = heroTypePriority | 2
    end
    if maxCount == airplaneTypeCount then
      heroTypePriority = heroTypePriority | 4
    end
    table.sort(heroDataList, function(a, b)
      local aUsed = usedHeroMap[a.uuid] or false
      local bUsed = usedHeroMap[b.uuid] or false
      if aUsed ~= bUsed then
        return not aUsed
      end
      if a.quality ~= b.quality then
        return a.quality > b.quality
      end
      local aHeroJob, bHeroJob = 0, 0
      if isFrontRowPriority then
        aHeroJob = a.heroJob == 1 and 1 or 0
        bHeroJob = b.heroJob == 1 and 1 or 0
      else
        aHeroJob = a.heroJob ~= 1 and 1 or 0
        bHeroJob = b.heroJob ~= 1 and 1 or 0
      end
      if aHeroJob ~= bHeroJob then
        return aHeroJob > bHeroJob
      end
      if a.level ~= b.level then
        return a.level > b.level
      end
      local aHeroType, bHeroType = 0, 0
      if a.heroType then
        local hasContain = heroTypePriority & 1 << a.heroType - 1 ~= 0
        if hasContain then
          aHeroType = 1
        end
      end
      if b.heroType then
        local hasContain = heroTypePriority & 1 << b.heroType - 1 ~= 0
        if hasContain then
          bHeroType = 1
        end
      end
      if aHeroType ~= bHeroType then
        return aHeroType > bHeroType
      end
      return a.heroId > b.heroId
    end)
    local needCount = 5 - useTotalHeroCount
    local surplusCount = totalHeroCount - useTotalHeroCount
    needCount = math.min(needCount, surplusCount)
    for i = 1, needCount do
      local heroInfo = heroDataList[i]
      local targetSlotIndex = 0
      if isFrontRowPriority then
        if heroFormationMap[1] == nil then
          targetSlotIndex = 1
        elseif heroFormationMap[2] == nil then
          targetSlotIndex = 2
        end
      elseif heroFormationMap[4] == nil then
        targetSlotIndex = 4
      elseif heroFormationMap[3] == nil then
        targetSlotIndex = 3
      elseif heroFormationMap[5] == nil then
        targetSlotIndex = 5
      end
      if 0 < targetSlotIndex then
        heroFormationMap[targetSlotIndex] = heroInfo.uuid
        usedHeroMap[heroInfo.uuid] = true
        useTotalHeroCount = useTotalHeroCount + 1
        local localHeroUuid = squadData:GetLocalHeroAtSlotIndex(targetSlotIndex)
        if heroInfo.uuid ~= localHeroUuid then
          heroChangeCount = heroChangeCount + 1
        end
      end
    end
  end
  if heroChangeCount == 0 then
    return heroChangeCount, nil
  end
  return heroChangeCount, heroFormationMap
end

function HeroUtils.GetHeroAwakenRankIdByHeroIdAndLevel(heroId, rankLevel)
  return checknumber(heroId) * 100 + checknumber(rankLevel)
end

function HeroUtils.GetHeroAwakenRankUpgradeCommonCostItemId()
  return LuaEntry.DataConfig:TryGetNum("hero_awaken_config", "k3", 0)
end

function HeroUtils.IsHeroAwakenSkill(heroInfo, skillInfo)
  local slotIndex = skillInfo:GetSlotIndex()
  local isHeroAwakenSkill = slotIndex == HeroUtils.HeroAwakenReplaceSkillSlotIndex and heroInfo ~= nil and heroInfo:IsHeroAwakened()
  return isHeroAwakenSkill
end

function HeroUtils.GetHeroSkillItemStarImageAssetPath(isHeroAwakenSkill, showStar)
  if isHeroAwakenSkill then
    return HeroUtils.HeroAwakenSkillItemStarImageAssetPathRed
  elseif 5 < showStar then
    return HeroUtils.HeroSkillItemStarImageAssetPathRed
  else
    return HeroUtils.HeroSkillItemStarImageAssetPathYellow
  end
end

function HeroUtils.GetHeroCellRankStarImageAssetPath(starIndex, rank, maxRank, heroAwakenRankLevel)
  rank = rank or 1
  local isShowAwakenStar = heroAwakenRankLevel ~= nil and 0 < heroAwakenRankLevel
  if isShowAwakenStar then
    local rankGroup = math.floor(heroAwakenRankLevel / 5) + 1
    local innerRank = heroAwakenRankLevel % 5
    if starIndex < rankGroup then
      return HeroUtils.HeroCellRankStarImageAssetPathRedFull
    elseif starIndex == rankGroup and 0 < innerRank then
      return string.format(HeroUtils.HeroCellRankStarImageAssetPathRed, innerRank)
    else
      return HeroUtils.HeroCellRankStarImageAssetPathYellowFull
    end
  else
    local starNum = (maxRank - 1) / 5
    if starIndex <= starNum then
      local rankGroup = math.floor((rank - 1) / 5) + 1
      local innerRank = (rank - 1) % 5
      if starIndex < rankGroup then
        return HeroUtils.HeroCellRankStarImageAssetPathYellowFull
      elseif starIndex == rankGroup and 0 < innerRank then
        return string.format(HeroUtils.HeroCellRankStarImageAssetPathYellow, innerRank)
      else
        return HeroUtils.HeroCellRankStarImageAssetPathEmpty
      end
    end
  end
  return nil
end

function HeroUtils.GetHeroSpinePath(heroAppearanceId, skinId, spineType)
  skinId = checknumber(skinId)
  spineType = spineType ~= nil and spineType or HeroSpineType.Normal
  local useSkin = 0 < skinId
  if useSkin then
    heroAppearanceId = GetTableData(TableName.LW_HERO_SKIN, skinId, "apperance_id")
  end
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(heroAppearanceId)
  if spineType == HeroSpineType.AwakenUpgrade then
    return GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "awaken_show_model_path")
  else
    return GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  end
end

function HeroUtils.OpenHeroDetailPropertyView(heroData, propertyDetailType)
  propertyDetailType = propertyDetailType or UIHeroPropertyDetailType.Hero
  if heroData == nil then
    return
  end
  if LuaEntry.DataConfig:CheckSwitch("hero_attribute_seperate_switch") and not heroData.isFromTemplate then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPropertyDetailPanelNew, {anim = true}, heroData, propertyDetailType)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPropertyDetailPanel, {anim = true}, heroData, propertyDetailType)
  end
end

function HeroUtils.GetSkinHeroModelPath(tableData, weaponLv)
  if table.IsNullOrEmpty(tableData) then
    return nil
  end
  for _, v in ipairs(tableData) do
    local tableDataSplit = string.split(v, "|")
    if #tableDataSplit == 2 then
      local weaponLvDataSplit = string.split(tableDataSplit[1], ",")
      if #weaponLvDataSplit == 2 then
        local minWeaponLv = checknumber(weaponLvDataSplit[1])
        local maxWeaponLv = checknumber(weaponLvDataSplit[2])
        if weaponLv >= minWeaponLv and weaponLv <= maxWeaponLv then
          return tableDataSplit[2]
        end
      end
    end
  end
end

function HeroUtils.GetHeroModelDataForceHeroSourceType(heroId, modelType)
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if heroTemplate then
    local result = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), heroTemplate.appearance, HeroModelTypeName[modelType])
    local appearanceId = heroTemplate.appearance
    return result, appearanceId
  end
end

function HeroUtils.GetHeroModelData(heroId, modelType, weaponLv, skinId, rankLv)
  weaponLv = checknumber(weaponLv)
  skinId = checknumber(skinId)
  local result, appearanceId, sourceType
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if heroTemplate then
    if heroTemplate.heroData_type == HeroTemplateType.Dominator then
      appearanceId = DataCenter.DominatorTemplateManager:GetAppearanceId(heroId, rankLv)
      sourceType = HeroModelSourceType.Rank
      result = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), appearanceId, HeroModelTypeName[modelType])
    elseif 0 < weaponLv then
      local weaponId = DataCenter.HeroUniqueWeaponTemplateManager:GetWeaponIdByHeroId(heroId, weaponLv)
      local weaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplate(weaponId)
      if weaponTemplate then
        if 0 < skinId then
          local tableData = GetTableData(TableName.LW_HERO_SKIN, skinId, HeroModelTypeName[modelType])
          result = HeroUtils.GetSkinHeroModelPath(tableData, weaponLv)
          if string.IsNullOrEmpty(result) then
            appearanceId = weaponTemplate.modelId
            result = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), appearanceId, HeroModelTypeName[modelType])
            sourceType = HeroModelSourceType.UniqueWeapon
          else
            appearanceId = weaponTemplate.modelId
            sourceType = HeroModelSourceType.HeroAwaken
          end
        else
          appearanceId = weaponTemplate.modelId
          result = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), appearanceId, HeroModelTypeName[modelType])
          sourceType = HeroModelSourceType.UniqueWeapon
        end
      end
    else
      result, appearanceId = HeroUtils.GetHeroModelDataForceHeroSourceType(heroId, modelType)
      sourceType = HeroModelSourceType.Hero
    end
  end
  local jpAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(appearanceId)
  if jpAppearanceId ~= appearanceId then
    appearanceId = jpAppearanceId
    result = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), appearanceId, HeroModelTypeName[modelType])
    sourceType = HeroModelSourceType.Hero
  end
  if string.IsNullOrEmpty(result) then
    Logger.LogError("HeroUtils.GetSkinHeroModelPath \230\156\170\230\137\190\229\136\176\232\139\177\233\155\132\230\168\161\229\158\139\232\181\132\230\186\144\232\183\175\229\190\132 heroId=" .. heroId .. " modelType=" .. modelType .. " weaponLv=" .. weaponLv .. " skinId=" .. skinId)
  end
  return result, appearanceId, sourceType
end

HeroUtils.CanNotDebrisExchange = nil
HeroUtils.HeroIsCanDebrisExchange = HeroIsCanDebrisExchange
HeroUtils.upgradeRedPointCondition = nil
HeroUtils.skillLvRedPointCondition = nil
HeroUtils.GetHeroSkillAndUpgradeRedPointLevelCondition = GetHeroSkillAndUpgradeRedPointLevelCondition
HeroUtils.GetCommonExchangeItemId = GetCommonExchangeItemId
HeroUtils.GetHeroDebrisIdByHeroId = GetHeroDebrisIdByHeroId
HeroUtils.GetHeroStarCostByHeroData = GetHeroStarCostByHeroData
HeroUtils.GetHeroStarCost = GetHeroStarCost
HeroUtils.heroDebrisIds = nil
HeroUtils.commonExchangeItemId = nil
HeroUtils.starConfig = nil
HeroUtils.skillMedalId = nil
HeroUtils.heroBagLimit = nil
HeroUtils.heroDebrisIds = nil
HeroUtils.goldHeroDebrisId = nil
HeroUtils.GetHeroStarAndProgress = GetHeroStarAndProgress
HeroUtils.GetSkillMedalId = GetSkillMedalId
HeroUtils.GetHeroBagLimit = GetHeroBagLimit
HeroUtils.GetHeroXmlName = GetHeroXmlName
HeroUtils.AniConfig = AniConfig
HeroUtils.RarityType = RarityType
HeroUtils.QualityType = QualityType
HeroUtils.GetHeroDebrisIds = GetHeroDebrisIds
HeroUtils.GetGoldHeroDebrisId = GetGoldHeroDebrisId
HeroUtils.HeroColorCount = 7
HeroUtils.HeroStarMax = 3
HeroUtils.ConsumeSlotMax = 3
HeroUtils.CampCount = 4
HeroUtils.SkillLevelLimit = 5
HeroUtils.SKILL_CNT_MAX = 5
HeroUtils.QualityMax = 10
HeroUtils.heroCommonDebrisIds = heroCommonDebrisIds
HeroUtils.IsInTheLottery = false
HeroUtils.PreviewScenePath = "Assets/Main/Prefabs/UI/UIHero/New/HeroPreview/Camp_%s.prefab"
HeroUtils.DisplayScenePath = "Assets/Main/Prefabs/UI/UIHero/New/HeroPreview/DisplayScene.prefab"
HeroUtils.DisplaySquadScenePath = "Assets/Main/Prefabs/UI/UIHero/New/HeroPreview/DisplaySquadScene.prefab"
HeroUtils.DisplayPVPSquadScenePath = "Assets/Main/Prefabs/UI/UIHero/New/HeroPreview/DisplayPVPSquadScene.prefab"
HeroUtils.DisplayPVESquadScenePath = "Assets/Main/Prefabs/UI/UIHero/New/HeroPreview/DisplayPVESquadScene.prefab"
HeroUtils.DisplayHeroDetailScenePath = "Assets/Main/Prefabs/UI/UIHero/New/HeroPreview/HeroSquadScene.prefab"
HeroUtils.DisplayTacticalWeaponScenePath = "Assets/Main/Prefabs/UI/UIHero/New/HeroPreview/TacticalWeaponScene.prefab"
HeroUtils.RecruitScenePath = "Assets/Main/Prefabs/UI/UIHero/New/HeroPreview/RecruitScene.prefab"
HeroUtils.RecruitSceneGaojiPath = "Assets/Main/Prefabs/UI/UIHero/New/HeroPreview/RecruitScene_gaoji.prefab"
HeroUtils.RecruitSceneOrangePath = "Assets/Main/Prefabs/UI/UIHero/New/HeroPreview/RecruitScene_chengse.prefab"
HeroUtils.RecruitTimeOpenPath = "Assets/_Art/UIScene/UI_yxzm/animator/zhaomu_Timeline_open.playable"
HeroUtils.RecruitTimeClosePath = "Assets/_Art/UIScene/UI_yxzm/animator/zhaomu_Timeline_close.playable"
HeroUtils.HeroAwakenReplaceSkillSlotIndex = 4
HeroUtils.HeroAwakenSkillItemStarImageAssetPathRed = "Assets/Main/Sprites/UI/UILWHeroAwaken/UILWHeroAwakenCommon/fu_juexing_xingxing06.png"
HeroUtils.HeroSkillItemStarImageAssetPathRed = "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_wurenjixinpian_zhujiemian_star01.png"
HeroUtils.HeroSkillItemStarImageAssetPathYellow = "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_wurenjixinpian_zhujiemian_star02.png"
HeroUtils.HeroCellRankStarImageAssetPathYellow = "Assets/Main/Sprites/UI/UILWHeroDetail/cfm_biandui_xingxing_%s.png"
HeroUtils.HeroCellRankStarImageAssetPathYellowFull = "Assets/Main/Sprites/UI/UILWHeroDetail/cfm_biandui_xingxing_5.png"
HeroUtils.HeroCellRankStarImageAssetPathRed = "Assets/Main/Sprites/UI/UILWHeroAwaken/UILWHeroAwakenCommon/FX_juexing_xingxing0%s.png"
HeroUtils.HeroCellRankStarImageAssetPathRedFull = "Assets/Main/Sprites/UI/UILWHeroAwaken/UILWHeroAwakenCommon/FX_juexing_xingxing05.png"
HeroUtils.HeroCellRankStarImageAssetPathEmpty = "Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_yingxiongxing_01.png"
HeroUtils.HeroAwakenBigRankStarImageAssetPathRed = "Assets/Main/Sprites/UI/UILWHeroAwaken/UILWHeroAwakenCommon/FX_yingxiong_xingxing_hong06.png"
HeroUtils.HeroAwakenBigRankStarImageAssetPathYellow = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_yingxiong_xingxing_06.png"
HeroUtils.SkinSupportHeroIconTypeList = {
  HeroIconType.half_portrait,
  HeroIconType.small_icon,
  HeroIconType.spine_path,
  HeroIconType.pvp_hero_awaken_icon
}
HeroUtils.HeroAwakenGuideFlowCondition = {Condition_1 = 1}
HeroUtils.HeroAwakenGuideFlowBehaviour = {Behaviour_1 = 1}
HeroUtils.HeroPropertyGroupType = {
  Level = 0,
  Rank = 1,
  Skill = 2,
  Equip = 3,
  Honor = 4,
  Weapon = 5,
  Deco = 6,
  SeasonCallBack = 7,
  DominatorTrain = 8,
  WeaponStrengthen = 9,
  Awaken = 11
}
HeroUtils.HeroAwakenPVPSkillCastEffectAssetPath = "Assets/Main/Prefabs/HeroAwakenEffect/Katyusha/eff_heroawaken_jinboli_jisudan_s.prefab"
HeroUtils.GetSkillIcon = GetSkillIcon
HeroUtils.EatForbidReason = EatForbidReason
HeroUtils.GetQualityIconPath = GetQualityIconPath
HeroUtils.GetQualityBgPath = GetQualityBgPath
HeroUtils.GetRarityIconName = GetRarityIconName
HeroUtils.GetHeroIconPath = GetHeroIconPath
HeroUtils.GetCampIconPath = GetCampIconPath
HeroUtils.GetCampNameAndDesc = GetCampNameAndDesc
HeroUtils.GetLevelUpNeedExp = GetLevelUpNeedExp
HeroUtils.GetLevelUpCostResources = GetLevelUpCostResources
HeroUtils.GetTotalCostGold = GetTotalCostGold
HeroUtils.GetTagsByHeroId = GetTagsByHeroId
HeroUtils.GetCampByHeroId = GetCampByHeroId
HeroUtils.GetTagIconAndName = GetTagIconAndName
HeroUtils.GetQualityName = GetQualityName
HeroUtils.GetRarityName = GetRarityName
HeroUtils.GetMaxLevelByQuality = GetMaxLevelByQuality
HeroUtils.GetMaxLevelWithScienceLimit = GetMaxLevelWithScienceLimit
HeroUtils.GetHeroFinalLevel = GetHeroFinalLevel
HeroUtils.GetHeroNameByConfigId = GetHeroNameByConfigId
HeroUtils.GetHeroBodyByHeroId = GetHeroBodyByHeroId
HeroUtils.GetPointConfig = GetPointConfig
HeroUtils.GetArmyLimit = GetArmyLimit
HeroUtils.GetConfigQuality = GetConfigQuality
HeroUtils.GetMaxAttrForHeroMap = GetMaxAttrForHeroMap
HeroUtils.GetHeroSkillCount = GetHeroSkillCount
HeroUtils.GetSkillUpgradeItemAndNum = GetSkillUpgradeItemAndNum
HeroUtils.GetArkIdAndGrade = GetArkIdAndGrade
HeroUtils.GetArkLines = GetArkLines
HeroUtils.GetArkGradeIcon = GetArkGradeIcon
HeroUtils.GetQualityBgInTroopsByPath = GetQualityBgInTroopsByPath
HeroUtils.GetJigsawCost = GetJigsawCost
HeroUtils.GetSkillDescStr = GetSkillDescStr
HeroUtils.GetHeroDebrisBgByColor = GetHeroDebrisBgByColor
HeroUtils.GetBeyondTimesByLevel = GetBeyondTimesByLevel
HeroUtils.GetHeroIconRoundPath = GetHeroIconRoundPath
HeroUtils.GetStarNumByQuality = GetStarNumByQuality
HeroUtils.GetQualityColorStr = GetQualityColorStr
HeroUtils.GetCircleQualityIconPath = GetCircleQualityIconPath
HeroUtils.GetTroopQualityIconPath = GetTroopQualityIconPath
HeroUtils.GetMilitaryRankIcon = GetMilitaryRankIcon
HeroUtils.GetMilitaryRankName = GetMilitaryRankName
HeroUtils.GetHeroAttr = GetHeroAttr
HeroUtils.GetLvColor = GetLvColor
HeroUtils.GetCampPageBgPath = GetCampPageBgPath
HeroUtils.GetRankIdByLvAndStage = GetRankIdByLvAndStage
HeroUtils.GetHeroBubbleBGPath = GetHeroBubbleBGPath
HeroUtils.GetHeroRestraintType = GetHeroRestraintType
HeroUtils.GetRarityIconPath = GetRarityIconPath
HeroUtils.GetMaxStarByRarity = GetMaxStarByRarity
HeroUtils.GetMaxStarLevel = GetMaxStarLevel
HeroUtils.GetRarityMaskPath = GetRarityMaskPath
HeroUtils.GetIsWakeUp = GetIsWakeUp
HeroUtils.GetHeroStarDialog = GetHeroStarDialog
HeroUtils.GetHeroNameColorByRarity = GetHeroNameColorByRarity
HeroUtils.GetPosterRarityPath = GetPosterRarityPath
HeroUtils.GetPosterSelectRarityPath = GetPosterSelectRarityPath
HeroUtils.GetPosterAddRarityPath = GetPosterAddRarityPath
HeroUtils.GetRarityColorStr = GetRarityColorStr
HeroUtils.GetSkillBigIcon = GetSkillBigIcon
HeroUtils.GetNextMaxLevelByQuality = GetNextMaxLevelByQuality
HeroUtils.GetExtraAtkByCamp = GetExtraAtkByCamp
HeroUtils.GetExtraDefByCamp = GetExtraDefByCamp
HeroUtils.GetExtraTroopByCamp = GetExtraTroopByCamp
HeroUtils.HeroStateType = HeroStateType
HeroUtils.HeroAllCamps = HeroAllCamps
HeroUtils.GetHeroRestraintEffectType = GetHeroRestraintEffectType
HeroUtils.GetCampCircleImgPath = GetCampCircleImgPath
HeroUtils.GetHeroBeRestraintType = GetHeroBeRestraintType
HeroUtils.GetHireHeroDataByBattleBuff = GetHireHeroDataByBattleBuff
HeroUtils.IsReachStarLimit = IsReachStarLimit
HeroUtils.heroStarLevel = nil
HeroUtils.GetMaxStarLevel = GetMaxStarLevel
HeroUtils.IsCommonHeroDebris = IsCommonHeroDebris
HeroUtils.GetAllCommonHeroDebris = GetAllCommonHeroDebris
HeroUtils.InitAllCommonHeroDebris = InitAllCommonHeroDebris
HeroUtils.GetHeroSkillDamage = GetHeroSkillDamage
HeroUtils.GetHeroFirstSkillId = GetHeroFirstSkillId
HeroUtils.SortHeroUuidsByRarityLevelPower = SortHeroUuidsByRarityLevelPower
HeroUtils.GetHeroSpecialBgByQuality = GetHeroSpecialBgByQuality
HeroUtils.GetHeroQualityTagImg = GetHeroQualityTagImg
HeroUtils.GetHeroRadarValues = GetHeroRadarValues
HeroUtils.GetHeroBaseValueTable = GetHeroBaseValueTable
HeroUtils.GetHeroPropertyNameId = GetHeroPropertyNameId
HeroUtils.GetFormattedValue = GetFormattedValue
HeroUtils.GetFormattedPropertyValue = GetFormattedPropertyValue
HeroUtils.GetHeroUpgradeChangedPropertyTable = GetHeroUpgradeChangedPropertyTable
HeroUtils.GetHeroWeaponBgByQuality = GetHeroWeaponBgByQuality
HeroUtils.GetWeaponSpecialBg = GetWeaponSpecialBg
HeroUtils.GetHeroChangedPropertyParam = GetHeroChangedPropertyParam
HeroUtils.AutoSetHeroesSupply = AutoSetHeroesSupply
HeroUtils.GetHeroQualityColor = GetHeroQualityColor
HeroUtils.GetHeroTypeIcon = GetHeroTypeIcon
HeroUtils.GetWorkerBgByQuality = GetWorkerBgByQuality
HeroUtils.GetLevelBg = GetLevelBg
HeroUtils.GetHeroTypeText = GetHeroTypeText
HeroUtils.GetFormationBgByQuality = GetFormationBgByQuality
HeroUtils.GetHeroJobIcon = GetHeroJobIcon
HeroUtils.GetEquipSlotSprite = GetEquipSlotSprite
HeroUtils.GetFormationBuffInfoList = GetFormationBuffInfoList
HeroUtils.GetFormationBuffInfoListByHeroInfos = GetFormationBuffInfoListByHeroInfos
HeroUtils.GetCampEffectConfig = GetCampEffectConfig
HeroUtils.GetCampEffectConfigByHeroInfos = GetCampEffectConfigByHeroInfos
HeroUtils.GetHeroTipInfoTextByType = GetHeroTipInfoTextByType
HeroUtils.GetHeroTipInfoTextByJob = GetHeroTipInfoTextByJob
HeroUtils.SortFormationHeros = SortFormationHeros
HeroUtils.SortFormationHerosByHeroInfos = SortFormationHerosByHeroInfos
HeroUtils.GenerateHeroDataList = GenerateHeroDataList
HeroUtils.GetFormattedPropertyValueColored = GetFormattedPropertyValueColored
HeroUtils.GetLWHeroXmlName = GetLWHeroXmlName
HeroUtils.CanHeroUpgradeMultipleLevels = CanHeroUpgradeMultipleLevels
HeroUtils.CanTeamHeroesUpgrade = CanTeamHeroesUpgrade
HeroUtils.CanTeamSSRHeroesUpgradeStar = CanTeamSSRHeroesUpgradeStar
return ConstClass("HeroUtils", HeroUtils)
