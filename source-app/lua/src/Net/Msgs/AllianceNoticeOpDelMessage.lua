local AllianceNoticeOpDelMessage = BaseClass("AllianceNoticeOpDelMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid, roomId)
  base.OnCreate(self)
  if uid then
    self.sfsObj:PutUtfString("uuid", tostring(uid))
  end
  if roomId then
    self.sfsObj:PutUtfString("room_id", tostring(roomId))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil and t.errorCode ~= "" then
    local lang = Localization:GetString(t.errorCode)
    local str = lang or t.errorCode
    UIUtil.ShowTips(lang or str)
  else
    UIUtil.ShowTipsId(2900059)
  end
end

AllianceNoticeOpDelMessage.OnCreate = OnCreate
AllianceNoticeOpDelMessage.HandleMessage = HandleMessage
return AllianceNoticeOpDelMessage
