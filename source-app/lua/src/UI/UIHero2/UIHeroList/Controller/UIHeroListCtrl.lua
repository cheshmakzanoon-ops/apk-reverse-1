local UIHeroListCtrl = BaseClass("UIHeroListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  if self.isArrow ~= nil and self.isArrow == CurScene.PVEScene then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroList, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  else
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroList, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllShow
    })
  end
  if self.callback then
    self.callback()
  end
end

local function InitData(self, isArrow, callback)
  self.isArrow = isArrow or nil
  self.callback = callback
end

local function GetHeroListByCamp(self, camp)
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  local heroes = table.values(allHeroes)
  table.sort(heroes, function(heroA, heroB)
    if heroA.quality ~= heroB.quality then
      return heroA.quality > heroB.quality
    end
    if heroA.level ~= heroB.level then
      return heroA.level > heroB.level
    end
    if heroA.camp ~= heroB.camp then
      return heroA.camp < heroB.camp
    end
    if heroA.rarity ~= heroB.rarity then
      return heroA.rarity < heroB.rarity
    end
    if heroA.heroId ~= heroB.heroId then
      return heroA.heroId < heroB.heroId
    end
    return heroA.uuid < heroB.uuid
  end)
  local result = {}
  local optimalHeroDict = {}
  for _, heroData in pairs(heroes) do
    if camp ~= -1 then
      local targetCamp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
      if targetCamp ~= camp then
        goto lbl_43
      end
    end
    table.insert(result, heroData.uuid)
    if optimalHeroDict[heroData.heroId] == nil then
      optimalHeroDict[heroData.heroId] = heroData.uuid
    end
    ::lbl_43::
  end
  return result, optimalHeroDict
end

local function GenerateHeroDataList(self, selectCamp, colMax)
  local function SortHero(heroConfigA, heroConfigB)
    if heroConfigA == nil or heroConfigB == nil then
      return false
    end
    if heroConfigA == nil or heroConfigB == nil then
      return false
    end
    if heroConfigA.rarity ~= heroConfigB.rarity then
      return heroConfigA.rarity < heroConfigB.rarity
    end
    if heroConfigA.quality ~= heroConfigB.quality then
      return heroConfigA.quality > heroConfigB.quality
    end
    if heroConfigA.level ~= heroConfigB.level then
      return heroConfigA.level > heroConfigB.level
    end
    if heroConfigA.camp ~= heroConfigB.camp then
      return heroConfigA.camp < heroConfigB.camp
    end
    if heroConfigA.rarity ~= heroConfigB.rarity then
      return heroConfigA.rarity < heroConfigB.rarity
    end
    if heroConfigA.heroId ~= heroConfigB.heroId then
      return heroConfigA.heroId < heroConfigB.heroId
    end
    return false
  end
  
  local heroList = {}
  local newHeroList = {}
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  for _, heroData in pairs(allHeroes) do
    if heroData.isMaster and (selectCamp == -1 or heroData.camp == selectCamp) then
      local isNew = DataCenter.HeroDataManager:IsNewHero(heroData.uuid)
      if isNew then
        table.insert(newHeroList, heroData.uuid)
      else
        table.insert(heroList, heroData.uuid)
      end
    end
  end
  local tmp = {}
  
  local function sortHero(heroList)
    table.sort(heroList, function(uuid1, uuid2)
      local heroA = DataCenter.HeroDataManager:GetHeroByUuid(uuid1)
      local heroB = DataCenter.HeroDataManager:GetHeroByUuid(uuid2)
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
        return needShowRedA
      end
      if heroA.rarity ~= heroB.rarity then
        return heroA.rarity < heroB.rarity
      end
      if heroA.quality ~= heroB.quality then
        return heroA.quality > heroB.quality
      end
      if heroA.level ~= heroB.level then
        return heroA.level > heroB.level
      end
      if heroA.camp ~= heroB.camp then
        return heroA.camp < heroB.camp
      end
      if heroA.rarity ~= heroB.rarity then
        return heroA.rarity < heroB.rarity
      end
      if heroA.heroId ~= heroB.heroId then
        return heroA.heroId < heroB.heroId
      end
      return heroA.uuid < heroB.uuid
    end)
  end
  
  sortHero(heroList)
  sortHero(newHeroList)
  local pureDataList = DeepCopy(heroList)
  local index = 1
  table.walk(newHeroList, function(k, v)
    table.insert(heroList, index, v)
    table.insert(pureDataList, index, v)
    index = index + 1
  end)
  local showDataList = {}
  local row = math.ceil(#heroList / colMax)
  for k = 1, row do
    local startIndex = colMax * (k - 1) + 1
    local endIndex = math.min(startIndex + colMax - 1, #heroList)
    local rowData = {
      table.unpack(heroList, startIndex, endIndex)
    }
    table.insert(showDataList, rowData)
  end
  return showDataList, pureDataList
end

local function OnBtnTestClick(self)
end

local function GetArrow(self)
  if self.isArrow ~= nil and self.isArrow == CurScene.PVEScene then
    return nil
  end
  return self.isArrow
end

local function SetArrow(self)
  self.isArrow = nil
end

UIHeroListCtrl.CloseSelf = CloseSelf
UIHeroListCtrl.InitData = InitData
UIHeroListCtrl.OnBtnTestClick = OnBtnTestClick
UIHeroListCtrl.GetHeroListByCamp = GetHeroListByCamp
UIHeroListCtrl.GenerateHeroDataList = GenerateHeroDataList
UIHeroListCtrl.GetArrow = GetArrow
UIHeroListCtrl.SetArrow = SetArrow
return UIHeroListCtrl
