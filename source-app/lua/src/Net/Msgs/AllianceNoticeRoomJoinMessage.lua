local AllianceNoticeRoomJoinMessage = BaseClass("AllianceNoticeRoomJoinMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid, roomId)
  base.OnCreate(self)
  if uid then
    self.sfsObj:PutUtfString("uuid", tostring(uid))
  end
  if roomId then
    self.sfsObj:PutUtfString("roomId", tostring(roomId))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode == nil and t.errorCode ~= "" then
    local lang = Localization:GetString(t.errorCode)
    local str = lang or t.errorCode
    UIUtil.ShowTips(lang or str)
  end
end

AllianceNoticeRoomJoinMessage.OnCreate = OnCreate
AllianceNoticeRoomJoinMessage.HandleMessage = HandleMessage
return AllianceNoticeRoomJoinMessage
