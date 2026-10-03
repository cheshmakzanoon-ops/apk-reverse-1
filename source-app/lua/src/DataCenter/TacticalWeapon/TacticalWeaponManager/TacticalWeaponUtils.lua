local TacticalWeaponUtils = BaseClass("TacticalWeaponUtils")
local ArmyFormationUtils = require("DataCenter.ArmyFormationData.ArmyFormationUtils")
local Localization = CS.GameEntry.Localization

function TacticalWeaponUtils.GetEffectTips(holder, effectId, containsSymbol)
  if not holder or not effectId then
    return ""
  end
  local descId = DataCenter.EffectNumberTemplateManager:GetEffectNumberDesc(effectId)
  if holder then
    if effectId == HeroEffectDefine.TacticalWeaponAll_Ratio then
      local _50081 = holder:GetProperty(50081)
      local _50087 = holder:GetProperty(50087)
      local _50090 = holder:GetProperty(50090)
      local _50091 = holder:GetProperty(50091) / 10000
      local _50094 = holder:GetProperty(50094)
      local _50084 = _50081 * (1 + _50087) * (_50090 + _50091) + _50094
      local hp = HeroUtils.GetFormattedPropertyValue(HeroEffectDefine.TacticalWeaponHp_Result, _50084, containsSymbol)
      local _50082 = holder:GetProperty(50082)
      local _50088 = holder:GetProperty(50088)
      local _50092 = holder:GetProperty(50092) / 10000
      local _50095 = holder:GetProperty(50095)
      local _50085 = _50082 * (1 + _50088) * (_50090 + _50092) + _50095
      local atk = HeroUtils.GetFormattedPropertyValue(HeroEffectDefine.TacticalWeaponAtk_Result, _50085, containsSymbol)
      local _50083 = holder:GetProperty(50083)
      local _50089 = holder:GetProperty(50089)
      local _50093 = holder:GetProperty(50093) / 10000
      local _50096 = holder:GetProperty(50096)
      local _50086 = _50083 * (1 + _50089) * (_50090 + _50093) + _50096
      local def = HeroUtils.GetFormattedPropertyValue(HeroEffectDefine.TacticalWeaponDef_Result, _50086, containsSymbol)
      local arr = {
        hp,
        atk,
        def
      }
      return Localization:GetString(descId, SafeUnpack(arr))
    elseif effectId == HeroEffectDefine.TacticalWeaponHp_Ratio then
      local _50081 = holder:GetProperty(50081)
      local _50087 = holder:GetProperty(50087)
      local _50090 = holder:GetProperty(50090)
      local _50091 = holder:GetProperty(50091) / 10000
      local _50084 = _50081 * (1 + _50087) * (_50090 + _50091)
      local hp = HeroUtils.GetFormattedPropertyValue(HeroEffectDefine.TacticalWeaponHp_Result, _50084, containsSymbol)
      return Localization:GetString(descId, hp)
    elseif effectId == HeroEffectDefine.TacticalWeaponAtk_Ratio then
      local _50090 = holder:GetProperty(50090)
      local _50082 = holder:GetProperty(50082)
      local _50088 = holder:GetProperty(50088)
      local _50092 = holder:GetProperty(50092) / 10000
      local _50085 = _50082 * (1 + _50088) * (_50090 + _50092)
      local atk = HeroUtils.GetFormattedPropertyValue(HeroEffectDefine.TacticalWeaponAtk_Result, _50085, containsSymbol)
      return Localization:GetString(descId, atk)
    elseif effectId == HeroEffectDefine.TacticalWeaponDef_Ratio then
      local _50090 = holder:GetProperty(50090)
      local _50083 = holder:GetProperty(50083)
      local _50089 = holder:GetProperty(50089)
      local _50093 = holder:GetProperty(50093) / 10000
      local _50086 = _50083 * (1 + _50089) * (_50090 + _50093)
      local def = HeroUtils.GetFormattedPropertyValue(HeroEffectDefine.TacticalWeaponDef_Result, _50086, containsSymbol)
      return Localization:GetString(descId, def)
    elseif effectId == TacticalWeaponUtils.ShowEffectId.HpRate then
      local percent = holder:GetProperty(effectId) * 1.0E-4
      local value = holder:GetProperty(TacticalWeaponUtils.ShowEffectId.HpBase) * percent
      local result = HeroUtils.GetFormattedPropertyValue(HeroEffectDefine.TacticalWeaponHp_Result, value, containsSymbol)
      return Localization:GetString(descId, result)
    elseif effectId == TacticalWeaponUtils.ShowEffectId.AttackRate then
      local percent = holder:GetProperty(effectId) * 1.0E-4
      local value = holder:GetProperty(TacticalWeaponUtils.ShowEffectId.AttackBase) * percent
      local result = HeroUtils.GetFormattedPropertyValue(HeroEffectDefine.TacticalWeaponAtk_Result, value, containsSymbol)
      return Localization:GetString(descId, result)
    elseif effectId == TacticalWeaponUtils.ShowEffectId.DefendRate then
      local percent = holder:GetProperty(effectId) * 1.0E-4
      local value = holder:GetProperty(TacticalWeaponUtils.ShowEffectId.DefendBase) * percent
      local result = HeroUtils.GetFormattedPropertyValue(HeroEffectDefine.TacticalWeaponDef_Result, value, containsSymbol)
      return Localization:GetString(descId, result)
    end
  end
  if descId then
    return Localization:GetString(descId)
  end
  return ""
