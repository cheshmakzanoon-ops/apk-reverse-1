local UIPVESceneCtrl = BaseClass("UIPVESceneCtrl", UIBaseCtrl)
local Const = require("Scene.PVEBattleLevel.Const")

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self, onKeyFill)
  self.curHeroes = {}
  self.curSoldiers = {}
  local freeSoldiers = DataCenter.ArmyManager:GetArmyDataForPve()
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
  if onKeyFill then
    self:OnOneKeyFillClick()
  end
end

local function GetCurrentHeroDataList(self, camp)
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroBySort()
  local hiredHeroes = DataCenter.BattleLevel.heroMgr:GetHiredHeroes()
  local heroes = {}
  for _, v in pairs(allHeroes) do
    table.insert(heroes, v)
  end
  for _, v in pairs(hiredHeroes) do
    table.insert(heroes, v)
  end
  local maxHeroLevel = DataCenter.BattleLevel:GetMaxHeroLevel()
  table.sort(heroes, function(heroA, heroB)
    if heroA.level > maxHeroLevel and heroB.level <= maxHeroLevel then
      return false
    end
    if heroA.level <= maxHeroLevel and heroB.level > maxHeroLevel then
      return true
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
    if not DataCenter.BattleLevel.heroMgr:IsHeroBanned(heroData.heroId) then
      if camp ~= nil and -1 < camp then
        local targetCamp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
        if targetCamp == camp then
          table.insert(result, heroData.uuid)
        end
      else
        table.insert(result, heroData.uuid)
      end
    end
  end
  return result
end

local function GetHeroDataByUuid(self, heroUuid)
  local data = {}
  local heroData = DataCenter.BattleLevel:GetPveHeroData(heroUuid)
  local heroConfig = heroData:GetConfig()
  local camp = heroConfig.camp
  local rarity = heroConfig.rarity
  data.hero_rarity = HeroUtils.GetRarityIconName(rarity, true)
  data.rankId = heroData:GetRank()
  data.heroUuid = heroUuid
  data.heroId = heroData.heroId
  data.qualityIndex = heroData.quality
  data.quality = HeroUtils.GetQualityBgInTroopsByPath(heroData.quality)
  data.icon = HeroUtils.GetHeroBodyByHeroId(heroData.heroId)
  data.level = heroData.level
  data.camp = HeroUtils.GetCampIconPath(camp)
  data.armyAdd = HeroUtils.GetArmyLimit(heroData.level, data.rankId, heroConfig.rarity, heroData.heroId, heroData.quality)
  data.power = 0
  data.restCount = heroData.restCount
  local k1 = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
  local curAtk = heroData.atk
  local curDef = heroData.def
  local curPower = Mathf.Round((curAtk + curDef) * k1)
  local skillIdList = heroConfig.skill
  if type(skillIdList) ~= "table" then
    skillIdList = string.split(skillIdList, "|")
  end
  for i = 1, #skillIdList do
    local skill = {}
    skill.id = tonumber(skillIdList[i])
    skill.level = 0
    local skillData = heroData:GetSkillData(skill.id)
    if skillData ~= nil and skillData:IsUnlock() then
      skill.level = skillData.level
      local powerStr = GetTableData(TableName.SkillTab, skill.id, "power")
      local strArr = string.split(powerStr, "|")
      if #strArr >= skill.level then
        local num = tonumber(strArr[skill.level])
        if num == nil then
        else
          curPower = curPower + tonumber(strArr[skill.level])
        end
      end
    end
  end
  data.power = curPower
  data.index = 0
  data.rarity = rarity
  data.isInMarch = false
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
  table.walk(self.curHeroes, function(k, v)
    if v == heroUuid then
      data.index = k
      data.isSelect = true
    else
      local tempHeroData = DataCenter.BattleLevel:GetPveHeroData(v)
      if tempHeroData ~= nil and tempHeroData.heroId == heroData.heroId then
        data.isLock = true
      end
    end
  end)
  return data
end

local function GetCurHeroNum(self)
  local levelType = DataCenter.BattleLevel:GetLevelType()
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.Adventure then
    return 99
  else
    return #self.curHeroes
  end
end

local function GetMaxHeroNum(self)
  local levelType = DataCenter.BattleLevel:GetLevelType()
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.MineCave then
    local _, formationUuid = DataCenter.MineCaveManager:GetBattleParam()
    local formationInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
    return MarchUtil.GetMaxHeroValueByFormationIndex(formationInfo.index)
  elseif levelType == PveLevelType.BattleExpLevel or levelType == PveLevelType.RadarExpLevel then
    return DataCenter.BattleLevel:GetMaxHeroCount()
  elseif entranceType == PveEntrance.ArenaSetting or entranceType == PveEntrance.ArenaBattle or entranceType == PveEntrance.AdventureSetting or entranceType == PveEntrance.Adventure then
    return MarchUtil.GetMaxHeroValueByFormationIndex(1)
  else
    local maxHeroNum = 0
    local k5 = LuaEntry.DataConfig:TryGetStr("aps_pve_config", "k5")
    local arr = string.split(k5, ";")
    local needLv = 100
    if 0 < #arr then
      for i = 1, #arr do
        local id = tonumber(arr[i])
        local level = DataCenter.BuildManager.MainLv
        if id ~= nil and level ~= nil and id <= level then
          maxHeroNum = maxHeroNum + 1
        end
      end
      if maxHeroNum < 5 and maxHeroNum + 1 <= #arr then
        needLv = tonumber(arr[maxHeroNum + 1])
      end
    end
    return math.min(maxHeroNum, 5), needLv
  end
end

local function SelectHeroByUuid(self, heroUuid)
  local tempIndex = 0
  local maxHeroNum, needLv = self:GetMaxHeroNum()
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.MineCave then
    local mineIndex, formationUuid = DataCenter.MineCaveManager:GetBattleParam()
    local formationInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
    maxHeroNum = MarchUtil.GetMaxHeroValueByFormationIndex(formationInfo.index)
  elseif entranceType == PveEntrance.ArenaSetting or entranceType == PveEntrance.ArenaBattle or entranceType == PveEntrance.AdventureSetting or entranceType == PveEntrance.Adventure then
    maxHeroNum = MarchUtil.GetMaxHeroValueByFormationIndex(1)
  end
  for i = 1, maxHeroNum do
    if tempIndex <= 0 and self.curHeroes[i] == nil then
      tempIndex = i
    end
  end
  if 0 < tempIndex then
    self.curHeroes[tempIndex] = heroUuid
    local heroData = DataCenter.BattleLevel:GetPveHeroData(heroUuid)
    if heroData ~= nil then
      EventManager:GetInstance():Broadcast(EventId.OnSelectPVEHeroSelect, heroData.heroId)
    end
  elseif 5 <= maxHeroNum then
    UIUtil.ShowTipsId(400034)
  else
    local levelType = DataCenter.BattleLevel:GetLevelType()
    if levelType == PveLevelType.BattleExpLevel or levelType == PveLevelType.RadarExpLevel then
      UIUtil.ShowTipsId(400035)
    elseif entranceType == PveEntrance.ArenaSetting or entranceType == PveEntrance.ArenaBattle or entranceType == PveEntrance.AdventureSetting or entranceType == PveEntrance.Adventure or entranceType == PveEntrance.MineCave then
      UIUtil.ShowTipsId(400035)
    else
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("400033", needLv, maxHeroNum + 1))
    end
  end
  self:OnOneKeyFillClick()
  PveActorMgr:GetInstance():SetHeros(self.curHeroes)
  self:SaveSelection(self.curHeroes)
