local UILWTitaniumBlueProductItemRender = BaseClass("UILWTitaniumBlueProductItemRender", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local ui_common_res_item_path = "Bg/UICommonResItem"
local tips_text_path = "Bg/TipsText"
local sold_text_path = "Bg/SoldText"
local buy_btn_path = "Bg/BuyBtn"
local price_icon_path = "Bg/BuyBtn/Layout/PriceContent/PriceIcon"
local cur_price_text_path = "Bg/BuyBtn/Layout/PriceContent/CurPriceText"
local today_tag_icon_path = "Bg/TodayTagIcon"
local hot_tag_icon_path = "Bg/HotTagIcon"
local special_tag_icon_path = "Bg/SpecialTagIcon"
local buyConditionText_path = "Bg/BuyConditionText"

function UILWTitaniumBlueProductItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWTitaniumBlueProductItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTitaniumBlueProductItemRender:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshTitaniumBlueOneProductData, self.RefreshProductDataView)
  self:AddUIListener(EventId.RefreshItems, self.RefreshEnoughCostNum)
end

function UILWTitaniumBlueProductItemRender:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshTitaniumBlueOneProductData, self.RefreshProductDataView)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshEnoughCostNum)
  base.OnRemoveListener(self)
end

function UILWTitaniumBlueProductItemRender:ComponentDefine()
  self.ui_common_res_item = self:AddComponent(UICommonResItem, ui_common_res_item_path)
  self.tips_text = self:AddComponent(UIText, tips_text_path)
  self.sold_text = self:AddComponent(UIText, sold_text_path)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn:SetOnClick(function()
    self:BuyBtnClick()
  end)
  self.price_icon = self:AddComponent(UIImage, price_icon_path)
  self.cur_price_text = self:AddComponent(UIText, cur_price_text_path)
  self.today_tag_icon = self:AddComponent(UIImage, today_tag_icon_path)
  self.hot_tag_icon = self:AddComponent(UIImage, hot_tag_icon_path)
  self.special_tag_icon = self:AddComponent(UIImage, special_tag_icon_path)
  self.textBuyCondition = self:AddComponent(UIText, buyConditionText_path)
  self.textBuyCondition:SetActive(false)
end

function UILWTitaniumBlueProductItemRender:ComponentDestroy()
  self.ui_common_res_item = nil
  self.tips_text = nil
  self.sold_text = nil
  self.buy_btn = nil
  self.price_icon = nil
  self.cur_price_text = nil
  self.today_tag_icon = nil
  self.hot_tag_icon = nil
  self.special_tag_icon = nil
  self.textBuyCondition = nil
end

function UILWTitaniumBlueProductItemRender:Update1000MS()
  if self.productData ~= nil and self.productData.refreshType == 1 and self.updateTime then
    self:RefreshTimerCountdown()
  end
end

function UILWTitaniumBlueProductItemRender:RefreshProductDataView(productData)
  if self.productData.id == productData.id then
    self:RefreshView(productData)
  end
end

function UILWTitaniumBlueProductItemRender:SetData(activityId, productData)
  self.activityId = activityId
  self:RefreshView(productData)
end

function UILWTitaniumBlueProductItemRender:RefreshView(productData)
  self.updateTime = false
  self.productData = productData
  local costType, costId, costNum = self:GetCostData(self.productData)
  self.today_tag_icon:SetActive(self.productData.extraDisplay == 1)
  self.hot_tag_icon:SetActive(self.productData.extraDisplay == 2)
  self.special_tag_icon:SetActive(self.productData.extraDisplay == 3)
  self:RefreshEnoughCostNum()
  self.cur_price_text:SetText(costNum)
  local iconPath = DataCenter.RewardManager:GetPicByType(costType, costId)
  local iconScale = 0.5
  if costType == RewardType.GOODS then
    iconScale = 0.5
  else
    iconScale = 0.35
  end
  self.price_icon:LoadSprite(iconPath)
  self.price_icon:SetLocalScaleXYZ(iconScale, iconScale, iconScale)
  if table.IsNullOrEmpty(self.productData.rewardList) then
    self.ui_common_res_item:SetActive(false)
    Logger.LogError("\233\146\155\232\147\157\229\149\134\229\186\151\233\135\140\239\188\140\229\149\134\229\147\129Id\228\184\186: " .. tostring(self.productData.id) .. " \231\154\132\229\165\150\229\138\177\228\184\186\231\169\186")
  else
    self.ui_common_res_item:SetActive(true)
    self.ui_common_res_item:ReInit(self.productData.rewardList[1])
  end
  if self.productData.buyTimeLimit == -1 then
    self.buy_btn:SetActive(true)
    self.sold_text:SetText("")
    self.tips_text:SetText("")
    UIGray.SetGray(self.ui_common_res_item.transform, false, true)
  else
    local surplusCount = self.productData.buyTimeLimit - self.productData.buyTimes
    if 0 < surplusCount then
      UIGray.SetGray(self.ui_common_res_item.transform, false, true)
      self.buy_btn:SetActive(true)
      self.sold_text:SetText("")
      if self.productData.refreshType == 0 then
        self.tips_text:SetText(Localization:GetString("activity_blue_shop_desc12", surplusCount))
      else
        self.tips_text:SetText(Localization:GetString("activity_blue_shop_desc6", surplusCount))
      end
    else
      UIGray.SetGray(self.ui_common_res_item.transform, true, false)
      self.buy_btn:SetActive(false)
      self.sold_text:SetActive(true)
      self.sold_text:SetLocalText("activity_blue_shop_desc8")
      if self.productData.refreshType == 0 then
        self.tips_text:SetText("")
      elseif self.productData.refreshType == 1 then
        self.updateTime = true
        self:RefreshTimerCountdown()
      end
    end
  end
  if self.productData.IsShowOwned and self.productData:IsShowOwned() then
    self.buy_btn:SetActive(false)
    self.sold_text:SetActive(true)
    self.sold_text:SetText(Localization:GetString("building_center_desc23"))
  end
  local isBuyConditionOk = true
  local inconsistentConditions
  if self.productData.GetInconsistentConditions then
    inconsistentConditions = self.productData:GetInconsistentConditions()
    if not table.IsNullOrEmpty(inconsistentConditions) then
      isBuyConditionOk = false
    end
  end
  if not isBuyConditionOk then
    self.sold_text:SetActive(false)
    self.buy_btn:SetActive(false)
    self.textBuyCondition:SetActive(true)
    self.textBuyCondition:SetText(DataCenter.RewardManager:ConvertBuyConditionToText(inconsistentConditions[1]))
  end
