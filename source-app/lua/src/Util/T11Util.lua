local T11Util = {}
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local Const = require("DataCenter.T11DataManager.T11Constant")
local T11EquipData = require("DataCenter.T11DataManager.T11EquipData")

function T11Util.IsUnlockT11()
  local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.UNLOCK_T11)
  return effectValue and 0 < effectValue
end

function T11Util.GetCurT11SoldierType()
  local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.UNLOCK_T11)
  if not effectValue or effectValue <= 0 then
    return T11SoldierType.T11NotUnLock
  end
  return T11Util.GetT11SoldierTypeByEffVal(effectValue)
end

function T11Util.GetT11SoldierTypeByEffVal(effVal)
  effVal = effVal or 0
  return math.floor(effVal + 0.5)
end

function T11Util.GetCurStageAllEquipData()
  return T11Util.GetT11LvData():GetEquipGroupData():GetAllEquipDataList()
end

function T11Util.GetCurStage()
  return T11Util.GetT11LvData().stageData:GetCurStage()
end

function T11Util.GetNextStageTmp()
  local curStageData = T11Util.GetT11LvData().stageData
  return curStageData:GetNextStageTmp()
end

function T11Util.GetT11LvData()
  return DataCenter.T11DataManager:GetT11LvlData()
end

function T11Util.GetCurUpgradeData()
  return T11Util.GetT11LvData().upgradeData
end

function T11Util.GetCurUpgradeEquipIdAndProgress()
  local upgradeData = T11Util.GetCurUpgradeData()
  if not upgradeData then
    Logger.LogError("T11Util.GetCurUpgradeEquipIdAndProgress upgradeData is nil")
    return nil, nil
  end
  local curUpgradeEquipId = upgradeData:GetCurUpgradeEquipId()
  local curUpgradeProgress = upgradeData:GetCurUpgradeProgressVal()
  return curUpgradeEquipId, curUpgradeProgress
end

function T11Util.GetCurUpgradeEquipProgress()
  local upgradeData = T11Util.GetCurUpgradeData()
  if not upgradeData then
    Logger.LogError("T11Util.GetCurUpgradeEquipIdAndProgress upgradeData is nil")
    return nil
  end
  return upgradeData:GetCurUpgradeProgressVal() or 0
end

function T11Util.GetCurUpgradeProgressId()
  local upgradeData = T11Util.GetCurUpgradeData()
  if not upgradeData then
    Logger.LogError("T11Util.GetNextUpgradeProgressId upgradeData is nil")
    return nil
  end
  return upgradeData:GetCurUpgradeProgressId()
end

function T11Util.GetNextUpgradeProgressId()
  local upgradeData = T11Util.GetCurUpgradeData()
  if not upgradeData then
    Logger.LogError("T11Util.GetNextUpgradeProgressId upgradeData is nil")
    return nil
  end
  return upgradeData:GetNextUpgradeProgressId()
end

function T11Util.GetNextUpgradeCostData()
  local upgradeData = T11Util.GetCurUpgradeData()
  if not upgradeData then
    Logger.LogError("T11Util.GetNextUpgradeCostData upgradeData is nil")
    return nil
  end
  return upgradeData:GetNextUpgradeCostData()
end

function T11Util.GetNextStageUpgradeCostData()
  local stageData = T11Util.GetT11LvData().stageData
  if not stageData then
    Logger.LogError("T11Util.GetNextStageUpgradeCostData stageData is nil")
    return nil
  end
  return stageData:GetNextStageUpgradeCostData()
end

function T11Util.GetCurBreakQueueInfo()
  return DataCenter.T11DataManager:GetCurBreakQueueInfo()
end

function T11Util.GetT11SoldierType(type)
  if type == nil then
    Logger.LogError("T11Util.GetT11SoldierType: type is nil")
    return nil
  end
  if type == "a" then
    return T11SoldierType.T11SoldierTypeA
  end
  if type == "b" then
    return T11SoldierType.T11SoldierTypeB
  end
end

