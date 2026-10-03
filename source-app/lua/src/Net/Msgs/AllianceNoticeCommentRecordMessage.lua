local AllianceNoticeCommentRecordMessage = BaseClass("AllianceNoticeCommentRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid)
  base.OnCreate(self)
  if uid then
    self.sfsObj:PutUtfString("uuid", tostring(uid))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local lang = Localization:GetString(t.errorCode)
    local str = lang or t.errorCode
    UIUtil.ShowTips(lang or str)
  end
end

AllianceNoticeCommentRecordMessage.OnCreate = OnCreate
AllianceNoticeCommentRecordMessage.HandleMessage = HandleMessage
return AllianceNoticeCommentRecordMessage
