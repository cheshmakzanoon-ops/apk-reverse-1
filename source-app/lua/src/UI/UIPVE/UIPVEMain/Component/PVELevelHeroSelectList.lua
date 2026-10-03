local PVELevelHeroSelectList = BaseClass("PVELevelHeroSelectList", UIBaseContainer)
local base = UIBaseContainer
local PVELevelHeroSelectCell = require("UI.UIPVE.UIPVEMain.Component.PVELevelHeroSelectCell")
local Localization = CS.GameEntry.Localization
local scroll_view_path = "ScrollView"
local hero_num_text_path = "heroNum"
local hero_camp_btn_path = "HeroStateButton"
local camp_text_path = "HeroStateButton/selectText"
local camp_image_path = "HeroStateButton/selectImg"
local camp_bar_path = "HeroStateChoose"
local camp_toggle_path = "HeroStateChoose/toggleGroup/Toggle%s"
local HERO_COUNT = 5

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.camp_text = self:AddComponent(UIText, camp_text_path)
  self.camp_image = self:AddComponent(UIImage, camp_image_path)
  self.hero_num_text = self:AddComponent(UIText, hero_num_text_path)
  self.hero_camp_btn = self:AddComponent(UIButton, hero_camp_btn_path)
  self.hero_camp_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ToggleCampBar()
  end)
  self.camp_bar_go = self:AddComponent(UIBaseContainer, camp_bar_path)
  self.camp_bar_go:SetActive(false)
  self.toggleList = {}
  for i = 0, 4 do
    local toggle = self:AddComponent(UIToggle, string.format(camp_toggle_path, i))
    if i == 0 then
      toggle:SetIsOn(true)
    end
    toggle:SetOnValueChanged(function(_)
      self:OnCampToggleClick()
    end)
    self.toggleList[i] = toggle
  end
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.camp_text = nil
  self.camp_image = nil
  self.hero_num_text = nil
  self.hero_camp_btn = nil
  self.camp_bar_go = nil
  self.toggleList = nil
  self.scroll_view = nil
end

local function DataDefine(self)
  self.showingCamp = false
  self.dataList = {}
  self.campIndex = 0
  self.itemList = {}
  self.heroes = {}
end

local function DataDestroy(self)
  self.showingCamp = nil
  self.dataList = nil
  self.campIndex = nil
  self.itemList = nil
  self.heroes = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:Refresh()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(PVELevelHeroSelectCell, itemObj)
  local data = self.dataList[index]
  item:SetData(data)
  item:SetOnClick(function()
    self:OnItemClick(index)
  end)
  item:SetSelected(table.hasvalue(self.heroes, data.uuid))
  self.itemList[data.uuid] = item
end

local function OnItemMoveOut(self, itemObj, index)
  local data = self.dataList[index]
  self.scroll_view:RemoveComponent(itemObj.name, PVELevelHeroSelectCell)
  self.itemList[data.uuid] = nil
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(PVELevelHeroSelectCell)
  self.itemList = {}
end

local function Refresh(self)
  if self.campIndex == 0 then
    self.camp_text:SetActive(true)
    self.camp_text:SetText("ALL")
    self.camp_image:SetActive(false)
  else
    self.camp_text:SetActive(false)
    self.camp_image:SetActive(true)
    self.camp_image:LoadSprite(HeroUtils.GetCampIconPath(self.campIndex - 1))
  end
  self.dataList = self:GetDataListInternal(self.campIndex - 1)
  local count = #self.dataList
  self.scroll_view:SetTotalCount(count)
  self.scroll_view:RefillCells()
  self.hero_num_text:SetText(count)
end

local function ToggleCampBar(self)
  self.showingCamp = not self.showingCamp
  self.camp_bar_go:SetActive(self.showingCamp)
end

local function OnCampToggleClick(self)
  for i = 0, 4 do
    if self.toggleList[i]:GetIsOn() then
      self.campIndex = i
    end
  end
  self:Refresh()
  self:ToggleCampBar()
end

