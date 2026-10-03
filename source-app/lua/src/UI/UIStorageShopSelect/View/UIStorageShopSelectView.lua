local base = UIBaseView
local UIStorageShopSelectView = BaseClass("UIStorageShopSelectView", base)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local ResourceItem = require("UI.UICapacityTable.Component.ResourceItem")
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local storageDes_path = "goods/UICapacityProgressBar/capacityDes"
local storageNum_path = "goods/UICapacityProgressBar/capacityDes/capacityNum"
local storageProg_path = "goods/UICapacityProgressBar/Slider"
local goodsSv_path = "goods/goodsList"
local goodsContent_path = "goods/goodsList/Viewport/Content"
local goodsIcon_path = "sell/operation/num/ItemIcon"
local subNumBtn_path = "sell/operation/num/DecNumBtn"
local addNumBtn_path = "sell/operation/num/AddNumBtn"
local curCount_path = "sell/operation/num/numTxt"
local subPriceBtn_path = "sell/operation/price/DecBtn"
local addPriceBtn_path = "sell/operation/price/AddBtn"
local iptCurPrice_path = "sell/operation/price/curPrice/InputField"
local maxPriceBtn_path = "sell/operation/maxBtn"
local minPriceBtn_path = "sell/operation/minBtn"
local confirmBtn_path = "sell/UseBtn"
local confirmBtnTxt_path = "sell/UseBtn/UseBtnName"
local emptyTip_path = "goods/emptyTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.curSlotIndex = self:GetUserData()
  self:RefreshAll()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(141050)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.storageDesN = self:AddComponent(UIText, storageDes_path)
  self.storageDesN:SetLocalText(100505)
  self.storageNumN = self:AddComponent(UIText, storageNum_path)
  self.storageProgN = self:AddComponent(UISlider, storageProg_path)
  self.goodsSvN = self:AddComponent(UIScrollView, goodsSv_path)
  self.goodsSvN:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.goodsSvN:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.goodsContentN = self:AddComponent(UIBaseContainer, goodsContent_path)
  self.goodsIconN = self:AddComponent(UIImage, goodsIcon_path)
  self.subNumBtnN = self:AddComponent(UIButton, subNumBtn_path)
  self.subNumBtnN:SetOnClick(function()
    self:OnClickSubNumBtn()
  end)
  self.addNumBtnN = self:AddComponent(UIButton, addNumBtn_path)
  self.addNumBtnN:SetOnClick(function()
    self:OnClickAddNumBtn()
  end)
  self.curNumTxtN = self:AddComponent(UIText, curCount_path)
  self.subPriceBtnN = self:AddComponent(UIButton, subPriceBtn_path)
  self.subPriceBtnN:SetOnClick(function()
    self:OnClickSubPriceBtn()
  end)
  self.addPriceBtnN = self:AddComponent(UIButton, addPriceBtn_path)
  self.addPriceBtnN:SetOnClick(function()
    self:OnClickAddPriceBtn()
  end)
  self.curPriceIptN = self:AddComponent(UIInput, iptCurPrice_path)
  self.curPriceIptN:SetOnEndEdit(function(value)
    self:OnInputPriceEnd(value)
  end)
  self.maxPriceBtnN = self:AddComponent(UIButton, maxPriceBtn_path)
  self.maxPriceBtnN:SetOnClick(function()
    self:OnClickMaxPriceBtn()
  end)
  self.minPriceBtnN = self:AddComponent(UIButton, minPriceBtn_path)
  self.minPriceBtnN:SetOnClick(function()
    self:OnClickMinPriceBtn()
  end)
  self.confirmBtnN = self:AddComponent(UIButton, confirmBtn_path)
  self.confirmBtnN:SetOnClick(function()
    self:OnClickConfirmBtn()
  end)
  self.confirmBtnTxtN = self:AddComponent(UIText, confirmBtnTxt_path)
  self.confirmBtnTxtN:SetLocalText(141051)
  self.emptyTipN = self:AddComponent(UIText, emptyTip_path)
  self.emptyTipN:SetLocalText(140042)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.storageNumN = nil
  self.storageProgN = nil
  self.goodsSvN = nil
  self.goodsContentN = nil
  self.goodsIconN = nil
  self.subNumBtnN = nil
  self.addNumBtnN = nil
  self.curNumTxtN = nil
  self.subPriceBtnN = nil
  self.addPriceBtnN = nil
  self.curPriceIptN = nil
  self.confirmBtnN = nil
end

local function DataDefine(self)
  self.curSlotIndex = nil
  self.goodsList = {}
  self.curNum = 0
  self.curPrice = 0
  self.numMax = 0
  self.priceBase = 0
  self.pricePerMax = 0
  self.pricePerMin = 0
  self.priceMax = 0
  self.priceMin = 0
  self.curIndex = nil
  self.curItem = nil
  self.pricePerChange = 1
end

