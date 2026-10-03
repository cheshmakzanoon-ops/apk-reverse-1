local rapidjson = require("rapidjson")
local util = require("Common.Tools.cjson.util")
local Localization = CS.GameEntry.Localization
local ArmyFormationDataManager = BaseClass("ArmyFormationDataManager")
local Setting = CS.GameEntry.Setting

local function __init(self)
  self.ArmyFormationList = {}
  self.ArmyFormationSlotIndexList = {}
  self.PVEFormationList = {}
  self.PVEFormationSlotIndexList = {}
  self.DefenceFormationList = {}
  self.InvestigateFormationList = {}
  self.ResSupportFormationList = {}
  self.GolloesFormationList = {}
  self.BattleFieldUseFlag = false
  self.BattleFieldFormationList = {}
  self.BattleFieldFormationSlotIndexList = {}
  self.tempArmyFormation = nil
  self.CostStaminaDome = 0
  self.CostStaminaBuild = 0
  self.CostStaminaRoad = 0
  self.CostStaminaMonster = 0
  self.CostStaminaBoss = 0
  self.CostStaminaPickGarbage = 0
  self.preDetectEventBubbleShowState = false
  self.isPop = true
  self.effectDic = {}
end

local function __delete(self)
  self:DeleteTimer()
  self.ArmyFormationList = nil
  self.ArmyFormationSlotIndexList = nil
  self.tempArmyFormation = nil
  self.InvestigateFormationList = nil
  self.ResSupportFormationList = nil
  self.GolloesFormationList = nil
  self.BattleFieldUseFlag = false
  self.BattleFieldFormationList = nil
  self.BattleFieldFormationSlotIndexList = nil
  self.PVEFormationList = nil
  self.PVEFormationSlotIndexList = nil
  self.preDetectEventBubbleShowState = nil
  self.isPop = nil
end

local function GetCurFormationList(self, ignoreDragon)
  if ignoreDragon then
    return self.ArmyFormationList
  end
  if BattleFieldUtil.InBattleField() and self.UseBattleFieldFlag then
    return self.BattleFieldFormationList
  end
  return self.ArmyFormationList
end

local function GetCurFormationSlotIndexList(self, ignoreDragon)
  if ignoreDragon then
    return self.ArmyFormationSlotIndexList
  end
  if BattleFieldUtil.InBattleField() and self.UseBattleFieldFlag then
    return self.BattleFieldFormationSlotIndexList
  end
  return self.ArmyFormationSlotIndexList
end

local function GetFormationFormDataByHeroUuid(self, uuid)
  local formUuid = 0
  table.walk(self.PVEFormationList, function(k, v)
    if v.heroes ~= nil and table.count(v.heroes) > 0 and v.heroes[uuid] ~= nil then
      formUuid = k
    end
  end)
  if formUuid ~= 0 then
    return self:GetArmyFormInfoByUuid(formUuid)
  end
end

local function RefreshFormationModelToJson(self, tempArmyFormation)
end

local function CreateFakeArmyFormation(self, index)
  local info = ArmyFormationInfo.New()
  info:ParseData({
    index = index,
    uuid = index,
    soldiers = {},
    heroes = {},
    slots = 5
  })
  return info
end

local function SendFormToServer(self)
  local sfsObjList = {}
  local list = self:GetCurFormationList()
  if list ~= nil then
    table.walk(list, function(k, v)
      if v.ownerUid == LuaEntry.Player.uid then
        local formationObj = SFSObject.New()
        formationObj:PutLong("uuid", v.uuid)
        local heroesArray = SFSArray.New()
        table.walk(v.heroes, function(a, b)
          local obj = SFSObject.New()
          obj:PutLong("heroUuid", a)
          obj:PutInt("index", b)
          heroesArray:AddSFSObject(obj)
        end)
        formationObj:PutSFSArray("heroInfos", heroesArray)
        table.insert(sfsObjList, formationObj)
      end
    end)
  end
  SFSNetwork.SendMessage(MsgDefines.SaveFormationTempHero, sfsObjList)
end

local function PackageFormationFormToSFSObj(self)
  local sfsObj = {}
  if self.PVEFormationList ~= nil then
    sfsObj.formation_template = {}
    table.walk(self.PVEFormationList, function(k, v)
      local oneObj = {}
      oneObj.uuid = v.uuid
      oneObj.ownerUid = v.ownerUid
      oneObj.index = v.index
      oneObj.maxNum = v.maxNum
      oneObj.soldiers = {}
      oneObj.heroes = {}
      if v.soldiers then
        table.walk(v.soldiers, function(a, b)
          local obj = {}
          obj.armyId = a
          obj.count = b
          table.insert(oneObj.soldiers, obj)
        end)
      end
      table.walk(v.heroes, function(a, b)
        local obj = {}
        obj.heroUuid = a
        obj.index = b
        table.insert(oneObj.heroes, obj)
      end)
      table.insert(sfsObj.formation_template, oneObj)
    end)
  end
  return sfsObj
end

local function GetConfigData(self)
  local oneData = {}
  local maxAddEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.STAMINA_MAX_LIMIT)
  local maxBase = LuaEntry.DataConfig:TryGetNum("car_stamina", "k1")
  oneData.FormationStaminaMax = maxBase + maxAddEffect
  local speedAddEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.STAMINA_RECOVER_SPEED_ADD)
  local timeBase = LuaEntry.DataConfig:TryGetNum("car_stamina", "k2")
  oneData.FormationStaminaUpdateTime = timeBase / (1 + speedAddEffect / 100)
  return oneData
end

local function GetMaxInvesFormationCount(self)
  return LuaEntry.Effect:GetGameEffect(EffectDefine.APS_SCOUT_FORMATION_SIZE)
end

