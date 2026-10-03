local base = UIBaseView
local UIStorageShopRetrieveNewView = BaseClass("UIStorageShopRetrieveNewView", base)
local Localization = CS.GameEntry.Localization
local title_path = "UICommonMidPopUpTitle/titleText"
local closeBtn_path = "UICommonMidPopUpTitle/CloseBtn"
local retrieveContainer_path = "ImgBg/scrollRect/content/retrieve"
local retrieveTitle_path = "ImgBg/scrollRect/content/retrieve/retrieveTitle"
local retrieveBtn_path = "ImgBg/scrollRect/content/retrieve/retrieveBtn"
local retrieveBtnTxt_path = "ImgBg/scrollRect/content/retrieve/retrieveBtn/retrieveBtnTxt"
local retrieveIcon_path = "ImgBg/scrollRect/content/retrieve/goods/iconImage"
local retrieveCount_path = "ImgBg/scrollRect/content/retrieve/goods/goodsCount"
local retrievePrice_path = "ImgBg/scrollRect/content/retrieve/goods/retrievePriceBg/retrievePrice"
local golloesContainer_path = "ImgBg/scrollRect/content/golloesBuy"
local golloesTitle_path = "ImgBg/scrollRect/content/golloesBuy/golloesBuyTitle"
local golloesPrice_path = "ImgBg/scrollRect/content/golloesBuy/sellPriceBg/sellPrice"
local golloesSellBtn_path = "ImgBg/scrollRect/content/golloesBuy/sellBtn"
local golloesSellBtnTxt_path = "ImgBg/scrollRect/content/golloesBuy/sellBtn/sellBtnTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshAll()
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(141049)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.retrieveContainerN = self:AddComponent(UIBaseContainer, retrieveContainer_path)
  self.retrieveTitleN = self:AddComponent(UIText, retrieveTitle_path)
  self.retrieveTitleN:SetLocalText(141049)
  self.retrieveBtnN = self:AddComponent(UIButton, retrieveBtn_path)
  self.retrieveBtnN:SetOnClick(function()
    self:OnClickRetrieveBtn()
  end)
  self.retrieveBtnTxtN = self:AddComponent(UIText, retrieveBtnTxt_path)
  self.retrieveBtnTxtN:SetLocalText(141049)
  self.retrieveIconN = self:AddComponent(UIImage, retrieveIcon_path)
  self.retrieveCountN = self:AddComponent(UIText, retrieveCount_path)
  self.retrievePriceN = self:AddComponent(UIText, retrievePrice_path)
  self.golloesContainerN = self:AddComponent(UIBaseContainer, golloesContainer_path)
  self.golloesTitleN = self:AddComponent(UIText, golloesTitle_path)
  self.golloesTitleN:SetLocalText(372189)
  self.golloesPriceN = self:AddComponent(UIText, golloesPrice_path)
  self.golloesSellBtnN = self:AddComponent(UIButton, golloesSellBtn_path)
  self.golloesSellBtnN:SetOnClick(function()
    self:OnClickGolloesBuyBtn()
  end)
  self.golloesSellBtnTxtN = self:AddComponent(UIText, golloesSellBtnTxt_path)
  self.golloesSellBtnTxtN:SetLocalText(372189)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.retrieveContainerN = nil
  self.retrieveTitleN = nil
  self.retrieveBtnN = nil
  self.retrieveBtnTxtN = nil
  self.retrieveIconN = nil
  self.retrieveCountN = nil
  self.retrievePriceN = nil
  self.golloesContainerN = nil
  self.golloesTitleN = nil
  self.golloesPriceN = nil
  self.golloesSellBtnN = nil
  self.golloesSellBtnTxtN = nil
end

local function DataDefine(self)
  self.slotInfo = nil
end

local function DataDestroy(self)
  self.slotInfo = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshAll(self)
  self.slotInfo = self:GetUserData()
  if not self.slotInfo then
    return
  end
  local itemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.slotInfo.itemId)
  self.retrieveIconN:LoadSprite(itemTemplate:GetIconPath())
  self.retrievePriceN:SetText(self.slotInfo.price)
  self.retrieveCountN:SetText(self.slotInfo.num .. "x")
  local showGolloesBuy = self:CheckIfShowGolloesBuy()
  if showGolloesBuy then
    self.golloesContainerN:SetActive(true)
    local golloesPrice = self:GetGolloesBuyPrice()
    self.golloesPriceN:SetText(golloesPrice)
  else
    self.golloesContainerN:SetActive(false)
  end
end

local function CheckIfShowGolloesBuy(self)
  if not self.slotInfo then
    return false
  end
  if LuaEntry.DataConfig:CheckSwitch("tradingbank_recover") then
    local durTime = LuaEntry.DataConfig:TryGetNum("tradingbank_para", "k11")
    local tempT = self.slotInfo.startTime + durTime * 1000
    local serverT = UITimeManager:GetInstance():GetServerTime()
    if tempT < serverT then
      return true
    end
  end
end

local function GetGolloesBuyPrice(self)
  if not self.slotInfo then
    return 0
  end
  local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.slotInfo.itemId)
  local golloesMulti = LuaEntry.DataConfig:TryGetNum("tradingbank_para", "k12")
  local tempP = template.price * golloesMulti * self.slotInfo.num
  tempP = DataCenter.HeroStationManager:CalcEffectedValue(tempP, HeroStationEffectType.GlobalMoney)
  tempP = Mathf.Round(tempP)
  local maxPrice = Mathf.Round(tempP)
  local golloesPrice = maxPrice
  if maxPrice > self.slotInfo.price then
    golloesPrice = self.slotInfo.price
  end
  return golloesPrice
end

local function OnClickRetrieveBtn(self)
  SFSNetwork.SendMessage(MsgDefines.StorageShopRemoveGoods, self.slotInfo.uuid)
  self.ctrl:CloseSelf()
end

local function OnClickGolloesBuyBtn(self)
  SFSNetwork.SendMessage(MsgDefines.StorageShopGolloesBuy, self.slotInfo.uuid)
  EventManager:GetInstance():Broadcast(EventId.OnStorageSellToGolloes, self.slotInfo.uuid)
  self.ctrl:CloseSelf()
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

UIStorageShopRetrieveNewView.OnCreate = OnCreate
UIStorageShopRetrieveNewView.OnDestroy = OnDestroy
UIStorageShopRetrieveNewView.OnAddListener = OnAddListener
UIStorageShopRetrieveNewView.OnRemoveListener = OnRemoveListener
UIStorageShopRetrieveNewView.ComponentDefine = ComponentDefine
UIStorageShopRetrieveNewView.ComponentDestroy = ComponentDestroy
UIStorageShopRetrieveNewView.DataDefine = DataDefine
UIStorageShopRetrieveNewView.DataDestroy = DataDestroy
UIStorageShopRetrieveNewView.RefreshAll = RefreshAll
UIStorageShopRetrieveNewView.GetGolloesBuyPrice = GetGolloesBuyPrice
UIStorageShopRetrieveNewView.CheckIfShowGolloesBuy = CheckIfShowGolloesBuy
UIStorageShopRetrieveNewView.OnClickCloseBtn = OnClickCloseBtn
UIStorageShopRetrieveNewView.OnClickRetrieveBtn = OnClickRetrieveBtn
UIStorageShopRetrieveNewView.OnClickGolloesBuyBtn = OnClickGolloesBuyBtn
return UIStorageShopRetrieveNewView
