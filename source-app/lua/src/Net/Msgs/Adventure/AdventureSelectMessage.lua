local AdventureSelectMessage = BaseClass("AdventureSelectMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, triggerId, type, subType, content)
  base.OnCreate(self)
  self.sfsObj:PutInt("trigger", triggerId)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("subType", subType)
  self.sfsObj:PutUtfString("content", content)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    return
  end
  DataCenter.AdventureManager:HandleSelect(t)
end

AdventureSelectMessage.OnCreate = OnCreate
AdventureSelectMessage.HandleMessage = HandleMessage
return AdventureSelectMessage
