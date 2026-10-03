local ActMigrationApprovalMessage = BaseClass("ActMigrationApprovalMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid, type)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", uid)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    local errorPara2 = t.errorPara2
    if errorPara2 then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString(errCode, table.unpack(errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
    return
  end
  DataCenter.ActMigrationManager:HandleApproval(t)
end

ActMigrationApprovalMessage.OnCreate = OnCreate
ActMigrationApprovalMessage.HandleMessage = HandleMessage
return ActMigrationApprovalMessage
