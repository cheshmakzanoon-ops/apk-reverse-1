local PushRechargeScoreMessage = BaseClass("PushRechargeScoreMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.CumulativeRechargeManager:PushRechargeScoreHandle(t)
end

PushRechargeScoreMessage.OnCreate = OnCreate
PushRechargeScoreMessage.HandleMessage = HandleMessage
return PushRechargeScoreMessage
