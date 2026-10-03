local DragonTeamGroupCancelMessage = BaseClass("DragonTeamGroupCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DragonTeamGroupCancelMessage:OnCreate()
  base.OnCreate(self)
end

function DragonTeamGroupCancelMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActDragonManager:HandleDragonTeamGroupCancel(t)
end

return DragonTeamGroupCancelMessage