end

local function SaveSelection(self, heroes)
  if heroes ~= nil then
    local pveHeroes = table.concat(heroes, ";")
    local uid = LuaEntry.Player.uid
    local levelType = DataCenter.BattleLevel:GetLevelType()
    local entryType = DataCenter.BattleLevel:GetEntranceType()
    if entryType == PveEntrance.ArenaBattle then
      local str = "ArenaPveCacheHeroes_" .. LuaEntry.Player.uid
      CS.GameEntry.Setting:SetString(str, pveHeroes)
    elseif entryType == PveEntrance.ArenaSetting then
    elseif entryType == PveEntrance.AdventureSetting then
      Setting:SetPrivateString(SettingKeys.PVE_HEROES_ADVENTURE .. uid, pveHeroes)
    elseif entryType == PveEntrance.MineCave then
    else
      local trigger = PveActorMgr:GetInstance():GetCurTrigger()
      local triggerTypeStr = ""
      if trigger ~= nil and trigger:IsTypeLevelLimitMonster() then
        triggerTypeStr = tostring(Const.TriggerType.LevelLimitMonster)
      end
      Setting:SetPrivateString(SettingKeys.PVE_HEROES .. uid .. "_" .. tostring(levelType) .. triggerTypeStr, pveHeroes)
      Setting:SetPrivateString(SettingKeys.PVE_HEROES .. uid, pveHeroes)
    end
  end
