local KillZombiePersonMonster = BaseClass("KillZombiePersonMonster", SFSBaseMessage)
local base = SFSBaseMessage

function KillZombiePersonMonster:OnCreate()
  base.OnCreate(self)
end

function KillZombiePersonMonster:HandleMessage(data)
  base.HandleMessage(self, data)
  if data ~= nil and data.monsters ~= nil then
    if data.monsters ~= nil then
      table.sort(data.monsters, function(a, b)
        return a.monsterLevel < b.monsterLevel
      end)
    end
    local v = data.monsters[1]
    if v then
      GoToUtil.CloseAllWindows()
      GoToUtil.MoveToWorldPointAndOpen(v.pointId, nil, v.monsterUid, LuaEntry.Player:GetSelfServerId())
    end
    SFSNetwork.SendMessage(MsgDefines.KillZombieDataPull)
  elseif data ~= nil and data.pointId ~= nil then
    GoToUtil.CloseAllWindows()
    GoToUtil.MoveToWorldPointAndOpen(data.pointId, nil, data.monsterUid, LuaEntry.Player:GetSelfServerId())
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

return KillZombiePersonMonster
