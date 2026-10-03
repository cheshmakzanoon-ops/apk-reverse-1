local ActivityFoodPartyV2MonsterConfirmMessage = BaseClass("ActivityFoodPartyV2MonsterConfirmMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, id, index, monsterGroupId, auto)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", activityId)
  self.sfsObj:PutInt("id", id)
  self.sfsObj:PutInt("index", index)
  auto = auto or 0
  self.sfsObj:PutInt("auto", auto)
  if monsterGroupId then
    self.sfsObj:PutInt("monsterGroupId", tonumber(monsterGroupId))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActBanquetV2Data:GetMonsterFinRewardHandle(t)
    EventManager:GetInstance():Broadcast(EventId.ActBanquetAttackMonsterFinBoxConfirm, t)
    EventManager:GetInstance():Broadcast(EventId.BanquetReceiveBatLogData, tostring(t.aid))
  end
end

ActivityFoodPartyV2MonsterConfirmMessage.OnCreate = OnCreate
ActivityFoodPartyV2MonsterConfirmMessage.HandleMessage = HandleMessage
return ActivityFoodPartyV2MonsterConfirmMessage
