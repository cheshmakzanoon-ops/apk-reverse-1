local PushDragonServerEffectUpdateMessage = BaseClass("PushDragonServerEffectUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActDragonManager:ReqBattleEffect()
  end
end

PushDragonServerEffectUpdateMessage.HandleMessage = HandleMessage
PushDragonServerEffectUpdateMessage.OnCreate = OnCreate
return PushDragonServerEffectUpdateMessage
