local DragonCommandOrderListMessage = BaseClass("DragonCommandOrderListMessage", SFSBaseMessage)
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
    DataCenter.ActDragonManager:HandleCommandOrderList(t)
  end
end

DragonCommandOrderListMessage.OnCreate = OnCreate
DragonCommandOrderListMessage.HandleMessage = HandleMessage
return DragonCommandOrderListMessage
