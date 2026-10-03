local ActivityRebateNewShopItemComponent = BaseClass("ActivityRebateNewShopItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function ActivityRebateNewShopItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityRebateNewShopItemComponent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ActivityRebateNewShopItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function ActivityRebateNewShopItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityRebateNewShopItemComponent:ComponentDefine()
  self.imgExchangeBackground = self:AddComponent(UIImage, "ExchangeBackground")
  self.compTargetItem = self:AddComponent(UICommonResItem, "TargetItem")
  self.textExchangeTime = self:AddComponent(UIText, "ExchangeTimeText")
  self.imgCostIcon = self:AddComponent(UIImage, "CostIcon")
  self.textCost = self:AddComponent(UIText, "CostText")
  self.compTagContent = self:AddComponent(UIBaseContainer, "TagContent")
  self.imgTagContent = self:AddComponent(UIImage, "TagContent")
  self.textTagYellow = self:AddComponent(UIText, "TagContent/TagTextYellow")
  self.textTagRed = self:AddComponent(UIText, "TagContent/TagTextRed")
  self.compDarkMask = self:AddComponent(UIBaseContainer, "DarkMask")
  self.btn = self:AddComponent(UIButton, "Btn")
  self.btn:SetOnClick(function()
    self:OnBuyButtonClick()
  end)
  self.textBuyCondition = self:AddComponent(UIText, "BuyConditionText")
  self.textBuyCondition:SetActive(false)
end

function ActivityRebateNewShopItemComponent:ComponentDestroy()
  self.imgExchangeBackground = nil
  self.compTargetItem = nil
  self.textExchangeTime = nil
  self.imgCostIcon = nil
  self.textCost = nil
  self.compTagContent = nil
  self.imgTagContent = nil
  self.textTagYellow = nil
  self.textTagRed = nil
  self.compDarkMask = nil
  self.btn = nil
  self.textBuyCondition = nil
end

function ActivityRebateNewShopItemComponent:DataDefine()
end

function ActivityRebateNewShopItemComponent:DataDestroy()
end

function ActivityRebateNewShopItemComponent:SetData(showData, activityId)
  self.showData = showData
  self.activityId = activityId
  self:RefreshView()
end

function ActivityRebateNewShopItemComponent:RefreshView()
  local function GetReward()
    if self.showData.reward ~= nil then
      for i, v in pairs(self.showData.reward) do
        if v.value ~= nil then
          return {
            rewardType = v.type,
            
            itemId = v.value.id,
            count = v.value.num
          }
        end
      end
    end
  end
  
  if self.showData == nil then
    return
  end
  local reward = GetReward()
  if reward ~= nil then
    self.compTargetItem:SetActive(true)
    self.compTargetItem:ReInit(reward)
  else
    self.compTargetItem:SetActive(false)
  end
  local curBuy = checknumber(self.showData.butTimes)
  local maxBuy = checknumber(self.showData.buyTimeLimit)
  local isTimeLimit = maxBuy ~= -1
  self.textExchangeTime:SetActive(isTimeLimit)
  local canBuy = not isTimeLimit or 0 < maxBuy - curBuy
  self.compDarkMask:SetActive(not canBuy)
  self.btn:SetActive(canBuy)
  if isTimeLimit then
    local leftBuy = maxBuy - curBuy
    local refreshType = checknumber(self.showData.refreshType)
    if refreshType == 0 then
      self.textExchangeTime:SetLocalText("total_mobilization_desc9", tostring(leftBuy))
    else
      self.textExchangeTime:SetLocalText("total_mobilization_desc10", tostring(leftBuy))
    end
  end
  local soldOut = false
  if isTimeLimit and maxBuy - curBuy <= 0 then
    self.textCost:SetLocalText("total_mobilization_desc11")
    soldOut = true
  else
    local costNum = checknumber(self.showData.costNum)
    self.imgCostIcon:SetActive(0 < costNum)
    if 0 < costNum then
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(checknumber(self.showData.costId))
      if goods ~= nil then
        self.imgCostIcon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
      end
      local curNum = DataCenter.ItemData:GetItemCount(checknumber(self.showData.costId))
      local showStr = ""
      if costNum <= curNum then
        showStr = costNum
      else
        showStr = string.format("<color=#dd2828> %s</color>", costNum)
      end
      self.textCost:SetText(showStr)
    else
      self.textCost:SetLocalText("total_mobilization_desc16")
    end
  end
  local tagIndex = checknumber(self.showData.extraDisplay)
  self.compTagContent:SetActive(tagIndex ~= 0)
  self.textTagYellow:SetActive(tagIndex ~= 2)
  self.textTagRed:SetActive(tagIndex == 2)
  if tagIndex == 1 then
    self.imgTagContent:LoadSprite("Assets/Main/Sprites/UI/UILWCommonStore/fx_youhua_shangcheng_libao_libaoshangcheng_zhekou_huang.png")
    self.textTagYellow:SetLocalText("total_mobilization_desc6")
    self.textTagRed:SetLocalText("total_mobilization_desc6")
  end
  if tagIndex == 2 then
    self.imgTagContent:LoadSprite("Assets/Main/Sprites/UI/UILWCommonStore/cfm_youhua_shangcheng_libao_libaoshangcheng_zhekou.png")
    self.textTagYellow:SetLocalText("total_mobilization_desc7")
    self.textTagRed:SetLocalText("total_mobilization_desc7")
  end
  if tagIndex == 3 then
    self.imgTagContent:LoadSprite("Assets/Main/Sprites/UI/UILWCommonStore/fx_youhua_shangcheng_libao_libaoshangcheng_zhekou_huang.png")
    self.textTagYellow:SetLocalText("total_mobilization_desc8")
    self.textTagRed:SetLocalText("total_mobilization_desc8")
  end
  local displayType = checknumber(self.showData.displayType)
  if displayType == 0 then
    self.imgExchangeBackground:LoadSprite("Assets/Main/Sprites/UI/UIActivityRebateNew/FX_quanmianzhanzheng_duihuan03.png")
  end
  if displayType == 1 then
    self.imgExchangeBackground:LoadSprite("Assets/Main/Sprites/UI/UIActivityRebateNew/FX_quanmianzhanzheng_duihuan02.png")
  end
  local inconsistentConditions
  local buyConditions = DataCenter.RewardManager:ParseBuyConditionStr(self.showData.common_buy_condition or "")
  if not table.IsNullOrEmpty(buyConditions) then
    inconsistentConditions = DataCenter.RewardManager:GetInconsistentBuyConditions(buyConditions)
  end
  local isBuyConditionOk = table.IsNullOrEmpty(inconsistentConditions)
  if not isBuyConditionOk then
    self.textBuyCondition:SetText(DataCenter.RewardManager:ConvertBuyConditionToText(inconsistentConditions[1]))
    self.textBuyCondition:SetActive(true)
    self.imgCostIcon:SetActive(false)
    self.textCost:SetActive(false)
  else
    self.textBuyCondition:SetActive(false)
    self.imgCostIcon:SetActive(not soldOut)
    self.textCost:SetActive(true)
  end
end

function ActivityRebateNewShopItemComponent:OnBuyButtonClick()
  local function GetReward()
    if self.showData.reward ~= nil then
      for i, v in pairs(self.showData.reward) do
        if v.value ~= nil then
          return {
            rewardType = v.type,
            
            itemId = v.value.id,
            count = v.value.count
          }
        end
      end
    end
  end
  
  if self.showData == nil then
    return
  end
  local reward = GetReward()
  if reward == nil then
    return
  end
  local inconsistentConditions
  local buyConditions = DataCenter.RewardManager:ParseBuyConditionStr(self.showData.common_buy_condition)
  if not table.IsNullOrEmpty(buyConditions) then
    inconsistentConditions = DataCenter.RewardManager:GetInconsistentBuyConditions(buyConditions)
  end
  local isBuyConditionOk = table.IsNullOrEmpty(inconsistentConditions)
  if not isBuyConditionOk then
    return
  end
  local param = {}
  param.goodsInfo = {}
  param.goodsInfo.rewardType = reward.rewardType
  param.goodsInfo.itemId = reward.itemId
  param.goodsInfo.count = reward.count
  local maxBuy = checknumber(self.showData.buyTimeLimit)
  local curBuy = checknumber(self.showData.butTimes)
  local isTimeLimit = maxBuy ~= -1
  if isTimeLimit then
    local limit = maxBuy - curBuy
    limit = math.max(limit, 0)
    param.goodsInfo.limitCount = limit
  else
    param.goodsInfo.limitCount = -1
  end
  param.consumeInfo = {}
  local costNum = checknumber(self.showData.costNum)
  local costId = checknumber(self.showData.costId)
  local isFree = costId <= 0 or costNum <= 0
  if isFree then
    param.goodsInfo.eachPrice = 0
  else
    param.goodsInfo.eachPrice = costNum
    param.consumeInfo.currencyType = RewardType.GOODS
    param.consumeInfo.currencyId = checknumber(self.showData.costId)
  end
  
  function param.callback(buyCount)
    self:ProcessPurchase(buyCount)
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuy, {anim = true}, param)
end

function ActivityRebateNewShopItemComponent:ProcessPurchase(buyCount)
  if not self:CheckCostEnough(true) then
    return
  end
  self.cacheBuyCount = buyCount
  if self.activityId ~= nil then
    DataCenter.ActivityRebateNewManager:SendBuyShopItem(self.activityId, self.showData.id, buyCount)
  end
end

function ActivityRebateNewShopItemComponent:CheckCostEnough(showTip)
  if self.showData == nil then
    return false
  end
  local curNum = DataCenter.ItemData:GetItemCount(checknumber(self.showData.costId))
  if curNum < checknumber(self.showData.costNum) then
    if showTip then
      UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
    end
    return false
  end
  return true
end

return ActivityRebateNewShopItemComponent
