local SoldierDataManager = BaseClass("SoldierDataManager")

function SoldierDataManager:__init()
  self.soldiers = {}
  self.soldierLevelMap = {}
  self.mummyLevelMap = {}
  self:InitAllTemplate()
end

function SoldierDataManager:__delete()
  self.soldiers = nil
  self.soldierLevelMap = nil
  self.mummyLevelMap = nil
end

function SoldierDataManager:InitAllTemplate()
  self.soldiers = {}
  self.soldierLevelMap = {}
  self.mummyLevelMap = {}
  LocalController:instance():visitTable(TableName.LW_Soldier, function(id, lineData)
    if lineData ~= nil then
      local item = SoldierDataTemplate.New()
      item:InitConfig(lineData)
      if item.id ~= nil then
        self.soldiers[item.id] = item
        if item.type == SoldierType.Player then
          self.soldierLevelMap[item.lv] = item
        elseif item.type == SoldierType.Mummy then
          self.mummyLevelMap[item.lv] = item
        end
      end
    end
  end)
end

function SoldierDataManager:GetTemplate(id)
  return self.soldiers[toInt(id)]
end

function SoldierDataManager:CleanDragonSoldier(excUuid)
  local ridMgr = DataCenter.ResourceItemDataManager
  for _, v in pairs(self.soldiers) do
    if v.type == SoldierType.Dragon then
      local list = ridMgr:GetItemUuidsByItemId(v.resourceItemId)
      for _, uuid in pairs(list) do
        if uuid ~= excUuid then
          ridMgr:RemoveItemByUuid(uuid)
        end
      end
    end
  end
end

function SoldierDataManager:GetDragonSoldierInfo()
  local soliderUuid = BattleFieldUtil.soliderUuid
  if soliderUuid ~= nil then
    local resourceItemData = DataCenter.ResourceItemDataManager:GetItemDataByUuid(soliderUuid)
    if resourceItemData ~= nil and resourceItemData.number > 0 then
      local soldier
      for _, v in pairs(self.soldiers) do
        if v.resourceItemId == resourceItemData.itemId then
          soldier = v
          break
        end
      end
      if soldier ~= nil then
        return {
          id = soldier.id,
          lv = soldier.lv,
          count = resourceItemData.number
        }
      end
    end
  end
  local infos = self:GetPlayerSoldiers()
  return infos[1]
end

function SoldierDataManager:GetPlayerSoldiers(theSoldierType)
  local playerSoldiers = {}
  local bInBattleField = BattleFieldUtil.InBattleField()
  for _, v in pairs(self.soldiers) do
    if v.resourceItemId ~= 0 then
      local canUse = false
      if bInBattleField then
        if v.type == SoldierType.Dragon then
          canUse = true
        end
      elseif v.type ~= SoldierType.Dragon and (theSoldierType == nil and v.type == SoldierType.Player or v.type == theSoldierType) then
        canUse = true
      end
      if canUse then
        local resourceItemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(v.resourceItemId)
        if resourceItemData ~= nil and 0 < resourceItemData.number then
          local soldier = {}
          soldier.id = v.id
          soldier.lv = v.lv
          soldier.count = resourceItemData.number
          if T11Util.IsSuperSoldier(soldier.lv) then
            soldier.t11Type = T11Util.GetCurT11SoldierType()
          end
          table.insert(playerSoldiers, soldier)
        end
      end
    end
  end
  return playerSoldiers
end

function SoldierDataManager:GetOutsideSoldiers(theSoldierType)
  local playerSoldiers = {}
  local bInBattleField = BattleFieldUtil.InBattleField()
  for _, v in pairs(self.soldiers) do
    local canUse = false
    if bInBattleField then
      if v.type == SoldierType.Dragon then
        canUse = true
      end
    elseif v.type ~= SoldierType.Dragon and (theSoldierType == nil and v.type == SoldierType.Player or v.type == theSoldierType) then
      canUse = true
    end
    if canUse then
      local number = LuaEntry.Effect:GetGameEffect(tonumber(v.effect))
      if 0 < number then
        local soldier = {}
        soldier.id = v.id
        soldier.lv = v.lv
        soldier.count = number
        if T11Util.IsSuperSoldier(soldier.lv) then
          soldier.t11Type = T11Util.GetCurT11SoldierType()
        end
        table.insert(playerSoldiers, soldier)
      end
    end
  end
  return playerSoldiers
end

function SoldierDataManager:GetInsideSoldiers(theSoldierType)
  local soldiers = self:GetPlayerSoldiers(theSoldierType)
  local outsides = self:GetOutsideSoldiers(theSoldierType)
  for i = 1, #outsides do
    for j = #soldiers, 1, -1 do
      if soldiers[j].id == outsides[i].id then
        soldiers[j].count = soldiers[j].count - outsides[i].count
      end
      if soldiers[j].count == 0 then
        table.remove(soldiers, j)
      end
    end
  end
  return soldiers
end

function SoldierDataManager:GetPlayerSoldiersTotalSupply(theSoldierType)
  local playerSoldiers = self:GetPlayerSoldiers(theSoldierType)
  local ret = 0
  for k, v in pairs(playerSoldiers) do
    local hp = self.soldiers[v.id].restoreHp
    ret = ret + hp * v.count
  end
  return toInt(ret)
