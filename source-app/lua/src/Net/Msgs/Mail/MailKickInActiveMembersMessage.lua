local MailKickInActiveMembersMessage = BaseClass("MailKickInActiveMembersMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage
local _mailId

function MailKickInActiveMembersMessage:OnCreate(mailId)
  base.OnCreate(self)
  _mailId = mailId
  self.sfsObj:PutUtfString("mailId", mailId)
end

function MailKickInActiveMembersMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "E100149" then
      local strKey = "MailKickAllDeal_" .. _mailId
      CS.GameEntry.Setting:SetInt(strKey, 1)
    end
    UIUtil.ShowTipsId(errCode)
    return
  end
  local mailId = t.mailId
  local strKey = "MailKickAllDeal_" .. mailId
  CS.GameEntry.Setting:SetInt(strKey, 1)
  EventManager:GetInstance():Broadcast(EventId.Mail_KickAllMailDone)
  local successMembers = t.successMember
  if 0 < #successMembers then
    local title = 455095
    local content = Localization:GetString(455096) .. "\n"
    for i, v in ipairs(successMembers) do
      content = content .. v.name
      if i ~= #successMembers then
        content = content .. "\n"
      end
    end
    UIUtil.ShowMessage(content, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, nil, nil, nil, title)
  end
end

return MailKickInActiveMembersMessage