end

function TacticalWeaponUtils.GetSkillChipTypeIcon(type)
  if 1 <= type and type <= 4 then
    return string.format("Assets/Main/Sprites/UI/LWUITacticalWeaponChipCommon/lrb_wurenji_zhujiemian_jiaobiao0%d.png", type)
  end
  return ""
end

function TacticalWeaponUtils.GetSkillChipTypeText(type)
  return Localization:GetString(string.format("drone_skillChip_Type_%d", type))
end

function TacticalWeaponUtils.ShowSkillChipExpLackWindow()
  LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.TWSkillChipExp, 1)
end

function TacticalWeaponUtils.ShowSkillChipLackWindow(chipId, need)
  LWResourceLackUtil:GotoSpecialResLackTacticalChip(ResLackContextType.TWSkillChip, need or 1, chipId)
end

function TacticalWeaponUtils.GetHighestPowerFreeChip(type, heroType)
  local chips = DataCenter.TWSkillChipManager:GetChipsByType(type)
  if chips == nil then
    return nil
  end
  local highestPowerChip
  for _, v in pairs(chips) do
    if (not heroType or heroType == HeroType.None or heroType == HeroType.All or v:GetHeroType() == heroType) and v:IsFree() then
      if highestPowerChip == nil then
        highestPowerChip = v
      elseif highestPowerChip:GetPower() < v:GetPower() then
        highestPowerChip = v
      end
    end
  end
  return highestPowerChip
end

function TacticalWeaponUtils.GetChipUseableCount(chipInfo)
  if chipInfo == nil then
    return 0
  end
  local chipId = chipInfo:GetId()
  local chipType = chipInfo:GetType()
  local chips = DataCenter.TWSkillChipManager:GetChipsByType(chipType)
  local count = 0
  for _, v in pairs(chips) do
    if v:GetId() == chipId and not (v:GetLevel() > 1) and not (0 < v:GetStar()) and v:IsFree() then
      count = count + v:GetNum()
    end
  end
  return count
end

function TacticalWeaponUtils.SkillChipCanStarUp(chipInfo)
  if not chipInfo.template then
    return false
  end
  if chipInfo:IsMaxStar() then
    return false
  end
  local commonFragId, fragId, costNum = chipInfo:GetStarUpCost()
  if commonFragId == nil or fragId == nil or costNum == nil then
    return false
  end
  local count = TacticalWeaponUtils.GetChipUseableCount(chipInfo)
  if costNum <= count then
    return true
  end
  return false
