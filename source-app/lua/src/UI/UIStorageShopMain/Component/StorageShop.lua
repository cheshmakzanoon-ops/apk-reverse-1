local base = UIBaseView
local StorageShop = BaseClass("StorageShop", base)
local Localization = CS.GameEntry.Localization
local StorageShopSlotItem = require("UI.UIStorageShop.Component.StorageShopSlotItem")
local titleTxt_path = "Offset/titleBg/titleTxt"
local titleBg_path = "Offset/titleBg"
local shareBtn_path = "Offset/shareBtn"
local shareBtnTxt_path = "Offset/shareBtn/shareTxt"
local emptyTip_path = "Offset/emptyTxt"
local svSlots_path = "Offset/Scroll View"
local content_path = "Offset/Scroll View/Viewport/Content"
local slotTemplate_path = "templates(inactive)/StorageShopSlotItem"
local extra_effect_path = "Offset/UIExtraEffect"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  if self.shopInfo then
    EventManager:GetInstance():Broadcast(EventId.StorageShopDataChange, self.shopInfo.pointId)
  end
  self.slotTemplateN.gameObject:GameObjectRecycleAll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleBg = self:AddComponent(UIBaseContainer, titleBg_path)
  self.titleTxtN = self:AddComponent(UIText, titleTxt_path)
  self.shareBtnN = self:AddComponent(UIButton, shareBtn_path)
  self.shareBtnN:SetOnClick(function()
    self:OnClickShareBtn()
  end)
  self.shareBtnTxtN = self:AddComponent(UIText, shareBtnTxt_path)
  self.shareBtnTxtN:SetLocalText(110073)
  self.svSlotsN = self:AddComponent(UIScrollRect, svSlots_path)
  self.emptyTipN = self:AddComponent(UIText, emptyTip_path)
  self.emptyTipN:SetLocalText(372149)
  self.contentN = self:AddComponent(UIBaseContainer, content_path)
  self.slotTemplateN = self:AddComponent(UIBaseContainer, slotTemplate_path)
  self.slotTemplateN.gameObject:GameObjectCreatePool()
  self.extra_effect = self:AddComponent(UIExtraEffect, extra_effect_path)
end

local function ComponentDestroy(self)
  self.titleTxtN = nil
  self.shareBtnN = nil
  self.closeBtnN = nil
  self.svSlotsN = nil
  self.contentN = nil
  self.slotTemplateN = nil
  self.extra_effect = nil
end

local function DataDefine(self)
  self.playerUid = nil
  self.isSelfShop = nil
  self.shopInfo = nil
  self.slotInfoList = {}
  self.cellList = {}
end

local function DataDestroy(self)
  self.playerUid = nil
  self.isSelfShop = nil
  self.shopInfo = nil
  self.slotInfoList = nil
  self.cellList = nil
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

local function ShowPanel(self, playerUid)
  self.playerUid = playerUid or LuaEntry.Player.uid
  self.isSelfShop = self.playerUid == LuaEntry.Player.uid
  if not self.isSelfShop then
    self:ShowOtherShop()
    local sid = DataCenter.StorageShopManager:GetOtherShopServer()
    SFSNetwork.SendMessage(MsgDefines.StorageShopGetShopInfo, self.playerUid, sid)
  else
    self:ShowMyShop(true)
  end
end

local function ShowMyShop(self, resetPos)
  if self.playerUid ~= LuaEntry.Player.uid then
    return
  end
  self.slotInfoList = DataCenter.StorageShopManager:GetSelfSlotsInfo()
  self.titleTxtN:SetLocalText(141046, LuaEntry.Player.name)
  self.shareBtnN:SetActive(true)
  self:RefreshSlots(resetPos)
  self.extra_effect:SetActive(true)
  self.extra_effect:SetData(HeroStationEffectType.GlobalMoney, self.view)
  self.extra_effect:SetTip(Localization:GetString("372145", self.extra_effect.val) .. "\n" .. Localization:GetString("162117"))
end