local function DataDestroy(self)
  self.curSlotIndex = nil
  self.goodsList = nil
  self.curNum = nil
  self.curPrice = nil
  self.numMax = nil
  self.priceBase = nil
  self.pricePerMax = nil
  self.pricePerMin = nil
  self.priceMax = nil
  self.priceMin = nil
  self.curIndex = nil
  self.curItem = nil
  self.pricePerChange = nil
end

local function RefreshAll(self)
  self.goodsList = self.ctrl:GetStorageContents()
  local storageMax = DataCenter.ResourceItemDataManager:GetFreezerStorageMax()
  local curNum = DataCenter.ResourceItemDataManager:GetResourceItemTotalNumByType(UICapacityTableTab.Farming)
  self.storageNumN:SetText(tostring(curNum) .. "/" .. storageMax)
  local percent = curNum / math.max(1, storageMax)
  self.storageProgN:SetValue(percent)
  self:ShowGoodsList()
  self:InitSell()
  self:RefreshSell()
end

local function ShowGoodsList(self)
  if #self.goodsList == 0 then
    self.goodsSvN:SetActive(false)
    self.emptyTipN:SetActive(true)
  else
    self.goodsSvN:SetTotalCount(#self.goodsList)
    self.goodsSvN:RefillCells()
    self.goodsSvN:SetActive(false)
    self.goodsSvN:SetActive(true)
    self.emptyTipN:SetActive(false)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.goodsContentN:AddComponent(ResourceItem, itemObj)
  cellItem.gameObject.transform:Set_localScale(0.83, 0.83, 0.83)
  local param = self.goodsList[index]
  param.index = index
  
  function param.callBack(cellTrans, index)
    self:OnSelectGoods(cellTrans, index)
  end
  
  cellItem:RefreshData(param)
end

local function OnItemMoveOut(self, itemObj, index)
  self.goodsContentN:RemoveComponent(itemObj.name, ResourceItem)
end

local function InitSell(self)
  if not self.curIndex then
    self.goodsIconN:SetActive(false)
    self.curItem = nil
    self.curNum = 0
    self.curPrice = 0
    self.numMax = 0
  else
    self.curItem = self.goodsList[self.curIndex]
    local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self.curItem.itemId)
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.curItem.itemId)
    if itemData ~= nil then
      self.numMax = itemData.number
      local confMax = 0
      if template and template.trade_num and 0 < template.trade_num then
        confMax = template.trade_num
      else
        confMax = LuaEntry.DataConfig:TryGetNum("tradingbank_para", "k2")
      end
      local effectAddMax = LuaEntry.Effect:GetGameEffect(EffectDefine.STORAGE_SHOP_ADD_MAX_NUM)
      confMax = confMax + Mathf.Round(effectAddMax)
      self.numMax = confMax < self.numMax and confMax or self.numMax
    else
      self.numMax = 0
    end
    self.curNum = math.floor(itemData.number / 2)
    self.curNum = self.curNum > self.numMax and self.numMax or self.curNum
    self.curNum = self.curNum < 1 and 1 or self.curNum
    local maxPriceMulti = LuaEntry.DataConfig:TryGetNum("tradingbank_para", "k4")
    local minPriceMulti = LuaEntry.DataConfig:TryGetNum("tradingbank_para", "k3")
    local effPercent = 1 + LuaEntry.Effect:GetGameEffect(EffectDefine.GLOBAL_MONEY_EXTRA_PERCENT) / 100
    self.pricePerMin = math.floor(template.price * minPriceMulti)
    self.pricePerMin = self.pricePerMin == 0 and 1 or self.pricePerMin
    self.pricePerMax = Mathf.Round(template.price * maxPriceMulti * effPercent + 0.49)
    self.priceBase = template.price
    local delta = LuaEntry.DataConfig:TryGetNum("tradingbank_para", "k16")
    self.pricePerChange = math.ceil(self.priceBase * effPercent / delta)
    self.priceMax = math.ceil(self.curNum * self.pricePerMax)
    self.priceMin = math.floor(self.curNum * self.pricePerMin)
    self.defaultPriceMulti = math.floor(LuaEntry.DataConfig:TryGetNum("tradingbank_para", "k10") * effPercent * template.price)
    self.curPrice = self.defaultPriceMulti * self.curNum
    self.goodsIconN:SetActive(true)
    self.goodsIconN:LoadSprite(template:GetIconPath())
  end
end

local function RefreshSell(self)
  self.curNumTxtN:SetText(self.curNum)
  self.curPriceIptN:SetText(self.curPrice)
  self:ResetButtonColor()
  local isAvailabel = self.curNum >= 1
  UIGray.SetGray(self.confirmBtnN.transform, not isAvailabel, isAvailabel)
end

local function ResetButtonColor(self)
  local isPriceMax = self.curPrice == self.priceMax
  UIGray.SetGray(self.maxPriceBtnN.transform, isPriceMax, not isPriceMax)
  UIGray.SetGray(self.addPriceBtnN.transform, isPriceMax, not isPriceMax)
  local isPriceMin = self.curPrice == self.priceMin
  UIGray.SetGray(self.minPriceBtnN.transform, isPriceMin, not isPriceMin)
  UIGray.SetGray(self.subPriceBtnN.transform, isPriceMin, not isPriceMin)
  local isMinNum = self.curNum <= 1
  UIGray.SetGray(self.subNumBtnN.transform, isMinNum, not isMinNum)
  local isMaxNum = self.curNum >= self.numMax
  UIGray.SetGray(self.addNumBtnN.transform, isMaxNum, not isMaxNum)
