local PushUserKwsResetMessage = BaseClass("PushUserKwsResetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUserKwsResetMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushUserKwsResetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    Logger.Log("[Coppa] PushUserKwsResetMessage received successfully")
    if t.role ~= nil and t.role.picVer ~= nil then
      LuaEntry.Player.picVer = t.role.picVer
      LuaEntry.Player:SetPic("player_head_1")
    end
    if t.gender ~= nil and t.gender.gender ~= nil then
      DataCenter.PlayerInfoDataManager:ChangeSelfGender(t.gender.gender)
      LuaEntry.Player:SetGender(t.gender.gender)
    end
    if t.new_name ~= nil then
      DataCenter.PlayerInfoDataManager:ChangeSelfName(t.new_name)
      LuaEntry.Player:SetName(t.new_name)
    end
  end
end

return PushUserKwsResetMessage
