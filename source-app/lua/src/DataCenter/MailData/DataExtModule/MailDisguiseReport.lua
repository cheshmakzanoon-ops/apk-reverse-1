local MailDisguiseReport = BaseClass("MailDisguiseReport")
local Localization = CS.GameEntry.Localization

function MailDisguiseReport:__init()
end

function MailDisguiseReport:ParseContent(mailContent)
  if table.IsNullOrEmpty(mailContent) then
    return
  end
  self.defUser = mailContent.defUser
  self.atkUser = mailContent.atkUser
end

function MailDisguiseReport:IsPassive()
  return self.defUser and self.defUser.uid == LuaEntry.Player.uid
end

function MailDisguiseReport:GetShareDesc()
  return Localization:GetString("")
end

return MailDisguiseReport
