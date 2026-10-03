local LWTitaniumBlueProductInfo = BaseClass("LWTitaniumBlueProductInfo")

function LWTitaniumBlueProductInfo:__init()
  self.id = 0
  self.buyTimes = 0
  self.refreshType = 0
  self.nextResetTime = 0
  self.extraDisplay = 0
  self.displayOrder = 0
  self.buyTimeLimit = 0
  self.costId = 0
  self.costNum = 0
  self.costResId = 0
  self.costResNum = 0
  self.rewardList = {}
  self.buyTimePara = 0
  self.common_buy_condition = ""
end

function LWTitaniumBlueProductInfo:__delete()
  self.id = nil
  self.buyTimes = nil
  self.refreshType = nil
  self.nextResetTime = nil
  self.extraDisplay = nil
  self.displayOrder = nil
  self.buyTimeLimit = nil
  self.costId = nil
  self.costNum = nil
  self.costResId = nil
  self.costResNum = nil
  self.rewardList = nil
  self.buyTimePara = nil
  self.common_buy_condition = nil
end

function LWTitaniumBlueProductInfo:InitData(message)
  if message.id then
    self.id = message.id
  end
  if message.butTimes then
    self.buyTimes = message.butTimes
  end
  if message.buyTimeLimit then
    self.buyTimeLimit = message.buyTimeLimit
  end
  if message.refreshType then
    self.refreshType = message.refreshType
  end
  if message.nextResetTime then
    self.nextResetTime = message.nextResetTime
    self.nextResetTime = self.nextResetTime * 1000
  end
  if message.extraDisplay then
    self.extraDisplay = tonumber(message.extraDisplay)
  end
  if message.displayOrder then
    self.displayOrder = tonumber(message.displayOrder)
  end
  if message.costId then
    self.costId = tonumber(message.costId) or 0
  end
  if message.costNum then
    self.costNum = tonumber(message.costNum) or 0
  end
  if message.costResId then
    self.costResId = tonumber(message.costResId) or 0
  end
  if message.costResNum then
    self.costResNum = tonumber(message.costResNum) or 0
  end
  if message.buyTimePara then
    self.buyTimePara = message.buyTimePara
  end
  if message.reward then
    self.rewardList = DataCenter.RewardManager:ReturnRewardParamForView(message.reward)
  end
  if message.common_buy_condition then
    self.common_buy_condition = message.common_buy_condition
  end
end

function LWTitaniumBlueProductInfo:UpdateBuyTimes(buyTimes, buyTimeLimit)
  self.buyTimes = buyTimes
  self.buyTimeLimit = buyTimeLimit
end

function LWTitaniumBlueProductInfo:GetBuyConditions()
  if not string.IsNullOrEmpty(self.common_buy_condition) then
    return DataCenter.RewardManager:ParseBuyConditionStr(self.common_buy_condition)
  end
end

function LWTitaniumBlueProductInfo:GetInconsistentConditions()
  local conditions = self:GetBuyConditions()
  return DataCenter.RewardManager:GetInconsistentBuyConditions(conditions)
end

function LWTitaniumBlueProductInfo:IsShowOwned()
  if self.rewardList ~= nil and self.rewardList[1] ~= nil then
    local reward = self.rewardList[1]
    if reward.rewardType == RewardType.GOODS then
      local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(reward.itemId)
      if goodsTemplate and goodsTemplate.type == GOODS_TYPE.GOODS_TYPE_113 then
        local para5Num = tonumber(goodsTemplate.para5) or 0
        if 0 < para5Num then
          local isEternal = false
          local eternalType = GoodsType113DecorationEternalType.None
          isEternal, eternalType = DataCenter.ItemTemplateManager:CheckDecorationEternalByGoodsType113ID(goodsTemplate.id)
          if isEternal then
            return true
          end
        end
      end
    end
  end
  return false
end

return LWTitaniumBlueProductInfo
