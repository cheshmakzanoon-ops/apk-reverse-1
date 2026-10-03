local ActDragonPlayerData = require("DataCenter.ActDragonManager.ActDragonPlayerData")
local ActDragonRecordData = BaseClass("ActDragonRecordData")
local ActDragonMvpData = require("DataCenter.ActDragonManager.ActDragonMvpData")

function ActDragonRecordData:__init()
  self:ResetData()
end

function ActDragonRecordData:__delete()
  self:ResetData()
end

function ActDragonRecordData:ResetData()
  self.abbr = ""
  self.name = ""
  self.icon = ""
  self.allianceId = ""
  self.side = 0
  self.score = 0
  self.serverId = 0
  self.escortScore = 0
  self.occupyScore = 0
  self.brokeScore = 0
  self.centerControlTime = 0
  self.killScore = 0
  self.killNum = 0
  self.totalMoveNum = 0
  self.moveNum = 0
  self.win = 0
  self.power = 0
  self.currPlayerNum = 0
  self.maxPlayerNum = 0
  self.userArr = {}
  self.mvp = {}
  self.bestGroup = {}
  self.reward = {}
end

function ActDragonRecordData:ParseData(message)
  if message == nil then
    return
  end
  if message.abbr ~= nil then
    self.abbr = message.abbr
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.icon ~= nil then
    self.icon = message.icon
  end
  if message.allianceId ~= nil then
    self.allianceId = message.allianceId
  end
  if message.side ~= nil then
    self.side = message.side
  end
  if message.score ~= nil then
    self.score = message.score
  end
  if message.serverId ~= nil then
    self.serverId = message.serverId
  end
  if message.escortScore ~= nil then
    self.escortScore = message.escortScore
  end
  if message.occupyScore ~= nil then
    self.occupyScore = message.occupyScore
  end
  if message.collectScore ~= nil then
    self.collectScore = message.collectScore
  end
  if message.brokeScore ~= nil then
    self.brokeScore = message.brokeScore
  end
  if message.killScore ~= nil then
    self.killScore = message.killScore
  end
  if message.centerControlTime ~= nil then
    self.centerControlTime = message.centerControlTime
  end
  if message.killNum ~= nil then
    self.killNum = message.killNum
  end
  if message.totalMoveNum ~= nil then
    self.totalMoveNum = message.totalMoveNum
  end
  if message.moveNum ~= nil then
    self.moveNum = message.moveNum
  end
  if message.win ~= nil then
    self.win = message.win
  end
  if message.power ~= nil then
    self.power = message.power
  end
  if message.currPlayerNum ~= nil then
    self.currPlayerNum = message.currPlayerNum
  end
  if message.maxPlayerNum ~= nil then
    self.maxPlayerNum = message.maxPlayerNum
  end
  if not table.IsNullOrEmpty(message.mvp) then
    self.mvp = ActDragonMvpData.New()
    self.mvp:ParseData(message.mvp)
  end
  if not table.IsNullOrEmpty(message.killMvp) then
    local mvp = ActDragonMvpData.New()
    mvp:ParseData(message.killMvp)
    table.insert(self.bestGroup, mvp)
  end
  if not table.IsNullOrEmpty(message.collectMvp) then
    local mvp = ActDragonMvpData.New()
    mvp:ParseData(message.collectMvp)
    table.insert(self.bestGroup, mvp)
  end
  if not table.IsNullOrEmpty(message.occupyMvp) then
    local mvp = ActDragonMvpData.New()
    mvp:ParseData(message.occupyMvp)
    table.insert(self.bestGroup, mvp)
  end
  if not table.IsNullOrEmpty(message.reward) then
    self.reward = message.reward
  end
  if message.userArr ~= nil then
    local dic = message.userArr
    for k, v in pairs(dic) do
      local oneData = ActDragonPlayerData.New()
      oneData:ParseData(v)
      if oneData.uid ~= nil and oneData.uid ~= "" then
        self.userArr[oneData.uid] = oneData
      end
    end
  end
end

return ActDragonRecordData
