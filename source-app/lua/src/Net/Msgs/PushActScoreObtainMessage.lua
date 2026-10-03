local PushActScoreObtainMessage = BaseClass("PushActScoreObtainMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityListDataManager:UpdateArmsActScore(t)
    if t.type == EnumActivity.AllianceCompete.EventType then
      DataCenter.GetDuelScoreManager:PushScoreChangeByType(GetDuelScoreType.Ally, t)
    end
  end
end

PushActScoreObtainMessage.OnCreate = OnCreate
PushActScoreObtainMessage.HandleMessage = HandleMessage
return PushActScoreObtainMessage
