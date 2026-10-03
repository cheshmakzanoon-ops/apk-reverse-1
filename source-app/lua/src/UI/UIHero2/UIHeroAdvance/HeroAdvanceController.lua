local HeroAdvanceController = BaseClass("HeroAdvanceController", Singleton)
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local LAST_CAN_ADVANCE_NUM = "LAST_CAN_ADVANCE_NUM"

local function __init(self)
  self.consumeMap = {}
  self.lastCanAdvanceNum = 0
end

local function __delete(self)
  self.consumeMap = nil
  self.curAdvanceUuid = nil
  self.lastCanAdvanceNum = nil
end

local function SetAdvanceHeroUuid(self, heroUuid)
  self.curAdvanceUuid = heroUuid
  self.consumeMap = {}
end

local function GetAdvanceHeroUuid(self)
  return self.curAdvanceUuid
end

local function GetAdvanceHeroData(self)
  if self.curAdvanceUuid == nil then
    return nil
  end
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.curAdvanceUuid)
  return heroData
end

local function IsConsumeFull(self)
  if self.curAdvanceUuid == nil or self.consumeMap == nil then
    return false
  end
  local coreHeroData = DataCenter.HeroDataManager:GetHeroByUuid(self.curAdvanceUuid)
  local requireNum = coreHeroData:GetAdvanceConsume():GetTotalNeedNum()
  return requireNum <= table.count(self.consumeMap)
end

local function GetCurConsumeMap(self)
  return self.consumeMap or {}
end

local function IsAlreadySelect(self, heroUuid)
  if self.curAdvanceUuid == nil or self.consumeMap == nil then
    return false
  end
  local key = table.keyof(self.consumeMap, heroUuid)
  return key ~= nil, key
end

local function OnToggleDogFood(self, heroUuid)
  local ret, key = self:IsAlreadySelect(heroUuid)
  if ret then
    self.consumeMap[key] = nil
  else
    local coreHeroData = DataCenter.HeroDataManager:GetHeroByUuid(self.curAdvanceUuid)
    local selfHeroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    local consume = coreHeroData:GetAdvanceConsume()
    local _, sameHeroNum = consume:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Hero)
    local _, sameCampNum = consume:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Camp)
    local canEatSameHero = coreHeroData:CanAdvanceEatOther(selfHeroData, HeroAdvanceConsumeType.ConsumeType_Same_Hero)
    local canEatSameCamp = coreHeroData:CanAdvanceEatOther(selfHeroData, HeroAdvanceConsumeType.ConsumeType_Same_Camp)
    sameHeroNum = sameHeroNum or 0
    sameCampNum = sameCampNum or 0
    for i = 1, HeroUtils.ConsumeSlotMax do
      if self.consumeMap[i] == nil then
        if i <= sameHeroNum then
          if canEatSameHero then
            self.consumeMap[i] = heroUuid
            break
          end
        elseif canEatSameCamp then
          self.consumeMap[i] = heroUuid
          break
        end
      end
    end
  end
end

local function GetAdvanceConfigByQuality(self, configQuality)
  local config = LocalController:instance():getLine(TableName.NewHeroesQuality, configQuality)
  return config
end

local function GetCurAdvanceRequireNum(self)
  if self.curAdvanceUuid == nil then
    return 0
  end
  local coreHeroData = DataCenter.HeroDataManager:GetHeroByUuid(self.curAdvanceUuid)
  local requireNum = coreHeroData:GetAdvanceConsume():GetTotalNeedNum()
  return requireNum
end

local function OnHandleHeroOneKeyAdvance(self, message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    local lang = Localization:GetString(errorCode)
    local str = lang or errorCode
    UIUtil.ShowTips(lang or str)
    return
  end
  if message.heros ~= nil then
    table.walk(message.heros, function(_, v)
      DataCenter.HeroDataManager:UpdateOneHero(v)
    end)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvanceOneKeySuccess, {anim = true, playEffect = false}, message.heros)
  end
  DataCenter.HeroDataManager:RemoveHeroes(message.rmHeroes)
  EventManager:GetInstance():Broadcast(EventId.OnOneKeyAdvanceSuccess, message)
end

