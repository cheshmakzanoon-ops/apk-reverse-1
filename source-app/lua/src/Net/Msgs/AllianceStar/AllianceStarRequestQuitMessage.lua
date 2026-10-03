local AllianceStarRequestQuitMessage = BaseClass("AllianceStarRequestQuitMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceStarRequestQuitMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceStarRequestQuitMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return AllianceStarRequestQuitMessage
