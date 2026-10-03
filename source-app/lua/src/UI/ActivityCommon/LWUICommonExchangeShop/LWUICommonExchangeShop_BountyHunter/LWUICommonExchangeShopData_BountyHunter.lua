local base = require("UI/ActivityCommon/LWUICommonExchangeShop/LWUICommonExchangeShopData/LWUICommonExchangeShopData_Base")
local LWUICommonExchangeShopData_BountyHunter = BaseClass("LWUICommonExchangeShopData_BountyHunter", base)
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")

function LWUICommonExchangeShopData_BountyHunter:__init(template, activityId)
  self.template = template
  self.activityId = activityId
end

function LWUICommonExchangeShopData_BountyHunter:__delete()
  self.activityId = nil
  self.template = nil
end

function LWUICommonExchangeShopData_BountyHunter:GetRewardData()
  if self.template then
    local res = RewardUtil.GetRewardItem(self.template.reward_id)
    return res[1]
  end
end

function LWUICommonExchangeShopData_BountyHunter:GetBackgroundImage()
  if self.template == nil then
    return nil
  end
  local displayType = checknumber(self.template.display_type)
  if displayType == 0 then
    return "Assets/Main/Sprites/UI/BountyHunter/BountyHunterExchange/lyt_shangjinlieren_duihuan_bg_lan.png"
  end
  if displayType == 1 then
    return "Assets/Main/Sprites/UI/BountyHunter/BountyHunterExchange/lyt_shangjinlieren_duihuan_bg_huang.png"
  end
end

function LWUICommonExchangeShopData_BountyHunter:GetExchangedTimes()
  local actData = DataCenter.BountyHunterActDataManager:GetActData(self.activityId)
  if actData and self.template then
    return actData:GetExchangeShopBoughtTimes(self.template.id) or 0
  end
  return 0
end

function LWUICommonExchangeShopData_BountyHunter:GetExchangeTimesLimit()
  if self.template == nil then
    return 0
  end
  return checknumber(self.template.buy_time_limit)
end

function LWUICommonExchangeShopData_BountyHunter:GetExchangeTimesLeft()
  local limit = self:GetExchangeTimesLimit()
  if limit < 0 then
    return -1
  end
  local exchangedTimes = self:GetExchangedTimes()
  return limit - exchangedTimes
end

function LWUICommonExchangeShopData_BountyHunter:GetExchangeTimesText()
  if self.template == nil then
    return nil
  end
  if self:IsSoldOut() then
    local actData = DataCenter.BountyHunterActDataManager:GetActData(self.activityId)
    if actData then
      local refreshType = checknumber(self.template.refresh_type)
      if refreshType == 0 then
        return Localization:GetString("total_mobilization_desc9", "0")
      else
        local actEndTime = actData:GetEndTime()
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if UITimeManager:GetInstance():IsSameDayForServer(actEndTime // 1000, curTime // 1000) then
          return Localization:GetString("total_mobilization_desc9", "0")
        else
          local refreshTime = actData:GetExchangeShopBuyTimesRefreshTime()
          if refreshTime == nil or refreshTime <= 0 then
            refreshTime = UITimeManager:GetInstance():GetTomorrowZero()
          end
          local leftTime = math.max(refreshTime - curTime, 0)
          local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
          return Localization:GetString("activity_blue_shop_desc7", leftTimeStr)
        end
      end
    end
  else
    local limit = self:GetExchangeTimesLimit()
    if 0 <= limit then
      local refreshType = checknumber(self.template.refresh_type)
      local leftTimes = self:GetExchangeTimesLeft()
      if refreshType == 0 then
        return Localization:GetString("total_mobilization_desc9", tostring(leftTimes))
      else
        return Localization:GetString("activity_blue_shop_desc6", tostring(leftTimes))
      end
    end
  end
end

function LWUICommonExchangeShopData_BountyHunter:GetTagTextYellow()
  if self.template == nil then
    return nil
  end
  local tagIndex = checknumber(self.template.extra_display)
  if tagIndex == 3 then
    return Localization:GetString("activity_convert_tipstype2")
  end
end

function LWUICommonExchangeShopData_BountyHunter:GetTagTextPurple()
  if self.template == nil then
    return nil
  end
  local tagIndex = checknumber(self.template.extra_display)
  if tagIndex == 1 then
    return Localization:GetString("activity_blue_shop_desc3")
  end
end

function LWUICommonExchangeShopData_BountyHunter:GetTagTextRed()
  if self.template == nil then
    return nil
  end
  local tagIndex = checknumber(self.template.extra_display)
  if tagIndex == 2 then
    return Localization:GetString("activity_hunter_shoptips1")
  end
end

function LWUICommonExchangeShopData_BountyHunter:IsShowCost()
  local limit = self:GetExchangeTimesLimit()
  local isLimit = 0 <= limit
  if isLimit and 0 >= self:GetExchangeTimesLeft() then
    return false
  end
  return true
end

function LWUICommonExchangeShopData_BountyHunter:IsSoldOut()
  local limit = self:GetExchangeTimesLimit()
  local isLimit = 0 <= limit
  if isLimit and 0 >= self:GetExchangeTimesLeft() then
    return true
  end
  return false
end

function LWUICommonExchangeShopData_BountyHunter:GetSoldText()
  local limit = self:GetExchangeTimesLimit()
  local isLimit = 0 <= limit
  if isLimit and 0 >= self:GetExchangeTimesLeft() then
    return Localization:GetString("total_mobilization_desc11")
  end
end

function LWUICommonExchangeShopData_BountyHunter:GetCostData()
  if self.template == nil then
    return nil
  end
  local split = string.split(self.template.currency_cost, "|")
  if #split == 2 then
    local costNum = checknumber(split[2])
    if 0 < costNum then
      return {
        rewardType = RewardType.GOODS,
        itemId = checknumber(split[1]),
        count = costNum
      }
    end
  end
end

function LWUICommonExchangeShopData_BountyHunter:GetBuyConditions()
  if self.template == nil then
    return nil
  end
  local buyConditions = DataCenter.RewardManager:ParseBuyConditionStr(self.template.common_buy_condition or "")
  return buyConditions
end

function LWUICommonExchangeShopData_BountyHunter:IsShowMask()
  local curBuy = self:GetExchangedTimes()
  local maxBuy = self:GetExchangeTimesLimit()
  local isTimeLimit = 0 <= maxBuy
  local canBuy = not isTimeLimit or 0 < maxBuy - curBuy
  return not canBuy
end

function LWUICommonExchangeShopData_BountyHunter:SendExchangeMessage(exchangeCount)
  if self.activityId ~= nil then
    DataCenter.BountyHunterActDataManager:SendExchangeShopBuy(self.activityId, self.template.id, exchangeCount)
  end
end

function LWUICommonExchangeShopData_BountyHunter:IsShowRed()
  local curBuy = self:GetExchangedTimes()
  local maxBuy = self:GetExchangeTimesLimit()
  local isTimeLimit = 0 <= maxBuy
  local canBuy = not isTimeLimit or 0 < maxBuy - curBuy
  if canBuy then
    local costData = self:GetCostData()
    local isFree = costData == nil or 0 >= costData.count
    if isFree then
      return true
    else
      local curNum = DataCenter.ItemData:GetItemCount(costData.itemId)
      if curNum >= checknumber(costData.count) then
        return true
      end
    end
  end
  return false
end

function LWUICommonExchangeShopData_BountyHunter:GetDisplayOrder()
  if self.template then
    return self.template.display_order
  end
  return 0
end

return LWUICommonExchangeShopData_BountyHunter
