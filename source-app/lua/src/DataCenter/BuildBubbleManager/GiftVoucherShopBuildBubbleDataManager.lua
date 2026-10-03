local GiftVoucherShopBuildBubbleDataManager = BaseClass("GiftVoucherShopBuildBubbleDataManager")
local targetShopType = CommonShopType.GiftVoucher
local targetItemId = "999901"
local needTipKey = "GiftVoucherBuildBubbleTipKey"

local function __init(self)
  self.isDataDirty = true
  self.isShowBubble = false
  self.bubbleShowSet = nil
  self:AddListener()
end

local function __delete(self)
  self.isDataDirty = true
  self.isShowBubble = nil
  self.bubbleShowSet = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.GiftVoucherNumChange, self.GetRefreshItemsMsg)
  EventManager:GetInstance():AddListener(EventId.UpdateOneCommonShop, self.OnShopDataChange)
  EventManager:GetInstance():AddListener(EventId.UpdateOneCommonShopGoods, self.OnBuyGoodsSucc)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.GiftVoucherNumChange, self.GetRefreshItemsMsg)
  EventManager:GetInstance():RemoveListener(EventId.UpdateOneCommonShop, self.OnShopDataChange)
  EventManager:GetInstance():RemoveListener(EventId.UpdateOneCommonShopGoods, self.OnBuyGoodsSucc)
end

local function GetRefreshItemsMsg()
  local self = DataCenter.GiftVoucherShopBuildBubbleDataManager
  self.isDataDirty = true
  self:TrySendMsg()
end

local function OnShopDataChange(shopType)
  local self = DataCenter.GiftVoucherShopBuildBubbleDataManager
  if shopType == targetShopType then
    self.isDataDirty = true
    self:TrySendMsg()
  end
end

local function OnBuyGoodsSucc(goodsId)
  local self = DataCenter.GiftVoucherShopBuildBubbleDataManager
  local shopGoodsTemp = LocalController:instance():getLine(TableName.LW_Shop, goodsId)
  if shopGoodsTemp and shopGoodsTemp.shop_id == CommonShopType.GiftVoucher then
    self.isDataDirty = true
    self:TrySendMsg()
  end
end

local function GetIsShowBubble(self)
  if self.isDataDirty then
    self.isDataDirty = false
    self.isShowBubble = false
    local goodsList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.GiftVoucher)
    local curSet = self:GetBubbleShowSet()
    if goodsList and 0 < #goodsList and curSet then
      local curNum = DataCenter.ItemData:GetItemCount(targetItemId) or 0
      for k, v in pairs(goodsList) do
        if curNum >= v.costNum then
          local state = self:GetGoodsState(v)
          if state == ShoGoodsState.Sale then
            self.isShowBubble = true
            break
          end
        end
      end
    end
  end
  return self.isShowBubble
end

local function GetGoodsState(self, goodsConf)
  local state = ShoGoodsState.None
  if self:IsGoodsItemSoldOut(goodsConf) then
    state = ShoGoodsState.SoldOut
  elseif self:IsGoodsItemUnlock(goodsConf) then
    state = ShoGoodsState.isUnlock
  elseif self:IsGoodsItemHaveItem(goodsConf) then
    state = ShoGoodsState.isHave
  else
    state = ShoGoodsState.Sale
  end
  return state
end

local function IsGoodsItemSoldOut(self, goodsConf)
  local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(CommonShopType.GiftVoucher, goodsConf.id)
  local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
  return boughtTimes >= goodsConf.maxTimes
end

local function IsGoodsItemUnlock(self, goodsConf)
  local itemId = goodsConf.itemId
  local items = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  local skinId = tonumber(items.para1)
  local skinData = DataCenter.DecorationDataManager:GetSkinDataById(skinId)
  return skinData and skinData.expireTime == 0
end

local function IsGoodsItemHaveItem(self, goodsConf)
  local isHave = false
  local itemId = goodsConf.itemId
  local items = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if items == nil then
    return isHave
  end
  if items.type ~= GOODS_TYPE.GOODS_TYPE_113 then
    return isHave
  end
  local skinId = tonumber(items.para1)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  local gain = template.gainMethod
  for k, v in pairs(gain) do
    local itemData = DataCenter.ItemTemplateManager:GetItemTemplate(v.id)
    if itemData and tonumber(itemData.para2) == 0 and 0 < DataCenter.ItemData:GetItemCount(v.id) then
      isHave = true
      break
    end
  end
  return isHave
end

local function TrySendMsg(self)
  if self.timer ~= nil then
    return
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    EventManager:GetInstance():Broadcast(EventId.GiftVoucherBubbleNeedRefresh)
  end, 1)
end

local function GetCostItemId(self)
  return targetItemId
end

local function GetBubbleShowSet(self)
  if self.bubbleShowSet == nil then
    self.bubbleShowSet = CS.GameEntry.Setting:GetBool(needTipKey, true)
  end
  return self.bubbleShowSet
end

local function SetBubbleShowSet(self, value)
  self.bubbleShowSet = value
  CS.GameEntry.Setting:SetBool(needTipKey, value)
  self.isDataDirty = true
  self:TrySendMsg()
end

GiftVoucherShopBuildBubbleDataManager.__init = __init
GiftVoucherShopBuildBubbleDataManager.__delete = __delete
GiftVoucherShopBuildBubbleDataManager.AddListener = AddListener
GiftVoucherShopBuildBubbleDataManager.RemoveListener = RemoveListener
GiftVoucherShopBuildBubbleDataManager.GetRefreshItemsMsg = GetRefreshItemsMsg
GiftVoucherShopBuildBubbleDataManager.OnShopDataChange = OnShopDataChange
GiftVoucherShopBuildBubbleDataManager.OnBuyGoodsSucc = OnBuyGoodsSucc
GiftVoucherShopBuildBubbleDataManager.TrySendMsg = TrySendMsg
GiftVoucherShopBuildBubbleDataManager.GetIsShowBubble = GetIsShowBubble
GiftVoucherShopBuildBubbleDataManager.GetCostItemId = GetCostItemId
GiftVoucherShopBuildBubbleDataManager.GetBubbleShowSet = GetBubbleShowSet
GiftVoucherShopBuildBubbleDataManager.SetBubbleShowSet = SetBubbleShowSet
GiftVoucherShopBuildBubbleDataManager.GetGoodsState = GetGoodsState
GiftVoucherShopBuildBubbleDataManager.IsGoodsItemSoldOut = IsGoodsItemSoldOut
GiftVoucherShopBuildBubbleDataManager.IsGoodsItemUnlock = IsGoodsItemUnlock
GiftVoucherShopBuildBubbleDataManager.IsGoodsItemHaveItem = IsGoodsItemHaveItem
return GiftVoucherShopBuildBubbleDataManager
