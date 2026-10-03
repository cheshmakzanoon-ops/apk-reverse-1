local WinterStormResultMessage = BaseClass("WinterStormResultMessage", SFSBaseMessage)
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
    local mr = DataCenter.ActWinterStormManager:GetMarchResult()
    if mr then
      mr.battleEndTime = 0
    end
    local bInWinter = BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm)
    if t.ret == 1 then
      DataCenter.ActWinterStormManager:HandleResultPush(t)
      if bInWinter then
        GoToUtil.CloseAllWindows()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormBattleResultS0, {anim = false})
      else
        UIUtil.ShowTipsId("winter_battlefield_interface_tips1075")
      end
    elseif bInWinter then
      BattleFieldUtil.BackToCity(BattleFieldType.WinterStorm)
    end
  end
end

WinterStormResultMessage.OnCreate = OnCreate
WinterStormResultMessage.HandleMessage = HandleMessage
return WinterStormResultMessage