local function InitArmyFormationListData(self, message)
  self:AddTimer()
  if message.formation_game_effect ~= nil then
    for uuidStr, dic in pairs(message.formation_game_effect) do
      local uuid = tonumber(uuidStr)
      self.effectDic[uuid] = {}
      for idStr, value in pairs(dic) do
        self.effectDic[uuid][tonumber(idStr)] = value
      end
    end
  end
  if message.army_formation ~= nil then
    self.ArmyFormationList = {}
    self.ArmyFormationSlotIndexList = {}
    table.walk(message.army_formation, function(k, v)
      local info = ArmyFormationInfo.New()
      info:ParseData(v)
      if info.uuid ~= nil and info.uuid ~= 0 then
        self.ArmyFormationList[info.uuid] = info
        self.ArmyFormationSlotIndexList[info.index] = info.uuid
        EventManager:GetInstance():Broadcast(EventId.RefreshCarbarnFormation, info.buildingUuid)
      end
    end)
  end
  if message.formation_template ~= nil then
    self.PVEFormationList = {}
    self.PVEFormationSlotIndexList = {}
    
    local function IsTruckFormation(index)
      if index > FormationSaveType.TruckDefenceSquad and index <= FormationSaveType.TruckDefenceSquad + 4 or index > FormationSaveType.TruckAttackSquad and index <= FormationSaveType.TruckAttackSquad + 4 then
        return true
      end
      return false
    end
    
    if table.count(message.formation_template) > 0 then
      table.walk(message.formation_template, function(k, v)
        if not IsTruckFormation(v.index) then
          local info = ArmyFormationInfo.New()
          info:ParseData(v)
          if info.uuid ~= nil and info.uuid ~= 0 then
            self.PVEFormationList[info.uuid] = info
            self.PVEFormationSlotIndexList[info.index] = info.uuid
          end
        end
      end)
    end
    if not self.PVEFormationSlotIndexList[1] then
      do
        local info = self:CreateFakeArmyFormation(1)
        self.PVEFormationList[info.uuid] = info
        self.PVEFormationSlotIndexList[info.index] = info.uuid
      end
    end
  end
  if message.defend_formation ~= nil then
    self.DefenceFormationList = {}
    table.walk(message.defend_formation, function(k, v)
      local info = ArmyFormationInfo.New()
      info:ParseData(v, true)
      if info.uuid ~= nil and info.uuid ~= 0 then
        self.DefenceFormationList[info.uuid] = info
      end
    end)
  end
  if message.scout_formation ~= nil then
    self.InvestigateFormationList = {}
    table.walk(message.scout_formation, function(k, v)
      local info = ArmyFormationInfo.New()
      info:ParseData(v)
      if info.uuid ~= nil and info.uuid ~= 0 then
        self.InvestigateFormationList[info.uuid] = info
      end
    end)
  end
  if message.resource_formation ~= nil then
    self.ResSupportFormationList = {}
    table.walk(message.resource_formation, function(k, v)
      local info = ArmyFormationInfo.New()
      info:ParseData(v)
      if info.uuid ~= nil and info.uuid ~= 0 then
        self.ResSupportFormationList[info.uuid] = info
      end
    end)
  end
  if message.golloes_formation then
    self.GolloesFormationList = {}
    table.walk(message.golloes_formation, function(k, v)
      local info = ArmyFormationInfo.New()
      info:ParseData(v)
      if info.uuid ~= nil and info.uuid ~= 0 then
        self.GolloesFormationList[info.uuid] = info
      end
    end)
  end
  if message.battlefield_formation then
    self.BattleFieldFormationList = {}
    self.BattleFieldFormationSlotIndexList = {}
    table.walk(message.battlefield_formation, function(k, v)
      local info = ArmyFormationInfo.New()
      info:ParseData(v)
      if info.uuid ~= nil and info.uuid ~= 0 then
        self.BattleFieldFormationList[info.uuid] = info
        self.BattleFieldFormationSlotIndexList[info.index] = info.uuid
      end
    end)
  end
end

local function UpdateArmyFormationListData(self, message)
  local uuId = message.uuid
  if uuId == nil then
    return
  end
  local list = self:GetCurFormationList()
  if list[uuId] ~= nil then
    list[uuId]:ParseData(message)
  else
    local info = ArmyFormationInfo.New()
    info:ParseData(message)
    list[uuId] = info
    local indexList = self:GetCurFormationSlotIndexList()
    indexList[info.index] = uuId
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshCarbarnFormation, message.buildingUuid)
end

local function UpdateTemplateFormationListData(self, message)
  local index = message.index
  local uuId = message.uuid
  if index == nil or uuId == nil then
    return
  end
  local prevUuid = self.PVEFormationSlotIndexList[index]
  if prevUuid ~= nil and prevUuid ~= uuId then
    local info = self.PVEFormationList[prevUuid]
    if info ~= nil then
      info:ParseData(message)
    end
    self.PVEFormationList[prevUuid] = nil
    self.PVEFormationList[uuId] = info
    self.PVEFormationSlotIndexList[index] = uuId
  elseif self.PVEFormationList[uuId] ~= nil then
    self.PVEFormationList[uuId]:ParseData(message)
  else
    local info = ArmyFormationInfo.New()
    info:ParseData(message)
    self.PVEFormationList[uuId] = info
    self.PVEFormationSlotIndexList[info.index] = uuId
  end
end

local function ChangeFormationNameData(self, message)
  local uuid = message.uuid
  local list = self:GetCurFormationList()
  if list[uuid] ~= nil then
    list[uuid]:SetName(message.name)
  end
end

local function GetOneArmyInfoByUuid(self, uuid)
  local list = self:GetCurFormationList()
  return list[uuid]
end

local function GetOneArmyInfoByIndex(self, index)
  local indexList = self:GetCurFormationSlotIndexList()
  return self:GetOneArmyInfoByUuid(indexList[index])
end

local function GetOneArmyInfoByBuildingUuid(self, buildingUuid)
  local info
  local list = self:GetCurFormationList()
  table.walk(list, function(k, v)
    if v.buildingUuid == buildingUuid then
      info = v
    end
  end)
  return info
end

local function GetArmyFormationIdList(self)
  local list = self:GetCurFormationList()
  local keys = table.keys(list)
  table.sort(keys, function(a, b)
    return list[a].index < list[b].index
  end)
  return keys
end

local function GetArmyFormationIdListSortByDefencePriority(self)
  local list = self:GetCurFormationList()
  local keys = table.keys(list)
  table.sort(keys, function(a, b)
    local pa = list[a].defencePriority
    local pb = list[b].defencePriority
    if pa == pb then
      return list[a].index < list[b].index
    end
    return pa > pb
  end)
  return keys
end

local function GetAlreadySetCountInArmyFormation(self)
  local Player = LuaEntry.Player
  local alreadySetCount = 0
  local list = self:GetCurFormationList()
  table.walk(list, function(k, v)
    local marchInfo = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(Player.uid, v.uuid, Player.allianceId)
    if marchInfo ~= nil then
      alreadySetCount = alreadySetCount + 1
    end
  end)
  return alreadySetCount
end

local function GetFreeCountInArmyFormation(self)
  local freeCount = 0
  local list = self:GetCurFormationList()
  table.walk(list, function(k, v)
    if v.state == ArmyFormationState.Free then
      freeCount = freeCount + 1
    end
  end)
  return freeCount
end

local function GetCurStaminaByUuid(self, uuid)
  return LuaEntry.Player:GetCurStamina()
