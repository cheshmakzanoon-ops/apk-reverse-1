local StorageShopSlotItem = BaseClass("StorageShopSlotItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local bgBtn_path = "Bg"
local lockedN_path = "locked"
local lockedCost_path = "locked/NeedResourceCell/ResourceNum"
local emptyN_path = "empty"
local emptyTxtN_path = "empty/emptyTxt"
local sellingN_path = "goods"
local sellingPrice_path = "goods/priceBg/price"
local sellingIcon_path = "goods/iconImage"
local sellingCount_path = "goods/NumText"
local soldN_path = "Sold"
local soldTip_path = "Sold/soldBg/SoldTip"
local playerNme_path = "Sold/playerName"
local soldMoney_path = "Sold/moneyBg/money"
local soldPlayerIcon_path = "Sold/GameObject/UIPlayerHead/HeadIcon"
local soldMoneyIcon_path = "Sold/moneyBg/moneyIcon"
local cleaningN_path = "Cleaning"
local cleaningTime_path = "Cleaning/cleanTime"
local cleanTxt_path = "Cleaning/cleanTxt"
local golloesBtn_path = "golloesBuy"

local function OnCreate(self)
  base.OnCreate(self)
  self.bgBtnN = self:AddComponent(UIButton, bgBtn_path)
  self.bgBtnN:SetOnClick(function()
    self:OnClickSlot()
  end)
  self.lockedN = self:AddComponent(UIBaseContainer, lockedN_path)
  self.lockedCostN = self:AddComponent(UIText, lockedCost_path)
  self.emptyN = self:AddComponent(UIBaseContainer, emptyN_path)
  self.onSellN = self:AddComponent(UIBaseContainer, sellingN_path)
  self.onSellPriceN = self:AddComponent(UIText, sellingPrice_path)
  self.emptyTxtN = self:AddComponent(UIText, emptyTxtN_path)
  self.onSellGoodsIconN = self:AddComponent(UIImage, sellingIcon_path)
  self.onSellGoodsCountN = self:AddComponent(UIText, sellingCount_path)
  self.soldN = self:AddComponent(UIBaseContainer, soldN_path)
  self.soldTipN = self:AddComponent(UIText, soldTip_path)
  self.playerNameN = self:AddComponent(UIText, playerNme_path)
  self.soldMoneyN = self:AddComponent(UIText, soldMoney_path)
  self.soldPlayerIconN = self:AddComponent(UIPlayerHead, soldPlayerIcon_path)
  self.soldMoneyIconN = self:AddComponent(UIBaseContainer, soldMoneyIcon_path)
  self.cleaningN = self:AddComponent(UIBaseContainer, cleaningN_path)
  self.cleanTimeN = self:AddComponent(UIText, cleaningTime_path)
  self.cleanTxtN = self:AddComponent(UIText, cleanTxt_path)
  self.golloesBtnN = self:AddComponent(UIButton, golloesBtn_path)
  self.golloesBtnN:SetOnClick(function()
    self:OnClickGolloesBtn()
  end)
  self.stateContainerN = {}
  table.insert(self.stateContainerN, self.emptyN)
  table.insert(self.stateContainerN, self.onSellN)
  table.insert(self.stateContainerN, self.cleaningN)
  table.insert(self.stateContainerN, self.soldN)
end

local function OnDestroy(self)
  self:DelCleanTimer()
  self.bgBtnN = nil
  self.lockedN = nil
  self.lockedCostN = nil
  self.emptyN = nil
  self.emptyTxtN = nil
  self.playerNameN = nil
  self.onSellN = nil
  self.onSellPriceN = nil
  self.onSellGoodsIconN = nil
  self.onSellGoodsCountN = nil
  self.soldN = nil
  self.soldTipN = nil
  self.soldMoneyN = nil
  self.soldPlayerIconN = nil
  self.cleaningN = nil
  self.cleanTimeN = nil
  self.cleanTxtN = nil
  self.stateContainerN = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:AddUIListener(EventId.StorageShopShowBuySuccEff, self.ShowBuySuccEff)
end

local function OnDisable(self)
  self:RemoveUIListener(EventId.StorageShopShowBuySuccEff, self.ShowBuySuccEff)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnStorageSellToGolloes, self.ShowGolloesBuyEff)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnStorageSellToGolloes, self.ShowGolloesBuyEff)
  base.OnRemoveListener(self)
end

local function ShowMySlot(self, slotIndex, slotInfo)
  self.slotIndex = slotIndex
  self.slotInfo = slotInfo
  self.isSelfSlot = true
  self:ShowSlot()