end

function TacticalWeaponUtils.GetFreeExpNum()
  local expItems = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_135)
  local expCount = 0
  if not table.IsNullOrEmpty(expItems) then
    for _, v in pairs(expItems) do
      expCount = expCount + v.para1 * v.count
    end
  end
  return expCount
end

function TacticalWeaponUtils.SkillChipCanLvUp(chipInfo)
  if not chipInfo.template then
    return false
  end
  if chipInfo:IsMaxLevel() then
    return false
  end
  local expId = chipInfo:GetExpId()
  local expNum = TacticalWeaponUtils.GetFreeExpNum()
  local needExp = DataCenter.TWSkillChipTemplateManager:GetNeedExpByTypeAndLevel(expId, chipInfo:GetLevel())
  if needExp == nil then
    return false
  end
  if expNum >= needExp then
    return true
  end
  return false
end

function TacticalWeaponUtils.SkillChipCanReplace(chipInfo)
  if not chipInfo then
    return false
  end
  local highestPowerChip = TacticalWeaponUtils.GetHighestPowerFreeChip(chipInfo:GetType(), chipInfo:GetHeroType())
  if highestPowerChip and highestPowerChip:GetPower() > chipInfo:GetPower() then
    return true, highestPowerChip
  end
  return false
end

TacticalWeaponUtils.ShowEffects = {
  50098,
  50099,
  50100,
  50244,
  50245,
  50246
}
TacticalWeaponUtils.ShowEffectId = {
  HpBase = 50098,
  AttackBase = 50099,
  DefendBase = 50100,
  HpRate = 50244,
  AttackRate = 50245,
  DefendRate = 50246,
  HpHero = 50094,
  AttackHero = 50095,
  DefendHero = 50096
}

function TacticalWeaponUtils.GetNextLevelAttrs(weaponInfo)
  if not weaponInfo then
    return {}
  end
  if not weaponInfo:GetRealTemplate() or not weaponInfo.propertyData then
    return {}
  end
  if weaponInfo:IsReachMaxLevel() then
    return {}
  end
  local attrs = {}
  attrs = weaponInfo.propertyData:GetAllProperty() or {}
  local baseLevelAttrs = {
    50081,
    50082,
    50083
  }
  local resultAttrs = {
    50098,
    50099,
    50100
  }
  local ratioAttrs = {
    50087,
    50088,
    50089
  }
  local levelAttrsDiff = {
    [50081] = 0,
    [50082] = 0,
    [50083] = 0
  }
  local levelTransferPercentIdMap = {
    [50091] = 50244,
    [50092] = 50245,
    [50093] = 50246
  }
  local nextLevelTemplate = weaponInfo:GetNextRealTemplate(weaponInfo.level)
  if nextLevelTemplate then
    local nextLevelProperties = nextLevelTemplate:GetAttrs(0)
    local curLevelProperties = weaponInfo:GetRealTemplate():GetAttrs(0)
    
    local function GetAttrValue(arr, id)
      for i = 1, #arr do
        local attr = arr[i]
        if attr.id == id then
          return attr.value
        end
      end
      return nil
    end
    
    for i = 1, #nextLevelProperties do
      local id = nextLevelProperties[i].id
      if not levelAttrsDiff[id] then
        attrs[id] = nextLevelProperties[i].value
      else
        local nextValue = GetAttrValue(nextLevelProperties, id)
        local curValue = GetAttrValue(curLevelProperties, id)
        levelAttrsDiff[id] = levelAttrsDiff[id] + (nextValue - curValue)
        attrs[id] = attrs[id] + levelAttrsDiff[id]
      end
    end
    for templateEffectId, v in pairs(levelTransferPercentIdMap) do
      local curServerValueId = levelTransferPercentIdMap[templateEffectId]
      local nextValue = GetAttrValue(nextLevelProperties, templateEffectId) or 0
      local curValue = GetAttrValue(curLevelProperties, templateEffectId) or 0
      local curSeverValue = attrs[curServerValueId] or 0
      attrs[curServerValueId] = curSeverValue + nextValue - curValue
    end
  end
  for i = 1, #resultAttrs do
    local id = resultAttrs[i]
    local ratioId = ratioAttrs[i]
    local ratio = weaponInfo.propertyData:GetProperty(ratioId) or 0
    attrs[id] = (attrs[id] or 0) + levelAttrsDiff[baseLevelAttrs[i]] * (1 + ratio)
  end
  return attrs
