local UITCViewCardDeckPanelView = BaseClass("UITCViewCardDeckPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CardDeck = require("UI.LWUITC.UITCViewCardDeckPanel.Component.CardDeck")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.windowParams = self:GetUserData()
  self.deckOwnerName = self.windowParams.ownerName
  self.cards = self.windowParams.cards
  self.title_txt:SetLocalText("battle_card_share_info", self.deckOwnerName)
  self.slots = self.ctrl:CardsToSlotData(self.windowParams.cards)
  self.cardDeck:ReInit(self.slots)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.title_txt = self:AddComponent(UITextMeshProUGUIEx, "Root/TopBar/TextTitle")
  self.deck = self:AddComponent(UIBaseComponent, "Root/ContentRoot/deck")
  self.back_btn = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.back_btn:SetOnClick(function()
    self:OnBack_btnClick()
  end)
  self.cardDeck = self:AddComponent(CardDeck, "Root/ContentRoot/deck")
end

local function ComponentDestroy(self)
  self.title_txt = nil
  self.deck = nil
  self.back_btn = nil
  self.cardDeck = nil
end

function UITCViewCardDeckPanelView:OnBack_btnClick()
  self.ctrl:CloseSelf()
end

UITCViewCardDeckPanelView.OnCreate = OnCreate
UITCViewCardDeckPanelView.OnDestroy = OnDestroy
UITCViewCardDeckPanelView.OnEnable = OnEnable
UITCViewCardDeckPanelView.OnDisable = OnDisable
UITCViewCardDeckPanelView.ComponentDefine = ComponentDefine
UITCViewCardDeckPanelView.ComponentDestroy = ComponentDestroy
return UITCViewCardDeckPanelView