local function ShowOtherShop(self, resetPos)
  self.shopInfo = DataCenter.StorageShopManager:GetCurOtherShopInfo()
  if not self.shopInfo then
    return
  end
  self.titleTxtN:SetLocalText(141046, self.shopInfo.name)
  self.slotInfoList = self.shopInfo:GetOnSaleSlots(true)
  self.shareBtnN:SetActive(false)
  self.extra_effect:SetActive(false)
  self:RefreshSlots(resetPos)
end

local function RefreshSlots(self, resetPos)
  self.contentN:RemoveComponents(StorageShopSlotItem)
  self.slotTemplateN.gameObject:GameObjectRecycleAll()
  self.cellList = {}
  local totalSlotNum = self:GetSlotCount(true)
  local originSlotNum = self:GetSlotCount(false)
  if self.isSelfShop then
    local maxSlotNum = self.view.ctrl:GetMaxSlotNum()
    if originSlotNum < maxSlotNum then
      totalSlotNum = totalSlotNum + 1
    end
  end
  for i = 1, totalSlotNum do
    local item = self.slotTemplateN.gameObject:GameObjectSpawn(self.contentN.transform)
    item.name = "item" .. i
    local obj = self.contentN:AddComponent(StorageShopSlotItem, item.name)
    if self.isSelfShop then
      local shopInfo = self.slotInfoList[i]
      if shopInfo ~= nil then
        obj:ShowMySlot(i, shopInfo)
      else
        obj:ShowMySlot(originSlotNum + 1, nil)
      end
      self.cellList[i] = obj
    else
      obj:ShowOtherSlot(self.slotInfoList[i], self.shopInfo)
    end
  end
  self.emptyTipN:SetActive(totalSlotNum <= 0)
  if resetPos then
    if totalSlotNum <= 4 then
      self.svSlotsN:SetHorizontalNormalizedPosition(0.5)
    else
      self.svSlotsN:SetHorizontalNormalizedPosition(0)
    end
  end
end

local function GetSlotInfo(self, index)
  for _, v in pairs(self.slotInfoList) do
    if v.index == index then
      return v
    end
  end
  return nil
end

local function GetSlotCount(self, includeExtra)
  local count = 0
  for _, v in pairs(self.slotInfoList) do
    if includeExtra or v.index < DataCenter.StorageShopManager.EXTRA_SLOT_INDEX then
      count = count + 1
    end
  end
  return count
end

local function OnClickShareBtn(self)
  local onSellItems = {}
  local onSellSlots = {}
  for i, v in ipairs(self.slotInfoList) do
    if v.state == StorageShopSlotState.OnSell then
      table.insert(onSellItems, v.itemId)
      local shareSlot = {}
      shareSlot.itemId = v.itemId
      shareSlot.count = v.num
      table.insert(onSellSlots, shareSlot)
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
  self.view.ctrl:OnShareClick(pointId, onSellItems, onSellSlots)
end

local function GetCellEmptyPos(self)
  for i = 1, #self.slotInfoList do
    if self.slotInfoList[i].state == StorageShopSlotState.Empty then
      return self.cellList[i]:GetPos()
    end
  end
end

StorageShop.OnCreate = OnCreate
StorageShop.OnDestroy = OnDestroy
StorageShop.OnAddListener = OnAddListener
StorageShop.OnRemoveListener = OnRemoveListener
StorageShop.ComponentDefine = ComponentDefine
StorageShop.ComponentDestroy = ComponentDestroy
StorageShop.DataDefine = DataDefine
StorageShop.DataDestroy = DataDestroy
StorageShop.ShowPanel = ShowPanel
StorageShop.RefreshSlots = RefreshSlots
StorageShop.ShowMyShop = ShowMyShop
StorageShop.ShowOtherShop = ShowOtherShop
StorageShop.CheckIfIsSelfShop = CheckIfIsSelfShop
StorageShop.GetSlotInfo = GetSlotInfo
StorageShop.GetSlotCount = GetSlotCount
StorageShop.OnClickShareBtn = OnClickShareBtn
StorageShop.GetCellEmptyPos = GetCellEmptyPos
return StorageShop
