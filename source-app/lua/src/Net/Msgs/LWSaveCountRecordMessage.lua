local LWSaveCountRecordMessage = BaseClass("LWSaveCountRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, stageId, restSoilders)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", stageId)
  self.sfsObj:PutInt("soldier", restSoilders)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.reward then
    DataCenter.ParkourManager:UpdateCountData(message.id, message.reward)
    DataCenter.RewardManager:AddRewardsAndRes(message)
    EventManager:GetInstance():Broadcast(EventId.CountBattleReward, message.reward)
  end
  EventManager:GetInstance():Broadcast(EventId.GF_count_battle_win, message.id)
  EventManager:GetInstance():Broadcast(EventId.PVEBattleVictoryConfirmed, PVEType.Count)
end

LWSaveCountRecordMessage.OnCreate = OnCreate
LWSaveCountRecordMessage.HandleMessage = HandleMessage
return LWSaveCountRecordMessage