function T11Util.GetCurT11SoldierTmpData()
  local soldierType = T11Util.GetCurT11SoldierType()
  local curStage = T11Util.GetCurStage()
  local soldierData = T11Util.GetT11SoldierDataByStageAndType(curStage, soldierType)
  if not soldierData then
    Logger.LogError("T11Util.GetCurT11SoldierTmpData soldierData is nil")
    return nil
  end
  return soldierData
end

function T11Util.GetT11SoldierDataByStageAndType(stage, soldierType)
  if not stage or not soldierType then
    return nil
  end
  local soldierTmpDic = DataCenter.T11DataManager:GetSoldierTmpData()
  if not soldierTmpDic then
    Logger.LogError("T11Util.GetT11SoldierDataByStageAndType soldierTmpDic is nil")
    return nil
  end
  local ret
  local curMaxStage = -1
  for tStage, v in pairs(soldierTmpDic) do
    if tStage <= stage and (not ret or tStage > curMaxStage) then
      ret = v
      curMaxStage = tStage
    end
  end
  if not ret then
    Logger.LogError("T11Util.GetT11SoldierDataByStageAndType ret is nil for stage:" .. stage .. " soldierType:" .. soldierType)
    return nil
  end
  return ret[soldierType]
end

function T11Util.GetT11InitialStage()
  local stageData = T11Util.GetT11LvData().stageData
  if not stageData then
    Logger.LogError("T11Util.GetT11InitialStage stageData is nil")
    return false
  end
  return stageData:GetMinStage()
end

function T11Util.GetNextStageSkillIcon()
  local nextStageUnlockSkillData = T11Util.GetNextStageSkillData()
  if not nextStageUnlockSkillData then
    return ""
  end
  return nextStageUnlockSkillData.icon or ""
end

function T11Util.GetSkillInfoByStage(skillStage, soldierType)
  local stage = T11Util.GetCurStage()
  return T11Util.GetSkillInfoByDesignatedStage(skillStage, soldierType, stage)
end

function T11Util.GetSkillInfoByDesignatedStage(skillStage, soldierType, playerStage)
  local skillInfo = DataCenter.T11DataManager.curT11LevelData.stageData:GetTmpByStage(skillStage)
  local result = {}
  local icon = ""
  if not skillInfo then
    T11Util.ShowLog("T11Util.GetSkillInfoByStage skillInfo is nil for stage:" .. skillStage)
    return result
  end
  if soldierType == T11SoldierType.T11SoldierTypeA then
    icon = skillInfo and skillInfo.effect_icon_a or ""
  elseif soldierType == T11SoldierType.T11SoldierTypeB then
    icon = skillInfo and skillInfo.effect_icon_b or ""
  else
    icon = skillInfo and skillInfo.effect_icon_a or ""
  end
  local name = ""
  if soldierType == T11SoldierType.T11SoldierTypeA then
    name = skillInfo.effect_name_a or ""
  elseif soldierType == T11SoldierType.T11SoldierTypeB then
    name = skillInfo.effect_name_b or ""
  else
    name = skillInfo.effect_name_a or ""
  end
  local desc = ""
  if soldierType == T11SoldierType.T11SoldierTypeA then
    desc = skillInfo.effect_info_a or ""
  elseif soldierType == T11SoldierType.T11SoldierTypeB then
    desc = skillInfo.effect_info_b or ""
  else
    desc = skillInfo.effect_info_a or ""
  end
  local isUnlock = skillStage <= playerStage
  local ifCoreEffect = skillInfo.if_core_effect
  local effect_unlock_info = skillInfo.effect_unlock_info
  result.name = name
  result.icon = icon
  result.desc = desc
  result.isUnlock = isUnlock
  result.ifCoreEffect = ifCoreEffect
  result.effect_unlock_info = effect_unlock_info
  result.stage = skillInfo.stage
  result.power = skillInfo.power
  result.effect_mummy_data = skillInfo.effect_mummy_data
  result.effect_mummy_icon = skillInfo.effect_mummy_icon
  result.effect_mummy_name = skillInfo.effect_mummy_name
  result.effect_mummy_desc = skillInfo.effect_mummy_desc
  return result
