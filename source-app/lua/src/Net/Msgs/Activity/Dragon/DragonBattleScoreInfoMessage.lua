local DragonBattleScoreInfoMessage = BaseClass("DragonBattleScoreInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActDragonManager:HandleBattleScore(t)
    EventManager:GetInstance():Broadcast(EventId.DragonBattleScoreInfo)
  end
end

DragonBattleScoreInfoMessage.OnCreate = OnCreate
DragonBattleScoreInfoMessage.HandleMessage = HandleMessage
return DragonBattleScoreInfoMessage
