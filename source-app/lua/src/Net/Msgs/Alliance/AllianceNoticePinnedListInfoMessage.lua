local AllianceNoticePinnedListInfoMessage = BaseClass("AllianceNoticePinnedListInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode == nil and t.errorCode ~= "" then
    DataCenter.AllianceNoticeManager:UpdateNoticePinnedList(t.notices)
  else
    local lang = Localization:GetString(t.errorCode)
    local str = lang or t.errorCode
    UIUtil.ShowTips(lang or str)
  end
end

AllianceNoticePinnedListInfoMessage.OnCreate = OnCreate
AllianceNoticePinnedListInfoMessage.HandleMessage = HandleMessage
return AllianceNoticePinnedListInfoMessage
