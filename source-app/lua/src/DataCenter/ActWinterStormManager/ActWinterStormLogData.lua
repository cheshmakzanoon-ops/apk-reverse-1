local ActWinterStormLogData = BaseClass("ActWinterStormLogData")
local TeamArr = require("DataCenter.ActWinterStormManager.TeamArr")

function ActWinterStormLogData:__init()
  self.rawData = nil
  self.time = 0
  self.isWin = false
  self.mvpId = 0
  self.team = nil
  self.scoreA = 0
  self.scoreB = 0
  self.achievement = nil
  self.side = 0
  self.conclusionId = 0
end

function ActWinterStormLogData:__delete()
  self.rawData = nil
  self.time = 0
  self.isWin = false
  self.mvpId = 0
  self.team = nil
  self.scoreA = 0
  self.scoreB = 0
  self.achievement = nil
  self.side = 0
  self.conclusionId = 0
end

function ActWinterStormLogData:ParseData(message)
  if message == nil then
    return
  end
  if message.battleBeginTime ~= nil then
    self.time = message.battleBeginTime
  end
  if message.isWin ~= nil then
    self.isWin = message.isWin
  end
  if message.mvpId ~= nil then
    self.mvpId = message.mvpId
  end
  if message.scoreA ~= nil then
    self.scoreA = message.scoreA
  end
  if message.scoreB ~= nil then
    self.scoreB = message.scoreB
  end
  if message.conclusionId ~= nil then
    self.conclusionId = message.conclusionId
  end
  if message.achievement ~= nil then
    self.achievement = message.achievement
  end
  if message.side ~= nil then
    self.side = message.side
  end
  if message.team ~= nil then
    self.team = {}
    local arr = message.team
    for i, v in ipairs(arr) do
      local oneData = TeamArr.New()
      oneData:ParseData(v)
      self.team[i] = oneData
    end
  end
  self.rawData = {}
  if self.conclusionId ~= nil and self.conclusionId ~= 0 then
    table.copy(message, self.rawData)
  end
end

return ActWinterStormLogData