end

local function GetArmyUnFormationList(self)
  local showList = {}
  local list = DataCenter.ArmyManager:GetArmyFreeList()
  table.walk(list, function(k, v)
    local restCount = v
    if restCount < 0 then
      Logger.Log("error in get UnFormationSoldier")
      restCount = 0
    end
    showList[k] = restCount
  end)
  return showList
end

local function GetSoliderFreeNumInFormationById(self, soliderId)
  local count = 0
  local list = self:GetCurFormationList()
  table.walk(list, function(k, v)
    if v.state == ArmyFormationState.Free and v.soldiers[soliderId] ~= nil then
      count = count + v.soldiers[soliderId]
    end
  end)
  return count
end

local function GetFreeResSupportFormation(self)
  for i, v in pairs(self.ResSupportFormationList) do
    if v.state ~= 1 then
      return v.uuid
    end
  end
end

local function CheckIfIsScountFormation(self, marchUuid)
  local info = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
  if info then
    for k, v in pairs(self.InvestigateFormationList) do
      if k == info.ownerFormationUuid then
        return true
      end
    end
  end
  return false
end

local function GetBattleFieldFormationList(self)
  return table.values(self.BattleFieldFormationList)
end

local function GetGolloesFormationList(self)
  return table.values(self.GolloesFormationList)
end

local function GetResSupportFormationList(self)
  return table.values(self.ResSupportFormationList)
end

local function GetInvestigateFormationList(self)
  return table.values(self.InvestigateFormationList)
end

local function GetInvestigateFormationInfoByIndex(self, tempIndex)
  for i, v in pairs(self.InvestigateFormationList) do
    if v.index == tempIndex then
      return v
    end
  end
  return nil
end

local function GetArmyFormationList(self)
  local list = self:GetCurFormationList()
  return table.values(list)
end

local function SetArmyFormationSoldier(self, formationUuid, soliderList)
  local list = self:GetCurFormationList()
  if list[formationUuid] ~= nil then
    list[formationUuid].soldiers = soliderList
  end
end

local function SetArmyFormationHero(self, formationUuid, heroList)
  local list = self:GetCurFormationList()
  if list[formationUuid] ~= nil then
    list[formationUuid].heroes = heroList
  end
end

local function AutoInitFormationData(self, formationUuid)
end

local function AutoAddHeroForCollect(self, formationUuid, resourceType)
  local resourceEffect = 0
  local weightEffect = EffectDefine.ARMY_CARRY_WEIGHT_ADD_PERCENT
  if resourceType == ResourceType.Oil then
    resourceEffect = EffectDefine.GAS_COLLECT_SPEED_PERCENT
  elseif resourceType == ResourceType.Water then
    resourceEffect = EffectDefine.WATER_COLLECT_SPEED_PERCENT
  elseif resourceType == ResourceType.Metal then
    resourceEffect = EffectDefine.CRYSTAL_COLLECT_SPEED_PERCENT
  elseif resourceType == ResourceType.Food then
    resourceEffect = EffectDefine.MONEY_COLLECT_SPEED_PERCENT
  end
  local list = self:GetCurFormationList()
  if list[formationUuid] ~= nil then
    local heroIdList = {}
    local heroes = {}
    local inMarchHeroId = DataCenter.HeroDataManager:GetHeroIdListInMarch()
    local indexNum = 0
    for uuid, index in pairs(list[formationUuid].heroes) do
      table.insert(heroes, DataCenter.HeroDataManager:GetHeroByUuid(uuid))
    end
    list[formationUuid].heroes = {}
    local maxHeroNum = 5
    for _, heroData in pairs(heroes) do
      if indexNum <= maxHeroNum - 1 and (heroData.state == ArmyFormationState.Free or heroData.state == ArmyFormationState.Formation) and heroIdList[heroData.heroId] == nil and inMarchHeroId[heroData.heroId] == nil then
        indexNum = indexNum + 1
        list[formationUuid].heroes[heroData.uuid] = indexNum
        heroIdList[heroData.heroId] = 1
      end
    end
  end
end

local function AutoInitFormationDataForCollect(self, formationUuid, resourceType)
end

local function GetArmyFormationHeroCanLevelUpUuid(self, formationUuid)
  local list = self:GetCurFormationList()
  if list[formationUuid] ~= nil then
    local canLevelUpHeroList = {}
    local heroList = list[formationUuid].heroes
    for k, v in pairs(heroList) do
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
      if heroData ~= nil and heroData:ShowUpGradeRedPoint() == true then
        table.insert(canLevelUpHeroList, heroData)
      end
    end
    if 0 < #canLevelUpHeroList then
      table.sort(canLevelUpHeroList, function(heroA, heroB)
        if heroA.level ~= heroB.level then
          return heroA.level < heroB.level
        end
        if heroA.quality ~= heroB.quality then
          return heroA.quality < heroB.quality
        end
        return heroA.heroId > heroB.heroId
      end)
      return canLevelUpHeroList[1].uuid
    end
  end
end

local function GetFormationHeroCanChangeHigherUuid(self, formationUuid)
  local list = self:GetCurFormationList()
  if list[formationUuid] ~= nil then
    local heroList = list[formationUuid].heroes
    local heroIdList = {}
    local minRarity = 999
    local minHeroUuid = 0
    local targetHeroUuid = 0
    for a, b in pairs(heroList) do
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(a)
      if heroData ~= nil then
        local heroId = heroData.heroId
        heroIdList[heroId] = 1
        if minRarity == 999 or minRarity < heroData.rarity then
          minRarity = heroData.rarity
          minHeroUuid = heroData.uuid
        end
      end
    end
    if minHeroUuid ~= 0 then
      local formHeroList = {}
      for c, d in pairs(self.PVEFormationList) do
        local tempHeroList = d.heroes
        for e, f in pairs(tempHeroList) do
          formHeroList[e] = 1
        end
      end
      local allHeroes = DataCenter.HeroDataManager:GetAllHeroBySort()
      for k, v in pairs(allHeroes) do
        local heroId = v.heroId
        if heroIdList[heroId] == nil and formHeroList[v.uuid] == nil and v.state == ArmyFormationState.Free and minRarity > v.rarity then
          targetHeroUuid = v.uuid
          return minHeroUuid, targetHeroUuid
        end
      end
    end
  end
end