end

function T11Util.GetStageSkillList()
  local curSelectSoldierType = T11Util.GetCurT11SoldierType()
  if curSelectSoldierType == T11SoldierType.T11NotUnLock then
    return nil
  end
  local mgr = DataCenter.T11DataManager
  if mgr.curT11LevelData == nil or T11Util.GetT11LvData() == nil then
    return nil
  end
  if mgr.curT11LevelData.stageData == nil then
    return nil
  end
  local initStage = T11Util.GetT11InitialStage()
  if initStage == false then
    return nil
  end
  local theSkillList = {}
  local stageList = mgr.curT11LevelData.stageData:GetStageList()
  local coreSkillInfo = T11Util.GetSkillInfoByStage(initStage, curSelectSoldierType)
  table.insert(theSkillList, coreSkillInfo)
  for _, v in ipairs(stageList) do
    if v ~= initStage then
      local skillInfo = T11Util.GetSkillInfoByStage(v, curSelectSoldierType)
      if skillInfo then
        table.insert(theSkillList, skillInfo)
      end
    end
  end
  table.sort(theSkillList, function(a, b)
    return toInt(a.stage) < toInt(b.stage)
  end)
  return theSkillList
end

function T11Util.GetStageUnlockSkillData()
  local curStage = T11Util.GetCurStage()
  local soldierType = T11Util.GetCurT11SoldierType()
  local skillInfo = T11Util.GetSkillInfoByStage(curStage, soldierType)
  return skillInfo
end

function T11Util.GetNextStageSkillData()
  if T11Util.IsMaxStage() then
    return nil
  end
  local curStage = T11Util.GetCurStage() + 1
  local soldierType = T11Util.GetCurT11SoldierType()
  local skillInfo = T11Util.GetSkillInfoByStage(curStage, soldierType)
  return skillInfo
end

function T11Util.GetCurStageSkillData()
  local curStage = T11Util.GetCurStage()
  local soldierType = T11Util.GetCurT11SoldierType()
  local skillInfo = T11Util.GetSkillInfoByStage(curStage, soldierType)
  return skillInfo
end

function T11Util.IsMaxExp()
  local upgradeData = T11Util.GetCurUpgradeData()
  if not upgradeData then
    T11Util.ShowLog("T11Util.IsMaxExp upgradeData is nil")
    return false
  end
  return upgradeData:IsMaxExp()
end

function T11Util.IsMaxStage()
  local curStage = T11Util.GetCurStage()
  local stageData = T11Util.GetT11LvData().stageData
  if not stageData then
    Logger.LogError("T11Util.IsMaxStage stageData is nil")
    return false
  end
  return curStage >= stageData:GetMaxStage()
end

function T11Util.ShowLog(info)
  if not CS.UnityEngine.Application.isEditor or not Const.IsShowDebugLog then
    return
  end
  Logger.LogCustom(string.format("[T11]%s", info))
end

function T11Util.GetUpgradeTmpByProgressId(progressId)
  local upgradeData = T11Util.GetCurUpgradeData()
  if not upgradeData then
    Logger.LogError("T11Util.GetUpgradeTmpByProgressId upgradeData is nil")
    return nil
  end
  return upgradeData:GetUpgradeTmpByProgressId(progressId)
end

function T11Util.GetCurUpgradeEquipType()
  local curUpgradeEquipId, progress = T11Util.GetCurUpgradeEquipIdAndProgress()
  local equipData = T11Util.GetCurEquipDataByEquipId(curUpgradeEquipId)
  if not equipData then
    return T11EquipType.Unknown
  end
  return equipData.type
end

function T11Util.GetCurEquipDataByEquipId(equipId)
  local equipGroupData = T11Util.GetT11LvData().equipGroupData
  if not equipGroupData then
    Logger.LogError("T11Util.GetCurEquipDataByEquipId equipGroupData is nil")
    return nil
  end
  return equipGroupData:GetEquipDataById(equipId)
end

