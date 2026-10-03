local DsbBattleWatchMessage = BaseClass("DsbBattleWatchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbBattleWatchMessage:OnCreate(battleIndex)
  base.OnCreate(self)
  self.sfsObj:PutInt("team", battleIndex)
end

function DsbBattleWatchMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.BattlefieldDsbDuelManager:OnHandleEnterBattleMessage(t, true)
end

return DsbBattleWatchMessage
