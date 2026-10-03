local DragonRevokePlayerMessage = BaseClass("DragonRevokePlayerMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, targetUid, group)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutInt("group", group)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.ActDragonManager:CheckErrorHideUI(errCode)
    DataCenter.ActDragonManager:SendGetPlayerList()
  else
    DataCenter.ActDragonManager:HandleSelectPlayer(t)
  end
end

DragonRevokePlayerMessage.OnCreate = OnCreate
DragonRevokePlayerMessage.HandleMessage = HandleMessage
return DragonRevokePlayerMessage
