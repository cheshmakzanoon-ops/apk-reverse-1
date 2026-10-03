local ActivityDecorationGachaProgressClaimMessage = BaseClass("ActivityDecorationGachaProgressClaimMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(param.activityId))
  self.sfsObj:PutInt("index", tonumber(param.index))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityDecorationGachaManager:OnClaimProgressMessageCallback(t)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

ActivityDecorationGachaProgressClaimMessage.OnCreate = OnCreate
ActivityDecorationGachaProgressClaimMessage.HandleMessage = HandleMessage
return ActivityDecorationGachaProgressClaimMessage