end

function SoldierDataManager:GetPlayerSoldiersTotalNum(theSoldierType, theSoldierId)
  local playerSoldiers = self:GetPlayerSoldiers(theSoldierType)
  local ret = 0
  for k, v in pairs(playerSoldiers) do
    if theSoldierId == nil or v.id == theSoldierId then
      ret = ret + v.count
    end
  end
  return toInt(ret)
end

function SoldierDataManager:GetInsideSoldiersTotalNum(theSoldierType, theSoldierId)
  local playerSoldiers = self:GetInsideSoldiers(theSoldierType)
  local ret = 0
  for k, v in pairs(playerSoldiers) do
    if theSoldierId == nil or v.id == theSoldierId then
      ret = ret + v.count
    end
  end
  return toInt(ret)
end

function SoldierDataManager:GetAllSoldiers(theSoldierType)
  local allSoldiers = {}
  if theSoldierType == nil then
    theSoldierType = SoldierType.Player
  end
  for k, v in pairs(self.soldiers) do
    if v.type == theSoldierType and v.resourceItemId ~= 0 then
      local resourceItemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(v.resourceItemId)
      if resourceItemData ~= nil then
        local soldier = {}
        soldier.id = v.id
        soldier.level = v.lv
        soldier.count = resourceItemData.number
        allSoldiers[soldier.id] = soldier
      else
        local soldier = {}
        soldier.id = v.id
        soldier.count = 0
        soldier.level = v.lv
        allSoldiers[soldier.id] = soldier
      end
    end
  end
  return allSoldiers
end

function SoldierDataManager:GetSoldierTemplateByLevel(level, theSoldierType)
  if theSoldierType == nil or theSoldierType == SoldierType.Player then
    return self.soldierLevelMap[level]
  end
  if theSoldierType == SoldierType.Mummy then
    return self.mummyLevelMap[level]
  end
  return nil
end

function SoldierDataManager:GetSoldierLevelById(id)
  local soldier = self:GetTemplate(id)
  if soldier ~= nil then
    return soldier.lv
  end
  return 0
end

function SoldierDataManager:GetSoldierIdByLevel(level, theSoldierType)
  local soldier = self:GetSoldierTemplateByLevel(level, theSoldierType)
  if soldier ~= nil then
    return soldier.id
  end
  return 0
end

function SoldierDataManager:GetMummyLevelMap()
  return self.mummyLevelMap
end

function SoldierDataManager:GetSoldierLevelMap()
  return self.soldierLevelMap
end

function SoldierDataManager:GetCanTrainHighestLevelSoldier()
  local soldierLevelMap = self:GetSoldierLevelMap()
  local sortedSoldierMap = {}
  for k, v in pairs(soldierLevelMap) do
    table.insert(sortedSoldierMap, v)
  end
  table.sort(sortedSoldierMap, function(a, b)
    return a.lv < b.lv
  end)
  local buildings = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_MILITARY_CAMP)
  local highestBuildingLevel = 0
  for k, v in pairs(buildings) do
    if highestBuildingLevel < v.level then
      highestBuildingLevel = v.level
    end
  end
  if highestBuildingLevel == 0 then
    return nil
  end
  for i = #sortedSoldierMap, 1, -1 do
    local soldier = sortedSoldierMap[i]
    local scienceTemplate, id, scienceData
    if soldier ~= nil then
      local canTrain = true
      local levelNumber = soldier.train_need_barrack
      levelNumber = levelNumber and tonumber(levelNumber)
      if levelNumber and highestBuildingLevel < levelNumber then
        canTrain = false
      else
        if not string.IsNullOrEmpty(soldier.train_need_science) then
          scienceTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(soldier.train_need_science)
          if scienceTemplate then
            id = scienceTemplate.science_id
            scienceData = DataCenter.ScienceDataManager:GetScienceById(id)
            if not scienceData or not (0 < scienceData.level) then
              canTrain = false
          end
        end
        elseif soldier.train_need_buff and 0 < soldier.train_need_buff then
          local effectValue = LuaEntry.Effect:GetGameEffect(soldier.train_need_buff)
          if not effectValue or not (0 < effectValue) then
            canTrain = false
          else
          end
        end
      end
      if canTrain then
        return soldier
      end
    end
  end
  return nil
end

