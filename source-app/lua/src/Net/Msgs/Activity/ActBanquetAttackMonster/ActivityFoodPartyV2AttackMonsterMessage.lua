local ActivityFoodPartyV2AttackMonsterMessage = BaseClass("ActivityFoodPartyV2AttackMonsterMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, id, index, num, type, monsterGroupId)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", activityId)
  self.sfsObj:PutInt("id", id)
  self.sfsObj:PutInt("index", index)
  self.sfsObj:PutInt("num", num)
  self.sfsObj:PutInt("type", type)
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
    DataCenter.ActBanquetV2Data:OnGetDamageDataMsg(t)
    EventManager:GetInstance():Broadcast(EventId.ActBanquetAttackMonsterBattle, t)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    EventManager:GetInstance():Broadcast(EventId.BanquetSuccessGetStashReward)
  end
end

ActivityFoodPartyV2AttackMonsterMessage.OnCreate = OnCreate
ActivityFoodPartyV2AttackMonsterMessage.HandleMessage = HandleMessage
return ActivityFoodPartyV2AttackMonsterMessage
