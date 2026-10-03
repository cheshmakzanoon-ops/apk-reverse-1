local UIHeroAdvanceView = BaseClass("UIHeroAdvanceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local HeroModelViewer = require("UI.UIHero2.UIHeroInfo.Component.HeroModelViewer")
local UIHeroPageAdvance = require("UI.UIHero2.UIHeroAdvance.Component.UIHeroPageAdvance")
local UIHeroPageReset = require("UI.UIHero2.UIHeroAdvance.Component.UIHeroPageReset")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local Tabs = {Advance = 1, Reset = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  HeroAdvanceController:GetInstance():SetAdvanceHeroUuid(nil)
  HeroAdvanceController:GetInstance():SetPreStoreAdvanceNum()
  HeroAdvanceController:GetInstance():UpdateAdvanceNum()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.modelViewer = self:AddComponent(HeroModelViewer, "RawImage")
  self.modelViewer:SetCameraOffset(Vector3.New(0.13, 0, 0))
  local btn_back = self:AddComponent(UIButton, "Root/BtnBack")
  btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textGoldNum = self:AddComponent(UIText, "Root/goldObj/goldNum")
  local btnGold = self:AddComponent(UIButton, "Root/goldObj")
  btnGold:SetOnClick(BindCallback(self.ctrl, self.ctrl.OnClickGoldBtn))
  self.tabButtons = {}
  self.tabButtons[Tabs.Advance] = self:AddComponent(UIButton, "Root/TabContent/BtnAdvance")
  self.tabButtons[Tabs.Reset] = self:AddComponent(UIButton, "Root/TabContent/BtnReset")
  self.pages = {}
  self.pages[Tabs.Advance] = self:AddComponent(UIHeroPageAdvance, "Root/PageRoot/PageAdvance")
  self.pages[Tabs.Reset] = self:AddComponent(UIHeroPageReset, "Root/PageRoot/PageReset")
  local tabNames = {
    [Tabs.Advance] = "150115",
    [Tabs.Reset] = "150116"
  }
  for k, v in pairs(self.tabButtons) do
    v.transform:Find("Normal/TextTab"):GetComponent(typeof(CS.UnityEngine.UI.Text)).text = Localization:GetString(tabNames[k])
    v.transform:Find("Selected/TextTab"):GetComponent(typeof(CS.UnityEngine.UI.Text)).text = Localization:GetString(tabNames[k])
    v:SetOnClick(function()
      self:SwitchTab(k)
    end)
  end
  self.btnInfo = self:AddComponent(UIButton, "Root/BtnInfo")
  self.btnInfo:SetOnClick(BindCallback(self, self.OnBtnInfoClick))
  self.nodeRoot = self:AddComponent(UIBaseContainer, "Root")
  self.nodeTabBg = self:AddComponent(UIBaseContainer, "ImgTabBg")
  self.nodeEffect = self:AddComponent(UIBaseContainer, "NodeEffect")
  self.animator = self:AddComponent(UIAnimator, "")
end

local function ComponentDestroy(self)
  self.modelViewer = nil
  self.textGoldNum = nil
  self.tabButtons = nil
  self.pages = nil
  self.gold_btn = nil
  self.gold_num = nil
  self.btnInfo = nil
end

local function SwitchTab(self, tabIdx)
  if self.currentTab == tabIdx then
    return
  end
  self.currentTab = tabIdx
  for k, tabObj in pairs(self.tabButtons) do
    tabObj.transform:Find("Selected").gameObject:SetActive(k == tabIdx)
  end
  if tabIdx == Tabs.Reset then
    self.animator:SetTrigger("resetShow")
  end
  for k, pageObj in pairs(self.pages) do
    pageObj:SetActive(k == tabIdx)
  end
end

local function DataDefine(self)
  self.selectCamp = 1
  self.curSelectCell = 0
  self.cells = {}
  self.showTips = false
end

local function DataDestroy(self)
  self.selectCamp = nil
  self.curSelectCell = nil
  self.cells = nil
  self.showTips = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  if self.heroUuid ~= nil and UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIHeroInfo) then
    local uiHeroInfoView = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroInfo)
    if uiHeroInfoView ~= nil and uiHeroInfoView.View ~= nil then
      uiHeroInfoView.View:OnBackFromAdvance()
    end
  end
  base.OnDisable(self)
end

local function ReInit(self)
  self.modelViewer:ShowEmptyScene()
  self:SwitchTab(Tabs.Advance)
  self:RefreshGoldNum()
  local heroUuid = self:GetUserData()
  self.heroUuid = heroUuid
  if heroUuid ~= nil then
    local data = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if data ~= nil then
      self.pages[Tabs.Advance]:OnSwitchCamp(data.camp)
    end
    self.pages[Tabs.Advance]:OnSelectCore(heroUuid)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGoldNum)
  self:AddUIListener(EventId.OnAdvanceSuccessClosed, self.OnAdvanceSuccessClosed)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshGoldNum)
  self:RemoveUIListener(EventId.OnAdvanceSuccessClosed, self.OnAdvanceSuccessClosed)
  base.OnRemoveListener(self)
end

local function RefreshGoldNum(self)
  local gold = LuaEntry.Player.gold
  self.textGoldNum:SetText(string.GetFormattedSeperatorNum(gold))
end

local function OnBtnInfoClick(self)
  self.showTips = not self.showTips
  if self.showTips then
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.btnInfo.transform.position + Vector3.New(0, -30, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString("129240")
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 350
    param.pivot = 0.82
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

local function OnAdvanceSuccessShown(self, message)
  self.animator:SetTrigger("hide")
end

local function OnAdvanceSuccessClosed(self)
  self.animator:SetTrigger("show")
end

local function GetPageAdvance(self)
  return self.pages[Tabs.Advance]
end

local function GetGuideCoreBtn(self)
  return self.pages[Tabs.Advance]:GetGuideCoreBtn()
end

local function GetGuideDogFoodBtn(self)
  return self.pages[Tabs.Advance]:GetGuideDogFoodBtn()
end

UIHeroAdvanceView.OnCreate = OnCreate
UIHeroAdvanceView.OnDestroy = OnDestroy
UIHeroAdvanceView.OnEnable = OnEnable
UIHeroAdvanceView.OnDisable = OnDisable
UIHeroAdvanceView.OnAddListener = OnAddListener
UIHeroAdvanceView.OnRemoveListener = OnRemoveListener
UIHeroAdvanceView.ComponentDefine = ComponentDefine
UIHeroAdvanceView.ComponentDestroy = ComponentDestroy
UIHeroAdvanceView.DataDefine = DataDefine
UIHeroAdvanceView.DataDestroy = DataDestroy
UIHeroAdvanceView.ReInit = ReInit
UIHeroAdvanceView.SwitchTab = SwitchTab
UIHeroAdvanceView.RefreshGoldNum = RefreshGoldNum
UIHeroAdvanceView.OnBtnInfoClick = OnBtnInfoClick
UIHeroAdvanceView.GetPageAdvance = GetPageAdvance
UIHeroAdvanceView.OnAdvanceSuccessShown = OnAdvanceSuccessShown
UIHeroAdvanceView.OnAdvanceSuccessClosed = OnAdvanceSuccessClosed
UIHeroAdvanceView.GetGuideCoreBtn = GetGuideCoreBtn
UIHeroAdvanceView.GetGuideDogFoodBtn = GetGuideDogFoodBtn
return UIHeroAdvanceView
