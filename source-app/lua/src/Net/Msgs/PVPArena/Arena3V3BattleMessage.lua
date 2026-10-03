local Arena3V3BattleMessage = BaseClass("Arena3V3BattleMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, opponentUid, teamInfoArray, revenge)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("otherUid", opponentUid)
  self.sfsObj:PutSFSArray("teamInfos", teamInfoArray)
  local isRevenge = revenge and 1 or 0
  self.sfsObj:PutInt("isRevenge", isRevenge)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.Arena3V3BattleFinishError)
  else
    DataCenter.LW3V3ArenaManager:OnBattleFinish(t)
  end
end

Arena3V3BattleMessage.OnCreate = OnCreate
Arena3V3BattleMessage.HandleMessage = HandleMessage
return Arena3V3BattleMessage
