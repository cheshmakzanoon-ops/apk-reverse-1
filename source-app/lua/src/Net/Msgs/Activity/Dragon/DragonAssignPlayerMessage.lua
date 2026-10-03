local DragonAssignPlayerMessage = BaseClass("DragonAssignPlayerMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, targetUid, state, group)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutInt("state", state)
  self.sfsObj:PutInt("group", group)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    local time = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k7", 24)
    if errCode == 501066 or errCode == 501103 then
      UIUtil.ShowTips(Localization:GetString("376092", time))
    elseif errCode == 376167 then
      UIUtil.ShowTips(Localization:GetString(errCode, time))
    elseif errCode == "Desert_strom_tips1037" then
      UIUtil.ShowTipsId(errCode)
      DataCenter.ActDragonManager:CheckErrorHideUI(errCode)
    elseif errCode == 458258 or errCode == "458258" then
      UIUtil.ShowTips(Localization:GetString(tostring(errCode), time))
    else
      UIUtil.ShowTipsId(errCode)
    end
    DataCenter.ActDragonManager:SendGetPlayerList()
  else
    DataCenter.ActDragonManager:HandleSelectPlayer(t)
  end
end

DragonAssignPlayerMessage.OnCreate = OnCreate
DragonAssignPlayerMessage.HandleMessage = HandleMessage
return DragonAssignPlayerMessage
