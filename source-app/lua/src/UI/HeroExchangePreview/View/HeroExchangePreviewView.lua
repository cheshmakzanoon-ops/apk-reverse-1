local HeroExchangePreviewView = BaseClass("HeroExchangePreviewView", UIBaseView)
local ExchangePreviewItem = require("UI.HeroExchangePreview.Component.HeroChangePreviewItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local panel_path = "panel"
local close_btn_path = "Common_bg_orange/CloseBtn"
local from_hero_path = "Common_bg_orange/Content/Scroll View/Viewport/Content/FromHero"
local to_hero_path = "Common_bg_orange/Content/Scroll View/Viewport/Content/ToHero"
local confirm_exchange_btn_path = "Common_bg_orange/Content/ConfirmExchangeBtn"
local content_path = "Common_bg_orange/Content/Scroll View/Viewport/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.param = self:GetUserData()
  self.leftHeroUuid = self.param.leftUuid
  self.rightHeroUuid = self.param.rightUuid
  self.doExchangeFunc = self.param.doExchangeFunc
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshView()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closePanelBtn = self:AddComponent(UIButton, panel_path)
  self.closePanelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.fromHeroItem = self:AddComponent(ExchangePreviewItem, from_hero_path)
  self.toHeroItem = self:AddComponent(ExchangePreviewItem, to_hero_path)
  self.confirmExchangeBtn = self:AddComponent(UIButton, confirm_exchange_btn_path)
  self.confirmExchangeBtn:SetOnClick(function()
    self:ConfirmExchangeBtn()
  end)
  self.scrollViewContent = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ExchangeHeroSuccess, self.OnExchangeSuccess)
  self:AddUIListener(EventId.ExchangeHeroFail, self.OnExchangeError)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ExchangeHeroSuccess, self.OnExchangeSuccess)
  self:RemoveUIListener(EventId.ExchangeHeroFail, self.OnExchangeError)
  base.OnRemoveListener(self)
end

function HeroExchangePreviewView:RefreshView()
  local fromHeroData = DataCenter.HeroDataManager:GetHeroByUuid(self.leftHeroUuid)
  local toHeroData = DataCenter.HeroDataManager:GetHeroByUuid(self.rightHeroUuid)
  if not fromHeroData or not toHeroData then
    Logger.LogError("exchange hero error,heroData not find!")
    return
  end
  self.fromHeroItem:SetData(fromHeroData, toHeroData)
  self.toHeroItem:SetData(toHeroData, fromHeroData)
  UIGray.SetGray(self.confirmExchangeBtn.transform, false, true)
  self.scrollViewContent.rectTransform:Set_localPosition(0, 0, 0)
end

function HeroExchangePreviewView:ConfirmExchangeBtn()
  if self.doExchangeFunc then
    self.doExchangeFunc(self.leftHeroUuid, self.rightHeroUuid)
    UIGray.SetGray(self.confirmExchangeBtn.transform, true, false)
  end
end

function HeroExchangePreviewView:OnExchangeSuccess()
  self.ctrl:CloseSelf()
end

function HeroExchangePreviewView:OnExchangeError()
  UIGray.SetGray(self.confirmExchangeBtn.transform, false, true)
end

HeroExchangePreviewView.OnCreate = OnCreate
HeroExchangePreviewView.OnDestroy = OnDestroy
HeroExchangePreviewView.OnEnable = OnEnable
HeroExchangePreviewView.OnDisable = OnDisable
HeroExchangePreviewView.ComponentDefine = ComponentDefine
HeroExchangePreviewView.ComponentDestroy = ComponentDestroy
HeroExchangePreviewView.DataDefine = DataDefine
HeroExchangePreviewView.DataDestroy = DataDestroy
HeroExchangePreviewView.OnAddListener = OnAddListener
HeroExchangePreviewView.OnRemoveListener = OnRemoveListener
return HeroExchangePreviewView