end

TacticalWeaponUtils.PowerAttrs = {
  50081,
  50082,
  50083
}

function TacticalWeaponUtils.CreateNextLevelTemplate(weaponInfo)
  if not weaponInfo then
    return nil
  end
  local nextLevelWeaponInfo = DeepCopy(weaponInfo)
  if weaponInfo:IsReachMaxLevel() then
    return nextLevelWeaponInfo
  end
  local nextLevelAttrs = TacticalWeaponUtils.GetNextLevelAttrs(weaponInfo)
  nextLevelWeaponInfo:UpdateProperty(nextLevelAttrs)
  local power = weaponInfo.power
  for i = 1, #TacticalWeaponUtils.PowerAttrs do
    local id = TacticalWeaponUtils.PowerAttrs[i]
    local diff = nextLevelAttrs[id] or 0 - weaponInfo:GetProperty(id) or 0
    power = power + diff * DataCenter.EffectNumberTemplateManager:GetEffectNumberPower(id)
  end
  nextLevelWeaponInfo.progress = 0
  nextLevelWeaponInfo:CalculateLevel()
  local prevSkillInfos = weaponInfo:GetSkillInfos()
  local nextSkillInfos = nextLevelWeaponInfo:GetSkillInfos()
  local prevSkillInfoPower = 0
  local nextSkillInfoPower = 0
  for i = 1, #prevSkillInfos do
    prevSkillInfoPower = prevSkillInfoPower + prevSkillInfos[i]:GetPower()
  end
  for i = 1, #nextSkillInfos do
    nextSkillInfoPower = nextSkillInfoPower + nextSkillInfos[i]:GetPower()
  end
  power = power + (nextSkillInfoPower + prevSkillInfoPower)
  nextLevelWeaponInfo.power = power
  return nextLevelWeaponInfo
end

function TacticalWeaponUtils.GetUsingFormationByTypeAndSet(type, setId)
  for i = 1, 4 do
    local formationData = ArmyFormationUtils.GetArmyFormationData(type, i)
    if formationData then
      local useSetId = formationData:GetLocalTWSkillChipSetId()
      if useSetId == setId then
        return i
      end
    end
  end
  return 0
end

function TacticalWeaponUtils.GetFormationSets(type, squadData)
  local map = {}
  if type ~= FormationDataType.None then
    for i = 1, 4 do
      local formationData = ArmyFormationUtils.GetArmyFormationDataByEnterWay(type, i)
      if formationData then
        local setId = formationData:GetLocalTWSkillChipSetId()
        map[setId] = {formationId = i, id = setId}
      end
    end
  elseif squadData then
    local useSetId = squadData:GetLocalTWSkillChipSetId()
    map[useSetId] = {
      formationId = squadData.index,
      id = useSetId
    }
  end
  for i = 1, 4 do
    if not map[i] then
      map[i] = {formationId = 0, id = i}
    end
    map[i].unlock = DataCenter.TacticalChipManager:IsPlanUnlock(i)
  end
  return map
end

function TacticalWeaponUtils:TryUnlockChipSet()
  local tounlockSetId = DataCenter.TWSkillChipManager:GetNextUnlockSetId()
  if not tounlockSetId then
    return
  end
  local cost = DataCenter.TWSkillChipManager:GetUnlockSetCost(tounlockSetId - 1)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipSetUnlock, {anim = true}, Localization:GetString("uav_chips_title5"), Localization:GetString("uav_chips_desc12"), Localization:GetString("uav_chips_desc13"), cost, function()
    if LuaEntry.Player.gold < cost then
      GoToUtil.GotoPayTips(cost)
      return
    end
    SFSNetwork.SendMessage(MsgDefines.TWSkillChipSetUnlock, tounlockSetId)
  end)
