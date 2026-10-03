local ActEpidemicZoneActivityBattleHistory = BaseClass("ActEpidemicZoneActivityBattleHistory")
local ActEpidemicZoneActivityBattleHistoryInfo = require("DataCenter.ActEpidemicZoneManager.ActEpidemicZoneActivityBattleHistoryInfo")

function ActEpidemicZoneActivityBattleHistory:__init()
  self.totalCount = 0
  self.winCount = 0
  self.failCount = 0
  self.list = {}
  self.lastBattleTime = 0
end

function ActEpidemicZoneActivityBattleHistory:__delete()
  self.totalCount = nil
  self.winCount = nil
  self.failCount = nil
  self.list = nil
  self.lastBattleTime = 0
end

function ActEpidemicZoneActivityBattleHistory:Update(msg)
  self.totalCount = msg.totalCount
  self.winCount = msg.winCount
  self.failCount = msg.failCount
  if msg.result and #msg.result > 0 then
    for k, rst in ipairs(msg.result) do
      if rst.alliances and #rst.alliances >= 3 then
        local info = ActEpidemicZoneActivityBattleHistoryInfo.New()
        info:Update(rst)
        table.insert(self.list, info)
        if 0 >= self.lastBattleTime or info.battleTime < self.lastBattleTime then
          self.lastBattleTime = info.battleTime
        end
      end
    end
    table.sort(self.list, function(a, b)
      local timeA = a and a.battleTime or 0
      local timeB = b and b.battleTime or 0
      return timeA > timeB
    end)
  end
end

function ActEpidemicZoneActivityBattleHistory:GetLastCreateTime()
  return self.lastBattleTime
end

return ActEpidemicZoneActivityBattleHistory
