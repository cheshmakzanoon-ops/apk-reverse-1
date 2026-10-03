local PushDragonResultMessage = BaseClass("PushDragonResultMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.DragonHospital)
    if queue ~= nil then
      DataCenter.QueueDataManager:DeleteQueueByUuid(queue.uuid)
    end
    DataCenter.ActDragonManager:HandleBattleScore(t)
    if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
      GoToUtil.CloseAllWindows()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleResultS0, {anim = false})
    end
  end
end

PushDragonResultMessage.OnCreate = OnCreate
PushDragonResultMessage.HandleMessage = HandleMessage
return PushDragonResultMessage
