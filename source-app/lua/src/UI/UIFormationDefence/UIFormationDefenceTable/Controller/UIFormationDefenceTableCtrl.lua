local UIFormationDefenceTableCtrl = BaseClass("UIFormationDefenceTableCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFormationDefenceTable)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function SetCurIndex(self, index)
  self.curIndex = index
end

local function InitData(self)
  self.formationList = DataCenter.ArmyFormationDataManager:GetDefenceArmyFormationData()
  local wallData = DataCenter.DefenceWallDataManager:GetConfigData()
  self.defenceFormationMaxSize = wallData.defenceFormationMaxSize
  self.defFormationFirstMaxCount = wallData.defFormationFirstMaxCount
  self.defFormationSecondMaxCount = wallData.defFormationSecondMaxCount
  self.defFormationThirdMaxCount = wallData.defFormationThirdMaxCount
  self.curFormationUuid = 0
  self:GetFormationEffect()
  self.buildTemplate = {}
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
  if buildTemplate ~= nil then
    self.buildTemplate.name = buildTemplate.name
    self.buildTemplate.formationUnLockIndex = {}
    self.buildTemplate.formationUnLockIndex[1] = {}
    local vecPara3 = string.split(buildTemplate.para3, "|")
    for _, v in ipairs(vecPara3) do
      local vec1 = string.split(v, ";")
      if 2 <= #vec1 then
        self.buildTemplate.formationUnLockIndex[1][tonumber(vec1[1])] = tonumber(vec1[2])
      end
    end
  end
end

local function GetBuildTemplateData(self)
  return self.buildTemplate
end

local function GetFormationEffect(self)
  local attack_base_arm = LuaEntry.Effect:GetGameEffect(EffectDefine.ATTACK_ADD_BASE_ALL_ARMY)
  local attack_arm1 = LuaEntry.Effect:GetGameEffect(EffectDefine.ATTACK_ADD_BASE_ARM_1)
  local attack_arm2 = LuaEntry.Effect:GetGameEffect(EffectDefine.ATTACK_ADD_BASE_ARM_2)
  local attack_arm3 = LuaEntry.Effect:GetGameEffect(EffectDefine.ATTACK_ADD_BASE_ARM_3)
  local attack_base_build = LuaEntry.Effect:GetGameEffect(EffectDefine.ATTACK_ADD_BUILD_ALL_ARMY)
  local attack_build1 = LuaEntry.Effect:GetGameEffect(EffectDefine.ATTACK_ADD_BUILD_ARM_1)
  local attack_build2 = LuaEntry.Effect:GetGameEffect(EffectDefine.ATTACK_ADD_BUILD_ARM_2)
  local attack_build3 = LuaEntry.Effect:GetGameEffect(EffectDefine.ATTACK_ADD_BUILD_ARM_3)
  self.attackEffect = attack_base_arm + math.max(attack_arm1, attack_arm2, attack_arm3) + attack_base_build + math.max(attack_build1, attack_build2, attack_build3)
  local defence_base_arm = LuaEntry.Effect:GetGameEffect(EffectDefine.DEFENCE_ADD_BASE_ALL_ARMY)
  local defence_arm1 = LuaEntry.Effect:GetGameEffect(EffectDefine.DEFENCE_ADD_BASE_ARM_1)
  local defence_arm2 = LuaEntry.Effect:GetGameEffect(EffectDefine.DEFENCE_ADD_BASE_ARM_2)
  local defence_arm3 = LuaEntry.Effect:GetGameEffect(EffectDefine.DEFENCE_ADD_BASE_ARM_3)
  local defence_base_build = LuaEntry.Effect:GetGameEffect(EffectDefine.DEFENCE_ADD_BUILD_ALL_ARMY)
  local defence_build1 = LuaEntry.Effect:GetGameEffect(EffectDefine.DEFENCE_ADD_BUILD_ARM_1)
  local defence_build2 = LuaEntry.Effect:GetGameEffect(EffectDefine.DEFENCE_ADD_BUILD_ARM_2)
  local defence_build3 = LuaEntry.Effect:GetGameEffect(EffectDefine.DEFENCE_ADD_BUILD_ARM_3)
  self.defenceEffect = defence_base_arm + math.max(defence_arm1, defence_arm2, defence_arm3) + defence_base_build + math.max(defence_build1, defence_build2, defence_build3)
  self.k2 = LuaEntry.DataConfig:TryGetNum("battle_config", "k2")
  self.k5 = LuaEntry.DataConfig:TryGetNum("battle_config", "k5")
end

local function GetFormationIdList(self)
  self.myFormationIndex = 0
  local idList = {}
  table.walksort(self.formationList, function(leftKey, rightKey)
    return self.formationList[leftKey].index < self.formationList[rightKey].index
  end, function(k, v)
    self.myFormationIndex = v.index
    table.insert(idList, k)
  end)
  return idList
end

local function GetBuildData(self)
  local data = {}
  local wallData = DataCenter.DefenceWallDataManager:GetConfigData()
  data.defDomeMaxNum = wallData.defDomeMaxNum
  data.defDomeAddSpeed = wallData.defDomeAddSpeed
  data.fixPercentOnce = wallData.fixPercentOnce
  data.fixDiamond = wallData.fixDiamond
  data.fixColdDownTime = wallData.fixColdDownTime
  local defenceData = DataCenter.DefenceWallDataManager:GetDefenceWallData()
  if defenceData ~= nil then
    local durability = defenceData.durability
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local addNum = (curTime - defenceData.lastDurabilityTime) / 1000 * wallData.defDomeAddSpeed
    local realDurabilityNum = durability + math.max(addNum, 0)
    data.durability = math.min(realDurabilityNum, wallData.defDomeMaxNum)
    data.lastGoldRecoverDurabilityTime = defenceData.lastGoldRecoverDurabilityTime
    data.lastDurabilityTime = defenceData.lastDurabilityTime
  end
  return data
end

local function SelectCurFormationUuid(self, uuid)
  self.curFormationUuid = uuid
end

local function GetCurrentHeroDataList(self)
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroBySort()
  local heroes = table.values(allHeroes)
  table.sort(heroes, function(heroA, heroB)
    if heroA.state ~= heroB.state then
      return heroA.state < heroB.state
    end
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
    table.insert(result, heroData.uuid)
  end
  return result
end

local function GetHeroIdInFormationWithOutCurIndex(self)
  local heroIdList = {}
  table.walk(self.formationList, function(k, v)
    if k ~= self.curFormationUuid then
      table.walk(v.heroes, function(a, b)
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(a)
        if heroData ~= nil then
          heroIdList[heroData.heroId] = 1
        end
      end)
    end
  end)
  return heroIdList
end

local function GetIsInFormationWithoutCurIndex(self, uuid)
  local isIn = false
  local curFormationIndex = 0
  table.walk(self.formationList, function(k, v)
    if isIn == false then
      if k ~= self.curFormationUuid then
        table.walk(v.heroes, function(a, b)
          if a == uuid then
            isIn = true
          end
        end)
      end
      if isIn then
        curFormationIndex = self.myFormationIndex
      end
    end
  end)
  return curFormationIndex
end

local function GetHeroDataByUuid(self, heroUuid)
  local data = {}
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  data.heroUuid = heroUuid
  data.heroId = heroData.heroId
  data.icon = HeroUtils.GetHeroBodyByHeroId(heroData.heroId)
  data.level = heroData.level
  data.index = 0
  data.isInMarch = false
  data.isSelect = false
  data.isInSelectFormationIndex = 0
  data.isLock = false
  if heroData.state == ArmyFormationState.March then
    data.isInMarch = true
    local curFormation = self.formationList[self.curFormationUuid]
    if curFormation ~= nil and curFormation.heroes ~= nil then
      table.walk(curFormation.heroes, function(k, v)
        if k == heroUuid then
          data.index = v
        end
      end)
    end
  else
    local inMarchHeroId = DataCenter.HeroDataManager:GetHeroIdListInMarch()
    if inMarchHeroId[heroData.heroId] ~= nil then
      data.isLock = true
    else
      local index = self:GetIsInFormationWithoutCurIndex(heroUuid)
      if 0 < index then
        data.isInSelectFormationIndex = index
      else
        local heroList = self:GetHeroIdInFormationWithOutCurIndex()
        if heroList[heroData.heroId] ~= nil then
          data.isLock = true
        else
          local curFormation = self.formationList[self.curFormationUuid]
          if curFormation ~= nil and curFormation.heroes ~= nil then
            table.walk(curFormation.heroes, function(k, v)
              if k == heroUuid then
                data.index = v
                data.isSelect = true
              else
                local tempHeroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
                if tempHeroData ~= nil and tempHeroData.heroId == heroData.heroId then
                  data.isLock = true
                end
              end
            end)
          end
        end
      end
    end
  end
  return data
end

local function GetCurHeroData(self, formationUuid)
  local heroData = {}
  if self.formationList[formationUuid] ~= nil then
    table.walk(self.formationList[formationUuid].heroes, function(k, v)
      local data = DataCenter.HeroDataManager:GetHeroByUuid(k)
      if data ~= nil then
        heroData[v] = k
      end
    end)
  end
  return heroData
end

local function SetCurrentHeroList(self, formationUuid, heroData)
  local heroes = {}
  if self.formationList[formationUuid] ~= nil then
    table.walk(heroData, function(k, v)
      heroes[v] = k
    end)
  end
  self.formationList[formationUuid].heroes = heroes
end

local function SelectHeroByUuid(self, heroUuid)
  local tempIndex = 0
  local formationIndex = self.myFormationIndex
  local maxHeroNum = 0
  if formationIndex == 1 then
    maxHeroNum = self.defFormationFirstMaxCount
  elseif formationIndex == 2 then
    maxHeroNum = self.defFormationSecondMaxCount
  elseif formationIndex == 3 then
    maxHeroNum = self.defFormationThirdMaxCount
  end
  if 0 < maxHeroNum then
    local heroData = self:GetCurHeroData(self.curFormationUuid)
    for i = 1, maxHeroNum do
      if tempIndex <= 0 and heroData[i] == nil then
        tempIndex = i
      end
    end
    if 0 < tempIndex then
      heroData[tempIndex] = heroUuid
      self:SetCurrentHeroList(self.curFormationUuid, heroData)
      local tempHeroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if tempHeroData ~= nil then
        EventManager:GetInstance():Broadcast(EventId.OnSelectHeroSelect, tempHeroData.heroId)
      end
    end
  end
end

local function GetMaxHeroNumByFormationUuid(self, formationUuid)
  return 5
end

local function OnDeleteHeroByIndex(self, index)
  local heroData = self:GetCurHeroData(self.curFormationUuid)
  if heroData[index] ~= nil then
    local uuid = 0
    uuid = heroData[index]
    heroData[index] = nil
    local tempHeroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
    self:SetCurrentHeroList(self.curFormationUuid, heroData)
    if tempHeroData ~= nil then
      EventManager:GetInstance():Broadcast(EventId.OnCancelHeroSelect, tempHeroData.heroId)
    end
  end
end

local function GetPowerData(self, formationUuid)
  local powerData = {}
  powerData.attackNum = 0
  powerData.defNum = 0
  local formation = self.formationList[formationUuid]
  local heroAttack = 0
  local heroDefence = 0
  if formation ~= nil then
    table.walk(formation.heroes, function(k, v)
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
      if heroData ~= nil then
        heroAttack = heroAttack + heroData.atk
        heroDefence = heroDefence + heroData.def
      end
    end)
  end
  powerData.attackNum = heroAttack * self.k2 + self.attackEffect
  powerData.defNum = heroDefence * self.k5 + self.defenceEffect
  return powerData
end

local function OnSaveDefenceFormation(self)
  if self.formationList ~= nil then
    table.walk(self.formationList, function(k, v)
      SFSNetwork.SendMessage(MsgDefines.DefenseInfoSave, k, v:GenerateServerHeroArray())
    end)
  end
end

local function fixDefencePower(self)
  local data = self:GetBuildData()
  local maxFixNum = data.defDomeMaxNum * data.fixPercentOnce / 100
  local diamondNum = data.fixDiamond
  local message = Localization:GetString(GameDialogDefine.FIX_DOME_CONFIRM, string.GetFormattedSeperatorNum(math.floor(diamondNum)), string.GetFormattedSeperatorNum(math.floor(maxFixNum)))
  UIUtil.ShowMessage(message, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    SFSNetwork.SendMessage(MsgDefines.CityDefenceAdd)
  end, function()
  end)
end

local function OnProtectClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICityManage, {anim = true, hideTop = true}, CityManageBuffType.WarGuard)
end

local function GetAllCityManageData(self)
  local retTb = {}
  local conf = DataCenter.CityManageDataManager:GetAllCityManageData()
  for i, group in ipairs(conf) do
    local groupContent = {}
    for j, buff in ipairs(group) do
      if buff.id == CityManageBuffType.GolloesFever or buff.id == CityManageBuffType.GolloesGuard then
        local timeInfo = DataCenter.StatusManager:GetBuffTimeInfo(buff.status)
        if timeInfo and timeInfo.endTime ~= nil and timeInfo.totalTime ~= nil then
          table.insert(groupContent, buff)
        end
      else
        table.insert(groupContent, buff)
      end
    end
    if 0 < #groupContent then
      table.insert(retTb, groupContent)
    end
  end
  return retTb
end

local function GetMyAssistanceData(self)
  local info = DataCenter.FormationAssistanceDataManager:GetMyAssistanceData()
  if info and info.memberList then
    local ret = {}
    for k, v in pairs(info.memberList) do
      table.insert(ret, v)
    end
    return ret
  end
  return nil
end

UIFormationDefenceTableCtrl.CloseSelf = CloseSelf
UIFormationDefenceTableCtrl.Close = Close
UIFormationDefenceTableCtrl.InitData = InitData
UIFormationDefenceTableCtrl.OnDeleteHeroByIndex = OnDeleteHeroByIndex
UIFormationDefenceTableCtrl.SelectHeroByUuid = SelectHeroByUuid
UIFormationDefenceTableCtrl.GetHeroDataByUuid = GetHeroDataByUuid
UIFormationDefenceTableCtrl.GetCurrentHeroDataList = GetCurrentHeroDataList
UIFormationDefenceTableCtrl.OnDeleteHeroByIndex = OnDeleteHeroByIndex
UIFormationDefenceTableCtrl.GetCurHeroData = GetCurHeroData
UIFormationDefenceTableCtrl.SetCurIndex = SetCurIndex
UIFormationDefenceTableCtrl.GetFormationIdList = GetFormationIdList
UIFormationDefenceTableCtrl.GetBuildData = GetBuildData
UIFormationDefenceTableCtrl.SetCurrentHeroList = SetCurrentHeroList
UIFormationDefenceTableCtrl.SelectCurFormationUuid = SelectCurFormationUuid
UIFormationDefenceTableCtrl.GetHeroIdInFormationWithOutCurIndex = GetHeroIdInFormationWithOutCurIndex
UIFormationDefenceTableCtrl.GetIsInFormationWithoutCurIndex = GetIsInFormationWithoutCurIndex
UIFormationDefenceTableCtrl.GetPowerData = GetPowerData
UIFormationDefenceTableCtrl.GetFormationEffect = GetFormationEffect
UIFormationDefenceTableCtrl.GetMaxHeroNumByFormationUuid = GetMaxHeroNumByFormationUuid
UIFormationDefenceTableCtrl.OnSaveDefenceFormation = OnSaveDefenceFormation
UIFormationDefenceTableCtrl.fixDefencePower = fixDefencePower
UIFormationDefenceTableCtrl.GetBuildTemplateData = GetBuildTemplateData
UIFormationDefenceTableCtrl.OnProtectClick = OnProtectClick
UIFormationDefenceTableCtrl.GetAllCityManageData = GetAllCityManageData
UIFormationDefenceTableCtrl.GetMyAssistanceData = GetMyAssistanceData
return UIFormationDefenceTableCtrl
