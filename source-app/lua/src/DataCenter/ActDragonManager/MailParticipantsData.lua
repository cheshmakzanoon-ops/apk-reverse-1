local MailParticipantsData = BaseClass("MailParticipantsData")
local ActDragonPlayerData = require("DataCenter.ActDragonManager.ActDragonPlayerData")

function MailParticipantsData:__init()
  self.allyBattlePlayerList = {}
  self.allyBattleSubPlayerList = {}
end

function MailParticipantsData:__delete()
  self.allyBattlePlayerList = {}
  self.allyBattleSubPlayerList = {}
end

function MailParticipantsData:ParseData(message)
  if message == nil then
    return
  end
  if message.result ~= nil then
    self.result = message.result
  end
  if message.dragonBattleAlMember ~= nil then
    for k, v in ipairs(message.dragonBattleAlMember) do
      local player = ActDragonPlayerData.New()
      player:ParseData(v)
      player.armyPower = v.armyPower
      player.power = v.power
      player.rank = v.rank
      if v.state == 1 then
        table.insert(self.allyBattlePlayerList, player)
      else
        table.insert(self.allyBattleSubPlayerList, player)
      end
    end
    table.sort(self.allyBattlePlayerList, function(a, b)
      return a.rank > b.rank
    end)
    table.sort(self.allyBattleSubPlayerList, function(a, b)
      return a.rank > b.rank
    end)
  end
end

return MailParticipantsData
