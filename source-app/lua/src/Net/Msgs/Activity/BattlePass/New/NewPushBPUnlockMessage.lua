local NewPushBPUnlockMessage = BaseClass("NewPushBPUnlockMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, taskId)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActBattlePassData:PushBattlePassUpdateHandle(t, EnumActivity.BattlePass_new.Type)
  end
end

NewPushBPUnlockMessage.OnCreate = OnCreate
NewPushBPUnlockMessage.HandleMessage = HandleMessage
return NewPushBPUnlockMessage