function T11Util.GetCurAttrInfo()
  local upgradeData = T11Util.GetCurUpgradeData()
  if not upgradeData then
    Logger.LogError("T11Util.GetUpgradeTmpByProgressId upgradeData is nil")
    return nil
  end
  return upgradeData:GetCurAttrInfo()
end

function T11Util.IfShowT11InCamp()
  local seasonConfig = LuaEntry.DataConfig:TryGetStr("soldier_eleven_param", "k1")
  if string.IsNullOrEmpty(seasonConfig) then
    Logger.LogError("T11Util.IfShowT11InCamp seasonConfig is nil")
    return false
  end
  local seasonConfigArr = string.split(seasonConfig, "|")
  if not seasonConfigArr or #seasonConfigArr < 2 then
    Logger.LogError("T11Util.IfShowT11InCamp seasonConfigArr is nil")
    return false
  end
  local result = true
  local requireSeason = tonumber(seasonConfigArr[1])
  local requireSeasonDay = tonumber(seasonConfigArr[2])
  local curSeason = SeasonUtil.GetSeason()
  local nowSeasonDay = SeasonUtil.GetSeasonDay()
  result = requireSeason < curSeason or curSeason == requireSeason and requireSeasonDay <= nowSeasonDay
  return result
end

function T11Util.CheckSuperSoldierByTmp(soldierTmp)
  if not soldierTmp then
    return
  end
  return T11Util.IsSuperSoldier(soldierTmp.lv, soldierTmp.type)
end

function T11Util.IsSuperSoldier(level, type)
  if not level then
    Logger.LogError("T11Util.IsSuperSoldier: level is nil")
    return false
  end
  if type and not T11SoldierTypeWhiteList[type] then
    return false
  end
  return level >= Const.SoldierLevel
end

function T11Util.IsSuperSoldierById(soldierId)
  local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
  if not soldierTemplate then
    return false
  end
  return T11Util.IsSuperSoldier(soldierTemplate.lv, soldierTemplate.type)
end

function T11Util.IsSuperMummySoldier(level, type)
  return type == SoldierType.Mummy and Const.SoldierLevel <= toInt(level)
end

function T11Util.IsSuperMummySoldierById(soldierId)
  local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
  if not soldierTemplate then
    return false
  end
  return T11Util.IsSuperMummySoldier(soldierTemplate.lv, soldierTemplate.type)
end

function T11Util.GoToT11Building()
  local data = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_T11_Research)
  if data == nil or data and data.level == 0 then
    GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_T11_Research)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.T11MainView)
  end
end

function T11Util.GetSoldierTypeByEffectList(effectList)
  if not effectList then
    return T11SoldierType.T11NotUnLock
  end
  local soldierType = T11SoldierType.T11NotUnLock
  local effectVal = 0
  for _, v in pairs(effectList) do
    if v and v.id == EffectDefine.UNLOCK_T11 then
      effectVal = v.val
      break
    end
  end
  soldierType = T11Util.GetT11SoldierTypeByEffVal(effectVal)
  return soldierType
end

function T11Util.GetSoldierTypeByEffectStr(effectStr)
  if string.IsNullOrEmpty(effectStr) then
    return T11SoldierType.T11NotUnLock
  end
  local effectStrList = string.split(effectStr, ";")
  if not effectStrList or #effectStrList ~= 2 then
    Logger.LogError("T11Util.GetSoldierTypeByEffectStr: effectStr is wrong, str==" .. effectStr)
    return T11SoldierType.T11NotUnLock
  end
  local effectList = {}
  local effect = {}
  effect.id = tonumber(effectStrList[1])
  effect.val = tonumber(effectStrList[2])
  table.insert(effectList, effect)
  return T11Util.GetSoldierTypeByEffectList(effectList)
end

function T11Util.GetPlayerSelfT11SoldierJCModelPath(soldierTemplate)
  if not T11Util.IsUnlockT11() then
    return soldierTemplate.model_jc
  end
  local curT11Tmp = T11Util.GetCurT11SoldierTmpData()
  if not curT11Tmp then
    return soldierTemplate.model_jc
  end
  return curT11Tmp.model_jc
