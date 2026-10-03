local AllianceNoticePinnedChangeMessage = BaseClass("AllianceNoticePinnedChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid1, uuid2)
  base.OnCreate(self)
  if uuid1 then
    self.sfsObj:PutUtfString("uuid1", tostring(uuid1))
  end
  if uuid2 then
    self.sfsObj:PutUtfString("uuid2", tostring(uuid2))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode == nil and t.errorCode ~= "" then
    DataCenter.AllianceNoticeManager:UpdateNoticePinned(t.notices[1])
    DataCenter.AllianceNoticeManager:UpdateNoticePinned(t.notices[2])
  else
    local lang = Localization:GetString(t.errorCode)
    local str = lang or t.errorCode
    UIUtil.ShowTips(lang or str)
  end
end

AllianceNoticePinnedChangeMessage.OnCreate = OnCreate
AllianceNoticePinnedChangeMessage.HandleMessage = HandleMessage
return AllianceNoticePinnedChangeMessage
