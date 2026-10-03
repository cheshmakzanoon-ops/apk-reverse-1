local base = UIBaseView
local UIStorageShopView = BaseClass("UIStorageShopView", base)
local Localization = CS.GameEntry.Localization
local StorageShopSlotItem = require("UI.UIStorageShop.Component.StorageShopSlotItem")
local titleTxt_path = "Offset/titleTxt"
local shareBtn_path = "Offset/shareBtn"
local closeBtn_path = "Offset/closeBtn"
local bgBtn_path = "Panel"
local reportBtn_path = "Offset/shopsListBtn"
local reportBtnTxt_path = "Offset/shopsListBtn/goTxt"
local content_path = "Offset/Scroll View/Viewport/Content"
local slotTemplate_path = "templates(inactive)/StorageShopSlotItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshAll()
end

local function OnDestroy(self)
  self.slotTemplateN.gameObject:GameObjectRecycleAll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleTxtN = self:AddComponent(UIText, titleTxt_path)
  self.shareBtnN = self:AddComponent(UIButton, shareBtn_path)
  self.shareBtnN:SetOnClick(function()
    self:OnClickShareBtn()
  end)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    if self.shopInfo then
      EventManager:GetInstance():Broadcast(EventId.StorageShopDataChange, self.shopInfo.pointId)
    end
    self.ctrl:CloseSelf()
  end)
  self.bgBtnN = self:AddComponent(UIButton, bgBtn_path)
  self.bgBtnN:SetOnClick(function()
    if self.shopInfo then
      EventManager:GetInstance():Broadcast(EventId.StorageShopDataChange, self.shopInfo.pointId)
    end
    self.ctrl:CloseSelf()
  end)
  self.reportBtnTxtN = self:AddComponent(UIText, reportBtnTxt_path)
  self.reportBtnTxtN:SetLocalText(141042)
  self.reportBtnN = self:AddComponent(UIButton, reportBtn_path)
  self.reportBtnN:SetOnClick(function()
    self.OnClickReportBtn()
  end)
  self.contentN = self:AddComponent(UIBaseContainer, content_path)
  self.slotTemplateN = self:AddComponent(UIBaseContainer, slotTemplate_path)
  self.slotTemplateN.gameObject:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.titleTxtN = nil
  self.shareBtnN = nil
  self.closeBtnN = nil
  self.reportBtnN = nil
  self.contentN = nil
  self.slotTemplateN = nil
end

local function DataDefine(self)
  self.playerUid = nil
  self.isSelfShop = nil
  self.shopInfo = nil
  self.slotInfoList = {}
end

local function DataDestroy(self)
  self.playerUid = nil
  self.isSelfShop = nil
  self.shopInfo = nil
  self.slotInfoList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.StorageShopGetOtherShopInfo, self.ShowOtherShop)
  self:AddUIListener(EventId.StorageShopRemoveGoods, self.ShowMyShop)
  self:AddUIListener(EventId.StorageShopBuyGoodsSucc, self.ShowOtherShop)
  self:AddUIListener(EventId.StorageShopClaimMoneyBack, self.ShowMyShop)
  self:AddUIListener(EventId.StorageShopAddGoods, self.ShowMyShop)
  self:AddUIListener(EventId.StorageShopUnlockSlotSucc, self.ShowMyShop)
  self:AddUIListener(EventId.StorageShopSoldSucc, self.ShowMyShop)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.StorageShopGetOtherShopInfo, self.ShowOtherShop)
  self:RemoveUIListener(EventId.StorageShopRemoveGoods, self.ShowMyShop)
  self:RemoveUIListener(EventId.StorageShopBuyGoodsSucc, self.ShowOtherShop)
  self:RemoveUIListener(EventId.StorageShopClaimMoneyBack, self.ShowMyShop)
  self:RemoveUIListener(EventId.StorageShopAddGoods, self.ShowMyShop)
  self:RemoveUIListener(EventId.StorageShopUnlockSlotSucc, self.ShowMyShop)
  self:RemoveUIListener(EventId.StorageShopSoldSucc, self.ShowMyShop)
  base.OnRemoveListener(self)
