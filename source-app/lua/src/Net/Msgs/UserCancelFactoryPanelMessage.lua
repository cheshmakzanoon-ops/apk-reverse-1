local UserCancelFactoryPanelMessage = BaseClass("UserCancelFactoryPanelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, bUuid, index)
  base.OnCreate(self)
  self.sfsObj:PutLong("bUuid", bUuid)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    return
  end
  DataCenter.FactoryDataManager:DoWhenCancelFactoryPanel(t)
end

UserCancelFactoryPanelMessage.OnCreate = OnCreate
UserCancelFactoryPanelMessage.HandleMessage = HandleMessage
return UserCancelFactoryPanelMessage
