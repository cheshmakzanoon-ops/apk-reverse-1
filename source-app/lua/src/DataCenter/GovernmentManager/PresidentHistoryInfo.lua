local PresidentHistoryInfo = BaseClass("PresidentHistoryInfo")
local PresidentHistoryListInfo = require("DataCenter.GovernmentManager.PresidentHistoryListInfo")

function PresidentHistoryInfo:__init()
  self.historyKings = {}
  self.serverId = 0
  self.page = 0
end

function PresidentHistoryInfo:__delete()
  self.historyKings = {}
  self.serverId = 0
  self.page = 0
end

function PresidentHistoryInfo:ParseData(message)
  if message == nil then
    return
  end
  if message.serverId ~= nil then
    local serverId = message.serverId
    if serverId ~= self.serverId then
      self.historyKings = {}
    end
    self.serverId = serverId
  end
  local dataCount = 0
  if message.historyKings then
    for _, v in ipairs(message.historyKings) do
      local round = v.round
      if self.historyKings[round] == nil then
        local info = PresidentHistoryListInfo.New()
        info:ParseData(v)
        self.historyKings[round] = info
        dataCount = dataCount + 1
      end
    end
  end
  if message.page then
    local page = message.page
    if page > self.page then
      self.page = page
      if 0 < dataCount then
        SFSNetwork.SendMessage(MsgDefines.GetKingHistory, LuaEntry.Player.serverId, page + 1)
      end
    end
  end
end

function PresidentHistoryInfo:GetShowList()
  local result = {}
  local theKingRank = {}
  for k, v in pairs(self.historyKings) do
    if theKingRank[v.round] == nil then
      theKingRank[v.round] = v
      table.insert(result, v)
    end
  end
  if result[2] ~= nil then
    table.sort(result, function(a, b)
      return b.round < a.round
    end)
  end
  return result
end

return PresidentHistoryInfo
