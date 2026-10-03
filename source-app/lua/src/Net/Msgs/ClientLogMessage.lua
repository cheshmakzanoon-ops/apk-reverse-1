local ClientLogMessage = BaseClass("ClientLogMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, curTime, delayTime, errLog)
  base.OnCreate(self)
  self.sfsObj:PutLong("curTime", curTime)
  self.sfsObj:PutLong("delayTime", delayTime)
  self.sfsObj:PutUtfString("errLog", errLog)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

ClientLogMessage.OnCreate = OnCreate
ClientLogMessage.HandleMessage = HandleMessage
return ClientLogMessage