local function AutoAddHero(self, formationUuid)
  local list = self:GetCurFormationList()
  if list[formationUuid] ~= nil then
    local heroIdList = {}
    local heroes = {}
    local inMarchHeroId = DataCenter.HeroDataManager:GetHeroIdListInMarch()
    local indexNum = 0
    for uuid, index in pairs(list[formationUuid].heroes) do
      table.insert(heroes, DataCenter.HeroDataManager:GetHeroByUuid(uuid))
    end
    list[formationUuid].heroes = {}
    local maxHeroNum = 5
    for _, heroData in pairs(heroes) do
      if indexNum <= maxHeroNum - 1 and (heroData.state == ArmyFormationState.Free or heroData.state == ArmyFormationState.Formation) and heroIdList[heroData.heroId] == nil and inMarchHeroId[heroData.heroId] == nil then
        indexNum = indexNum + 1
        list[formationUuid].heroes[heroData.uuid] = indexNum
        heroIdList[heroData.heroId] = 1
        Logger.Log("hero add amry formationstate", heroData.uuid, "num", indexNum)
      end
    end
  end
end

local function AutoAddSoldier(self, formationUuid, useForm)
end

local function AutoAddSoldierByForm(self, formationUuid)
  local list = self:GetCurFormationList()
  if list[formationUuid] ~= nil then
    list[formationUuid].soldiers = {}
    local freeSoldiers = DataCenter.ArmyFormationDataManager:GetArmyUnFormationList()
    local maxNum = MarchUtil.GetMaxCanAddSoldierNum(list[formationUuid].heroes, list[formationUuid].index)
    local totalNum = 0
    if self.PVEFormationList[formationUuid] ~= nil then
      local allHeroes = self.PVEFormationList[formationUuid].heroes
      local allSoldier = self.PVEFormationList[formationUuid].soldiers
      if 0 < table.count(allHeroes) and 0 < table.count(allSoldier) then
        local formSoldier = self.PVEFormationList[formationUuid].soldiers
        table.walksort(formSoldier, function(leftKey, rightKey)
          local aData = DataCenter.ArmyManager:FindArmy(leftKey)
          local bData = DataCenter.ArmyManager:FindArmy(rightKey)
          if aData ~= nil and bData ~= nil then
            if aData.level ~= bData.level then
              return aData.level > bData.level
            end
            return aData.id > bData.id
          end
          return false
        end, function(k, v)
          if 0 < v and freeSoldiers[k] ~= nil then
            local freeNum = freeSoldiers[k]
            if 0 < freeNum then
              local realNum = math.min(freeNum, v)
              local addNum = math.min(maxNum - totalNum, realNum)
              if 0 < addNum then
                list[formationUuid].soldiers[k] = addNum
                totalNum = totalNum + addNum
              end
            end
          end
        end)
      end
    else
      self:AutoAddSoldier()
    end
  end
end

local function AutoClearFormationData(self, formationUuid)
  local list = self:GetCurFormationList()
  if list[formationUuid] ~= nil then
    list[formationUuid].heroes = {}
    list[formationUuid].soldiers = {}
  end
end

local function GetDefenceArmyFormationData(self)
  return self.DefenceFormationList
end

local function GetDefenceFormation(self)
  for k, v in pairs(self.DefenceFormationList) do
    return v
  end
end

local function GetMarchArmyWeight(uuid)
  local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
  for _, march in pairs(selfMarch) do
    if march.uuid == uuid and march.plunderRes then
      local num = 0
      local stringNum = string.split(march.plunderRes, ";")
      table.walk(stringNum, function(k, v)
        local pos = string.find(v, ",")
        if pos ~= nil then
          num = tonumber(string.sub(v, pos + 1, -1)) + num
        end
      end)
      return num == march.armyWeight
    end
  end
end

local function GetArmyFormInfoByUuid(self, uuid)
  return self.PVEFormationList[uuid]
end

local function GetFirstFormationUnlockScienceId(self)
  local scienceId
  for _, v in pairs(self.PVEFormationList) do
    local buildId = MarchUtil.GetFormationBuildNameByIndex(v.index)
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if buildTemplate ~= nil then
      local vecPara1 = string.split(buildTemplate.para1, "|")
      for k, v in ipairs(vecPara1) do
        local vec1 = string.split(v, ";")
        if 2 <= #vec1 then
          local tmp = tonumber(vec1[2])
          local index = tonumber(vec1[1])
          local maxNum = 5
          local isLocked = index > maxNum
          if isLocked then
            scienceId = tmp
            break
          end
        end
      end
    end
  end
  return scienceId
end

local function CheckDetectEventStamina(self)
  local exploreStamina = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.EXPLORE)
  local attackMonster = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.ATTACK_MONSTER)
  local stamina = math.min(exploreStamina, attackMonster)
  local result = self:HasStaminaEnoughFormation(stamina)
  self.preDetectEventBubbleShowState = result
  return result
end

local function HasStaminaEnoughFormation(self, checkStamina)
  if checkStamina <= self:GetCurStaminaByUuid() then
    return true
  end
  return false
end

local function AutoCheckDetectEventStamina(self)
  if self.preDetectEventBubbleShowState == true then
    return
  end
  local preState = self.preDetectEventBubbleShowState
  local result = self:CheckDetectEventStamina()
  if preState ~= result then
    EventManager:GetInstance():Broadcast(EventId.FormationInfoUpdate)
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(10.0, self.AutoCheckDetectEventStamina, self, false, false, false)
  end
  self.timer:Start()
end

local function GetMarchArmyNum(self)
  local result = 0
  local list = self:GetCurFormationList()
  for _, v in pairs(list) do
    if v ~= nil and v.soldiers and v.state == ArmyFormationState.March then
      table.walk(v.soldiers, function(_, k)
        result = result + k
      end)
    end
  end
  return result
end

local function IsAllFormationFree(self)
  local result = true
  local list = self:GetCurFormationList()
  for k, v in pairs(list) do
    if result == true and v.state ~= ArmyFormationState.Free then
      result = false
    end
  end
  return result
end

local function GetConfirmFlag(self)
  return self.isPop
end

local function SetConfirmFlag(self, state)
  self.isPop = state
end

local function HasUnsetFormation(self)
  local list = self:GetCurFormationList()
  if list ~= nil and self.PVEFormationList ~= nil and LuaEntry.Player ~= nil then
    local uid = LuaEntry.Player.uid
    local count = 0
    table.walk(self.PVEFormationList, function(_, v)
      if v.ownerUid == uid and table.count(v.heroes) > 0 then
        count = count + 1
      end
    end)
    local realCount = table.count(list)
    return 0 < realCount and count ~= realCount
  end
  return false
end

local function IsFormationUnsetByIndex(self, index)
  local indexList = self:GetCurFormationSlotIndexList()
  local uuid = indexList[index]
  local FormationForm = self:GetArmyFormInfoByUuid(uuid)
  if FormationForm ~= nil then
    return false
  end
  return true
