local FormationHeroSelectList = BaseClass("FormationHeroSelectList", UIBaseContainer)
local base = UIBaseContainer
local FormationHeroSelectCell = require("UI.UIFormation.UIFormationTableNew.Component.FormationHeroSelectCell")
local Localization = CS.GameEntry.Localization
local scroll_view_path = "ScrollView"
local hero_num_path = "heroNum"
local hero_select_btn_path = "HeroStateButton"
local select_txt_path = "HeroStateButton/selectText"
local select_icon_path = "HeroStateButton/selectImg"
local select_hero_btn_path = "selectHeroBtn"
local select_bar_path = "HeroStateChoose"
local toggle_0_path = "HeroStateChoose/toggleGroup/ToggleAll"
local toggle_1_path = "HeroStateChoose/toggleGroup/Toggle1"
local toggle_2_path = "HeroStateChoose/toggleGroup/Toggle2"
local toggle_3_path = "HeroStateChoose/toggleGroup/Toggle3"
local toggle_4_path = "HeroStateChoose/toggleGroup/Toggle4"
local toggle_all_txt_path = "HeroStateChoose/toggleGroup/ToggleAll/allText"

local function OnCreate(self)
  base.OnCreate(self)
  self.select_txt = self:AddComponent(UIText, select_txt_path)
  self.select_icon = self:AddComponent(UIImage, select_icon_path)
  self.hero_num = self:AddComponent(UIText, hero_num_path)
  self.hero_select_btn = self:AddComponent(UIButton, hero_select_btn_path)
  self.hero_select_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShowSelectBar()
  end)
  self.close_select_btn = self:AddComponent(UIButton, select_hero_btn_path)
  self.close_select_btn:SetOnClick(function()
    if self.view.ctrl.isMarch > 0 then
      return
    end
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.view:OnSelectClick()
  end)
  self.select_bar = self:AddComponent(UIBaseContainer, select_bar_path)
  self.select_bar.gameObject:SetActive(false)
  self.showSelect = false
  self.toggleList = {}
  local toggle0 = self:AddComponent(UIToggle, toggle_0_path)
  toggle0:SetIsOn(true)
  self.toggleList[0] = toggle0
  local toggle1 = self:AddComponent(UIToggle, toggle_1_path)
  self.toggleList[1] = toggle1
  local toggle2 = self:AddComponent(UIToggle, toggle_2_path)
  self.toggleList[2] = toggle2
  local toggle3 = self:AddComponent(UIToggle, toggle_3_path)
  self.toggleList[3] = toggle3
  local toggle4 = self:AddComponent(UIToggle, toggle_4_path)
  self.toggleList[4] = toggle4
  self.toggle_all_txt = self:AddComponent(UIText, toggle_all_txt_path)
  self.toggle_all_txt:SetText("ALL")
  table.walk(self.toggleList, function(k, v)
    v:SetOnValueChanged(function(tf)
      if tf then
        self:ToggleControlBorS()
      end
    end)
  end)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.list = {}
  self.heroCampIndex = 0
  self.heroItemList = {}
end

local function OnDestroy(self)
  self.ScrollView = nil
  self.toggle_all_txt = nil
  table.walk(self.toggleList, function(k, v)
    v = nil
  end)
  self.select_txt = nil
  self.select_icon = nil
  self.hero_num = nil
  self.close_select_btn = nil
  self.select_bar = nil
  self.toggleList = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ToggleControlBorS(self)
  table.walk(self.toggleList, function(k, v)
    if v:GetIsOn() == true then
      self.heroCampIndex = k
    end
  end)
  self:RefreshData()
  self:OnShowSelectBar()
end

local function RefreshData(self)
  if self.heroCampIndex == 0 then
    self.select_txt:SetActive(true)
    self.select_txt:SetText("ALL")
    self.select_icon:SetActive(false)
  else
    self.select_txt:SetActive(false)
    self.select_icon:SetActive(true)
    self.select_icon:LoadSprite(HeroUtils.GetCampIconPath(self.heroCampIndex - 1))
  end
  self:ClearScroll(self)
  self.list = self.view.ctrl:GetCurrentHeroDataList(self.heroCampIndex - 1)
  self.hero_num:SetText("0")
  if self.list ~= nil then
    self.hero_num:SetText(table.count(self.list))
    self.ScrollView:SetTotalCount(#self.list)
    self.ScrollView:RefillCells()
  end
  if self.view.ctrl:NeedTakeArmy() then
    self.close_select_btn:SetActive(true)
  else
    self.close_select_btn:SetActive(false)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(FormationHeroSelectCell, itemObj)
  cellItem:SetItemShow(self.list[index])
  self.heroItemList[self.list[index]] = cellItem
end

local function OnItemMoveOut(self, itemObj, index)
  local uuid = self.list[index]
  if uuid ~= nil then
    self.heroItemList[uuid] = nil
  end
  self.ScrollView:RemoveComponent(itemObj.name, FormationHeroSelectCell)
end

local function ClearScroll(self)
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(FormationHeroSelectCell)
  self.heroItemList = {}
end

local function OnShowSelectBar(self)
  self.showSelect = not self.showSelect
  self.select_bar.gameObject:SetActive(self.showSelect)
end

local function GetAddHeroObj(self, heroUuid)
  if self.heroItemList ~= nil and self.heroItemList[heroUuid] ~= nil then
    return self.heroItemList[heroUuid]:GetAddObj()
  end
end

FormationHeroSelectList.OnCreate = OnCreate
FormationHeroSelectList.OnDestroy = OnDestroy
FormationHeroSelectList.RefreshData = RefreshData
FormationHeroSelectList.OnEnable = OnEnable
FormationHeroSelectList.OnDisable = OnDisable
FormationHeroSelectList.OnItemMoveIn = OnItemMoveIn
FormationHeroSelectList.OnItemMoveOut = OnItemMoveOut
FormationHeroSelectList.ClearScroll = ClearScroll
FormationHeroSelectList.ToggleControlBorS = ToggleControlBorS
FormationHeroSelectList.OnShowSelectBar = OnShowSelectBar
FormationHeroSelectList.GetAddHeroObj = GetAddHeroObj
return FormationHeroSelectList
