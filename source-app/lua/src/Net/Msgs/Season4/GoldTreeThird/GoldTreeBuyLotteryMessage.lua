local GoldTreeBuyLotteryMessage = BaseClass("GoldTreeBuyLotteryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GoldTreeBuyLotteryMessage:OnCreate(weekTime, day)
  base.OnCreate(self)
  self.sfsObj:PutLong("weekTime", weekTime)
  self.sfsObj:PutInt("day", day)
end

function GoldTreeBuyLotteryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.GoldTreeThirdError, MsgDefines.GoldTreeBuyLottery)
    return
  end
  UIUtil.ShowTipsId("season_golden_tree_phase_third_UI_29")
  DataCenter.SeasonGoldTreeThirdManager:GoldTreeBuyLotteryMessage(t)
end

return GoldTreeBuyLotteryMessage
