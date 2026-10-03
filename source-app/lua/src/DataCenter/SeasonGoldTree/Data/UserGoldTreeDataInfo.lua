local UserGoldTreeDataInfo = BaseClass("UserGoldTreeDataInfo")
local UserGoldTreeCardInfo = require("DataCenter/SeasonGoldTree/Data/UserGoldTreeCardInfo")
local UserGoldTeeInfo = require("DataCenter/SeasonGoldTree/Data/UserGoldTeeInfo")

function UserGoldTreeDataInfo:__init(msg)
  self:RefreshData(msg)
end

function UserGoldTreeDataInfo:__delete()
  self.weekTime = nil
  self.userGoldTeeInfo = nil
  self.userGoldTreeCardMap = nil
end

function UserGoldTreeDataInfo:RefreshData(msg)
  self.weekTime = msg.weekTime
  self.userGoldTeeInfo = UserGoldTeeInfo.New(msg.userGoldTeeInfo)
  self.userGoldTreeCardMap = {}
  if msg.userGoldTreeCardArr then
    for _, cardInfo in ipairs(msg.userGoldTreeCardArr) do
      self.userGoldTreeCardMap[cardInfo.day] = UserGoldTreeCardInfo.New(cardInfo)
    end
  end
end

function UserGoldTreeDataInfo:HasPray(day)
  if not self.userGoldTreeCardMap then
    return false
  end
  day = day or UITimeManager:GetInstance():GetNowWeekdayIndex()
  if self.userGoldTreeCardMap[day] then
    return true
  end
  return false
end

function UserGoldTreeDataInfo:IsActive(timeMs_)
  timeMs_ = timeMs_ or UITimeManager:GetInstance():GetServerTime()
  if self.userGoldTeeInfo and self.userGoldTeeInfo.startTime and self.userGoldTeeInfo.endTime then
    return timeMs_ >= self.userGoldTeeInfo.startTime and timeMs_ <= self.userGoldTeeInfo.endTime
  end
  return false
end

local function __SortByDay(a, b)
  return a.day < b.day
end

function UserGoldTreeDataInfo:GetCombinationId(fake)
  local combinationId = self.userGoldTeeInfo and self.userGoldTeeInfo.combinationId or 0
  if not (not (0 < combinationId) and fake) or not self.userGoldTreeCardMap then
    return combinationId
  end
  local cards, index = {}, 0
  for _, cardInfo in pairs(self.userGoldTreeCardMap) do
    index = index + 1
    cards[index] = cardInfo
  end
  table.sort(cards, __SortByDay)
  for i, cardInfo in ipairs(cards) do
    local temp = DataCenter.SeasonGoldTreeTemplateManager:GetCardTemp(cardInfo.cardId)
    cards[i] = temp and temp.type or 0
  end
  return DataCenter.SeasonGoldTreeTemplateManager:GetCardCombinationsId(cards)
end

function UserGoldTreeDataInfo:GetUserGoldTreeInfo()
  return self.userGoldTeeInfo
end

return UserGoldTreeDataInfo