function SoldierDataManager:CalcSoldierPower(soldierDataTemplate, soldierNum)
  if soldierDataTemplate == nil then
    return 0
  end
  local soldier_multiplier = 1
  local effect94070 = 0
  local effect94071 = 0
  local effect94073 = 0
  local effect94074 = 0
  local effect94076 = 0
  local effect94077 = 0
  if toInt(soldierDataTemplate.type) == SoldierType.Mummy then
    effect94070 = LuaEntry.Effect:GetGameEffect(94070)
    effect94071 = LuaEntry.Effect:GetGameEffect(94071)
    effect94073 = LuaEntry.Effect:GetGameEffect(94073)
    effect94074 = LuaEntry.Effect:GetGameEffect(94074)
    effect94076 = LuaEntry.Effect:GetGameEffect(94076)
    effect94077 = LuaEntry.Effect:GetGameEffect(94077)
    soldier_multiplier = tonumber(soldierDataTemplate.soldier_multiplier)
    if soldier_multiplier == nil or soldier_multiplier == 0 then
      soldier_multiplier = 1
    end
  end
  local effectValue_50066 = 0
  local templatePower_50066 = GetTableData(TableName.LW_Effect_Number, EffectDefine.LW_Effect_Id_50066, "power")
  local effectValue_50065 = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_Effect_Id_50065)
  local effectValue_50076 = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_Effect_Id_50076)
  if soldierDataTemplate.life ~= nil then
    local lifeValue = soldierDataTemplate.life.value
    effectValue_50066 = (lifeValue + effectValue_50065 + effect94070) * (1 + effectValue_50076 + effect94071) * soldier_multiplier
  end
  local effectValue_50068 = 0
  local templatePower_50068 = GetTableData(TableName.LW_Effect_Number, EffectDefine.LW_Effect_Id_50068, "power")
  local effectValue_50067 = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_Effect_Id_50067)
  local effectValue_50077 = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_Effect_Id_50077)
  if soldierDataTemplate.attack ~= nil then
    local attackValue = soldierDataTemplate.attack.value
    effectValue_50068 = (attackValue + effectValue_50067 + effect94073) * (1 + effectValue_50077 + effect94074) * soldier_multiplier
  end
  local effectValue_50070 = 0
  local templatePower_50070 = GetTableData(TableName.LW_Effect_Number, EffectDefine.LW_Effect_Id_50070, "power")
  local effectValue_50069 = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_Effect_Id_50069)
  local effectValue_50078 = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_Effect_Id_50078)
  if soldierDataTemplate.defense ~= nil then
    local defenseValue = soldierDataTemplate.defense.value
    effectValue_50070 = (defenseValue + effectValue_50069 + effect94076) * (1 + effectValue_50078 + effect94077) * soldier_multiplier
  end
  local power = math.floor(effectValue_50066 * templatePower_50066 * soldierNum) + math.floor(effectValue_50068 * templatePower_50068 * soldierNum) + math.floor(effectValue_50070 * templatePower_50070 * soldierNum)
  return power
end

function SoldierDataManager:IsUnlockSoldier(soldierId, buildingLevel)
  local isLevelUnLock, isUnLockScience = false, false
  local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
  if soldierTemplate then
    local needBuildingLevel = tonumber(soldierTemplate.train_need_barrack)
    if not needBuildingLevel or buildingLevel >= needBuildingLevel then
      isLevelUnLock = true
    end
    if string.IsNullOrEmpty(soldierTemplate.train_need_science) then
      isUnLockScience = true
    else
      local scienceData = DataCenter.ScienceTemplateManager:GetScienceTemplate(soldierTemplate.train_need_science)
      if scienceData then
        local scienceId = scienceData.science_id
        local science = DataCenter.ScienceDataManager:GetScienceById(scienceId)
        if science then
          isUnLockScience = science.level > 0
        end
      end
    end
  end
  return isLevelUnLock and isUnLockScience
end

function SoldierDataManager:GetPlayerSelfSoldierIcon(soldierId)
  local soldierTemplate = self:GetTemplate(soldierId)
  if not soldierTemplate then
    return ""
  end
  return self:GetPlayerSelfSoldierIconByTmp(soldierTemplate)
end

function SoldierDataManager:GetPlayerSelfSoldierIconByTmp(soldierTemplate)
  if not soldierTemplate then
    return ""
  end
  local isT11 = T11Util.IsSuperSoldier(soldierTemplate.lv, soldierTemplate.type)
  local t11Data
  if isT11 then
    local curStage = T11Util.GetCurStage()
    local type = T11Util.GetCurT11SoldierType()
    t11Data = {type = type, stage = curStage}
  end
  return self:GetSoldierIconByTmp(soldierTemplate, t11Data)
end

function SoldierDataManager:GetSoldierIconById(soldierId, t11Data)
  local soldierTemplate = self:GetTemplate(soldierId)
  if not soldierTemplate then
    return ""
  end
  return self:GetSoldierIconByTmp(soldierTemplate, t11Data)
end

function SoldierDataManager:GetSoldierIconByTmp(soldierTmp, t11Data)
  if not soldierTmp then
    return ""
  end
  local isT11 = T11Util.IsSuperSoldier(soldierTmp.lv, soldierTmp.type)
  local soldierIcon = ""
  if not isT11 or not t11Data then
    soldierIcon = string.format(LoadPath.ItemPath, soldierTmp.icon)
    return soldierIcon
  end
  local stage, type
  stage = t11Data.stage
  type = t11Data.type
  if stage == 0 then
    stage = T11Util.GetT11InitialStage()
  end
  if type == T11SoldierType.T11NotUnLock then
    type = T11SoldierType.T11SoldierTypeA
  end
  local soldierData = T11Util.GetT11SoldierDataByStageAndType(stage, type)
  return soldierData.icon
end

return SoldierDataManager
