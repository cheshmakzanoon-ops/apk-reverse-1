local UIHeroListView = BaseClass("UIHeroListView", UIBaseView)
local base = UIBaseView
local UIHeroListPageHero = require("UI.UIHero2.UIHeroList.Component.UIHeroListPageHero")
local UIHeroSkillMedalNum = require("UI.UIHero2.Common.UIHeroSkillMedalNum")
local ArrowTypeHero = {HeroUid = 1, LvUpHero = 2}
local btn_back_path = "Root/BtnBack"
local skill_medal_path = "Root/UIHeroSkillMedalNum"
local hero_select_btn_path = "Root/HeroStateBg/HeroStateButton"
local select_txt_path = "Root/HeroStateBg/HeroStateButton/selectText"
local select_icon_path = "Root/HeroStateBg/HeroStateButton/selectImg"
local select_bar_path = "Root/HeroStateBg/HeroStateChoose"
local toggle_0_path = "Root/HeroStateBg/HeroStateChoose/toggleGroup/ToggleAll"
local toggle_1_path = "Root/HeroStateBg/HeroStateChoose/toggleGroup/Toggle1"
local toggle_2_path = "Root/HeroStateBg/HeroStateChoose/toggleGroup/Toggle2"
local toggle_3_path = "Root/HeroStateBg/HeroStateChoose/toggleGroup/Toggle3"
local toggle_4_path = "Root/HeroStateBg/HeroStateChoose/toggleGroup/Toggle4"
local toggle_all_txt_path = "Root/HeroStateBg/HeroStateChoose/toggleGroup/ToggleAll/allText"

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl:InitData(self:GetUserData())
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  DataCenter.HeroDataManager:MarkHeroRedPoint()
  EventManager:GetInstance():Broadcast(EventId.CheckPubBubble, true)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnBack = self:AddComponent(UIButton, btn_back_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.panelHero = self:AddComponent(UIHeroListPageHero, "Root/PanelHero")
  self.panelHero:SetActive(true)
  self.select_txt = self:AddComponent(UIText, select_txt_path)
  self.select_icon = self:AddComponent(UIImage, select_icon_path)
  self.hero_select_btn = self:AddComponent(UIButton, hero_select_btn_path)
  self.hero_select_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShowSelectBar()
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
  self.select_icon:SetActive(false)
  table.walk(self.toggleList, function(k, v)
    v:SetOnValueChanged(function(tf)
      if tf then
        self:ToggleControlBorS()
      end
    end)
  end)
  self.skillMedal = self:AddComponent(UIHeroSkillMedalNum, skill_medal_path)
end

local function ComponentDestroy(self)
  self.btnBack = nil
  self.panelHero = nil
end

local function DataDefine(self)
  self.curPanelIndex = 1
  self.selectCamp = -1
  self.currentSelectHeroUid = nil
end

local function DataDestroy(self)
  self.curPanelIndex = nil
  self.selectCamp = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:OnOpen()
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

local function OnOpen(self)
  self:OnSwitchCamp(-1)
  self:OnSwitchPanel(1)
  self.currentSelectHeroUid = self.ctrl:GetArrow()
  if self.currentSelectHeroUid ~= nil and self.panelHero ~= nil and self.currentSelectHeroUid ~= ArrowTypeHero.LvUpHero then
    self.panelHero:ShowSelectHero(self.currentSelectHeroUid)
  end
  self.currentSelectHeroUid = nil
  self.skillMedal:RefreshView()
end

local function OnSwitchPanel(self, panelIndex)
  self.curPanelIndex = panelIndex or self.curPanelIndex == 1 and 2 or 1
  self.panelHero:SetActive(self.curPanelIndex == 1)
end

local function ToggleControlBorS(self)
  table.walk(self.toggleList, function(k, v)
    if v:GetIsOn() == true then
      self.selectCamp = k - 1
      self.panelHero:OnSwitchCamp(self.selectCamp)
      self:SetSelectState()
    end
  end)
  self:OnShowSelectBar()
end

local function SetSelectState(self)
  if self.selectCamp == -1 then
    self.select_txt:SetActive(true)
    self.select_txt:SetText("ALL")
    self.select_icon:SetActive(false)
  else
    self.select_txt:SetActive(false)
    self.select_icon:SetActive(true)
    self.select_icon:LoadSprite(HeroUtils.GetCampIconPath(self.selectCamp))
  end
end

local function OnSwitchCamp(self, camp)
  self.selectCamp = camp
  self.panelHero:OnSwitchCamp(camp)
  self:SetSelectState()
end

local function OnHeroDataChanged(self)
end

local function OnShowSelectBar(self)
  self.showSelect = not self.showSelect
  self.select_bar.gameObject:SetActive(self.showSelect)
end

local function GetHeroCellAdvanceGuideBtn(self)
  if self.panelHero ~= nil then
    return self.panelHero:GetHeroCellAdvanceGuideBtn()
  end
  return nil
end

local function GetHeroCellStarGuideBtn(self)
  if self.panelHero ~= nil then
    return self.panelHero:GetHeroCellStarGuideBtn()
  end
  return nil
end

local function MoveToHero(self, heroId)
  if self.panelHero ~= nil then
    return self.panelHero:MoveToHero(heroId)
  end
end

local function GetHeroItem(self, heroId)
  if self.panelHero ~= nil then
    return self.panelHero:GetHeroItem(heroId)
  end
  return nil
end

UIHeroListView.OnCreate = OnCreate
UIHeroListView.OnDestroy = OnDestroy
UIHeroListView.OnEnable = OnEnable
UIHeroListView.OnDisable = OnDisable
UIHeroListView.OnAddListener = OnAddListener
UIHeroListView.OnRemoveListener = OnRemoveListener
UIHeroListView.ComponentDefine = ComponentDefine
UIHeroListView.ComponentDestroy = ComponentDestroy
UIHeroListView.DataDefine = DataDefine
UIHeroListView.DataDestroy = DataDestroy
UIHeroListView.ToggleControlBorS = ToggleControlBorS
UIHeroListView.OnShowSelectBar = OnShowSelectBar
UIHeroListView.OnOpen = OnOpen
UIHeroListView.OnSwitchPanel = OnSwitchPanel
UIHeroListView.OnSwitchCamp = OnSwitchCamp
UIHeroListView.OnHeroDataChanged = OnHeroDataChanged
UIHeroListView.SetSelectState = SetSelectState
UIHeroListView.GetHeroCellAdvanceGuideBtn = GetHeroCellAdvanceGuideBtn
UIHeroListView.GetHeroCellStarGuideBtn = GetHeroCellStarGuideBtn
UIHeroListView.MoveToHero = MoveToHero
UIHeroListView.GetHeroItem = GetHeroItem
return UIHeroListView
