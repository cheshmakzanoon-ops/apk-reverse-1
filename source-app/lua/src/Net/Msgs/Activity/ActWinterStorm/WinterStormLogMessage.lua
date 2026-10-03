local WinterStormLogMessage = BaseClass("WinterStormLogMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, time, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("time", time)
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActWinterStormManager:HandleLog(t)
  end
end

WinterStormLogMessage.OnCreate = OnCreate
WinterStormLogMessage.HandleMessage = HandleMessage
return WinterStormLogMessage