end

local function IsHeroInSquad(self, heroUuid)
  local result = false
  local list = self:GetCurFormationList()
  if list ~= nil then
    for _, v in pairs(list) do
      if v ~= nil and v.localHeroes ~= nil then
        if result == false then
          result = table.containsKey(v.localHeroes, heroUuid)
        end
        if result == true then
          break
        end
      end
    end
  end
  return result
end

local function GetHeroSquadIndex(self, heroUuid)
  local list = self:GetCurFormationList()
  if list ~= nil then
    for _, v in pairs(list) do
      if v ~= nil and v.localHeroes ~= nil then
        local hasHero = table.containsKey(v.localHeroes, heroUuid)
        if hasHero then
          return v.index
        end
      end
    end
  end
  return nil
end

local function GetHeroFormationInfoBySquadIndex(self, heroUuid, isContainBattleField)
  local list = self:GetCurFormationList()
  if list ~= nil then
    for _, v in pairs(list) do
      if v ~= nil and v.localHeroes ~= nil then
        local hasHero = table.containsKey(v.localHeroes, heroUuid)
        if hasHero then
          return v
        end
      end
    end
  end
  if isContainBattleField and self.BattleFieldFormationList then
    for _, v in pairs(self.BattleFieldFormationList) do
      if v ~= nil and v.localHeroes ~= nil then
        local hasHero = table.containsKey(v.localHeroes, heroUuid)
        if hasHero then
          return v
        end
      end
    end
  end
  return nil
end

local function GetHeroUuidListInSquad(self, squadIndex)
  local list = self:GetCurFormationList()
  if list ~= nil then
    for _, v in pairs(list) do
      if v ~= nil and v.index == squadIndex then
        local res = {}
        if v.localHeroes then
          for heroUuid, _ in pairs(v.localHeroes) do
            if heroUuid then
              table.insert(res, heroUuid)
            end
          end
        end
        return res
      end
    end
  end
  return nil
end

local function GetTemplateFormationByIndex(self, index)
  if self.PVEFormationSlotIndexList[index] == nil or self.PVEFormationList[self.PVEFormationSlotIndexList[index]] == nil then
    local info = self:CreateFakeArmyFormation(index)
    self.PVEFormationList[info.uuid] = info
    self.PVEFormationSlotIndexList[info.index] = info.uuid
  end
  return self.PVEFormationList[self.PVEFormationSlotIndexList[index]]
end

local function IsHeroInFormationTemplate(self, heroUuid)
  local result = false
  if self.PVEFormationList ~= nil then
    for _, v in pairs(self.PVEFormationList) do
      if v ~= nil and v.localHeroes ~= nil then
        if result == false then
          result = table.containsKey(v.localHeroes, heroUuid)
        end
        if result == true then
          break
        end
      end
    end
  end
  return result
end

local function IsHeroInDefenceFormation(self, heroUuid)
  local result = false
  if self.DefenceFormationList ~= nil then
    for _, v in pairs(self.DefenceFormationList) do
      if v ~= nil and v.localHeroes ~= nil then
        if result == false then
          result = table.containsKey(v.localHeroes, heroUuid)
        end
        if result == true then
          break
        end
      end
    end
  end
  return result
end

local function HasArmyFormationInIndex(self, index, ignoreDragon)
  local indexList = self:GetCurFormationSlotIndexList(ignoreDragon)
  local uuid = indexList[index]
  if uuid == nil then
    return false
  end
  local list = self:GetCurFormationList(ignoreDragon)
  return list[uuid] ~= nil
end

local function RefreshFormationSoldier(self, message)
  if not message.uuid then
    return
  end
  local formationUuid = message.uuid
  local list = self:GetCurFormationList()
  if not list[formationUuid] then
    return
  end
  local formation = list[formationUuid]
  formation:RefreshFormationSoldier(message)
end

local function GetFormationByType(self, entranceType, index)
  if entranceType == EnterHeroSquadPanelWay.Gate then
    return self:GetDefenceFormation(index)
  elseif entranceType < EnterHeroSquadPanelWay.PVE then
    return self:GetOneArmyInfoByIndex(index)
  else
    return self:GetTemplateFormationByIndex(index)
  end
end

local function SaveDefenceFormation(self, formation)
  local info = ArmyFormationInfo.New()
  info:ParseData(formation, true)
  if info.uuid ~= nil and info.uuid ~= 0 then
    self.DefenceFormationList[info.uuid] = info
  end
end

local function GetFormationBurdenByUuid(self, formationUuid)
  local totalPower = 0
  local formation = self:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    totalPower = formation:GetTotalBurden()
  end
  if totalPower == 0 and CommonUtil.IsGrayServer() then
    if formation then
      if 0 < formation.totalSoldierNum then
        Logger.LogError("GetFormationBurdenByUuid:" .. (formationUuid or "nil") .. formation.totalSoldierNum)
      end
    else
      Logger.LogError("GetFormationBurdenByUuid:" .. (formationUuid or "nil") .. ",formation==nil")
    end
  end
  return totalPower
end

local function GetFormationPowerByUuid(self, formationUuid)
  local totalPower = 0
  local formation = self:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    totalPower = formation:GetTotalCapacity()
  end
  return totalPower
end

local function GetAllTotalSoldierNum(self)
  local ret = 0
  local list = self:GetCurFormationList()
  for _, formation in pairs(list) do
    ret = ret + formation.totalSoldierNum
  end
  return ret
end

local function FetchFormationSoldier(self)
end

local function GetFormationIndexByBuildingType(self, buildingType)
  local index = -1
  if buildingType == BuildingTypes.LW_BUILD_PARKINGLOT then
    index = 1
  elseif buildingType == BuildingTypes.LW_BUILD_PARKINGLOT_TWO then
    index = 2
  elseif buildingType == BuildingTypes.LW_BUILD_PARKINGLOT_THREE then
    index = 3
  elseif buildingType == BuildingTypes.LW_BUILD_PARKINGLOT_FOUR then
    index = 4
  end
  return index
end

local function GetUnlockFormationCount(self)
  local list = self:GetCurFormationList()
  return table.count(list)
end

local function OnPushFormationEffectNumber(self, msg)
  for uuidStr, dict in pairs(msg) do
    local uuid = tonumber(uuidStr)
    if not self.effectDic[uuid] then
      self.effectDic[uuid] = {}
    end
    for idStr, value in pairs(dict) do
      self.effectDic[uuid][tonumber(idStr)] = value
    end
  end
end

