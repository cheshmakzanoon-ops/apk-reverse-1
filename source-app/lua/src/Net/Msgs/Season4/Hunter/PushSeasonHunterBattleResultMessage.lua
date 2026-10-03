local PushSeasonHunterBattleResultMessage = BaseClass("PushSeasonHunterBattleResultMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSeasonHunterBattleResultMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushSeasonHunterBattleResultMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.result then
    SFSNetwork.SendMessage(MsgDefines.SeasonHunterGetActivityInfo)
    DataCenter.UIPopWindowManager:Push(UIWindowNames.SeasonHunterResult, {anim = true}, t)
  end
end

function PushSeasonHunterBattleResultMessage:GetTestData()
  local player = LuaEntry.Player
  return {
    result = math.random(0, 1),
    total = math.random(1000, 2000),
    lifeTime = math.random(1000, 2000),
    timeRank = math.random(1, 10),
    score = math.random(1000, 2000),
    matchRank = math.random(-10, 10)
  }
end

return PushSeasonHunterBattleResultMessage
