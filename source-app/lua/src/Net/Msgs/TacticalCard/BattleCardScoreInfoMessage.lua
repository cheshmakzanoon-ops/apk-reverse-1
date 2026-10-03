local BattleCardScoreInfoMessage = BaseClass("BattleCardScoreInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.TacticalCardDataManager:UpdateScoreInfo(message.score)
  DataCenter.TacticalCardDataManager:UpdatePointReward(message.rewardedList)
  EventManager:GetInstance():Broadcast(EventId.TacticalCardBoxPointUpdate)
end

BattleCardScoreInfoMessage.OnCreate = OnCreate
BattleCardScoreInfoMessage.HandleMessage = HandleMessage
return BattleCardScoreInfoMessage