end

local function ShowOtherSlot(self, slotInfo, playerInfo)
  self.slotInfo = slotInfo
  self.slotIndex = self.slotInfo.index
  self.playerInfo = playerInfo
  self.isSelfSlot = false
  self:ShowSlot()
end

local function SetItem(self, slotIndex, slotInfo, isSelfSlot)
  if not slotInfo then
    self.slotIndex = slotIndex
    self.slotInfo = slot
  else
    self.slotInfo = slotInfo
    self.slotIndex = self.slotInfo.index
  end
  self.isSelfSlot = isSelfSlot
  self:ShowSlot()
end

local function ShowSlot(self)
  if self.slotInfo == nil then
    for i, v in ipairs(self.stateContainerN) do
      v:SetActive(false)
    end
    self.lockedN:SetActive(true)
    local unlockCost = DataCenter.StorageShopManager:GetUnlockSlotCost(self.slotIndex)
    self.lockedCostN:SetText(unlockCost)
    self.golloesBtnN:SetActive(false)
  else
    self.golloesBtnN:SetActive(false)
    self.lockedN:SetActive(false)
    for i, v in ipairs(self.stateContainerN) do
      if i == self.slotInfo.state + 1 then
        v:SetActive(true)
      else
        v:SetActive(false)
      end
    end
    if self.slotInfo.state == StorageShopSlotState.OnSell then
      self.onSellPriceN:SetText(self.slotInfo.price)
      local itemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.slotInfo.itemId)
      self.onSellGoodsIconN:LoadSprite(itemTemplate:GetIconPath())
      self.onSellGoodsCountN:SetText(self.slotInfo.num .. "x")
      local showGolloesBuy = self:CheckIfShowGolloesBuy()
      self.golloesBtnN:SetActive(showGolloesBuy)
    elseif self.slotInfo.state == StorageShopSlotState.Empty then
      self.emptyTxtN:SetText(Localization:GetString(372138))
    elseif self.slotInfo.state == StorageShopSlotState.SoldOut then
      self.soldTipN:SetText(Localization:GetString(372137))
      local serverId = self.slotInfo.serverId and self.slotInfo.serverId ~= LuaEntry.Player.serverId and "#" .. self.slotInfo.serverId or ""
      local buyerAbbr = string.IsNullOrEmpty(self.slotInfo.buyerAbbr) and "" or "[" .. self.slotInfo.buyerAbbr .. "]"
      self.playerNameN:SetText(serverId .. buyerAbbr .. self.slotInfo.buyerName)
      self.soldMoneyN:SetText(self.slotInfo.price)
      self.soldPlayerIconN:SetData(self.slotInfo.buyerUid, self.slotInfo.buyerPic, self.slotInfo.buyerPicVer)
    elseif self.slotInfo.state == StorageShopSlotState.Cleaning then
      if self.isSelfSlot then
        self:SetCleanTime()
        self:AddCleanTimer()
      else
        self.cleanTxtN:SetLocalText(141044)
      end
    end
  end
end

local function CheckIfShowGolloesBuy(self)
  if LuaEntry.DataConfig:CheckSwitch("tradingbank_recover") and self.isSelfSlot then
    local durTime = LuaEntry.DataConfig:TryGetNum("tradingbank_para", "k11")
    local tempT = self.slotInfo.startTime + durTime * 1000
    local serverT = UITimeManager:GetInstance():GetServerTime()
    if tempT < serverT then
      return true
    end
  end
  return false
end

local function AddCleanTimer(self)
  function self.CleanTimerAction()
    self:SetCleanTime()
  end
  
  if self.cleanTimer == nil then
    self.cleanTimer = TimerManager:GetInstance():GetTimer(1, self.CleanTimerAction, self, false, false, false)
  end
  self.cleanTimer:Start()
end

local function SetCleanTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.slotInfo.cleanEndT - curTime
  if 0 < remainTime then
    self.cleanTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    self.cleanTxtN:SetText(Localization:GetString("141044"))
  else
    self.slotInfo:TryAdjustState()
    self:ShowSlot()
    self:DelCleanTimer()
  end
end

local function DelCleanTimer(self)
  if self.cleanTimer ~= nil then
    self.cleanTimer:Stop()
    self.cleanTimer = nil
  end
end