end

function TacticalWeaponUtils:SetSquadUseSet(source, squadData, idx, refreshCallBack)
  if not source then
    return
  end
  if not squadData then
    return
  end
  if not idx then
    return
  end
  if not DataCenter.TWSkillChipManager:IsFunctionUnlock() then
    return
  end
  if not DataCenter.TacticalChipManager:IsPlanUnlock(idx) then
    UIUtil.ShowTipsId("battlesystem_tips1")
    return
  end
  if not squadData:IsFree() then
    UIUtil.ShowTipsId("drone_skillChip_title_11")
    return
  end
  local formationDataType = ArmyFormationUtils.GetDataTypeByEnterWay(source)
  if formationDataType and ArmyFormationUtils.ExclusiveFormationTypes[formationDataType] then
    local prevUsingChipSetId = squadData:GetLocalTWSkillChipSetId()
    local usingFormation = TacticalWeaponUtils.GetUsingFormationByTypeAndSet(formationDataType, idx)
    local checkIdx = squadData.index
    if formationDataType == FormationDataType.ChampionDuel then
      checkIdx = DataCenter.ChampionDuelManager:GetSelfTeamOrderByIndex(squadData.index)
    end
    if usingFormation == checkIdx then
      return
    elseif usingFormation and 0 < usingFormation then
      do
        local otherSquadData = ArmyFormationUtils.GetArmyFormationData(formationDataType, usingFormation)
        if not otherSquadData then
          return
        end
        if not otherSquadData:IsFree() then
          UIUtil.ShowTipsId("drone_skillChip_title_11")
          return
        end
        UIUtil.ShowMessage(Localization:GetString("drone_skillChip_title_10", idx, usingFormation), 1, "110006", nil, function()
          squadData:SetLocalTWSkillChipSetId(idx)
          if refreshCallBack then
            refreshCallBack()
          end
          if formationDataType == FormationDataType.Formation3V3Def or formationDataType == FormationDataType.Formation3V3Atk or formationDataType == FormationDataType.TruckDeparture or formationDataType == FormationDataType.TruckRob or formationDataType == FormationDataType.KOFDefence or formationDataType == FormationDataType.KOFAttack or formationDataType == FormationDataType.ChampionDuel then
            otherSquadData:SetLocalTWSkillChipSetId(prevUsingChipSetId)
          elseif formationDataType == FormationDataType.ArmyFormation then
            local curHeroes = otherSquadData:GenerateServerHeroArray()
            SFSNetwork.SendMessage(MsgDefines.NormalFormationInfoSave, otherSquadData.uuid, curHeroes, 0, prevUsingChipSetId)
          end
        end, nil, nil)
        return
      end
    end
  end
  squadData:SetLocalTWSkillChipSetId(idx)
  if refreshCallBack then
    refreshCallBack()
  end
end

function TacticalWeaponUtils.GetQuickEquipOptions(setId)
  local quickEquipOptions = {}
  local skillChips = DataCenter.TWSkillChipManager:GetChipsByMasterSet(setId)
  for i = 1, SetSkillChipCount do
    local chipInfo
    if skillChips then
      chipInfo = skillChips[i]
    end
    local highestPowerFreeChip = TacticalWeaponUtils.GetHighestPowerFreeChip(i)
    if highestPowerFreeChip then
      if chipInfo == nil then
        quickEquipOptions[i] = highestPowerFreeChip.uuid
      elseif chipInfo and chipInfo:GetPower() < highestPowerFreeChip:GetPower() then
        quickEquipOptions[i] = highestPowerFreeChip.uuid
      end
    end
  end
  return quickEquipOptions
end

