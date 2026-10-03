local PushEpidemicZoneBattleResultMessage = BaseClass("PushEpidemicZoneBattleResultMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushEpidemicZoneBattleResultMessage:OnCreate()
  base.OnCreate(self)
end

function PushEpidemicZoneBattleResultMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.DragonHospital)
  if queue ~= nil then
    DataCenter.QueueDataManager:DeleteQueueByUuid(queue.uuid)
  end
  local actInfo = DataCenter.ActEpidemicZoneManager:GetActInfo()
  if actInfo then
    actInfo.leaveCDTime = 0
  end
  if BattleFieldUtil.InMap(BattleFieldType.EpidemicZone) then
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIEpidemicBattleResult, {anim = false}, t)
  end
end

return PushEpidemicZoneBattleResultMessage
