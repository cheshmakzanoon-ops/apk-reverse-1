local UIHeroBagView = BaseClass("UIHeroBagView", UIBaseView)
local base = UIBaseView
local UIHeroBagRow = require("UI.UIHero2.UIHeroBag.Component.UIHeroBagRow")
local Localization = CS.GameEntry.Localization
local DetectEventRewardCell = require("UI.UIRadarCenter.UIDetectEvent.Component.DetectEventRewardCell")
local UIMedalCell = require("UI.UIHero2.UIHeroDebrisExchange.Component.UIMedalCell")
local UIHeroSkillMedalNum = require("UI.UIHero2.Common.UIHeroSkillMedalNum")
local hero_select_btn_path = "Root/HeroRarityBg/HeroRarityButton"
require("UI.UIHero2.UIHeroDebrisExchange.Component.UIMedalCell")
local select_txt_path = "Root/HeroRarityBg/HeroRarityButton/SelectText"
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local select_bar_path = "Root/HeroRarityBg/HeroRarityChoose"
local toggle_0_path = "Root/HeroRarityBg/HeroRarityChoose/toggleGroup/ToggleAll"
local toggle_1_path = "Root/HeroRarityBg/HeroRarityChoose/toggleGroup/Toggle1"
local toggle_2_path = "Root/HeroRarityBg/HeroRarityChoose/toggleGroup/Toggle2"
local toggle_3_path = "Root/HeroRarityBg/HeroRarityChoose/toggleGroup/Toggle3"
local toggle_4_path = "Root/HeroRarityBg/HeroRarityChoose/toggleGroup/Toggle4"
local toggle_0_text_path = "Root/HeroRarityBg/HeroRarityChoose/toggleGroup/ToggleAll/RarityTextAll"
local toggle_1_text_path = "Root/HeroRarityBg/HeroRarityChoose/toggleGroup/Toggle1/RarityText1"
local toggle_2_text_path = "Root/HeroRarityBg/HeroRarityChoose/toggleGroup/Toggle2/RarityText2"
local toggle_3_text_path = "Root/HeroRarityBg/HeroRarityChoose/toggleGroup/Toggle3/RarityText3"
local toggle_4_text_path = "Root/HeroRarityBg/HeroRarityChoose/toggleGroup/Toggle4/RarityText4"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.currentSelectRarity = 0
  self.textTitle = self:AddComponent(UIText, "Root/BtnBack/TitleText")
  self.textTitle:SetLocalText(150199)
  local btnClose = self:AddComponent(UIButton, "Root/BtnBack")
  btnClose:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.btnInfo = self:AddComponent(UIButton, "Root/BtnInfo")
  self.btnInfo:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnInfoClick()
  end)
  local btnBatch = self:AddComponent(UIButton, "Root/Left/BatchDecompose")
  btnBatch:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnBatchClick()
  end)
  local btnBatchText = self:AddComponent(UIText, "Root/Left/BatchDecompose/BatchDecomposeText")
  btnBatchText:SetLocalText(129256)
  local ownTitle = self:AddComponent(UIText, "Root/Left/SkillItemTitle")
  ownTitle:SetLocalText(129229)
  local descText = self:AddComponent(UIText, "Root/Left/DescText")
  descText:SetLocalText(129262)
  self.skillItem = self:AddComponent(UIMedalCell, "Root/Left/SkillItem")
  self.skillMedal = self:AddComponent(UIHeroSkillMedalNum, "Root/UIHeroSkillMedalNum")
  self.skillMedal:HideBtn()
  self.content = self:AddComponent(UIBaseContainer, "Root/Right/LoopScroll/Viewport/Content")
  self.scroll_view = self:AddComponent(UILoopListView2, "Root/Right/LoopScroll/")
  self.scroll_view:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.empty_text = self:AddComponent(UIText, "Root/Right/EmptyTipText")
  self.empty_text:SetLocalText(129268)
  self.empty_text:SetActive(false)
  self.select_txt = self:AddComponent(UIText, select_txt_path)
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
  local toggleText0 = self:AddComponent(UIText, toggle_0_text_path)
  toggleText0:SetText(self:GetRarityText(0))
  local toggleText1 = self:AddComponent(UIText, toggle_1_text_path)
  toggleText1:SetText(self:GetRarityText(HeroUtils.RarityType.S))
  local toggleText2 = self:AddComponent(UIText, toggle_2_text_path)
  toggleText2:SetText(self:GetRarityText(HeroUtils.RarityType.A))
  local toggleText3 = self:AddComponent(UIText, toggle_3_text_path)
  toggleText3:SetText(self:GetRarityText(HeroUtils.RarityType.B))
  local toggleText4 = self:AddComponent(UIText, toggle_4_text_path)
  toggleText4:SetText(self:GetRarityText(HeroUtils.RarityType.C))
  table.walk(self.toggleList, function(k, v)
    v:SetOnValueChanged(function(tf)
      if tf then
        self:ToggleControlBorS()
      end
    end)
  end)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.dataList then
    return nil
  end
  local dt = self.dataList[index]
  local item = loopScroll:NewListViewItem("Row")
  local script = self.content:GetComponent(item.gameObject.name, UIHeroBagRow)
  if script == nil then
    local objectName = self:GetItemNameSequence()
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.content:AddComponent(UIHeroBagRow, objectName)
  end
  script:SetActive(true)
  script:SetData(dt, index, BindCallback(self, self.OnCellClick))
  return item
