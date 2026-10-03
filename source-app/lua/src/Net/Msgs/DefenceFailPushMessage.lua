local DefenceFailPushMessage = BaseClass("DefenceFailPushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.AllianceHelpVirtualMarchManager:OnGetDefenceFailInfo(t.helperInfos, t.targetInfo, t.isLogin)
end

DefenceFailPushMessage.OnCreate = OnCreate
DefenceFailPushMessage.HandleMessage = HandleMessage
return DefenceFailPushMessage
