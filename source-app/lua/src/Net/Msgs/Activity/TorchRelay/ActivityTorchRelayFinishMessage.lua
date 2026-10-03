local ActivityTorchRelayFinishMessage = BaseClass("ActivityTorchRelayFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(param.activityId))
  self.sfsObj:PutUtfString("content", param.contentStr)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.LWBattleManager:Exit(nil, "win")
  else
    DataCenter.ActivityTorchRelayManager:OnFinishGameCallback(t)
  end
end

ActivityTorchRelayFinishMessage.OnCreate = OnCreate
ActivityTorchRelayFinishMessage.HandleMessage = HandleMessage
return ActivityTorchRelayFinishMessage
