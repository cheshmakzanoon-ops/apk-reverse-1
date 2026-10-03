require("DataCenter.MonthCardData.MonthCardInfo")
MonthCardManager = {}
local M = MonthCardManager
local cardDict = {}

function M.init(message)
  if message == nil then
    return
  end
  cardDict = {}
  local monthLyCards = message.monthLyCards
  if monthLyCards then
    for _, v in ipairs(monthLyCards) do
      if cardDict[v.itemId] == nil then
        local card = require("DataCenter.MonthCardData.MonthCardInfo").New()
        card:update(v)
        cardDict[card:getID()] = card
      end
    end
  end
end

function M.update(data)
  if data == nil then
    return nil
  end
  local id = data.itemId
  local card = M.get(id)
  if card then
    card:update(data)
  else
    card = require("DataCenter.MonthCardData.MonthCardInfo").New()
    card:update(data)
    cardDict[id] = card
  end
  return card
end

function M.get(id)
  if string.IsNullOrEmpty(id) then
    return nil
  end
  return cardDict[id]
end

function M.getDefault()
  for _, v in pairs(cardDict) do
    return v
  end
end

function M.buy(id)
  if string.IsNullOrEmpty(id) then
    return
  end
  local giftPack = GiftPackManager.get(id)
  if giftPack == nil then
    return
  end
  local Player = LuaEntry.Player
  PayManager.payGiftPack(giftPack, function(payResult, payResultError, payResultData)
    if payResult == PayResult.Success then
      local oldPayTotal = Player.payTotal
      local newPayTotal = payResultData.payTotal
      local isFirstPay = oldPayTotal <= 0 and 0 < newPayTotal
      local gold = payResultData.gold
      Player.gold = gold
      Player.payTotal = newPayTotal
      if payResultData.reward then
        CS.RewardController.Instance:HandleRewardInfos(payResultData._raw:GetSFSArray("reward"))
      end
      Event:notify_all(CS.EventId.PlayerInfoUpdated)
      GiftPackManager.requestLatest()
    elseif payResult == PayResult.Fail then
    end
  end)
end

function M.receiveReward(id)
  require("Game.MonthCard.Protocol.MonthCardRewardProtocol").request(id)
end

function M.onReceiveReward(id, message)
end

function M.onPush(message)
  local card = M.update(message)
  if card then
  end
  Event:notify(MonthCardEvent.REFRESH)
  Event:notify_all(CS.EventId.LFMonthCardRefresh)
end

function M.hasBoughtSomeCard()
  return false
end

function M._addListener()
end

function M._removeListener()
end

function M.hasBoughtCard(_, giftID)
  return false
end

function M.canBuyCard(_, giftID)
  local card = M.get(giftID)
  if card == nil then
    return false
  end
  return not card:isBought()
end

function M.updateDataOnDayChange()
  for _, v in pairs(cardDict) do
    v:updateOnDayChange()
  end
end

return M
