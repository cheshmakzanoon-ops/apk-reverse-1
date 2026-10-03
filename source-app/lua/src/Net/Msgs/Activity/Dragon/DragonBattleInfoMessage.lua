local DragonBattleInfoMessage = BaseClass("DragonBattleInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == "dragon_battle_info_error" then
    DataCenter.ActDragonManager:CleanMatch()
  elseif errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActDragonManager:OnHandleBattleInfo(t)
  end
end

DragonBattleInfoMessage.OnCreate = OnCreate
DragonBattleInfoMessage.HandleMessage = HandleMessage
return DragonBattleInfoMessage
