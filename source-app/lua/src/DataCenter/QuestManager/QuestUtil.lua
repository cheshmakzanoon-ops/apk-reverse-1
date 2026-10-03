local QuestUtil = BaseClass("QuestUtil")
local Localization = CS.GameEntry.Localization

local function GetQuestDesc(questTemplate, isChatView)
  if questTemplate == nil then
    return ""
  end
  local show1, show2, show3
  if questTemplate.desctype == QuestDescType.Normal then
    show1 = questTemplate.para1
    show2 = questTemplate.para2
    show3 = questTemplate.para3
  elseif questTemplate.desctype == QuestDescType.Build then
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(questTemplate.para1)
    if template ~= nil then
      show1 = Localization:GetString(template.name)
    end
    show2 = questTemplate.para2
    show3 = questTemplate.para3
  elseif questTemplate.desctype == QuestDescType.Train then
    local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(questTemplate.para1)
    if template ~= nil then
      show1 = Localization:GetString(template.name)
    end
    show2 = questTemplate.para2
  elseif questTemplate.desctype == QuestDescType.Farm then
    local template = DataCenter.FarmingDataManager:GetFramingTemplate(questTemplate.para1)
    if template ~= nil then
      show1 = Localization:GetString(template.product_name)
    end
    show2 = questTemplate.para2
  elseif questTemplate.desctype == QuestDescType.Factory then
    local template = DataCenter.FactoryDataManager:GetFactoryTemplate(questTemplate.para1)
    if template ~= nil then
      show1 = Localization:GetString(template.product_name)
    end
    show2 = questTemplate.para2
  elseif questTemplate.desctype == QuestDescType.ResourceItem then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(questTemplate.para1)
    if template ~= nil then
      show1 = Localization:GetString(template.name)
    end
    show2 = questTemplate.para2
  elseif questTemplate.desctype == QuestDescType.HeroUpStar then
    local star, const = HeroUtils.GetHeroStarAndProgress(questTemplate.para1)
    show1 = Localization:GetString("129269", star)
    show2 = questTemplate.para2
  elseif questTemplate.desctype == QuestDescType.Resource then
    local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(questTemplate.para1)
    if template ~= nil then
      show1 = Localization:GetString(template.name)
    end
    show2 = questTemplate.para2
  elseif questTemplate.desctype == QuestDescType.Science then
    local baseId = CommonUtil.GetScienceBaseType(questTemplate.para1)
    local level = CommonUtil.GetScienceLv(questTemplate.para1)
    local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(baseId, level)
    if template ~= nil then
      show1 = Localization:GetString(template.name)
    end
    show2 = questTemplate.para2
  elseif questTemplate.desctype == QuestDescType.Monster then
    local template = DataCenter.MonsterTemplateManager:GetMonsterTemplate(questTemplate.para1)
    if template ~= nil then
      show1 = Localization:GetString(GameDialogDefine.MONSTER_LEVEL_NAME, template.level, Localization:GetString(template.name))
    end
    show2 = questTemplate.para2
  elseif questTemplate.desctype == QuestDescType.Robot then
    local template = LocalController:instance():getLine(TableName.Robot, questTemplate.para1)
    if template ~= nil then
      show1 = Localization:GetString(template:getValue("name"))
    end
    show2 = questTemplate.para2
  elseif questTemplate.desctype == QuestDescType.LandLockMonster then
    show1 = Localization:GetString(GetTableData(TableName.MonsterLock, questTemplate.para1, "name"), questTemplate.para2)
  elseif questTemplate.desctype == QuestDescType.HeroName then
    show1 = Localization:GetString(HeroUtils.GetHeroNameByConfigId(questTemplate.para1))
    show2 = questTemplate.para2
  elseif questTemplate.desctype == QuestDescType.HeroQuality then
    if questTemplate.para1 == 1 then
      show1 = Localization:GetString(156004)
    elseif questTemplate.para1 == 2 then
      show1 = Localization:GetString(156003)
    elseif questTemplate.para1 == 3 then
      show1 = Localization:GetString(156002)
    elseif questTemplate.para1 == 4 then
      show1 = Localization:GetString(156001)
    end
    show2 = questTemplate.para2
  elseif questTemplate.desctype == QuestDescType.HeroSkill then
    show1 = Localization:GetString(HeroUtils.GetHeroNameByConfigId(questTemplate.para3))
    local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(questTemplate.para1)
    if skillTemplate then
      show2 = Localization:GetString(skillTemplate.name)
    end
    show3 = questTemplate.para2
  elseif questTemplate.desctype == QuestDescType.LandLockStage then
    show1 = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), questTemplate.para1, "order")
  elseif questTemplate.desctype == QuestDescType.HeroTrial then
    show1 = toInt((tonumber(questTemplate.para3) or 0) / 5)
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(tonumber(questTemplate.para1))
    if heroTemplate then
      show2 = Localization:GetString(heroTemplate.name)
    end
  elseif questTemplate.desctype == QuestDescType.ThanksGiving then
    show1 = tonumber(questTemplate.para2)
    local itemId = tonumber(questTemplate.para1)
    local itemName = DataCenter.ItemTemplateManager:GetName(itemId)
    show2 = itemName
  elseif questTemplate.desctype == QuestDescType.ActMonopoly then
    show1 = questTemplate.para1
    show2 = questTemplate.para2
    show3 = questTemplate.para3
    local show1QualityType = tonumber(show1) or 0
    if show1QualityType == 1 then
      show1 = Localization:GetString("snow_season_color_name1")
    elseif show1QualityType == 2 then
      show1 = Localization:GetString("snow_season_color_name2")
    elseif show1QualityType == 3 then
      show1 = Localization:GetString("snow_season_color_name3")
    elseif show1QualityType == 4 then
      show1 = Localization:GetString("snow_season_color_name4")
    elseif show1QualityType == 5 then
      show1 = Localization:GetString("snow_season_color_name5")
    end
  elseif questTemplate.desctype == QuestDescType.SlotMachine then
    show1 = questTemplate.para2
    local iconTemplate = DataCenter.ActSlotMachineDataManager:GetIconTemplate(questTemplate.para1)
    if iconTemplate then
      show2 = Localization:GetString(iconTemplate.name)
    end
  elseif questTemplate.desctype == QuestDescType.ActMonopolyLoopTask then
    show1 = questTemplate.para1
    show2 = questTemplate.para2
    show3 = questTemplate.overflow_value
  elseif questTemplate.desctype == QuestDescType.ActGiftGivingTask then
    show1 = questTemplate.para2
  elseif questTemplate.desctype == QuestDescType.CountBattleMap then
    show1 = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), questTemplate.para3, "order")
    show3 = nil
    show2 = questTemplate.para2
  elseif questTemplate.desctype == QuestDescType.SparkMonopoly then
    show1 = DataCenter.MonopolyManager:GetPlacealityQuestOrder(tonumber(questTemplate.para1))
    show2 = questTemplate.para2
    show3 = questTemplate.para3
  else
    show1 = questTemplate.para1
    show2 = questTemplate.para2
    show3 = questTemplate.para3
  end
  local numShow1 = tonumber(show1)
  show1 = numShow1 and string.GetFormattedSeperatorNum(numShow1) or show1
  local numShow2 = tonumber(show2)
  show2 = numShow2 and string.GetFormattedSeperatorNum(numShow2) or show2
  local numShow3 = tonumber(show3)
  show3 = numShow3 and string.GetFormattedSeperatorNum(numShow3) or show3
  local empty1 = show1 == nil or show1 == ""
  local empty2 = show2 == nil or show2 == ""
  local empty3 = show3 == nil or show3 == ""
  if not empty3 then
    return Localization:GetString(questTemplate.desc, show1, show2, show3)
  end
  if empty1 and empty2 then
    if isChatView then
      return Localization:GetString(questTemplate.desc)
    end
    return Localization:GetString(questTemplate.mainshow == "" and questTemplate.desc or questTemplate.mainshow)
  else
    local key = questTemplate.desc
    if isChatView then
    elseif not string.IsNullOrEmpty(questTemplate.mainshow) then
      key = questTemplate.mainshow
    end
    if empty2 then
      return Localization:GetString(key, show1)
    end
    return Localization:GetString(key, show1, show2)
  end
end

local function GetTargetNum(questTemplate)
  local targetNum = questTemplate.para2
  if questTemplate.overflow and questTemplate.overflow > 0 then
    targetNum = questTemplate.overflow_value
  end
  return targetNum
end

QuestUtil.GetQuestDesc = GetQuestDesc
QuestUtil.GetTargetNum = GetTargetNum
return QuestUtil
