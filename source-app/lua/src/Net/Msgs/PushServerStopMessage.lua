local PushServerStopMessage = BaseClass("PushServerStopMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, curTime, delayTime, errLog)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  ChatManager2:GetInstance().Net:CloseWebSocket()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIExitGameTip)
end

PushServerStopMessage.OnCreate = OnCreate
PushServerStopMessage.HandleMessage = HandleMessage
return PushServerStopMessage
