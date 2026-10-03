local UIHeroAdvanceCtrl = BaseClass("UIHeroAdvanceCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroAdvance)
end

local canAdvanceCache = {}

local function IsCanAdvance(hero)
  if canAdvanceCache[hero.uuid] ~= nil then
    return canAdvanceCache[hero.uuid]
  end
  local canAdvance = HeroAdvanceController:GetInstance():HasFullDogForCore(hero)
  canAdvanceCache[hero.uuid] = canAdvance
  return canAdvance
end

local function bool_to_number(b)
  return b and 1 or 0
end

local function SortForSameType(heroA, heroB, masterToInt)
  if masterToInt == 1 then
    if heroA.rarity ~= heroB.rarity then
      return heroA.rarity < heroB.rarity
    end
    if heroA.quality ~= heroB.quality then
      return heroA.quality > heroB.quality
    end
  else
    local rarityA = heroA.rarity
    local rarityB = heroB.rarity
    if rarityA == HeroUtils.RarityType.C then
      rarityA = HeroUtils.RarityType.B
    end
    if rarityB == HeroUtils.RarityType.C then
      rarityB = HeroUtils.RarityType.B
    end
    if rarityA ~= rarityB then
      return rarityA < rarityB
    end
    if heroA.quality ~= heroB.quality then
      return heroA.quality > heroB.quality
    elseif rarityA == HeroUtils.RarityType.B and heroA.rarity ~= heroB.rarity then
      return heroA.rarity < heroB.rarity
    end
    if heroA.heroId ~= heroB.heroId then
      return heroA.heroId < heroB.heroId
    end
  end
  return false
end

local function GetHeroListByCamp(self, camp, colMax, isGuide, guideQality)
  canAdvanceCache = {}
  isGuide = isGuide or false
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  local heroes = {}
  local maxMasterAdvanceRarity = HeroUtils.RarityType.B
  if camp == -1 then
    heroes = table.values(allHeroes)
  else
    for _, v in pairs(allHeroes) do
      if v.camp == camp then
        table.insert(heroes, v)
      end
    end
  end
  local canTipAdvanceNum = {}
  local hasBluePosterAdvance = false
  local heroDict = {}
  for _, heroData in pairs(heroes) do
    local masterToInt = heroData.isMaster and 1 or 0
    if heroDict[masterToInt] == nil then
      heroDict[masterToInt] = {}
    end
    if not heroData:IsMaxQuality() and IsCanAdvance(heroData) then
      canTipAdvanceNum[heroData.uuid] = 1
    end
    if heroData.isMaster and maxMasterAdvanceRarity > heroData.rarity then
      maxMasterAdvanceRarity = heroData.rarity
    end
    table.insert(heroDict[masterToInt], heroData)
  end
  for masterToInt, heroList in pairs(heroDict) do
    table.sort(heroList, function(heroA, heroB)
      return SortForSameType(heroA, heroB, masterToInt)
    end)
  end
  local keys = table.keys(heroDict)
  table.sort(keys, function(a, b)
    return b < a
  end)
  if isGuide == true and guideQality ~= nil then
    local find = false
    for _, masterToInt in ipairs(keys) do
      local heroList = heroDict[masterToInt]
      for k, hero in ipairs(heroList) do
        if hero.quality == guideQality and canTipAdvanceNum[hero.uuid] ~= nil then
          table.remove(heroList, k)
          table.insert(heroList, 1, hero)
          find = true
          break
        end
      end
      if find then
        break
      end
    end
  end
  local showDataList = {}
  for _, masterToInt in ipairs(keys) do
    if masterToInt == 0 then
      table.insert(showDataList, masterToInt)
    end
    local heroList = heroDict[masterToInt]
    local row = math.ceil(#heroList / colMax)
    for k = 1, row do
      local startIndex = colMax * (k - 1) + 1
      local endIndex = math.min(startIndex + colMax - 1, #heroList)
      local rowData = {
        table.unpack(heroList, startIndex, endIndex)
      }
      table.insert(showDataList, rowData)
    end
  end
  return showDataList, canTipAdvanceNum, maxMasterAdvanceRarity
end

local function GetDogFoods(self, colMax)
  local coreHeroData = HeroAdvanceController:GetInstance():GetAdvanceHeroData()
  local dogFoods = {}
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  local minRarity = HeroUtils.RarityType.S
  for _, v in pairs(allHeroes) do
    if v.uuid ~= coreHeroData.uuid and (coreHeroData:CanAdvanceEatOther(v, HeroAdvanceConsumeType.ConsumeType_Same_Hero) or coreHeroData:CanAdvanceEatOther(v, HeroAdvanceConsumeType.ConsumeType_Same_Camp)) then
      table.insert(dogFoods, v)
      if minRarity < v.rarity then
        minRarity = v.rarity
      end
    end
  end
  table.sort(dogFoods, function(heroA, heroB)
    local a_isInFormation = heroA:IsInFormation()
    local b_isInFormation = heroB:IsInFormation()
    if a_isInFormation ~= b_isInFormation then
      return bool_to_number(a_isInFormation) < bool_to_number(b_isInFormation)
    end
    local rarityA = heroA.rarity
    local rarityB = heroB.rarity
    if rarityA == HeroUtils.RarityType.C then
      rarityA = HeroUtils.RarityType.B
    elseif rarityA == HeroUtils.RarityType.B then
      rarityA = HeroUtils.RarityType.C
    end
    if rarityB == HeroUtils.RarityType.C then
      rarityB = HeroUtils.RarityType.B
    elseif rarityB == HeroUtils.RarityType.B then
      rarityB = HeroUtils.RarityType.C
    end
    if rarityA ~= rarityB then
      return rarityA < rarityB
    end
    if heroA.level ~= heroB.level then
      return heroA.level < heroB.level
    end
    if heroA.heroId ~= heroB.heroId then
      if heroA.heroId == coreHeroData.heroId then
        return true
      end
      if heroB.heroId == coreHeroData.heroId then
        return false
      end
      return heroA.heroId < heroB.heroId
    end
    return heroA.uuid < heroB.uuid
  end)
  local showDataList = {}
  local rowData = {coreHeroData}
  table.insert(showDataList, rowData)
  table.insert(showDataList, 0)
  local row = math.ceil(#dogFoods / colMax)
  for k = 1, row do
    local startIndex = colMax * (k - 1) + 1
    local endIndex = math.min(startIndex + colMax - 1, #dogFoods)
    local rowData = {
      table.unpack(dogFoods, startIndex, endIndex)
    }
    table.insert(showDataList, rowData)
  end
  return showDataList, minRarity
end

local function GetAllCanResetHeroes(self)
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  local heroes = table.values(allHeroes)
  table.sort(heroes, function(heroA, heroB)
    if heroA.level ~= heroB.level then
      return heroA.level > heroB.level
    end
    if heroA.quality ~= heroB.quality then
      return heroA.quality > heroB.quality
    end
    if heroA.camp ~= heroB.camp then
      return heroA.camp < heroB.camp
    end
    if heroA.heroId ~= heroB.heroId then
      return heroA.heroId < heroB.heroId
    end
    return heroA.uuid < heroB.uuid
  end)
  local result = {}
  for _, heroData in pairs(heroes) do
    if heroData.level > 1 then
      table.insert(result, heroData.uuid)
    end
  end
  return result
end

local function OnClickGoldBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, {anim = true})
end

UIHeroAdvanceCtrl.CloseSelf = CloseSelf
UIHeroAdvanceCtrl.GetHeroListByCamp = GetHeroListByCamp
UIHeroAdvanceCtrl.GetDogFoods = GetDogFoods
UIHeroAdvanceCtrl.GetAllCanResetHeroes = GetAllCanResetHeroes
UIHeroAdvanceCtrl.OnClickGoldBtn = OnClickGoldBtn
return UIHeroAdvanceCtrl