end

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

local function OnCellClick(self, param)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDecompose, {anim = true}, param)
end

local function ClearScroll(self)
  self.content:RemoveComponents(UIHeroBagRow)
  self.scroll_view:ClearAllItems()
end

local function ComponentDestroy(self)
  self:ClearScroll()
end

local function OnBtnBatchClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDecomposeBatch)
end

local function OnInfoClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.btnInfo.transform.position + Vector3.New(0, -30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("129255")
  param.dir = UIHeroTipView.Direction.BELOW
  param.defWidth = 366
  param.pivot = 0.85
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function ShowScroll(self)
  self:ClearScroll()
  local dataCount = table.count(self.dataList)
  self.scroll_view:SetListItemCount(dataCount, false, false)
  self.empty_text:SetActive(dataCount == 0)
end

local function RefreshView(self)
  self.dataList = self.ctrl:GetPanelData(self.currentSelectRarity)
  self:ShowScroll()
  self:SetSelectState()
  local id = HeroUtils.GetSkillMedalId()
  local num = DataCenter.ItemData:GetItemCount(id)
  self.skillItem:SetData(id, num)
  self.skillItem:SetNameActive(false)
  self.skillMedal:RefreshView()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnItemChange)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.OnItemChange)
end

local function OnItemChange(self)
  self:RefreshView()
end

local function ToggleControlBorS(self)
  table.walk(self.toggleList, function(k, v)
    if v:GetIsOn() == true then
      self.currentSelectRarity = k
      self:RefreshView()
    end
  end)
  self:OnShowSelectBar()
end

local function SetSelectState(self)
  self.select_txt:SetText(self:GetRarityText(self.currentSelectRarity))
end

local function GetRarityText(self, rarity)
  if rarity == HeroUtils.RarityType.S then
    return "S"
  end
  if rarity == HeroUtils.RarityType.A then
    return "A"
  end
  if rarity == HeroUtils.RarityType.B then
    return "B"
  end
  if rarity == HeroUtils.RarityType.C then
    return "C"
  end
  return "ALL"
end

local function GetRarityColor(self, rarity)
end

local function OnShowSelectBar(self)
  self.showSelect = not self.showSelect
  self.select_bar.gameObject:SetActive(self.showSelect)
end

UIHeroBagView.GetRarityColor = GetRarityColor
UIHeroBagView.GetRarityText = GetRarityText
UIHeroBagView.OnCreate = OnCreate
UIHeroBagView.OnDestroy = OnDestroy
UIHeroBagView.ComponentDefine = ComponentDefine
UIHeroBagView.ComponentDestroy = ComponentDestroy
UIHeroBagView.OnBtnBatchClick = OnBtnBatchClick
UIHeroBagView.OnInfoClick = OnInfoClick
UIHeroBagView.OnGetItemByIndex = OnGetItemByIndex
UIHeroBagView.OnCellClick = OnCellClick
UIHeroBagView.ClearScroll = ClearScroll
UIHeroBagView.ShowScroll = ShowScroll
UIHeroBagView.GetItemNameSequence = GetItemNameSequence
UIHeroBagView.RefreshView = RefreshView
UIHeroBagView.OnAddListener = OnAddListener
UIHeroBagView.OnRemoveListener = OnRemoveListener
UIHeroBagView.OnItemChange = OnItemChange
UIHeroBagView.ToggleControlBorS = ToggleControlBorS
UIHeroBagView.SetSelectState = SetSelectState
UIHeroBagView.OnShowSelectBar = OnShowSelectBar
return UIHeroBagView
