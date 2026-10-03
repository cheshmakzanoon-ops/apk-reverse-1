local DragonBattleSignUpMessage = BaseClass("DragonBattleSignUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, battlePeriod, group)
  base.OnCreate(self)
  self.sfsObj:PutInt("battlePeriod", battlePeriod or 1)
  self.sfsObj:PutInt("group", group)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.ActDragonManager:CheckErrorHideUI(errCode)
  else
    UIUtil.ShowTipsId(302036)
    DataCenter.ActDragonManager:HandleBattlePeriod(t)
  end
end

DragonBattleSignUpMessage.OnCreate = OnCreate
DragonBattleSignUpMessage.HandleMessage = HandleMessage
return DragonBattleSignUpMessage
