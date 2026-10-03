local DragonCommanderListMessage = BaseClass("DragonCommanderListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActDragonManager:HandleCommanderList(t)
  end
end

DragonCommanderListMessage.OnCreate = OnCreate
DragonCommanderListMessage.HandleMessage = HandleMessage
return DragonCommanderListMessage
