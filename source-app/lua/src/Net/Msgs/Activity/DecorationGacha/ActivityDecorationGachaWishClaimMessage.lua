local ActivityDecorationGachaWishClaimMessage = BaseClass("ActivityDecorationGachaWishClaimMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(param.activityId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityDecorationGachaManager:OnClaimWishMessageCallback(t)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

ActivityDecorationGachaWishClaimMessage.OnCreate = OnCreate
ActivityDecorationGachaWishClaimMessage.HandleMessage = HandleMessage
return ActivityDecorationGachaWishClaimMessage
