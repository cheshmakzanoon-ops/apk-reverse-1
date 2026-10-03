local ChatRoomModifyNameMessage = BaseClass("ChatRoomModifyNameMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, roomId, name, group)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("name", name)
  self.sfsObj:PutUtfString("roomId", roomId)
  self.sfsObj:PutUtfString("group", group)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

ChatRoomModifyNameMessage.OnCreate = OnCreate
ChatRoomModifyNameMessage.HandleMessage = HandleMessage
return ChatRoomModifyNameMessage
