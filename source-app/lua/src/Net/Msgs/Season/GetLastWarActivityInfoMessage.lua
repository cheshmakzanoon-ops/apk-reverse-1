local GetLastWarActivityInfoMessage = BaseClass("GetLastWarActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetLastWarActivityInfoMessage:OnCreate()
  base.OnCreate(self)
  self.sfsObj:PutBool("needReward", true)
end

function GetLastWarActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.tasks then
    local task = t.tasks[1]
    DataCenter.ActivityListDataManager:UpdateExtraData(EVE_DECISIVE_BATTLE_TASK, t.tasks)
    EventManager:GetInstance():Broadcast(EventId.EveDecisiveBattleInfo, task)
  end
end

return GetLastWarActivityInfoMessage
