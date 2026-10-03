local SeasonUserDesertHistoryDataManager = BaseClass("SeasonUserDesertHistoryDataManager")
local UserDesertHistoryData = require("DataCenter.SeasonManager.UserDesertHistoryData")

function SeasonUserDesertHistoryDataManager:__init()
  self.historyDataMap = {}
end

function SeasonUserDesertHistoryDataManager:__delete()
  self.historyDataMap = nil
end

function SeasonUserDesertHistoryDataManager:HandleUserDesertHistoryMessage(message)
  if message.records then
    for key, value in pairs(message.records) do
      local id = value.uuid
      local data
      if self.historyDataMap[id] then
        data = self.historyDataMap[id]
        data:SetDat(value, id)
      else
        data = UserDesertHistoryData.New()
        data:SetDat(value, id)
      end
      self.historyDataMap[id] = data
    end
    EventManager:GetInstance():Broadcast(EventId.LWSeasonUserDesertHistoryInfoUpdate)
  end
end

function SeasonUserDesertHistoryDataManager:GetHistoryDataList()
  local result = {}
  if self.historyDataMap then
    for key, value in pairs(self.historyDataMap) do
      table.insert(result, value)
    end
    table.sort(result, function(lValue, rValue)
      return rValue.time < lValue.time
    end)
  end
  return result
end

return SeasonUserDesertHistoryDataManager