function TacticalWeaponUtils.GuarantBoxShowRedPoint()
  local skillChipManager = DataCenter.TWSkillChipManager
  local guaranttedBoxData = skillChipManager:GetGuaranteedBoxData()
  if not guaranttedBoxData then
    return false
  end
  local pointId = guaranttedBoxData.point_goods
  if pointId == 0 then
    return false
  end
  local havePointCount = DataCenter.ItemData:GetItemCount(pointId)
  local needPointCount = guaranttedBoxData.target_point
  if havePointCount >= needPointCount then
    return true
  end
  local groupItems = guaranttedBoxData.list_goods
  for _, data in pairs(groupItems) do
    local haveCount = DataCenter.ItemData:GetItemCount(data.id)
    if 0 < haveCount then
      return true
    end
  end
  return false
end

function TacticalWeaponUtils.ChipSetShowRedPoint(setId)
  local skillChipManager = DataCenter.TWSkillChipManager
  if not DataCenter.TacticalChipManager:IsPlanUnlock(setId) then
    return false
  end
  local chips = skillChipManager:GetChipsByMasterSet(setId)
  if not chips then
    return false
  end
  for i = 1, SetSkillChipCount do
    local v = chips[i]
    if v then
      if TacticalWeaponUtils.SkillChipCanReplace(v) or TacticalWeaponUtils.SkillChipCanStarUp(v) or TacticalWeaponUtils.SkillChipCanLvUp(v) then
        return true
      end
    else
      local hasFreeChip = TacticalWeaponUtils.GetHighestPowerFreeChip(i)
      if hasFreeChip then
        return true
      end
    end
  end
  return false
end

function TacticalWeaponUtils.ChipBubbleShowRedPoint()
  if not DataCenter.TacticalChipManager:IsFunctionChipPlanTabShow() then
    return false
  end
  if TacticalWeaponUtils.GuarantBoxShowRedPoint() then
    return true
  end
  if TacticalWeaponUtils.IsChipPlanSetRedPoint() then
    return true
  end
  return false
end

function TacticalWeaponUtils.CheckChipMainSystemFunctionRedPoint()
  if not DataCenter.TacticalChipManager:IsFunctionTabShow() then
    return false
  end
  local unlockTime = DataCenter.TWSkillChipManager:GetChipOpenTime()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if unlockTime > curTime then
    return false
  end
  if not DataCenter.TacticalChipManager:IsFunctionOpen() then
    return true
  end
  if TacticalWeaponUtils.GuarantBoxShowRedPoint() then
    return true
  end
  if DataCenter.TacticalChipManager:CheckCanUpgrade() then
    return true
  end
  return false
end

function TacticalWeaponUtils.CheckChipPlanFunctionRedPoint()
  if not DataCenter.TacticalChipManager:IsFunctionChipPlanTabShow() then
    return false
  end
  if TacticalWeaponUtils.GuarantBoxShowRedPoint() then
    return true
  end
  if TacticalWeaponUtils.IsChipPlanSetRedPoint() then
    return true
  end
  return false
end

function TacticalWeaponUtils.IsChipPlanSetRedPoint()
  for i = 1, SkillChipSetCount do
    if TacticalWeaponUtils.ChipSetShowRedPoint(i) then
      return true
    end
  end
  return false
end

function TacticalWeaponUtils.GetFreeChipsByType(skillType)
  local result = {}
  local list = DataCenter.TWSkillChipManager:GetChipsByType(skillType)
  if list then
    for i, v in pairs(list) do
      if v and v:IsFree() then
        table.insert(result, v)
      end
    end
  end
  return result
end

function TacticalWeaponUtils.ConvertSkillInfoServerToLocal(skillInfos)
  local skillInfoList = {}
  for i, skillPair in pairs(skillInfos) do
    if skillPair then
      local skillId = skillPair.skillId
      local skillLv = skillPair.skillLv
      local skillInfo = SkillInfo.New()
      skillInfo:CreateFromTemplate(skillId, true, skillLv)
      table.insert(skillInfoList, skillInfo)
    end
  end
  return skillInfoList
end

return TacticalWeaponUtils