local function OnHandleHeroAdvance(self, message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    local lang = Localization:GetString(errorCode)
    local str = lang or errorCode
    UIUtil.ShowTips(lang or str)
    return
  end
  self:SetAdvanceHeroUuid(nil)
  DataCenter.HeroDataManager:UpdateOneHero(message.heroInfo)
  DataCenter.HeroDataManager:RemoveHeroes(message.rmHeroes)
  EventManager:GetInstance():Broadcast(EventId.HeroAdvanceSuccess, message)
  EventManager:GetInstance():Broadcast(EventId.HeroStationUpdate)
end

local function HasRaritySOrAHeroInConsume(self)
  local coreData = self:GetAdvanceHeroData()
  local consumeMap = self:GetCurConsumeMap()
  local requireType2 = coreData:GetAdvanceConsume():GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Camp)
  if requireType2 == nil then
    return false
  end
  local ret, str = false, ""
  local heroIdList = {}
  for _, heroUuid in ipairs(consumeMap) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData.heroId ~= coreData.heroId and not table.hasvalue(heroIdList, heroData.heroId) then
      table.insert(heroIdList, heroData.heroId)
      if heroData ~= nil and (heroData.rarity == HeroUtils.RarityType.S or heroData.rarity == HeroUtils.RarityType.A) then
        local heroName = string.format("<color='%s'>%s</color>", HeroUtils.GetQualityColorStr(heroData.quality), heroData:GetName())
        ret = true
        str = str .. (str == "" and "" or "\227\128\129") .. heroName
      end
    end
  end
  return ret, str
end

local function HasStationedHeroInConsume(self)
  local consumeMap = self:GetCurConsumeMap()
  local ret, heroNames, buildNames = false, {}, {}
  for _, heroUuid in ipairs(consumeMap) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    local stationId = DataCenter.HeroStationManager:GetHeroStationId(heroUuid)
    if stationId ~= nil then
      local buildId = DataCenter.HeroStationManager:GetBuildIdByStationId(stationId)
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      ret = true
      table.insert(heroNames, heroData:GetName())
      table.insert(buildNames, Localization:GetString(tostring(buildTemplate.name)))
    end
  end
  return ret, heroNames, buildNames
end

local function HasFullDogForCore(self, coreHeroData)
  local sameHeroCount = 0
  local sameCampCount = 0
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  local advanceCondition = coreHeroData:GetAdvanceConsume()
  local _, sameHeroNeed = advanceCondition:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Hero)
  local _, sameCampNeed = advanceCondition:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Camp)
  sameHeroNeed = sameHeroNeed or 0
  sameCampNeed = sameCampNeed or 0
  for _, v in pairs(allHeroes) do
    if v.uuid ~= coreHeroData.uuid then
      if sameHeroCount < sameHeroNeed and coreHeroData:CanAdvanceEatOther(v, HeroAdvanceConsumeType.ConsumeType_Same_Hero) then
        sameHeroCount = sameHeroCount + 1
      elseif sameCampCount < sameCampNeed and coreHeroData:CanAdvanceEatOther(v, HeroAdvanceConsumeType.ConsumeType_Same_Camp) then
        sameCampCount = sameCampCount + 1
      end
      if sameHeroNeed <= sameHeroCount and sameCampNeed <= sameCampCount then
        return true
      end
    end
  end
  return false
end

local function GetRedDotShowNum(self)
  local k3 = LuaEntry.DataConfig:TryGetStr("free_heroes", "k6")
  local vec1 = string.split(k3, "|")
  local mainLv = DataCenter.BuildManager.MainLv
  local needNum = -1
  local maxNum = 0
  local total = #vec1
  for i = 1, total do
    local vec2 = string.split(vec1[total - i + 1], ";")
    if table.count(vec2) == 2 then
      local lv = toInt(vec2[1])
      maxNum = toInt(vec2[2])
      if mainLv >= lv then
        needNum = maxNum
        break
      end
    end
  end
  if needNum < 0 then
    needNum = maxNum
  end
  return needNum
end

local function GetCanAdvanceNumForBubbleTip(self)
  local needNum = self:GetRedDotShowNum()
  for _, v in ipairs(HeroUtils.HeroAllCamps) do
    local curCanAdvanceNum = self:GetAdvanceHeroNum(v, needNum)
    if 1 <= curCanAdvanceNum then
      return 1
    end
  end
  return 0
end

local function CanShowAdvanceBubble(self)
  local curCanAdvanceNum = self:GetCanAdvanceNumForBubbleTip()
  return 0 < curCanAdvanceNum
end

local function UpdateAdvanceNum(self)
  self.lastCanAdvanceNum = self:GetCanAdvanceNumForBubbleTip()
  EventManager:GetInstance():Broadcast(EventId.CheckPubBubble)
end

local function SetPreStoreAdvanceNum(self)
  local key = LuaEntry.Player.uid .. "_Advance_Num"
  local num = self:GetAdvanceHeroNum(-1)
  Setting:SetInt(key, num)
end

local function GetPreStoreAdvanceNum(self)
  local key = LuaEntry.Player.uid .. "_Advance_Num"
  local num = Setting:GetInt(key, 0)
  return num
end

local function HasHeroCanAdvance(self, quality)
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  local heroes = table.values(allHeroes)
  for _, heroData in pairs(heroes) do
    if heroData.quality == quality then
      local canAdvance = self:HasFullDogForCore(heroData)
      if canAdvance then
        return true
      end
    end
  end
  return false