end

local function RefreshAll(self)
  self.playerUid = self:GetUserData()
  self.isSelfShop = not self.playerUid or self.playerUid == LuaEntry.Player.uid
  if not self.isSelfShop then
    SFSNetwork.SendMessage(MsgDefines.StorageShopGetShopInfo, self.playerUid)
  else
    self:ShowMyShop()
  end
end

local function ShowMyShop(self)
  self.slotInfoList = DataCenter.StorageShopManager:GetSelfSlotsInfo()
  self.titleTxtN:SetLocalText(141046, LuaEntry.Player.name)
  self.shareBtnN:SetActive(true)
  self.reportBtnN:SetActive(true)
  self:RefreshSlots()
end

local function ShowOtherShop(self)
  self.shopInfo = DataCenter.StorageShopManager:GetCurOtherShopInfo()
  if not self.shopInfo then
    return
  end
  self.titleTxtN:SetLocalText(141046, self.shopInfo.name)
  self.slotInfoList = self.shopInfo:GetOnSaleSlots()
  self.shareBtnN:SetActive(false)
  self.reportBtnN:SetActive(true)
  self:RefreshSlots()
end

local function RefreshSlots(self)
  self.contentN:RemoveComponents(StorageShopSlotItem)
  self.slotTemplateN.gameObject:GameObjectRecycleAll()
  local slotNum = #self.slotInfoList
  if self.isSelfShop then
    local maxSlotNum = self.ctrl:GetMaxSlotNum()
    if slotNum < maxSlotNum then
      slotNum = slotNum + 1
    end
  end
  for i = 1, slotNum do
    local item = self.slotTemplateN.gameObject:GameObjectSpawn(self.contentN.transform)
    item.name = "item" .. i
    local obj = self.contentN:AddComponent(StorageShopSlotItem, item.name)
    obj:SetItem(i, nil, self.isSelfShop)
  end
end

local function GetSlotInfo(self, index)
  return self.slotInfoList[index]
end

local function CheckIfIsSelfShop(self)
  if self.isSelfShop then
    return true
  else
    return false, self.shopInfo
  end
end

local function OnClickShareBtn(self)
  local onSellItems = {}
  for i, v in ipairs(self.slotInfoList) do
    if v.state == StorageShopSlotState.OnSell then
      table.insert(onSellItems, v.itemId)
    end
  end
  if #onSellItems == 0 then
    UIUtil.ShowTipsId(141047)
    return
  end
  local pointId
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_KONBINI)
  if list ~= nil then
    for k, v in pairs(list) do
      if not pointId then
        pointId = v.pointId
        break
      end
    end
  end
  self.ctrl:OnShareClick(pointId, onSellItems)
end

local function OnClickReportBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopList)
end

UIStorageShopView.OnCreate = OnCreate
UIStorageShopView.OnDestroy = OnDestroy
UIStorageShopView.OnAddListener = OnAddListener
UIStorageShopView.OnRemoveListener = OnRemoveListener
UIStorageShopView.ComponentDefine = ComponentDefine
UIStorageShopView.ComponentDestroy = ComponentDestroy
UIStorageShopView.DataDefine = DataDefine
UIStorageShopView.DataDestroy = DataDestroy
UIStorageShopView.RefreshAll = RefreshAll
UIStorageShopView.RefreshSlots = RefreshSlots
UIStorageShopView.ShowMyShop = ShowMyShop
UIStorageShopView.ShowOtherShop = ShowOtherShop
UIStorageShopView.CheckIfIsSelfShop = CheckIfIsSelfShop
UIStorageShopView.GetSlotInfo = GetSlotInfo
UIStorageShopView.OnClickShareBtn = OnClickShareBtn
UIStorageShopView.OnClickReportBtn = OnClickReportBtn
return UIStorageShopView
