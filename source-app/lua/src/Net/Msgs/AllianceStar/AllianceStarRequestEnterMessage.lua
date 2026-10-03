local AllianceStarRequestEnterMessage = BaseClass("AllianceStarRequestEnterMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceStarRequestEnterMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceStarRequestEnterMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIAllianceStarMain) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceStarMain, {anim = true})
  end
end

return AllianceStarRequestEnterMessage
