local KillZombieALMonster = BaseClass("KillZombieALMonster", SFSBaseMessage)
local base = SFSBaseMessage

function KillZombieALMonster:OnCreate(difficulty)
  base.OnCreate(self)
  self.sfsObj:PutInt("difficulty", difficulty)
end

function KillZombieALMonster:HandleMessage(data)
  base.HandleMessage(self, data)
  base.HandleMessage(self, data)
  if data ~= nil and data.monster ~= nil and data.monster.pointId ~= nil then
    GoToUtil.CloseAllWindows()
    GoToUtil.MoveToWorldPointAndOpen(data.monster.pointId, nil, data.monster.monsterUid)
    SFSNetwork.SendMessage(MsgDefines.KillZombieDataPull)
  elseif data.errorCode ~= nil then
    print(data.errorCode)
    if data.errorMsg ~= nil then
      print(data.errorMsg)
    end
    UIUtil.ShowTipsId(data.errorCode)
  else
    UIUtil.ShowTipsId("E100047")
  end
end

return KillZombieALMonster
