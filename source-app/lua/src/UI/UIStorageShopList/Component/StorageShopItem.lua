local StorageShopItem = BaseClass("StorageShopItem", UIBaseContainer)
local base = UIBaseContainer
local StorageShopSlotItem = require("UI.UIStorageShop.Component.StorageShopSlotItem")
local playerHead_path = "GameObject/UIPlayerHead/HeadIcon"
local playerName_path = "playerName"
local slotContent_path = "slotList"
local slotTemplate_path = "Templates(inactive)/StorageShopSlotItem"
local fgBtn_path = "Btn"
local emptyTip_path = "emptyTxt"
local playerHead_btn_path = "GameObject/UIPlayerHead"

local function OnCreate(self)
  base.OnCreate(self)
  self.playerHeadN = self:AddComponent(UIPlayerHead, playerHead_path)
  self.playerNameN = self:AddComponent(UIText, playerName_path)
  self.slotContentN = self:AddComponent(UIBaseContainer, slotContent_path)
  self.slotTemplateN = self:AddComponent(UIBaseContainer, slotTemplate_path)
  self.slotTemplateN.gameObject:GameObjectCreatePool()
  self.fgBtnN = self:AddComponent(UIButton, fgBtn_path)
  self.fgBtnN:SetOnClick(function()
    self:OnClickJumpToBtn()
  end)
  self.emptyTipN = self:AddComponent(UIText, emptyTip_path)
  self.emptyTipN:SetLocalText(372149)
  self.playerHead_btn = self:AddComponent(UIButton, playerHead_btn_path)
  self.playerHead_btn:SetOnClick(function()
    self:OnPlayerBtnClick()
  end)
end

local function OnDestroy(self)
  self.slotTemplateN.gameObject:GameObjectRecycleAll()
  self.playerHeadN = nil
  self.playerNameN = nil
  self.slotContentN = nil
  self.slotTemplateN = nil
  self.emptyTipN = nil
  self.playerHead_btn = nil
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.StorageShopBuyGoodsSucc, self.ShowShop)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.StorageShopBuyGoodsSucc, self.ShowShop)
  base.OnRemoveListener(self)
end

local function SetItem(self, shopInfo)
  self.curShopInfo = shopInfo
  self.slotInfoList = self.curShopInfo:GetOnSaleSlots()
  local serverId = ""
  if LuaEntry.Player.serverId ~= self.curShopInfo.serverId then
    serverId = "#" .. self.curShopInfo.serverId
  end
  self.playerHeadN:SetData(self.curShopInfo.uid, self.curShopInfo.pic, self.curShopInfo.picVer)
  local tempAbbr = string.IsNullOrEmpty(self.curShopInfo.abbr) and "" or "[" .. self.curShopInfo.abbr .. "]"
  self.playerNameN:SetText(serverId .. tempAbbr .. self.curShopInfo.name)
  self:ShowShop()
end

local function ShowShop(self)
  self.slotContentN:RemoveComponents(StorageShopSlotItem)
  self.slotTemplateN.gameObject:GameObjectRecycleAll()
  local hasGoods = false
  local slotNum = #self.slotInfoList
  for i = 1, slotNum do
    if self.slotInfoList[i].state == StorageShopSlotState.OnSell then
      hasGoods = true
      local item = self.slotTemplateN.gameObject:GameObjectSpawn(self.slotContentN.transform)
      item.name = "item" .. i
      local obj = self.slotContentN:AddComponent(StorageShopSlotItem, item.name)
      obj:ShowOtherSlot(self.slotInfoList[i], self.curShopInfo)
    end
  end
  self.emptyTipN:SetActive(not hasGoods)
end

local function OnClickJumpToBtn(self)
  self.view.ctrl:CloseSelf()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIStorageShop) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIStorageShop)
  end
  GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(self.curShopInfo.pointId), CS.SceneManager.World.InitZoom, 1.5)
end

local function OnPlayerBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.curShopInfo.uid)
end

StorageShopItem.OnCreate = OnCreate
StorageShopItem.OnDestroy = OnDestroy
StorageShopItem.SetItem = SetItem
StorageShopItem.ShowShop = ShowShop
StorageShopItem.OnAddListener = OnAddListener
StorageShopItem.OnRemoveListener = OnRemoveListener
StorageShopItem.OnClickJumpToBtn = OnClickJumpToBtn
StorageShopItem.OnPlayerBtnClick = OnPlayerBtnClick
return StorageShopItem
