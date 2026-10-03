local LottoInfoMessage = BaseClass("LottoInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActLotteryDataManager:RefreshActDetailData(t)
  DataCenter.ActLotteryDataManager:TryPushNotice()
  EventManager:GetInstance():Broadcast(EventId.ActLotteryDetailDataGet)
end

LottoInfoMessage.OnCreate = OnCreate
LottoInfoMessage.HandleMessage = HandleMessage
return LottoInfoMessage
