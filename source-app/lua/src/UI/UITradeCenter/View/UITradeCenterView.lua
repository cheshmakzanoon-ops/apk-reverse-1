local TradeResItem = require("UI.UITradeCenter.Component.TradeResItem")
local UITradeCenterView = BaseClass("UITradeCenterView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "ImgBg/TxtTitle"
local toogle1_path = "ImgBg/Tab/Toggle1"
local toogle2_path = "ImgBg/Tab/Toggle2"
local close_btn_path = "ImgBg/BtnClose"
local return_btn_path = "Panel"
local btn_path = "ImgBg/Button"
local btn_text_path = "ImgBg/Button/Text"
local arrow_path = "ImgBg/jiage/Arrow"
local exchange_text_path = "ImgBg/jiage/TxtExchange"
local fuzhong_obj_path = "ImgBg/jiage/countFuzhongBG"
local fuzhong_text_path = "ImgBg/jiage/countFuzhongBG/fuzhong"
local money_obj_path = "ImgBg/jiage/countMoneyBG"
local money_text_path = "ImgBg/jiage/countMoneyBG/qian"
local content_path = "ImgBg/GameObject"

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl:InitData()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(100393)
  self.toogle1 = self:AddComponent(UIToggle, toogle1_path)
  self.toogle1:SetIsOn(true)
  self.toogle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toogle1.text = self.toogle1:AddComponent(UIText, "Text")
  self.toogle1.text:SetLocalText(110081)
  self.toogle2 = self:AddComponent(UIToggle, toogle2_path)
  self.toogle2:SetIsOn(false)
  self.toogle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toogle2.text = self.toogle2:AddComponent(UIText, "Text")
  self.toogle2.text:SetLocalText(360072)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:Close()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.toogle1:GetIsOn() then
      self.ctrl:OnClickSell()
    elseif self.toogle2:GetIsOn() then
      self.ctrl:OnClickBuy()
    end
  end)
  self.btn_text = self:AddComponent(UIText, btn_text_path)
  self.exchange_text = self:AddComponent(UIText, exchange_text_path)
  self.fuzhong_obj = self:AddComponent(UIBaseContainer, fuzhong_obj_path)
  self.fuzhong_text = self:AddComponent(UIText, fuzhong_text_path)
  self.money_obj = self:AddComponent(UIBaseContainer, money_obj_path)
  self.money_text = self:AddComponent(UIText, money_text_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.item_prefab = self.transform:Find("UITradeResItem").gameObject
  self.item_prefab:GameObjectCreatePool()
  self.itemList = {}
end

local function OnDestroy(self)
  self.txt_title = nil
  self.toogle1.text = nil
  self.toogle1 = nil
  self.toogle2.text = nil
  self.toogle2 = nil
  self.close_btn = nil
  self.return_btn = nil
  self.btn = nil
  self.btn_text = nil
  self.exchange_text = nil
  self.fuzhong_obj = nil
  self.fuzhong_text = nil
  self.money_obj = nil
  self.money_text = nil
  self.arrow = nil
  self.item_prefab.gameObject:GameObjectRecycleAll()
  self.item_prefab = nil
  self.content = nil
  self.itemList = nil
  base.OnDestroy(self)
end

local function ToggleControlBorS(self)
  if self.toogle1:GetIsOn() then
    self:UpdateSellObj()
  elseif self.toogle2:GetIsOn() then
    self:UpdateBuyObj()
  end
end

local function UpdateBuyObj(self)
  self.btn_text:SetLocalText(360072)
  self.fuzhong_obj.gameObject:SetActive(false)
  self.arrow.gameObject:SetActive(false)
  self.exchange_text:SetText("")
  self.ctrl:RefreshData(false, true)
  self:UpdateContent()
  self:UpdateViewState()
end

local function UpdateSellObj(self)
  self.btn_text:SetLocalText(110081)
  self.fuzhong_obj.gameObject:SetActive(true)
  self.arrow.gameObject:SetActive(true)
  self.exchange_text:SetLocalText(110086)
  self.ctrl:RefreshData(true, true)
  self:UpdateContent()
  self:UpdateViewState()
end

local function UpdateContent(self)
  local list = self.view.ctrl:GetResTypeArray()
  if list ~= nil then
    table.walk(list, function(k, v)
      if self.itemList[v] == nil then
        local item = self.item_prefab:GameObjectSpawn(self.content.transform)
        item.name = v
        self.itemList[v] = self.content:AddComponent(TradeResItem, item.name, v)
      end
      self.itemList[v]:RefreshData()
    end)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self.ToggleControlBorS(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RES_SELL_MSG, self.OnTradeFinish)
  self:AddUIListener(EventId.ResourceUpdated, self.OnResUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RES_SELL_MSG, self.OnTradeFinish)
  self:RemoveUIListener(EventId.ResourceUpdated, self.OnResUpdate)
end

local function OnResUpdate(self)
  self.ctrl:RefreshData(self.toogle1:GetIsOn(), false)
  self:UpdateContent()
  self:UpdateViewState()
end

local function OnTradeFinish(self)
  self.ctrl:RefreshData(self.toogle1:GetIsOn(), true)
  self:UpdateContent()
  self:UpdateViewState()
end

local function UpdateViewState(self)
  if self.toogle1:GetIsOn() then
    local strTop = self.ctrl:GetTopNum()
    self.fuzhong_text:SetText(strTop)
  end
  local strBottom = self.ctrl:GetBottomNum(self.toogle1:GetIsOn())
  self.money_text:SetText(strBottom)
end

UITradeCenterView.OnCreate = OnCreate
UITradeCenterView.OnDestroy = OnDestroy
UITradeCenterView.ToggleControlBorS = ToggleControlBorS
UITradeCenterView.OnEnable = OnEnable
UITradeCenterView.OnDisable = OnDisable
UITradeCenterView.UpdateContent = UpdateContent
UITradeCenterView.UpdateBuyObj = UpdateBuyObj
UITradeCenterView.UpdateSellObj = UpdateSellObj
UITradeCenterView.OnAddListener = OnAddListener
UITradeCenterView.OnRemoveListener = OnRemoveListener
UITradeCenterView.OnResUpdate = OnResUpdate
UITradeCenterView.OnTradeFinish = OnTradeFinish
UITradeCenterView.UpdateViewState = UpdateViewState
return UITradeCenterView
