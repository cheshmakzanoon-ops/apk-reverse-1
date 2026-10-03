local OffSeasonDigGameOpenMessage = BaseClass("OffSeasonDigGameOpenMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, pos)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("pos", pos)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
end

OffSeasonDigGameOpenMessage.OnCreate = OnCreate
OffSeasonDigGameOpenMessage.HandleMessage = HandleMessage
return OffSeasonDigGameOpenMessage
