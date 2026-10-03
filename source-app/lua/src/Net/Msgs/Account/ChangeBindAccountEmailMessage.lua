local ChangeBindAccountEmailMessage = BaseClass("ChangeBindAccountEmailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ChangeBindAccountEmailMessage:OnCreate(param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("changeType", param.changeType)
    if param.newMail then
      self.sfsObj:PutUtfString("newMail", param.newMail)
    end
  end
end

function ChangeBindAccountEmailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
end

return ChangeBindAccountEmailMessage
