local UIHeroListRow = BaseClass("UIHeroListRow", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellBig = require("UI.UIHero2.Common.UIHeroCellBig")
local ColMax = 6

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.cellObjList = {}
  for k = 1, ColMax do
    local cell = self:AddComponent(UIHeroCellBig, "HeroCell" .. k)
    table.insert(self.cellObjList, cell)
  end
end

local function ComponentDestroy(self)
  self.cellObjList = nil
end

local function SetData(self, uuidList, clickFunc)
  for k, cell in ipairs(self.cellObjList) do
    local uuid = uuidList[k]
    cell:SetActive(uuid ~= nil)
    if uuid ~= nil then
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
      if heroData ~= nil then
        cell:SetData(uuid, clickFunc)
        cell:EnableRedPoint()
      else
        cell:InitWithHeroPieceItem(uuid, clickFunc)
      end
    end
  end
end

local function GetCellPos(self)
  return self.cellObjList[1]:GetCellPos()
end

local function GetCellSizeDelta(self)
  return self.cellObjList[1]:GetCellSizeDelta()
end

local function GetHeroCellAdvanceGuideBtn(self)
  for _, v in ipairs(self.cellObjList) do
    local heroUuid = v.param
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil then
      local needShowRed = heroData:NeedBeyond()
      if needShowRed then
        return v:GetGuideClickBtn()
      end
    end
  end
  return nil
end

local function GetHeroCellStarGuideBtn(self)
  for _, v in ipairs(self.cellObjList) do
    local heroUuid = v.param
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil then
      local canStarUp = heroData:CanUpgradeStar()
      if canStarUp then
        return v:GetGuideClickBtn()
      end
    end
  end
  return nil
end

local function GetHeroItem(self, heroId)
  for _, v in ipairs(self.cellObjList) do
    local heroUuid = v.param
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil and heroData.heroId == heroId then
      return v:GetGuideClickBtn()
    end
  end
  return nil
end

UIHeroListRow.GetHeroItem = GetHeroItem
UIHeroListRow.OnCreate = OnCreate
UIHeroListRow.OnDestroy = OnDestroy
UIHeroListRow.ComponentDefine = ComponentDefine
UIHeroListRow.ComponentDestroy = ComponentDestroy
UIHeroListRow.SetData = SetData
UIHeroListRow.GetCellPos = GetCellPos
UIHeroListRow.GetCellSizeDelta = GetCellSizeDelta
UIHeroListRow.GetHeroCellAdvanceGuideBtn = GetHeroCellAdvanceGuideBtn
UIHeroListRow.GetHeroCellStarGuideBtn = GetHeroCellStarGuideBtn
return UIHeroListRow
