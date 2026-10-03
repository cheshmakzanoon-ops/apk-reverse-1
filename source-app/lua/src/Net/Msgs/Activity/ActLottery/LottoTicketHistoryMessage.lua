local LottoTicketHistoryMessage = BaseClass("LottoTicketHistoryMessage", SFSBaseMessage)
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
  DataCenter.ActLotteryDataManager:SetTicketHistory(t)
  EventManager:GetInstance():Broadcast(EventId.ActLotteryTicketHistoryMsg)
end

LottoTicketHistoryMessage.OnCreate = OnCreate
LottoTicketHistoryMessage.HandleMessage = HandleMessage
return LottoTicketHistoryMessage
