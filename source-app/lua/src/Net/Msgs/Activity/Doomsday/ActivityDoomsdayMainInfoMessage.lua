local ActivityDoomsdayMainInfoMessage = BaseClass("ActivityDoomsdayMainInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWDoomsdayManager:OnGetMainInfo(t)
  end
end

ActivityDoomsdayMainInfoMessage.OnCreate = OnCreate
ActivityDoomsdayMainInfoMessage.HandleMessage = HandleMessage
return ActivityDoomsdayMainInfoMessage