end

function T11Util.GetPlayerSelfT11SoldierPerformModelPath(soldierTemplate)
  if not T11Util.IsUnlockT11() then
    return soldierTemplate.model
  end
  local curT11Tmp = T11Util.GetCurT11SoldierTmpData()
  if not curT11Tmp then
    return soldierTemplate.model
  end
  return curT11Tmp.model
end

function T11Util.IsDownloadedTXXRes(soliderLv)
  local packageIdResConfig = Const.SuperSoldierResPackageConfig
  if not table.containsKey(packageIdResConfig, soliderLv) then
    return false
  end
  local packConfigId = packageIdResConfig[soliderLv]
  return packConfigId and 0 < packConfigId and CS.DownloadResGroupCommonManager.Instance:IsDownload(packConfigId)
end

function T11Util.IsShowRedDot4T11Building()
  return T11Util.IsShowRedDotForT11Overview()
end

function T11Util.IsShowRedDotForT11Overview()
  local state = DataCenter.T11DataManager:GetCurT11UpgradeState()
  if state == T11UnlockState.Unknown or state == T11UnlockState.T11MaxStage then
    return false
  end
  if state == T11UnlockState.T11Unlockable or state == T11UnlockState.SkillBreakable or state == T11UnlockState.T11UnlockConfirmComplete or state == T11UnlockState.SkillBreakConfirmComplete then
    return true
  end
  if state == T11UnlockState.T11UnlockProgressUpgrade or state == T11UnlockState.SkillProgressUpgrade then
    local upgradeCostData = T11Util.GetNextUpgradeCostData()
    if not upgradeCostData then
      return false
    end
    for _, v in ipairs(upgradeCostData) do
      local type = v.type
      local itemId = v.itemId
      local costNum = v.costNum
      local have = 0
      if type == CommonCostNeedType.ResourceItem then
        have = DataCenter.ResourceItemDataManager:GetCountByItemId(itemId)
      elseif type == CommonCostNeedType.Goods then
        have = DataCenter.ItemData:GetItemCount(itemId)
      elseif type == CommonCostNeedType.Resource then
        have = LuaEntry.Resource:GetCntByResType(itemId)
      end
      if costNum > have then
        return false
      end
    end
    return true
  end
  return false
end

function T11Util.IsInResearchingState()
  local state = DataCenter.T11DataManager:GetCurT11UpgradeState()
  if state == T11UnlockState.Unknown or state == T11UnlockState.T11MaxStage then
    return false
  end
  return state == T11UnlockState.T11Unlocking or state == T11UnlockState.SkillBreaking
end

function T11Util.CheckIsCanChangeSoldierMode()
  local worldFormationList = DataCenter.ArmyFormationDataManager:GetCurFormationList(true)
  if worldFormationList then
    for _, v in pairs(worldFormationList) do
      if v.state ~= 0 then
        return false
      end
    end
  end
  local battleFieldFormationList = DataCenter.ArmyFormationDataManager:GetBattleFieldFormationList()
  if battleFieldFormationList then
    for _, v in pairs(battleFieldFormationList) do
      if v.state ~= 0 then
        return false
      end
    end
  end
  return true
end

function T11Util:GetShowMaxStageEquipDataList()
  local ret = {}
  local showStage = T11Util.GetCurStage() - 1
  local allEquipTmpIdList = DataCenter.T11DataManager:GetCurStageAllEquipIdList(showStage)
  for _, equipId in pairs(allEquipTmpIdList) do
    local equipData = T11EquipData.New()
    equipData:UpdateData(equipId)
    table.insert(ret, equipData)
  end
  return ret
end

