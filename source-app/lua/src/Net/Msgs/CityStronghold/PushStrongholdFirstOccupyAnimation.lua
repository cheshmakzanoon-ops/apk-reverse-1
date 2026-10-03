local PushStrongholdFirstOccupyAnimation = BaseClass("PushStrongholdFirstOccupyAnimation", SFSBaseMessage)
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
    DataCenter.WorldAllianceCityDataManager:PushStrongholdFirstOccupyAnimation(t)
  end
end

PushStrongholdFirstOccupyAnimation.OnCreate = OnCreate
PushStrongholdFirstOccupyAnimation.HandleMessage = HandleMessage
return PushStrongholdFirstOccupyAnimation
