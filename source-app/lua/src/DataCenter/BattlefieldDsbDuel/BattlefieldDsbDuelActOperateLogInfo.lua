local BattlefieldDsbDuelActOperateLogInfo = BaseClass("BattlefieldDsbDuelActOperateLogInfo")

local function __init(self)
  self.type = 0
  self.time = 0
  self.params = ""
end

local function __delete(self)
  self.type = 0
  self.time = 0
  self.params = ""
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.type ~= nil then
    self.type = message.type
  end
  if message.time ~= nil then
    self.time = message.time
  end
  if message.params ~= nil then
    self.params = message.params
  end
end

BattlefieldDsbDuelActOperateLogInfo.__init = __init
BattlefieldDsbDuelActOperateLogInfo.__delete = __delete
BattlefieldDsbDuelActOperateLogInfo.ParseData = ParseData
return BattlefieldDsbDuelActOperateLogInfo
