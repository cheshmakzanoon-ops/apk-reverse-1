local GetDragonSeverEffectMessage = BaseClass("GetDragonSeverEffectMessage", SFSBaseMessage)
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
    BattleFieldUtil.HandleEffects(t, BattleFieldType.Desert)
  end
end

GetDragonSeverEffectMessage.HandleMessage = HandleMessage
GetDragonSeverEffectMessage.OnCreate = OnCreate
return GetDragonSeverEffectMessage
