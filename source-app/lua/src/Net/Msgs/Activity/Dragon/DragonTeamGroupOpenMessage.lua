local DragonTeamGroupOpenMessage = BaseClass("DragonTeamGroupOpenMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DragonTeamGroupOpenMessage:OnCreate()
  base.OnCreate(self)
end

function DragonTeamGroupOpenMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActDragonManager:HandleDragonTeamGroupOpen(t)
end

return DragonTeamGroupOpenMessage
