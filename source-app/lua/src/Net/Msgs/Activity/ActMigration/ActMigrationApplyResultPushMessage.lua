local ActMigrationApplyResultPushMessage = BaseClass("ActMigrationApplyResultPushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local mgr = DataCenter.ActMigrationManager
  local myInfo = mgr:GetMyInfo()
  local sId = myInfo ~= nil and myInfo.serverId or 0
  mgr:UpdateMyInfo(t.myinfo)
  myInfo = mgr:GetMyInfo()
  if sId == 0 then
    sId = myInfo ~= nil and myInfo.serverId or 0
  end
  if sId ~= 0 then
    mgr:ReqServerInfo(sId)
  end
end

ActMigrationApplyResultPushMessage.OnCreate = OnCreate
ActMigrationApplyResultPushMessage.HandleMessage = HandleMessage
return ActMigrationApplyResultPushMessage
