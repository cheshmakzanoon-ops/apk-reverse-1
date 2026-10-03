local ActBossData = BaseClass("ActBossData")
local rapidjson = require("rapidjson")

local function __init(self)
  self.uuid = 0
  self.monsterId = 0
  self.actStartTime = 0
  self.actEndTime = 0
  self.armyUnit = {}
  self.armyHealth = 0
  self.armyInitHealth = 0
  self.startPos = 0
  self.monsterJson = {}
end

local function __delete(self)
  self.uuid = nil
  self.monsterId = nil
  self.actStartTime = nil
  self.actEndTime = nil
  self.armyUnit = nil
  self.armyHealth = nil
  self.armyInitHealth = nil
  self.startPos = nil
  self.monsterJson = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.monsterId ~= nil then
    self.monsterId = message.monsterId
  end
  if message.actStart ~= nil then
    self.actStartTime = message.actStart
  end
  if message.actEnd ~= nil then
    self.actEndTime = message.actEnd
  end
  self.serverId = message.serverId or message.server or message.srcServer
  if message.startPos ~= nil then
    self.startPos = message.startPos
  end
  if message.combatInfos ~= nil then
    for k, v in pairs(message.combatInfos) do
      self.armyUnit = PBController.ParsePb1(v, "protobuf.ArmyCombatUnit")
      if self.armyUnit then
        self.armyHealth = self.armyUnit.simpleCombatUnit.health
        self.armyInitHealth = self.armyUnit.simpleCombatUnit.initHealth
      end
      break
    end
  end
  if message.monsterJson ~= nil then
    local monsterJson = message.monsterJson
    self.monsterJson = rapidjson.decode(monsterJson) or {}
  end
end

ActBossData.__init = __init
ActBossData.__delete = __delete
ActBossData.ParseData = ParseData
return ActBossData
