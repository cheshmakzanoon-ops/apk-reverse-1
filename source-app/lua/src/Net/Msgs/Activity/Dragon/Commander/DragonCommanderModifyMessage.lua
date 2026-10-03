local DragonCommanderModifyMessage = BaseClass("DragonCommanderModifyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, group, type, uid)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutUtfString("uid", uid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.ActDragonManager:SendGetPlayerList()
  else
  end
end

DragonCommanderModifyMessage.OnCreate = OnCreate
DragonCommanderModifyMessage.HandleMessage = HandleMessage
return DragonCommanderModifyMessage
