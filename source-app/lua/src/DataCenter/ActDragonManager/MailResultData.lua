local MailResultData = BaseClass("MailResultData")
local ActDragonPlayerData = require("DataCenter.ActDragonManager.ActDragonPlayerData")

function MailResultData:__init()
  self.allyList = {}
  self.occupyScoreMvp = nil
  self.brokeScoreMvp = nil
  self.collectScoreMvp = nil
  self.killScoreMvp = nil
  self.rankList = {}
  self.result = nil
end

function MailResultData:__delete()
  self.allyList = {}
  self.occupyScoreMvp = nil
  self.brokeScoreMvp = nil
  self.collectScoreMvp = nil
  self.killScoreMvp = nil
  self.rankList = {}
  self.result = nil
end

function MailResultData:ParseData(message)
  if message == nil then
    return
  end
  if message.result ~= nil then
    self.result = message.result
  end
  if message.alliances ~= nil then
    for k, v in pairs(message.alliances) do
      self.allyList[k] = {
        alId = v.alId,
        serverId = v.serverId,
        score = v.score,
        name = v.name,
        icon = v.icon,
        abbr = v.abbr
      }
    end
  end
  if message.occupyScoreMvp ~= nil then
    self.occupyScoreMvp = ActDragonPlayerData.New()
    self.occupyScoreMvp:ParseData(message.occupyScoreMvp)
  end
  if message.brokeScoreMvp ~= nil then
    self.brokeScoreMvp = ActDragonPlayerData.New()
    self.brokeScoreMvp:ParseData(message.brokeScoreMvp)
  end
  if message.collectScoreMvp ~= nil then
    self.collectScoreMvp = ActDragonPlayerData.New()
    self.collectScoreMvp:ParseData(message.collectScoreMvp)
  end
  if message.killScoreMvp ~= nil then
    self.killScoreMvp = ActDragonPlayerData.New()
    self.killScoreMvp:ParseData(message.killScoreMvp)
  end
  if message.ranks ~= nil then
    self.rankList = {}
    for k, v in pairs(message.ranks) do
      local player = ActDragonPlayerData.New()
      player:ParseData(v)
      player.rank = v.rank
      self.rankList[v.rank] = player
    end
  end
end

return MailResultData
