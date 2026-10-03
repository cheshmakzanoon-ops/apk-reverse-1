local PushBattleCardScoreMessage = BaseClass("PushBattleCardScoreMessage", SFSBaseMessage)
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
  DataCenter.TacticalCardDataManager:UpdatePointReward(message.rewardedList)
  DataCenter.TacticalCardDataManager:UpdateScoreInfo(message.score)
  EventManager:GetInstance():Broadcast(EventId.TacticalCardBoxPointUpdate)
end

PushBattleCardScoreMessage.OnCreate = OnCreate
PushBattleCardScoreMessage.HandleMessage = HandleMessage
return PushBattleCardScoreMessage
