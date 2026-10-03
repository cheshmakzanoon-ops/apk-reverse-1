local DragonBattleModifyBattlePeriodMessage = BaseClass("DragonBattleModifyBattlePeriodMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, battlePeriod, group)
  base.OnCreate(self)
  self.sfsObj:PutInt("battlePeriod", battlePeriod)
  self.sfsObj:PutInt("group", group)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.ActDragonManager:CheckErrorHideUI(errCode)
  else
    UIUtil.ShowTipsId(280146)
    DataCenter.ActDragonManager:HandleBattlePeriod(t)
  end
end

DragonBattleModifyBattlePeriodMessage.OnCreate = OnCreate
DragonBattleModifyBattlePeriodMessage.HandleMessage = HandleMessage
return DragonBattleModifyBattlePeriodMessage
