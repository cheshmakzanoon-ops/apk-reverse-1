local RebateShopContentItem = BaseClass("RebateShopContentItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function RebateShopContentItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RebateShopContentItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function RebateShopContentItem:OnAddListener()
  base.OnAddListener(self)
end

function RebateShopContentItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RebateShopContentItem:ComponentDefine()
  self.BuyButton = self:AddComponent(UIButton, "")
  self.BuyButton:SetOnClick(function()
    self:OnBuyButtonClick()
  end)
  self.buyTxt = self:AddComponent(UIText, "buyTxt")
  self.freeContent = self:AddComponent(UIBaseContainer, "FreeContent")
  self.exchangeContent = self:AddComponent(UIBaseContainer, "ExchangeContent")
  self.freeResItem = self:AddComponent(UICommonResItem, "FreeContent/freeResItem")
  self.exchangeResItem1 = self:AddComponent(UICommonResItem, "ExchangeContent/item1Content/exchangeResItem1")
  self.item1Num = self:AddComponent(UIText, "ExchangeContent/item1Content/item1Num")
  self.exchangeResItem2 = self:AddComponent(UICommonResItem, "ExchangeContent/item2Content/exchangeResItem2")
  self.item2Num = self:AddComponent(UIText, "ExchangeContent/item2Content/item2Num")
  self.noticContent = self:AddComponent(UIButton, "ExchangeContent/noticContent")
  self.noticContent:SetOnClick(function()
  end)
  self.beSelect = self:AddComponent(UIBaseContainer, "ExchangeContent/noticContent/beSelect")
  self.noticTipTxt = self:AddComponent(UIText, "ExchangeContent/noticContent/noticTipTxt")
  self.sellOutImg = self:AddComponent(UIBaseContainer, "sellOutImage")
end

function RebateShopContentItem:ComponentDestroy()
  self.BuyButton = nil
  self.buyTxt = nil
  self.freeContent = nil
  self.exchangeContent = nil
  self.freeResItem = nil
  self.exchangeResItem1 = nil
  self.item1Num = nil
  self.exchangeResItem2 = nil
  self.item2Num = nil
  self.noticContent = nil
  self.beSelect = nil
  self.noticTipTxt = nil
  self.sellOutImg = nil
end

function RebateShopContentItem:DataDefine()
end

function RebateShopContentItem:DataDestroy()
end

function RebateShopContentItem:SetData(showData)
  self.showData = showData
  self:RefreshView()
end

function RebateShopContentItem:RefreshView()
  local param = self.showData:GetRewardData()
  local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(self.showData.shopType, self.showData.id)
  local curBuy = goodsInfo and goodsInfo.boughtTimes or 0
  local maxBuy = self.showData.maxTimes
  local leftBuy = maxBuy - curBuy
  self.sellOutImg:SetActive(leftBuy <= 0)
  if 0 < self.showData.costNum then
    self.freeContent:SetActive(false)
    self.exchangeContent:SetActive(true)
    self.exchangeResItem2:ReInit(param)
    self.item2Num:SetActive(false)
    self.buyTxt:SetText("" .. leftBuy .. "/" .. maxBuy)
    local costParam = {}
    costParam.rewardType = self.showData.currencyType
    costParam.itemId = self.showData.currencyId
    costParam.count = self.showData.costNum
    self.exchangeResItem1:ReInit(costParam)
    self.exchangeResItem1:SetItemCountActive(false)
    local curNum = 0
    curNum = DataCenter.ItemData:GetItemCount(costParam.itemId)
    local showStr = ""
    if curNum >= costParam.count then
      showStr = curNum .. "/" .. costParam.count
    else
      showStr = string.format("<color=#dd2828> %s</color>", curNum) .. "/" .. costParam.count
    end
    self.item1Num:SetText(showStr)
  else
    self.freeResItem:ReInit(param)
    if 0 < leftBuy then
      self.buyTxt:SetLocalText(2000549)
    else
      self.buyTxt:SetText("" .. leftBuy .. "/" .. maxBuy)
    end
  end
end

function RebateShopContentItem:OnBuyButtonClick()
  local param = {}
  param.goodsInfo = {}
  if not (string.IsNullOrEmpty(self.showData.itemId) and string.IsNullOrEmpty(self.showData.resourceitem_id)) or not string.IsNullOrEmpty(self.showData.equipid) then
    local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(self.showData.shopType, self.showData.id)
    local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
    if 0 < self.showData.maxTimes and boughtTimes >= self.showData.maxTimes then
      UIUtil.ShowTipsId(129061)
      return
    end
    local rewardData = self.showData:GetRewardData()
    param.goodsInfo.rewardType = rewardData.rewardType
    param.goodsInfo.itemId = rewardData.itemId
    param.goodsInfo.count = rewardData.count
    local limit = self.showData.maxTimes - boughtTimes
    limit = math.max(limit, 0)
    param.goodsInfo.limitCount = limit == 0 and MaxLimit or limit
    param.goodsInfo.eachPrice = self.showData.costNum
  else
    param.goodsInfo.rewardType = RewardType.HERO
    param.goodsInfo.itemId = self.showData.hero
    param.goodsInfo.count = self.showData.itemNum
  end
  param.consumeInfo = {}
  param.consumeInfo.currencyType = self.showData.currencyType
  param.consumeInfo.currencyId = self.showData.currencyId
  
  function param.callback(buyCount)
    self:ProcessPurchase(buyCount)
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuy, {anim = true}, param)
end

function RebateShopContentItem:ProcessPurchase(buyCount)
  if not self:CheckCostEnough(true) then
    return
  end
  self.cacheBuyCount = buyCount
  SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, self.showData.id, nil, buyCount)
end

function RebateShopContentItem:CheckCostEnough(showTip)
  local resType = RewardToResType[self.showData.currencyType]
  if resType and DataCenter.ResourceManager:GetResourceIconByType(resType) then
    if resType == ResourceType.Gold then
      if LuaEntry.Player.gold < self.showData.costNum then
        if showTip then
          GoToUtil.GotoPayTips(self.showData.costNum)
        end
        return false
      end
    else
      local cnt = LuaEntry.Resource:GetCntByResType(resType)
      if cnt < self.showData.costNum then
        if showTip then
          local lackTab = {}
          local param = {}
          param.type = ResLackType.Res
          param.resType = resType
          param.targetNum = self.showData.costNum
          table.insert(lackTab, param)
          GoToResLack.GoToItemResLackList(lackTab)
        end
        return false
      end
    end
  else
    local curNum = DataCenter.ItemData:GetItemCount(self.showData.currencyId)
    if curNum < self.showData.costNum then
      if showTip then
        UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
      end
      return false
    end
  end
  return true
end

return RebateShopContentItem