end

local function OnDeleteHeroByIndex(self, index)
  local newList = {}
  for i = 1, #self.curHeroes do
    local uuid = self.curHeroes[i]
    local tempHeroData = DataCenter.BattleLevel:GetPveHeroData(uuid)
    if tempHeroData ~= nil then
      if index == i then
        EventManager:GetInstance():Broadcast(EventId.OnCancelPVEHeroSelect, tempHeroData.heroId)
      else
        local idx = #newList + 1
        newList[idx] = uuid
      end
    end
  end
  self.curHeroes = newList
  self:OnOneKeyFillClick()
  PveActorMgr:GetInstance():SetHeros(self.curHeroes)
  self:SaveSelection(self.curHeroes)
end

local function GetArmyIdList(self)
  return table.keys(self.maxSoldiers)
end

local function GetArmyData(self, armyId, isEm)
  local oneData = {}
  oneData.name = ""
  oneData.armyId = armyId
  oneData.maxNum = self.maxSoldiers[armyId]
  oneData.icon = ""
  oneData.level = 0
  local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
  if template ~= nil then
    oneData.name = template.name
    oneData.level = template.level
    if isEm ~= nil and isEm then
      local icon = template.icon
      oneData.icon = string.format(LoadPath.SoldierIcons, icon)
    else
      local icon = template.icon
      if template.arm == 3 then
        icon = "UInewbie_img_head2"
      elseif template.arm == 2 then
        icon = "UInewbie_img_head3"
      elseif template.arm == 1 then
        icon = "UInewbie_img_head1"
      end
      oneData.icon = string.format(LoadPath.Guide, icon)
    end
  end
  return oneData
end

local function GetCurrentSoldierNum(self, armyId)
  local num = 0
  if self.curSoldiers[armyId] ~= nil and 0 < self.curSoldiers[armyId] then
    num = self.curSoldiers[armyId]
  end
  return num
end

