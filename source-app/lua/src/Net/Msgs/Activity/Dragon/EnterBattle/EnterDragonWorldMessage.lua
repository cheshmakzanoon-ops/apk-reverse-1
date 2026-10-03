local EnterDragonWorldMessage = BaseClass("EnterDragonWorldMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EnterDragonWorldMessage:OnCreate()
  base.OnCreate(self)
end

function EnterDragonWorldMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActDragonManager:OnHandleEnterBattleMessage(t, false)
end

return EnterDragonWorldMessage