end

local function OnSelectGoods(self, cellTrans, index)
  self.curIndex = index
  self:InitSell()
  self:RefreshSell()
end

local function OnClickSubNumBtn(self)
  if not self.curItem or self.curNum <= 1 then
    return
  end
  self.curNum = self.curNum - 1
  self.priceMax = self.curNum * self.pricePerMax
  self.priceMin = self.curNum * self.pricePerMin
  self.curPrice = self.curPrice - self.defaultPriceMulti
  self.curPrice = self.curPrice >= self.priceMin and self.curPrice or self.priceMin
  self.curPrice = self.curPrice <= self.priceMax and self.curPrice or self.priceMax
  self:RefreshSell()
end

local function OnClickAddNumBtn(self)
  if not self.curItem or self.curNum >= self.numMax then
    return
  end
  self.curNum = self.curNum + 1
  self.priceMax = self.curNum * self.pricePerMax
  self.priceMin = self.curNum * self.pricePerMin
  self.curPrice = self.curPrice + self.defaultPriceMulti
  self.curPrice = self.curPrice <= self.priceMax and self.curPrice or self.priceMax
  self:RefreshSell()
end

local function OnClickSubPriceBtn(self)
  if self.curPrice > self.priceMin then
    local tempP = self.curPrice - self.pricePerChange * self.curNum
    if tempP < self.priceMin then
      tempP = self.priceMin
    end
    self.curPrice = tempP
    self:RefreshSell()
  end
end

local function OnClickAddPriceBtn(self)
  if self.curPrice < self.priceMax then
    local tempP = self.curPrice + self.pricePerChange * self.curNum
    if tempP > self.priceMax then
      tempP = self.priceMax
    end
    self.curPrice = tempP
    self:RefreshSell()
  end
end

local function OnClickMaxPriceBtn(self)
  self.curPrice = self.priceMax
  self:RefreshSell()
end

local function OnClickMinPriceBtn(self)
  self.curPrice = self.priceMin
  self:RefreshSell()
end

local function OnClickConfirmBtn(self)
  local param = {}
  self.slotInfoList = DataCenter.StorageShopManager:GetSelfSlotsInfo()
  param.uuid = self:GetSlotInfo(self.curSlotIndex).uuid
  param.itemId = self.curItem.itemId
  param.num = self.curNum
  param.price = self.curPrice
  SFSNetwork.SendMessage(MsgDefines.StorageShopAddGoods, param)
  self.ctrl:CloseSelf()
end

local function OnInputPriceEnd(self, value)
  local tempP = tonumber(value) or 0
  self.curPrice = tempP > self.priceMax and self.priceMax or tempP
  self.curPrice = self.curPrice < self.priceMin and self.priceMin or self.curPrice
  self:RefreshSell()
end

local function GetSlotInfo(self, index)
  for _, v in pairs(self.slotInfoList) do
    if v.index == index then
      return v
    end
  end
  return nil
end

UIStorageShopSelectView.OnCreate = OnCreate
UIStorageShopSelectView.OnDestroy = OnDestroy
UIStorageShopSelectView.ComponentDefine = ComponentDefine
UIStorageShopSelectView.ComponentDestroy = ComponentDestroy
UIStorageShopSelectView.DataDefine = DataDefine
UIStorageShopSelectView.DataDestroy = DataDestroy
UIStorageShopSelectView.RefreshAll = RefreshAll
UIStorageShopSelectView.ShowGoodsList = ShowGoodsList
UIStorageShopSelectView.OnItemMoveIn = OnItemMoveIn
UIStorageShopSelectView.OnItemMoveOut = OnItemMoveOut
UIStorageShopSelectView.OnSelectGoods = OnSelectGoods
UIStorageShopSelectView.InitSell = InitSell
UIStorageShopSelectView.RefreshSell = RefreshSell
UIStorageShopSelectView.OnClickSubNumBtn = OnClickSubNumBtn
UIStorageShopSelectView.OnClickAddNumBtn = OnClickAddNumBtn
UIStorageShopSelectView.OnClickSubPriceBtn = OnClickSubPriceBtn
UIStorageShopSelectView.OnClickAddPriceBtn = OnClickAddPriceBtn
UIStorageShopSelectView.OnClickConfirmBtn = OnClickConfirmBtn
UIStorageShopSelectView.OnClickMaxPriceBtn = OnClickMaxPriceBtn
UIStorageShopSelectView.OnClickMinPriceBtn = OnClickMinPriceBtn
UIStorageShopSelectView.OnInputPriceEnd = OnInputPriceEnd
UIStorageShopSelectView.ResetButtonColor = ResetButtonColor
UIStorageShopSelectView.GetSlotInfo = GetSlotInfo
return UIStorageShopSelectView
