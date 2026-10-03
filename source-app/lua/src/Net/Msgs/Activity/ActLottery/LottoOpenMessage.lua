local LottoOpenMessage = BaseClass("LottoOpenMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, day)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("day", day)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActLotteryDataManager:GetOpenBigRewardMsg()
  DataCenter.ActLotteryDataManager:GetOpenMsg(t)
  if t.win == 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActLotteryBigRewardOpen, {anim = false}, t)
  elseif t.win == 1 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.ActLotteryBigRewardSpecialShow, {anim = false}, t)
  end
  DataCenter.ActLotteryDataManager:TryPushNotice()
  EventManager:GetInstance():Broadcast(EventId.ActLotteryOpenMsg, t)
end

LottoOpenMessage.OnCreate = OnCreate
LottoOpenMessage.HandleMessage = HandleMessage
return LottoOpenMessage