function T11Util.GetT11PowerMap(getType, offsetEffDic)
  local soldierInfo = T11Util.GetCurAttrInfo()
  local ret = {}
  local attack, defence, health, morale
  local baseAttackTitle = "soldier_eleven_hero_attack_01"
  local baseAttackVal = soldierInfo[EffectDefine.LW_Effect_Id_50067] or 0
  local baseAttrEffOffset = offsetEffDic and offsetEffDic[EffectDefine.LW_Effect_Id_50067] or 0
  baseAttackVal = baseAttackVal + baseAttrEffOffset
  local attackPercentTitle = "soldier_eleven_hero_attack_02"
  local attEffectVal = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_Effect_Id_50077) + 1
  local attEffectOffset = offsetEffDic and offsetEffDic[EffectDefine.LW_Effect_Id_50077] or 0
  attEffectVal = attEffectVal + attEffectOffset
  local desc, attackAddPercent = WorkerUtil.GetEffectText(EffectDefine.LW_Effect_Id_50077, attEffectVal, true)
  local maxHeroSoldier = T11Util.GetMaxHeroSoldierCapacity()
  local attackMaxSoldierTitle = "soldier_eleven_hero_attack_03"
  local attResult = baseAttackVal * attEffectVal * maxHeroSoldier
  local atkResultInfo = {
    title = "soldier_eleven_hero_attack_04",
    value = string.GetFormattedStr(attResult),
    numVal = attResult
  }
  if getType == T11PowerInfoGetType.All then
    attack = {}
    table.insert(attack, {title = baseAttackTitle, value = baseAttackVal})
    table.insert(attack, {title = attackPercentTitle, value = attackAddPercent})
    table.insert(attack, {title = attackMaxSoldierTitle, value = maxHeroSoldier})
    table.insert(attack, atkResultInfo)
  elseif getType == T11PowerInfoGetType.ResultVal then
    table.insert(ret, atkResultInfo)
  elseif getType == T11PowerInfoGetType.BaseVal then
    table.insert(ret, {title = baseAttackTitle, numVal = baseAttackVal})
  end
  local baseDefenceTitle = "soldier_eleven_hero_defend_01"
  local baseDefenceVal = soldierInfo[EffectDefine.LW_Effect_Id_50069] or 0
  local baseDefenceOffset = offsetEffDic and offsetEffDic[EffectDefine.LW_Effect_Id_50069] or 0
  baseDefenceVal = baseDefenceVal + baseDefenceOffset
  local defencePercentTitle = "soldier_eleven_hero_defend_02"
  local defenceAddEffectVal = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_Effect_Id_50078) + 1
  local defenceAddEffectOffset = offsetEffDic and offsetEffDic[EffectDefine.LW_Effect_Id_50078] or 0
  defenceAddEffectVal = defenceAddEffectVal + defenceAddEffectOffset
  local descDef, defenceAddPercent = WorkerUtil.GetEffectText(EffectDefine.LW_Effect_Id_50078, defenceAddEffectVal, true)
  local defenceMaxHeroTitle = "soldier_eleven_hero_defend_03"
  local defResult = baseDefenceVal * defenceAddEffectVal * maxHeroSoldier
  local defResultInfo = {
    title = "soldier_eleven_hero_defend_04",
    value = string.GetFormattedStr(defResult),
    numVal = defResult
  }
  if getType == T11PowerInfoGetType.All then
    defence = {}
    table.insert(defence, {title = baseDefenceTitle, value = baseDefenceVal})
    table.insert(defence, {title = defencePercentTitle, value = defenceAddPercent})
    table.insert(defence, {title = defenceMaxHeroTitle, value = maxHeroSoldier})
    table.insert(defence, defResultInfo)
  elseif getType == T11PowerInfoGetType.ResultVal then
    table.insert(ret, defResultInfo)
  elseif getType == T11PowerInfoGetType.BaseVal then
    table.insert(ret, {title = baseDefenceTitle, numVal = baseDefenceVal})
  end
  local baseHealthTitle = "soldier_eleven_hero_life_01"
  local baseHealthVal = soldierInfo[EffectDefine.LW_Effect_Id_50065] or 0
  local baseHealthOffset = offsetEffDic and offsetEffDic[EffectDefine.LW_Effect_Id_50065] or 0
  baseHealthVal = baseHealthVal + baseHealthOffset
  local healthPercentTitle = "soldier_eleven_hero_life_02"
  local healthAddEffectVal = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_Effect_Id_50076) + 1
  local healthAddEffectOffset = offsetEffDic and offsetEffDic[EffectDefine.LW_Effect_Id_50076] or 0
  healthAddEffectVal = healthAddEffectVal + healthAddEffectOffset
  local descHealth, healthAddPercent = WorkerUtil.GetEffectText(EffectDefine.LW_Effect_Id_50076, healthAddEffectVal, true)
  local healthMaxHeroTitle = "soldier_eleven_hero_life_03"
  local healthResult = baseHealthVal * healthAddEffectVal * maxHeroSoldier
  local healthResultInfo = {
    title = "soldier_eleven_hero_life_04",
    value = string.GetFormattedStr(healthResult),
    numVal = healthResult
  }
  if getType == T11PowerInfoGetType.All then
    health = {}
    table.insert(health, {title = baseHealthTitle, value = baseHealthVal})
    table.insert(health, {title = healthPercentTitle, value = healthAddPercent})
    table.insert(health, {title = healthMaxHeroTitle, value = maxHeroSoldier})
    table.insert(health, healthResultInfo)
  elseif getType == T11PowerInfoGetType.ResultVal then
    table.insert(ret, healthResultInfo)
  elseif getType == T11PowerInfoGetType.BaseVal then
    table.insert(ret, {title = baseHealthTitle, numVal = baseHealthVal})
  end
  local baseMoraleTitle = "soldier_eleven_hero_morale_01"
  local baseMoraleVal = soldierInfo[EffectDefine.LW_Effect_Id_50160] or 0
  local baseMoraleOffset = offsetEffDic and offsetEffDic[EffectDefine.LW_Effect_Id_50160] or 0
  baseMoraleVal = baseMoraleVal + baseMoraleOffset
  local moralePercentTitle = "soldier_eleven_hero_morale_02"
  local moraleAddEffectVal = 1 + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_Effect_Id_50080)
  local moraleAddEffectOffset = offsetEffDic and offsetEffDic[EffectDefine.LW_Effect_Id_50080] or 0
  moraleAddEffectVal = moraleAddEffectVal + moraleAddEffectOffset
  local descMorale, moraleAddPercent = WorkerUtil.GetEffectText(EffectDefine.LW_Effect_Id_50080, moraleAddEffectVal, true)
  local moraleMaxHeroTitle = "soldier_eleven_hero_morale_03"
  local moraleMaxArmySolderCapacity = T11Util.GetMaxArmySolderCapacity()
  local moraleResult = baseMoraleVal * moraleAddEffectVal * moraleMaxArmySolderCapacity
  local moraleResultInfo = {
    title = "soldier_eleven_hero_morale_04",
    value = string.GetFormattedStr(moraleResult),
    numVal = moraleResult
  }
  if getType == T11PowerInfoGetType.All then
    morale = {}
    table.insert(morale, {title = baseMoraleTitle, value = baseMoraleVal})
    table.insert(morale, {title = moralePercentTitle, value = moraleAddPercent})
    table.insert(morale, {
      title = moraleMaxHeroTitle,
      value = string.GetFormattedStr(moraleMaxArmySolderCapacity)
    })
    table.insert(morale, moraleResultInfo)
  elseif getType == T11PowerInfoGetType.ResultVal then
    table.insert(ret, moraleResultInfo)
  elseif getType == T11PowerInfoGetType.BaseVal then
    table.insert(ret, {title = baseMoraleTitle, numVal = baseMoraleVal})
  end
  if getType == T11PowerInfoGetType.All then
    table.insert(ret, attack)
    table.insert(ret, defence)
    table.insert(ret, health)
    table.insert(ret, morale)
  end
  return ret
