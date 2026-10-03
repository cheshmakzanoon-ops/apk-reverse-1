local ParkourInfoMessage = BaseClass("ParkourInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, stageId, goods)
  base.OnCreate(self)
  self.sfsObj:PutInt("stageId", stageId)
  self.sfsObj:PutInt("coin", goods[2] or 0)
  self.sfsObj:PutInt("progress", goods[ResourceType.GoldProgress] or 0)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.ParkourManager:UpdateData(message.stageId, message.reward_ts, message.reward)
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), message.stageId)
    local bonus_level = line:getValue("bonus_level")
    if string.IsNullOrEmpty(bonus_level) then
      EventManager:GetInstance():Broadcast(EventId.ParkourBattleReward, message.reward)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.PVEBattleVictoryConfirmed, PVEType.Parkour)
end

ParkourInfoMessage.OnCreate = OnCreate
ParkourInfoMessage.HandleMessage = HandleMessage
return ParkourInfoMessage
