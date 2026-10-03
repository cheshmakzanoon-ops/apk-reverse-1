local PushAllianceNoticeDelMessage = BaseClass("PushAllianceNoticeDelMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local lang = Localization:GetString(t.errorCode)
    local str = lang or t.errorCode
    UIUtil.ShowTips(lang or str)
  else
    DataCenter.AllianceNoticeManager:RemoveNoticen(t)
  end
end

PushAllianceNoticeDelMessage.OnCreate = OnCreate
PushAllianceNoticeDelMessage.HandleMessage = HandleMessage
return PushAllianceNoticeDelMessage