local function OnOneKeyFillClick(self)
  self.curSoldiers = {}
  local levelType = DataCenter.BattleLevel:GetLevelType()
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.ArenaBattle or entranceType == PveEntrance.ArenaSetting then
    local max = self:GetMaxNum()
    local armsConf = LuaEntry.DataConfig:TryGetStr("arena", "k10")
    local arrArmsConf = string.split(armsConf, ";")
    local perCount = math.modf(max / #arrArmsConf)
    local leftNum = max
    for i, v in ipairs(arrArmsConf) do
      if i == #arrArmsConf then
        self:SetCurrentSoldierNum(tonumber(v), leftNum)
      else
        self:SetCurrentSoldierNum(tonumber(v), perCount)
        leftNum = leftNum - perCount
      end
    end
  elseif levelType == PveLevelType.ArmyLevel and DataCenter.BattleLevel:GetArmyRecord() then
    local max = self:GetMaxNum()
    local armyRecord = DataCenter.BattleLevel:GetArmyRecord()
    local list = {}
    for id, count in pairs(armyRecord.alive) do
      table.insert(list, {id = id, count = count})
    end
    table.sort(list, function(a, b)
      local templateA = DataCenter.ArmyTemplateManager:GetArmyTemplate(a.id)
      local templateB = DataCenter.ArmyTemplateManager:GetArmyTemplate(b.id)
      if templateA.level ~= templateB.level then
        return templateA.level > templateB.level
      else
        return templateA.arm > templateB.arm
      end
    end)
    local rest = max
    for _, v in ipairs(list) do
      if rest >= v.count then
        rest = rest - v.count
        self:SetCurrentSoldierNum(tostring(v.id), v.count)
      else
        self:SetCurrentSoldierNum(tostring(v.id), rest)
        break
      end
    end
  else
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
end

local function CheckMax(self, armyId, num)
  local oneMaxNum = self.maxSoldiers[armyId]
  local oneCurrentNum = self:GetCurrentSoldierNum(armyId)
  local currentTotalNum = self:GetTotalSoldierNum()
  local restNum = currentTotalNum - oneCurrentNum
  local checkMax = math.min(oneMaxNum, num)
  local totalRest = self:GetMaxNum() - restNum
  local final = math.min(totalRest, checkMax)
  if final < 0 then
    final = 0
  end
  return final
end

local function GetTotalSoldierNum(self)
  local count = 0
  table.walk(self.curSoldiers, function(k, v)
    count = count + v
  end)
  return count
end

local function GetCurSoldierList(self)
  return self.curSoldiers
end

local function SetCurrentSoldierNum(self, armyId, num)
  if 0 < num then
    self.curSoldiers[armyId] = num
  else
    self.curSoldiers[armyId] = nil
  end
end

local function GetMaxNum(self)
  local heroes = {}
  table.walk(self.curHeroes, function(k, v)
    if v ~= nil then
      heroes[v] = k
    end
  end)
  local asPlayerMaxSoldiers = LuaEntry.DataConfig:TryGetNum("building_base", "k5")
  local baseSize = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_SIZE)
  local sizeEnhance = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_SIZE_ENHANCE)
  asPlayerMaxSoldiers = asPlayerMaxSoldiers + math.floor(baseSize + 0.5)
  local campAdd = 0
  if heroes ~= nil then
    table.walk(heroes, function(k, v)
      local heroData = DataCenter.BattleLevel:GetPveHeroData(k)
      if heroData ~= nil then
        local config = heroData:GetConfig()
        local rankId = heroData:GetRank()
        local armyAdd = HeroUtils.GetArmyLimit(heroData.level, rankId, config.rarity, heroData.heroId, heroData.quality)
        asPlayerMaxSoldiers = asPlayerMaxSoldiers + armyAdd
        local heroBaseSize = heroData:GetEffectNum(EffectDefine.APS_FORMATION_SIZE)
        local heroSizeEnhance = heroData:GetEffectNum(EffectDefine.APS_FORMATION_SIZE_ENHANCE)
        local campAddEffect = LuaEntry.Effect:GetGameEffect(HeroUtils.GetExtraTroopByCamp(heroData.camp))
        campAdd = campAddEffect + campAdd
        asPlayerMaxSoldiers = asPlayerMaxSoldiers + heroBaseSize
        sizeEnhance = sizeEnhance + heroSizeEnhance
      end
    end)
  end
  local formationIndex = 1
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.MineCave then
    local mineIndex, formationUuid = DataCenter.MineCaveManager:GetBattleParam()
    local formationInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
    formationIndex = formationInfo.index
  end
  local finalAddNumByIndex = MarchUtil.GetFormationMaxNumByFormationIndex(formationIndex)
  asPlayerMaxSoldiers = asPlayerMaxSoldiers + finalAddNumByIndex + campAdd
  asPlayerMaxSoldiers = asPlayerMaxSoldiers * (1 + sizeEnhance / 100)
  return math.floor(asPlayerMaxSoldiers)
end

UIPVESceneCtrl.Close = Close
UIPVESceneCtrl.InitData = InitData
UIPVESceneCtrl.GetCurrentHeroDataList = GetCurrentHeroDataList
UIPVESceneCtrl.GetHeroDataByUuid = GetHeroDataByUuid
UIPVESceneCtrl.SelectHeroByUuid = SelectHeroByUuid
UIPVESceneCtrl.OnDeleteHeroByIndex = OnDeleteHeroByIndex
UIPVESceneCtrl.GetArmyIdList = GetArmyIdList
UIPVESceneCtrl.GetArmyData = GetArmyData
UIPVESceneCtrl.GetCurrentSoldierNum = GetCurrentSoldierNum
UIPVESceneCtrl.OnOneKeyFillClick = OnOneKeyFillClick
UIPVESceneCtrl.CheckMax = CheckMax
UIPVESceneCtrl.GetTotalSoldierNum = GetTotalSoldierNum
UIPVESceneCtrl.SetCurrentSoldierNum = SetCurrentSoldierNum
UIPVESceneCtrl.GetMaxNum = GetMaxNum
UIPVESceneCtrl.SaveSelection = SaveSelection
UIPVESceneCtrl.GetCurHeroNum = GetCurHeroNum
UIPVESceneCtrl.GetMaxHeroNum = GetMaxHeroNum
UIPVESceneCtrl.GetCurSoldierList = GetCurSoldierList
return UIPVESceneCtrl