local function OnClickSlot(self)
  if self.slotInfo == nil then
    local unlockCost = DataCenter.StorageShopManager:GetUnlockSlotCost(self.slotIndex)
    local isEnough = self.view.ctrl:SendAddBoxMessage(ResourceType.Gold, unlockCost)
    if isEnough then
      UIUtil.ShowMessage(Localization:GetString("141045", unlockCost), 2, nil, nil, function()
        SFSNetwork.SendMessage(MsgDefines.StorageShopUnlockSlot, self.slotIndex)
      end, function()
      end)
    end
  elseif self.slotInfo.state == StorageShopSlotState.Empty then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopSelect, {anim = true}, self.slotInfo.index)
  elseif self.slotInfo.state == StorageShopSlotState.OnSell then
    if self.isSelfSlot then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopRetrieveNew, {anim = true}, self.slotInfo)
    else
      local isEnough = self.view.ctrl:SendAddBoxMessage(ResourceType.Food, self.slotInfo.price)
      if not isEnough then
        return
      end
      local isCapacityFull = false
      if DataCenter.ResourceItemDataManager:CheckIsStorageFull(self.slotInfo.num) then
        isCapacityFull = true
      end
      if isCapacityFull then
        GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
        return
      end
      local itemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.slotInfo.itemId)
      UIUtil.ShowMessage(Localization:GetString("320355", self.slotInfo.price, Localization:GetString(itemTemplate.name), self.slotInfo.num), 2, nil, nil, function()
        local param = {}
        param.uid = self.playerInfo.uid
        param.uuid = self.slotInfo.uuid
        param.serverId = self.playerInfo.serverId
        param.itemId = self.slotInfo.itemId
        param.price = self.slotInfo.price
        DataCenter.StorageShopManager:TryBuyGoods(param, self.slotInfo)
      end, function()
      end)
    end
  elseif self.slotInfo.state == StorageShopSlotState.Cleaning then
    UIUtil.ShowTipsId(141044)
  elseif self.slotInfo.state == StorageShopSlotState.SoldOut then
    local moneyTemplate = DataCenter.ResourceTemplateManager:GetResourceTemplate(ResourceType.Food)
    UIUtil.DoFly(RewardType.FOOD, 5, moneyTemplate.icon, self.soldMoneyIconN.transform.position, VecZero)
    SFSNetwork.SendMessage(MsgDefines.StorageShopClaimMoney, self.slotInfo.uuid)
  end
end

local function ShowBuySuccEff(self, uuid)
  if self.slotInfo and self.slotInfo.uuid and self.slotInfo.uuid == uuid then
    local tempType = RewardType.RESOURCE_ITEM
    local tempId = self.slotInfo.itemId
    local pic = RewardUtil.GetPic(tempType, tempId)
    UIUtil.DoFly(tempType, 5, pic, self.onSellGoodsIconN.transform.position, Vector3.New(0, 0, 0))
    self.slotInfo.state = StorageShopSlotState.SoldOut
  end
end

local function ShowGolloesBuyEff(self, uuid)
  if self.slotInfo and uuid == self.slotInfo.uuid then
    local moneyTemplate = DataCenter.ResourceTemplateManager:GetResourceTemplate(ResourceType.Food)
    UIUtil.DoFly(RewardType.FOOD, 5, moneyTemplate.icon, self.soldMoneyIconN.transform.position, VecZero)
  end
end

local function OnClickGolloesBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopRetrieveNew, {anim = true}, self.slotInfo)
end

local function GetPos(self)
  return self.transform.position
end

StorageShopSlotItem.OnCreate = OnCreate
StorageShopSlotItem.OnDestroy = OnDestroy
StorageShopSlotItem.OnAddListener = OnAddListener
StorageShopSlotItem.OnRemoveListener = OnRemoveListener
StorageShopSlotItem.OnEnable = OnEnable
StorageShopSlotItem.OnDisable = OnDisable
StorageShopSlotItem.ShowSlot = ShowSlot
StorageShopSlotItem.AddCleanTimer = AddCleanTimer
StorageShopSlotItem.SetCleanTime = SetCleanTime
StorageShopSlotItem.DelCleanTimer = DelCleanTimer
StorageShopSlotItem.OnClickSlot = OnClickSlot
StorageShopSlotItem.ShowBuySuccEff = ShowBuySuccEff
StorageShopSlotItem.ShowOtherSlot = ShowOtherSlot
StorageShopSlotItem.ShowMySlot = ShowMySlot
StorageShopSlotItem.ShowGolloesBuyEff = ShowGolloesBuyEff
StorageShopSlotItem.OnClickGolloesBtn = OnClickGolloesBtn
StorageShopSlotItem.GetPos = GetPos
StorageShopSlotItem.CheckIfShowGolloesBuy = CheckIfShowGolloesBuy
return StorageShopSlotItem
