local TestBattleEnterMessage = BaseClass("TestBattleEnterMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TestBattleEnterMessage:OnCreate(type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
  BattleFieldUtil.Log("\228\189\191\231\148\168GM\229\145\189\228\187\164\232\191\155\229\133\165%s", type)
end

function TestBattleEnterMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BattlefieldDsbDuelManager:OnHandleEnterBattleMessage(t, false)
  end
end

return TestBattleEnterMessage