end

function UILWTitaniumBlueProductItemRender:RefreshTimerCountdown()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local surplusTime = self.productData.nextResetTime - curTime
  if self.tips_text then
    if 0 < surplusTime then
      self.tips_text:SetText(Localization:GetString("activity_blue_shop_desc7", UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime)))
    else
      self.updateTime = false
      self.tips_text:SetText(Localization:GetString("activity_blue_shop_desc7", UITimeManager:GetInstance():MilliSecondToFmtString(0)))
    end
  end
end

function UILWTitaniumBlueProductItemRender:RefreshEnoughCostNum()
  if self.productData ~= nil and self.cur_price_text then
    local costType, costId, costNum = self:GetCostData(self.productData)
    local curHave = 0
    if costType == RewardType.GOODS then
      curHave = DataCenter.ItemData:GetItemCount(costId)
    else
      curHave = LuaEntry.Resource:GetCntByResType(costId)
    end
    if costNum <= curHave then
      self.cur_price_text:SetColor(WhiteColor)
    else
      self.cur_price_text:SetColor(RedColor)
    end
  end
end

function UILWTitaniumBlueProductItemRender:BuyBtnClick()
  if self.productData == nil then
    return
  end
  if self.productData.GetInconsistentConditions then
    local inconsistentConditions = self.productData:GetInconsistentConditions()
    if not table.IsNullOrEmpty(inconsistentConditions) then
      return
    end
  end
  local param = {}
  param.goodsInfo = {}
  if not table.IsNullOrEmpty(self.productData.rewardList) then
    local reward = self.productData.rewardList[1]
    param.goodsInfo.rewardType = reward.rewardType
    param.goodsInfo.itemId = reward.itemId
    param.goodsInfo.count = reward.count
    local surplusCount = self.productData.buyTimeLimit - self.productData.buyTimes
    surplusCount = math.max(surplusCount, 0)
    param.goodsInfo.limitCount = surplusCount == 0 and self.productData.buyTimePara or surplusCount
    param.goodsInfo.eachPrice = self.productData.costNum
  end
  param.consumeInfo = {}
  local costType, costId, costNum = self:GetCostData(self.productData)
  param.consumeInfo.currencyType = costType
  param.consumeInfo.currencyId = costId
  param.goodsInfo.eachPrice = costNum
  
  function param.callback(buyCount)
    SFSNetwork.SendMessage(MsgDefines.BlueShopBuy, self.activityId, self.productData.id, buyCount)
  end
  
  local rewardPackGroupId = DataCenter.LWTitaniumBlueStoreManager:GetGiftPackId()
  local giftPack = GiftPackManager.GetPacksByGroupId(rewardPackGroupId, false)
  if not table.IsNullOrEmpty(giftPack) then
    function param.notEnoughCallBack()
      local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
      
      if costType == RewardType.GOODS and activityData and tonumber(activityData.para_2) and tonumber(activityData.para_2) == costId then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.activityId, rewardPackGroupId, tonumber(self.productData.costId))
      elseif costType == RewardType.GOODS then
        LWResourceLackUtil:GotoGoodsItemLack(costId, costNum)
      elseif RewardToResType[costType] then
        LWResourceLackUtil:GotoResLack({
          {
            resType = RewardToResType[costType],
            need = costNum
          }
        })
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.activityId, rewardPackGroupId, tonumber(self.productData.costId))
      end
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuy, {anim = true}, param)
end

function UILWTitaniumBlueProductItemRender:GetCostData(productData)
  local costType = RewardType.GOODS
  local costId = 0
  local costNum = 0
  if 0 < productData.costId and 0 < productData.costNum then
    costType = RewardType.GOODS
    costId = productData.costId
    costNum = productData.costNum
  elseif 0 < productData.costResId and 0 < productData.costResNum then
    costType = ResTypeToReward[productData.costResId]
    costId = productData.costResId
    costNum = productData.costResNum
  end
  return costType, costId, costNum
end

return UILWTitaniumBlueProductItemRender
