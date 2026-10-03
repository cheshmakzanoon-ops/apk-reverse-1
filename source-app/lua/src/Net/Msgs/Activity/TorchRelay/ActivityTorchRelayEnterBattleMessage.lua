local ActivityTorchRelayEnterBattleMessage = BaseClass("ActivityTorchRelayEnterBattleMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(param.activityId))
  if table.IsNullOrEmpty(param.uids) then
  else
    self.sfsObj:PutUtfStringArray("uids", param.uids)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTorchRelayManager:OnEnterBattleCallback(t)
  end
end

ActivityTorchRelayEnterBattleMessage.OnCreate = OnCreate
ActivityTorchRelayEnterBattleMessage.HandleMessage = HandleMessage
return ActivityTorchRelayEnterBattleMessage