end

function T11Util.GetMaxHeroSoldierCapacity()
  local allHero = DataCenter.HeroDataManager:GetAllHeroList()
  local maxNum = 0
  for _, hero in pairs(allHero) do
    local soldierCapacity = 0
    if hero then
      soldierCapacity = hero:GetSoldierCapacity()
      if maxNum < soldierCapacity then
        maxNum = soldierCapacity
      end
    end
  end
  return maxNum
end

function T11Util.GetMaxArmySolderCapacity()
  local maxArmySoldierCapacity = 0
  local allArmy = DataCenter.ArmyFormationDataManager:GetCurFormationList()
  for _, army in pairs(allArmy) do
    if army then
      local heroes = army.heroes
      local eachArmyTotalSoldierCapacity = 0
      for uuid, index in pairs(heroes) do
        eachArmyTotalSoldierCapacity = eachArmyTotalSoldierCapacity + DataCenter.HeroDataManager:GetHeroByUuid(uuid):GetSoldierCapacity()
      end
      if army.dominatorUuid then
        local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(army.dominatorUuid)
        if dominatorInfo then
          eachArmyTotalSoldierCapacity = eachArmyTotalSoldierCapacity + dominatorInfo:GetSoldierCapacity()
        end
      end
      if maxArmySoldierCapacity < eachArmyTotalSoldierCapacity then
        maxArmySoldierCapacity = eachArmyTotalSoldierCapacity
      end
    end
  end
  return maxArmySoldierCapacity