local function GetEffectNumber(self, uuid, effectId)
  local fromFormation = 0
  if self.effectDic[uuid] and self.effectDic[uuid][effectId] then
    fromFormation = self.effectDic[uuid][effectId]
  end
  local fromPlayer = LuaEntry.Effect:GetGameEffect(effectId)
  if GMUtils.GetBool(GMConst.ShowParkEffectNumberLog, false) then
    Logger.LogCustom(string.format("id:%s,effect:%.2f,\232\189\166\229\186\147\239\188\154%.2f\239\188\140\231\142\169\229\174\182\239\188\154%.2f", effectId, fromFormation + fromPlayer, fromFormation, fromPlayer))
  end
  return fromFormation + fromPlayer
end

local function GetEffectResult(self, uuid, effectId, useLightWorkerMan)
  if effectId == EffectDefine.FINAL_NORMAL_SPEED_71050 then
    local LW_71000 = GetEffectNumber(self, uuid, EffectDefine.LW_71000)
    local LW_71000_Season = SeasonUtil.GetSeasonBuffValue(EffectDefine.LW_71000)
    local LW_71000_LightWorker = 0
    local LW_71018 = GetEffectNumber(self, uuid, EffectDefine.LW_MARCH_NORMAL_SPEED_ADD_PERCENT_71018)
    local LW_71039 = GetEffectNumber(self, uuid, EffectDefine.LW_71039)
    if useLightWorkerMan then
      local stateMeta = LocalController:instance():getLine(TableName.StatusTab, 704008)
      if stateMeta and stateMeta.effect_num ~= nil and toInt(stateMeta.effect) == EffectDefine.LW_71000 then
        LW_71000_LightWorker = tonumber(stateMeta.effect_num) or 0
      end
    end
    local ret = LW_71000 + LW_71000_Season + LW_71018 + LW_71039 + LW_71000_LightWorker
    if GMUtils.GetBool(GMConst.ShowParkEffectNumberLog, false) then
      Logger.LogCustom("71050=71000+\232\181\155\229\173\163+\230\143\144\231\129\175+71018+71039")
      Logger.LogCustom(string.format("%.2f = %.2f + %.2f + %.2f + %.2f + %.2f", ret, LW_71000, LW_71000_Season, LW_71000_LightWorker, LW_71018, LW_71039))
    end
    return ret
  elseif effectId == EffectDefine.FINAL_MONSTER_SPEED_71051 then
    local normalSpeed = self:GetEffectResult(uuid, EffectDefine.FINAL_NORMAL_SPEED_71050, useLightWorkerMan)
    local LW_71001 = GetEffectNumber(self, uuid, EffectDefine.LW_71001)
    local LW_71019 = GetEffectNumber(self, uuid, EffectDefine.LW_MARCH_MONSTER_SPEED_ADD_PERCENT_71019)
    local LW_71040 = GetEffectNumber(self, uuid, EffectDefine.LW_71040)
    local ret = normalSpeed + LW_71001 + LW_71019 + LW_71040
    if GMUtils.GetBool(GMConst.ShowParkEffectNumberLog, false) then
      Logger.LogCustom("71051=71050+71001+71019+71040")
      Logger.LogCustom(string.format("%.2f = %.2f + %.2f + %.2f + %.2f", ret, normalSpeed, LW_71001, LW_71019, LW_71040))
    end
    return ret
  elseif effectId == EffectDefine.FINAL_PLAYER_SPEED_71052 then
    local normalSpeed = self:GetEffectResult(uuid, EffectDefine.FINAL_NORMAL_SPEED_71050, useLightWorkerMan)
    local LW_71002 = GetEffectNumber(self, uuid, EffectDefine.LW_71002)
    local LW_71020 = GetEffectNumber(self, uuid, EffectDefine.LW_MARCH_PLAYER_SPEED_ADD_PERCENT_71020)
    local LW_71041 = GetEffectNumber(self, uuid, EffectDefine.LW_71041)
    local ret = normalSpeed + LW_71002 + LW_71020 + LW_71041
    if GMUtils.GetBool(GMConst.ShowParkEffectNumberLog, false) then
      Logger.LogCustom("71052=71050+71002+71020+71041")
      Logger.LogCustom(string.format("%.2f = %.2f + %.2f + %.2f + %.2f", ret, normalSpeed, LW_71002, LW_71020, LW_71041))
    end
    return ret
  elseif effectId == EffectDefine.FINAL_ALLIANCE_CITY_SPEED_71053 then
    local normalSpeed = self:GetEffectResult(uuid, EffectDefine.FINAL_NORMAL_SPEED_71050, useLightWorkerMan)
    local LW_71003 = GetEffectNumber(self, uuid, EffectDefine.LW_71003)
    local LW_71021 = GetEffectNumber(self, uuid, EffectDefine.LW_MARCH_ALLIANCE_CITY_SPEED_ADD_PERCENT_71021)
    local LW_71042 = GetEffectNumber(self, uuid, EffectDefine.LW_71042)
    local ret = normalSpeed + LW_71003 + LW_71021 + LW_71042
    if GMUtils.GetBool(GMConst.ShowParkEffectNumberLog, false) then
      Logger.LogCustom("71053=71050+71003+71021+71042")
      Logger.LogCustom(string.format("%.2f = %.2f + %.2f + %.2f + %.2f", ret, normalSpeed, LW_71003, LW_71021, LW_71042))
    end
    return ret
  elseif effectId == EffectDefine.FINAL_GATHER_SPEED_71054 then
    local normalSpeed = self:GetEffectResult(uuid, EffectDefine.FINAL_NORMAL_SPEED_71050, useLightWorkerMan)
    local LW_71004 = GetEffectNumber(self, uuid, EffectDefine.LW_71004)
    local LW_71031 = GetEffectNumber(self, uuid, EffectDefine.LW_MARCH_GATHER_SPEED_ADD_PERCENT_71031)
    local LW_71043 = GetEffectNumber(self, uuid, EffectDefine.LW_71043)
    local ret = normalSpeed + LW_71004 + LW_71031 + LW_71043
    if GMUtils.GetBool(GMConst.ShowParkEffectNumberLog, false) then
      Logger.LogCustom("71054=71050+71004+71031+71043")
      Logger.LogCustom(string.format("%.2f = %.2f + %.2f + %.2f + %.2f", ret, normalSpeed, LW_71004, LW_71031, LW_71043))
    end
    return ret
  elseif effectId == EffectDefine.FINAL_ASSIST_SPEED_71057 then
    local normalSpeed = self:GetEffectResult(uuid, EffectDefine.FINAL_NORMAL_SPEED_71050, useLightWorkerMan)
    local LW_71005 = GetEffectNumber(self, uuid, EffectDefine.LW_71005)
    local ret = normalSpeed + LW_71005
    if GMUtils.GetBool(GMConst.ShowParkEffectNumberLog, false) then
      Logger.LogCustom("71057=71050+71005")
      Logger.LogCustom(string.format("%.2f = %.2f + %.2f", ret, normalSpeed, LW_71005))
    end
    return ret
  elseif effectId == EffectDefine.LW_SEASON_EFFECT_94024 then
    return GetEffectNumber(self, uuid, EffectDefine.LW_SEASON_EFFECT_94024)
  elseif effectId == EffectDefine.LW_Collect_Add_71030 then
    local normalSpeed = GetEffectNumber(self, uuid, effectId)
    local LW_71030_LightWorker = 0
    if useLightWorkerMan then
      local stateMeta = LocalController:instance():getLine(TableName.StatusTab, 704016)
      if stateMeta and stateMeta.effect_num ~= nil and toInt(stateMeta.effect) == EffectDefine.LW_Collect_Add_71030 then
        LW_71030_LightWorker = tonumber(stateMeta.effect_num) or 0
      end
    end
    local ret = normalSpeed + LW_71030_LightWorker
    if GMUtils.GetBool(GMConst.ShowParkEffectNumberLog, false) then
      Logger.LogCustom("71030 = 71030.base + 704016.light")
      Logger.LogCustom(string.format("%.2f = %.2f + %.2f", ret, normalSpeed, LW_71030_LightWorker))
    end
    return ret
  else
    return GetEffectNumber(self, uuid, effectId)
  end
