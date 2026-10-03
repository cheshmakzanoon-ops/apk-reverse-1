local PushActivityTasksMessage = BaseClass("PushActivityTasksMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, taskId)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.type == EnumActivity.BattlePass_new.Type and t.a_task then
      DataCenter.ActBattlePassData:PushBattlePassTaskUpdateHandle(t, t.aid, t.a_task)
      return
    end
    if t.type == EnumActivity.ActTask.Type then
      DataCenter.ActTaskManager:UpdateActTasks(t)
      EventManager:GetInstance():Broadcast(EventId.GetActTaskDataUpdateMsg)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
      return
    end
    if t.type == EnumActivity.ActSlotMachine.Type then
      DataCenter.ActSlotMachineDataManager:UpdateActTasks(t)
      EventManager:GetInstance():Broadcast(EventId.ActSlotTaskDataUpdate)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
      return
    end
    if t.type == EnumActivity.BanquetAttackMonster.Type then
      DataCenter.ActBanquetV2Data:UpdateActTasks(t)
      EventManager:GetInstance():Broadcast(EventId.ActBanquetAttackMonsterTaskDataUpdate)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
      return
    end
    if t.type == EnumActivity.ActBingo.Type then
      DataCenter.ActBingoDataManager:UpdateActTasks(t)
      EventManager:GetInstance():Broadcast(EventId.ActBingoTaskDataUpdate)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
      return
    end
    if t.type == EnumActivity.ContinuePay.Type and t.a_task then
      DataCenter.ContinuePayActivityManager:UpdateOneTaskInfo(t)
      return
    end
    if t.type == EnumActivity.LeadingQuestV2.Type and t.a_task then
      DataCenter.LWLeadingQuestV2Manager:UpdateTaskInfo(t)
      return
    end
    if t.type == EnumActivity.TorchRelay.Type and t.a_task then
      DataCenter.ActivityTorchRelayTaskManager:ParseTaskServerData(t)
      return
    end
    if t.type == EnumActivity.SandWormHunt.Type and t.a_task then
      DataCenter.SandWormHuntDataManager:OnPushTask(t.a_task)
      return
    end
    if t.type == EnumActivity.ActEasterEgg.Type and t.a_task then
      DataCenter.ActEasterEggTaskManager:ParseTaskServerData(t)
      return
    end
    if t.type == EnumActivity.OffSeason1Recapture.Type and t.a_task then
      DataCenter.OffSeason1TaskDataManager:ParseTaskServerData(t)
      return
    end
    if t.type == EnumActivity.OffSeason1QueenOfBlood.Type and t.a_task then
      DataCenter.OffSeason1TaskDataManager:ParseTaskServerData(t)
      return
    end
    if t.type == EnumActivity.CrazyRock.Type and t.a_task then
      DataCenter.ActCrazyRockTaskManager:ParseTaskServerData(t)
      return
    end
  end
end

PushActivityTasksMessage.OnCreate = OnCreate
PushActivityTasksMessage.HandleMessage = HandleMessage
return PushActivityTasksMessage
