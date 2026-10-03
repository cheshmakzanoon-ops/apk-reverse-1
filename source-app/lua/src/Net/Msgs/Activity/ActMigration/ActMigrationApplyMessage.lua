local ActMigrationApplyMessage = BaseClass("ActMigrationApplyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, serverId, message)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutUtfString("message", message)
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
    DataCenter.ActMigrationManager:UpdatePApply()
    return
  end
  DataCenter.ActMigrationManager:HandleApply(true)
end

ActMigrationApplyMessage.OnCreate = OnCreate
ActMigrationApplyMessage.HandleMessage = HandleMessage
return ActMigrationApplyMessage