end

local function GetFreeScoutFormation(self)
  for _, v in pairs(self.InvestigateFormationList) do
    if v:IsFree() then
      return v
    end
  end
end

local SCOUT_CD = 60

function ArmyFormationDataManager:GetScoutCD(uuid)
  if not self.scoutTimestamp then
    self:LoadScoutCD()
  end
  local lastTime = self.scoutTimestamp[uuid] or 0
  return lastTime + SCOUT_CD
end

function ArmyFormationDataManager:SetScoutCD(uuid)
  if not self.scoutTimestamp then
    self:LoadScoutCD()
  end
  local now = UITimeManager:GetInstance():GetServerSeconds()
  self.scoutTimestamp[uuid] = now
  self:SaveScoutCD()
end

function ArmyFormationDataManager:SaveScoutCD()
  local saveString = ""
  local now = UITimeManager:GetInstance():GetServerSeconds()
  for uuid, time in pairs(self.scoutTimestamp) do
    if now > time + SCOUT_CD then
      self.scoutTimestamp[uuid] = nil
    else
      saveString = saveString .. uuid .. "," .. time .. "|"
    end
  end
  CommonUtil.PlayerPrefsSetString("SCOUT_CD_BY_UUID", saveString)
end

function ArmyFormationDataManager:LoadScoutCD()
  SCOUT_CD = LuaEntry.DataConfig:TryGetNum("scout_cd", "k1", 60)
  self.scoutTimestamp = {}
  local scoutCDString = CommonUtil.PlayerPrefsGetString("SCOUT_CD_BY_UUID", "")
  scoutCDString = string.split(scoutCDString, "|")
  for _, v in ipairs(scoutCDString) do
    local kvpair = string.split(v, ",")
    if #kvpair == 2 then
      self.scoutTimestamp[tonumber(kvpair[1])] = tonumber(kvpair[2])
    end
  end
end

function ArmyFormationDataManager:GetDominatorSquadIndex(dominatorUuid)
  if dominatorUuid then
    local list = self:GetCurFormationList()
    if list ~= nil then
      for _, v in pairs(list) do
        if v ~= nil and v.dominatorUuid ~= nil and v.dominatorUuid == dominatorUuid then
          return v.index
        end
      end
    end
  end
  return nil
end

function ArmyFormationDataManager:IsAnyWorldFormationOutside()
  local list = self.ArmyFormationList
  for _, v in pairs(list) do
    if not v:IsFree() then
      return true
    end
  end
  return false
end

function ArmyFormationDataManager:GetFormationUnlockTipStr(index)
  if index <= 4 then
    if index < 4 then
      local needLv = self:GetFormationUnlockLv(index)
      return Localization:GetString("truck_tips10011", needLv, index)
    else
      return Localization:GetString("city_trade_tips1015")
    end
  else
    Logger.LogError("\229\143\170\230\156\1374\228\184\170\229\176\143\233\152\159")
  end
end

local function GetNeedLvByBuildId(buildId)
  local needLv = 0
  local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, 1)
  if template then
    local preBuild = template:GetPreBuild()
    if preBuild and preBuild[1] and preBuild[1].level then
      needLv = preBuild[1].level
    end
  end
  return needLv
end

function ArmyFormationDataManager:GetFormationUnlockLv(index)
  local needLv = 0
  if index == 1 then
    if self.formation1NeedLv == nil then
      self.formation1NeedLv = GetNeedLvByBuildId(BuildingTypes.LW_BUILD_PARKINGLOT)
    end
    needLv = self.formation1NeedLv
  elseif index == 2 then
    if self.formation2NeedLv == nil then
      self.formation2NeedLv = GetNeedLvByBuildId(BuildingTypes.LW_BUILD_PARKINGLOT_TWO)
    end
    needLv = self.formation2NeedLv
  elseif index == 3 then
    if self.formation3NeedLv == nil then
      self.formation3NeedLv = GetNeedLvByBuildId(BuildingTypes.LW_BUILD_PARKINGLOT_THREE)
    end
    needLv = self.formation3NeedLv
  end
  return needLv
end