end

local function GetAdvanceHeroNum(self, camp, checkNum)
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  local heroes = table.values(allHeroes)
  checkNum = checkNum or 1
  local count = 0
  for _, heroData in pairs(heroes) do
    if (not (0 <= camp) or camp == heroData.camp) and not heroData.isMaster and (heroData.rarity == HeroUtils.RarityType.C or heroData.rarity == HeroUtils.RarityType.B) and heroData.quality <= Poster_Show_Bubble_Quality then
      local canAdvance = self:HasFullDogForCore(heroData)
      if canAdvance then
        count = count + 1
        if checkNum <= count then
          return 1
        end
      end
    end
  end
  return 0
end

local function GetRedPointState(self, camp)
  local needNum = self:GetRedDotShowNum()
  local curCanAdvanceNum = self:GetAdvanceHeroNum(camp, needNum)
  return 0 < curCanAdvanceNum
end

local function CanEatHero(self, coreHero, eatHero)
  if eatHero == nil or coreHero == nil then
    return false
  end
  local consume = coreHero:GetAdvanceConsume()
  local _, sameHeroNum = consume:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Hero)
  local _, sameCampNum = consume:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Camp)
  local canEatSameHero = coreHero:CanAdvanceEatOther(eatHero, HeroAdvanceConsumeType.ConsumeType_Same_Hero)
  local canEatSameCamp = coreHero:CanAdvanceEatOther(eatHero, HeroAdvanceConsumeType.ConsumeType_Same_Camp)
  sameHeroNum = sameHeroNum or 0
  sameCampNum = sameCampNum or 0
  local currentSameHeroNum = 0
  local index = 1
  while sameHeroNum >= index do
    if self.consumeMap[index] ~= nil then
      currentSameHeroNum = currentSameHeroNum + 1
    end
    index = index + 1
  end
  if 0 < sameHeroNum and sameHeroNum > currentSameHeroNum and canEatSameHero then
    return true
  end
  local currentSameCampNum = 0
  while index <= sameCampNum + sameHeroNum do
    if self.consumeMap[index] ~= nil then
      currentSameCampNum = currentSameCampNum + 1
    end
    index = index + 1
  end
  if 0 < sameCampNum and sameCampNum > currentSameCampNum and canEatSameCamp then
    return true
  end
  return false
end

local function HasHeroAdvanced(self)
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  for _, v in pairs(allHeroes) do
    if v ~= nil and v.quality > 1 then
      return true
    end
  end
  return false
end

HeroAdvanceController.__init = __init
HeroAdvanceController.__delete = __delete
HeroAdvanceController.SetAdvanceHeroUuid = SetAdvanceHeroUuid
HeroAdvanceController.GetAdvanceHeroUuid = GetAdvanceHeroUuid
HeroAdvanceController.GetAdvanceHeroData = GetAdvanceHeroData
HeroAdvanceController.IsConsumeFull = IsConsumeFull
HeroAdvanceController.GetCurConsumeMap = GetCurConsumeMap
HeroAdvanceController.IsAlreadySelect = IsAlreadySelect
HeroAdvanceController.GetAdvanceConfigByQuality = GetAdvanceConfigByQuality
HeroAdvanceController.OnToggleDogFood = OnToggleDogFood
HeroAdvanceController.GetCurAdvanceRequireNum = GetCurAdvanceRequireNum
HeroAdvanceController.OnHandleHeroAdvance = OnHandleHeroAdvance
HeroAdvanceController.HasRaritySOrAHeroInConsume = HasRaritySOrAHeroInConsume
HeroAdvanceController.HasStationedHeroInConsume = HasStationedHeroInConsume
HeroAdvanceController.HasFullDogForCore = HasFullDogForCore
HeroAdvanceController.CanShowAdvanceBubble = CanShowAdvanceBubble
HeroAdvanceController.UpdateAdvanceNum = UpdateAdvanceNum
HeroAdvanceController.GetCanAdvanceNumForBubbleTip = GetCanAdvanceNumForBubbleTip
HeroAdvanceController.GetRedPointState = GetRedPointState
HeroAdvanceController.GetPreStoreAdvanceNum = GetPreStoreAdvanceNum
HeroAdvanceController.SetPreStoreAdvanceNum = SetPreStoreAdvanceNum
HeroAdvanceController.GetAdvanceHeroNum = GetAdvanceHeroNum
HeroAdvanceController.OnHandleHeroOneKeyAdvance = OnHandleHeroOneKeyAdvance
HeroAdvanceController.CanEatHero = CanEatHero
HeroAdvanceController.HasHeroCanAdvance = HasHeroCanAdvance
HeroAdvanceController.GetRedDotShowNum = GetRedDotShowNum
HeroAdvanceController.HasHeroAdvanced = HasHeroAdvanced
return HeroAdvanceController