local function OnItemClick(self, index)
  local heroData = self.dataList[index]
  local heroUuid = heroData.uuid
  if table.hasvalue(self.heroes, heroUuid) then
    self:DeleteHero(heroUuid)
  else
    local maxHeroCount = DataCenter.BattleLevel:GetMaxHeroCount()
    local curHeroCount = table.count(self.heroes)
    if curHeroCount < HERO_COUNT and maxHeroCount > curHeroCount then
      self:SelectHero(heroUuid)
    else
      UIUtil.ShowTipsId(400035)
    end
  end
end

local function SelectHero(self, heroUuid)
  table.insert(self.heroes, heroUuid)
  local i = #self.heroes
  local item = self.itemList[heroUuid]
  if item then
    item:SetSelected(true)
  end
  self:OnHeroChanged(i, heroUuid, true)
end

local function DeleteHero(self, heroUuid)
  local i = table.indexof(self.heroes, heroUuid)
  table.remove(self.heroes, i)
  local item = self.itemList[heroUuid]
  if item then
    item:SetSelected(false)
  end
  self:OnHeroChanged(i, heroUuid, false)
end

local function SetHeroes(self, heroes)
  self.heroes = heroes
  self:Refresh()
end

local function GetDataListInternal(self, camp)
  local heroDataDict = DataCenter.HeroDataManager:GetAllHeroList()
  local heroDataList = table.values(heroDataDict)
  local list = {}
  for _, heroData in ipairs(heroDataList) do
    if heroData.isMaster and not DataCenter.BattleLevel.heroMgr:IsHeroBanned(heroData.heroId) then
      if camp ~= nil and -1 < camp then
        local targetCamp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
        if targetCamp == camp then
          table.insert(list, heroData)
        end
      else
        table.insert(list, heroData)
      end
    end
  end
  table.sort(list, function(heroDataA, heroDataB)
    if heroDataA.rarity ~= heroDataB.rarity then
      return heroDataA.rarity < heroDataB.rarity
    elseif heroDataA.level ~= heroDataB.level then
      return heroDataA.level > heroDataB.level
    elseif heroDataA.quality ~= heroDataB.quality then
      return heroDataA.quality > heroDataB.quality
    elseif heroDataA.camp ~= heroDataB.camp then
      return heroDataA.camp < heroDataB.camp
    else
      return heroDataA.heroId < heroDataB.heroId
    end
  end)
  return list
end

local function SetOnHeroChanged(self, onHeroChanged)
  self.onHeroChanged = onHeroChanged
end

local function OnHeroChanged(self, i, heroUuid, isAdd)
  if self.onHeroChanged then
    self.onHeroChanged(i, heroUuid, isAdd)
  end
end

PVELevelHeroSelectList.OnCreate = OnCreate
PVELevelHeroSelectList.OnDestroy = OnDestroy
PVELevelHeroSelectList.ComponentDefine = ComponentDefine
PVELevelHeroSelectList.ComponentDestroy = ComponentDestroy
PVELevelHeroSelectList.DataDefine = DataDefine
PVELevelHeroSelectList.DataDestroy = DataDestroy
PVELevelHeroSelectList.OnEnable = OnEnable
PVELevelHeroSelectList.OnDisable = OnDisable
PVELevelHeroSelectList.OnAddListener = OnAddListener
PVELevelHeroSelectList.OnRemoveListener = OnRemoveListener
PVELevelHeroSelectList.OnItemMoveIn = OnItemMoveIn
PVELevelHeroSelectList.OnItemMoveOut = OnItemMoveOut
PVELevelHeroSelectList.ClearScroll = ClearScroll
PVELevelHeroSelectList.Refresh = Refresh
PVELevelHeroSelectList.ToggleCampBar = ToggleCampBar
PVELevelHeroSelectList.OnCampToggleClick = OnCampToggleClick
PVELevelHeroSelectList.OnItemClick = OnItemClick
PVELevelHeroSelectList.SelectHero = SelectHero
PVELevelHeroSelectList.DeleteHero = DeleteHero
PVELevelHeroSelectList.SetHeroes = SetHeroes
PVELevelHeroSelectList.SetOnHeroChanged = SetOnHeroChanged
PVELevelHeroSelectList.OnHeroChanged = OnHeroChanged
PVELevelHeroSelectList.GetDataListInternal = GetDataListInternal
return PVELevelHeroSelectList