ArmyFormationDataManager.GetFreeScoutFormation = GetFreeScoutFormation
ArmyFormationDataManager.SaveDefenceFormation = SaveDefenceFormation
ArmyFormationDataManager.__init = __init
ArmyFormationDataManager.__delete = __delete
ArmyFormationDataManager.GetCurFormationList = GetCurFormationList
ArmyFormationDataManager.GetCurFormationSlotIndexList = GetCurFormationSlotIndexList
ArmyFormationDataManager.InitArmyFormationListData = InitArmyFormationListData
ArmyFormationDataManager.ChangeFormationNameData = ChangeFormationNameData
ArmyFormationDataManager.GetOneArmyInfoByUuid = GetOneArmyInfoByUuid
ArmyFormationDataManager.GetOneArmyInfoByIndex = GetOneArmyInfoByIndex
ArmyFormationDataManager.GetOneArmyInfoByBuildingUuid = GetOneArmyInfoByBuildingUuid
ArmyFormationDataManager.GetArmyFormationIdList = GetArmyFormationIdList
ArmyFormationDataManager.GetSoliderFreeNumInFormationById = GetSoliderFreeNumInFormationById
ArmyFormationDataManager.GetArmyUnFormationList = GetArmyUnFormationList
ArmyFormationDataManager.GetArmyFormationList = GetArmyFormationList
ArmyFormationDataManager.SetArmyFormationSoldier = SetArmyFormationSoldier
ArmyFormationDataManager.GetAlreadySetCountInArmyFormation = GetAlreadySetCountInArmyFormation
ArmyFormationDataManager.GetFreeCountInArmyFormation = GetFreeCountInArmyFormation
ArmyFormationDataManager.AutoClearFormationData = AutoClearFormationData
ArmyFormationDataManager.AutoInitFormationData = AutoInitFormationData
ArmyFormationDataManager.SetArmyFormationHero = SetArmyFormationHero
ArmyFormationDataManager.AutoAddHero = AutoAddHero
ArmyFormationDataManager.AutoAddSoldier = AutoAddSoldier
ArmyFormationDataManager.GetDefenceArmyFormationData = GetDefenceArmyFormationData
ArmyFormationDataManager.GetMarchArmyWeight = GetMarchArmyWeight
ArmyFormationDataManager.GetConfigData = GetConfigData
ArmyFormationDataManager.GetCurStaminaByUuid = GetCurStaminaByUuid
ArmyFormationDataManager.GetInvestigateFormationList = GetInvestigateFormationList
ArmyFormationDataManager.GetInvestigateFormationInfoByIndex = GetInvestigateFormationInfoByIndex
ArmyFormationDataManager.GetMaxInvesFormationCount = GetMaxInvesFormationCount
ArmyFormationDataManager.RefreshFormationModelToJson = RefreshFormationModelToJson
ArmyFormationDataManager.PackageFormationFormToSFSObj = PackageFormationFormToSFSObj
ArmyFormationDataManager.GetArmyFormInfoByUuid = GetArmyFormInfoByUuid
ArmyFormationDataManager.AutoAddSoldierByForm = AutoAddSoldierByForm
ArmyFormationDataManager.GetFirstFormationUnlockScienceId = GetFirstFormationUnlockScienceId
ArmyFormationDataManager.GetResSupportFormationList = GetResSupportFormationList
ArmyFormationDataManager.GetFreeResSupportFormation = GetFreeResSupportFormation
ArmyFormationDataManager.CheckIfIsScountFormation = CheckIfIsScountFormation
ArmyFormationDataManager.GetFormationFormDataByHeroUuid = GetFormationFormDataByHeroUuid
ArmyFormationDataManager.HasStaminaEnoughFormation = HasStaminaEnoughFormation
ArmyFormationDataManager.CheckDetectEventStamina = CheckDetectEventStamina
ArmyFormationDataManager.AutoCheckDetectEventStamina = AutoCheckDetectEventStamina
ArmyFormationDataManager.DeleteTimer = DeleteTimer
ArmyFormationDataManager.AddTimer = AddTimer
ArmyFormationDataManager.GetMarchArmyNum = GetMarchArmyNum
ArmyFormationDataManager.IsAllFormationFree = IsAllFormationFree
ArmyFormationDataManager.GetBattleFieldFormationList = GetBattleFieldFormationList
ArmyFormationDataManager.GetGolloesFormationList = GetGolloesFormationList
ArmyFormationDataManager.GetConfirmFlag = GetConfirmFlag
ArmyFormationDataManager.SetConfirmFlag = SetConfirmFlag
ArmyFormationDataManager.HasUnsetFormation = HasUnsetFormation
ArmyFormationDataManager.GetArmyFormationHeroCanLevelUpUuid = GetArmyFormationHeroCanLevelUpUuid
ArmyFormationDataManager.GetFormationHeroCanChangeHigherUuid = GetFormationHeroCanChangeHigherUuid
ArmyFormationDataManager.AutoInitFormationDataForCollect = AutoInitFormationDataForCollect
ArmyFormationDataManager.AutoAddHeroForCollect = AutoAddHeroForCollect
ArmyFormationDataManager.IsFormationUnsetByIndex = IsFormationUnsetByIndex
ArmyFormationDataManager.SendFormToServer = SendFormToServer
ArmyFormationDataManager.IsHeroInSquad = IsHeroInSquad
ArmyFormationDataManager.GetHeroSquadIndex = GetHeroSquadIndex
ArmyFormationDataManager.UpdateArmyFormationListData = UpdateArmyFormationListData
ArmyFormationDataManager.UpdateTemplateFormationListData = UpdateTemplateFormationListData
ArmyFormationDataManager.GetTemplateFormationByIndex = GetTemplateFormationByIndex
ArmyFormationDataManager.IsHeroInFormationTemplate = IsHeroInFormationTemplate
ArmyFormationDataManager.IsHeroInDefenceFormation = IsHeroInDefenceFormation
ArmyFormationDataManager.HasArmyFormationInIndex = HasArmyFormationInIndex
ArmyFormationDataManager.RefreshFormationSoldier = RefreshFormationSoldier
ArmyFormationDataManager.GetFormationByType = GetFormationByType
ArmyFormationDataManager.GetDefenceFormation = GetDefenceFormation
ArmyFormationDataManager.GetFormationBurdenByUuid = GetFormationBurdenByUuid
ArmyFormationDataManager.GetFormationPowerByUuid = GetFormationPowerByUuid
ArmyFormationDataManager.GetAllTotalSoldierNum = GetAllTotalSoldierNum
ArmyFormationDataManager.FetchFormationSoldier = FetchFormationSoldier
ArmyFormationDataManager.CreateFakeArmyFormation = CreateFakeArmyFormation
ArmyFormationDataManager.GetFormationIndexByBuildingType = GetFormationIndexByBuildingType
ArmyFormationDataManager.GetUnlockFormationCount = GetUnlockFormationCount
ArmyFormationDataManager.GetArmyFormationIdListSortByDefencePriority = GetArmyFormationIdListSortByDefencePriority
ArmyFormationDataManager.OnPushFormationEffectNumber = OnPushFormationEffectNumber
ArmyFormationDataManager.GetEffectResult = GetEffectResult
ArmyFormationDataManager.GetHeroUuidListInSquad = GetHeroUuidListInSquad
ArmyFormationDataManager.GetHeroFormationInfoBySquadIndex = GetHeroFormationInfoBySquadIndex
return ArmyFormationDataManager
