local SoldResourceItemMessage = BaseClass("SoldResourceItemMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, count)
  base.OnCreate(self)
  if uuid ~= 0 then
    self.sfsObj:PutLong("uuid", uuid)
    self.sfsObj:PutInt("count", count)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ResourceItemDataManager:RefreshOneItem(t)
    LuaEntry.Resource:UpdateResource(t)
    if t.uuid ~= nil then
      EventManager:GetInstance():Broadcast(EventId.SoldResourceItem, t.uuid)
    end
  end
end

SoldResourceItemMessage.OnCreate = OnCreate
SoldResourceItemMessage.HandleMessage = HandleMessage
return SoldResourceItemMessage
