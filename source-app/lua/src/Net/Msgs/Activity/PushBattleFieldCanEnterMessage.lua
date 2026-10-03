local PushBattleFieldCanEnterMessage = BaseClass("PushBattleFieldCanEnterMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBattleFieldCanEnterMessage:OnCreate()
  base.OnCreate(self)
end

function PushBattleFieldCanEnterMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local worldType = t.worldType
  if worldType == nil then
    return
  end
  BattleFieldUtil.SetBattleFieldCanEnterFlag(worldType)
end

return PushBattleFieldCanEnterMessage
