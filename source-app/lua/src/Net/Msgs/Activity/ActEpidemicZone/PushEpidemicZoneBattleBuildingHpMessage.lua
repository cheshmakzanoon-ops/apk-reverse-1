local PushEpidemicZoneBattleBuildingHpMessage = BaseClass("PushEpidemicZoneBattleBuildingHpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushEpidemicZoneBattleBuildingHpMessage:OnCreate()
  base.OnCreate(self)
end

function PushEpidemicZoneBattleBuildingHpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local worldType = t.worldType
  if worldType then
    local mgr = BattleFieldUtil.GetMgr(worldType)
    if mgr then
      mgr:HandleBuildingHpChange(t)
    end
  end
end

return PushEpidemicZoneBattleBuildingHpMessage
