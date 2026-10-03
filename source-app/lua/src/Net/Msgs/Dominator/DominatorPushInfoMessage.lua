local DominatorPushInfoMessage = BaseClass("DominatorPushInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DominatorManager:OnPushInfo(t)
  end
end

DominatorPushInfoMessage.OnCreate = OnCreate
DominatorPushInfoMessage.HandleMessage = HandleMessage
return DominatorPushInfoMessage
