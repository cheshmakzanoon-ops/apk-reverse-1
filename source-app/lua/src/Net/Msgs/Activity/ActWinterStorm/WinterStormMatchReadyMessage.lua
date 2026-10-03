local WinterStormMatchReadyMessage = BaseClass("WinterStormMatchReadyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, bReady)
  base.OnCreate(self)
  self.sfsObj:PutBool("ready", bReady)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActWinterStormManager:HandleMatchReady(t)
  end
end

WinterStormMatchReadyMessage.OnCreate = OnCreate
WinterStormMatchReadyMessage.HandleMessage = HandleMessage
return WinterStormMatchReadyMessage
