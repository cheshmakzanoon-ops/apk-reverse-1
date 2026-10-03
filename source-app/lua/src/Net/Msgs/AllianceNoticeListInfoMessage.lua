local AllianceNoticeListInfoMessage = BaseClass("AllianceNoticeListInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, startIndex, endIndex)
  base.OnCreate(self)
  if startIndex then
    self.sfsObj:PutInt("start", startIndex)
    self.sfsObj:PutInt("end", endIndex)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode == nil and t.errorCode ~= "" then
    DataCenter.AllianceNoticeManager:UpdateNoticeList(t.notices)
  else
    local lang = Localization:GetString(t.errorCode)
    local str = lang or t.errorCode
    UIUtil.ShowTips(lang or str)
  end
end

AllianceNoticeListInfoMessage.OnCreate = OnCreate
AllianceNoticeListInfoMessage.HandleMessage = HandleMessage
return AllianceNoticeListInfoMessage