end

function T11Util.GetSelfCurSoldierData()
  local elevenData = {}
  elevenData.stage = T11Util.GetCurStage()
  elevenData.type = T11Util.GetCurT11SoldierType()
  return elevenData
end

function T11Util.GetSoldierBubblePath()
  local curStage = T11Util.GetCurStage()
  local soldierType = T11Util.GetCurT11SoldierType()
  local soldierData = T11Util.GetT11SoldierDataByStageAndType(curStage, soldierType)
  if not soldierData then
    Logger.LogError("T11Util.GetSoldierBubblePath soldierData is nil for stage:" .. curStage .. " soldierType:" .. soldierType)
    return ""
  end
  return soldierData.bubbleIcon or ""
end

function T11Util.GetEffectByStageAndType()
  local effect
  if not T11Util.IsUnlockT11() then
    return effect
  end
  local stageData = T11Util.GetT11LvData().stageData
  if not stageData then
    Logger.LogError("T11Util.GetNextStageUpgradeCostData stageData is nil")
    return effect
  end
  local soldierType = T11Util.GetCurT11SoldierType()
  if not soldierType then
    Logger.LogError("T11Util.GetEffectByStageAndType soldierType is nil")
    return effect
  end
  if soldierType == T11SoldierType.T11SoldierTypeA then
    effect = stageData.curStageTmp and stageData.curStageTmp.effect_a
  elseif soldierType == T11SoldierType.T11SoldierTypeB then
    effect = stageData.curStageTmp and stageData.curStageTmp.effect_b
  end
  return effect
end

function T11Util.GetAttributePower(rate)
  rate = rate or 1
  local t11Power = 0
  local t11EffectMap = T11Util.GetEffectByStageAndType()
  if not table.IsNullOrEmpty(t11EffectMap) then
    for key, val in pairs(t11EffectMap) do
      local attributeId = tonumber(key)
      local attributeValue = tonumber(val)
      local attributePower = GetTableData(TableName.LW_Effect_Number, attributeId, "power")
      local effectValue = math.floor(attributeValue * attributePower * rate)
      t11Power = t11Power + effectValue
    end
  end
  return t11Power
end

function T11Util.IfHasUnLockCamp()
  local result = false
  local t11SoldierTemplate = DataCenter.SoldierDataManager:GetSoldierTemplateByLevel(Const.SoldierLevel)
  if not t11SoldierTemplate then
    return true
  end
  local campRequiredLevel = t11SoldierTemplate.train_need_barrack and tonumber(t11SoldierTemplate.train_need_barrack) or 0
  local list = DataCenter.BuildManager:GetFunbuildListByItemID(BuildingTypes.LW_BUILD_MILITARY_CAMP)
  for _, v in pairs(list) do
    if v and v.level and campRequiredLevel <= v.level then
      result = true
      break
    end
  end
  return result
end

return ConstClass("T11Util", T11Util)
