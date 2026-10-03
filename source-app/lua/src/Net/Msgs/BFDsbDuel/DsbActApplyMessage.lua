local DsbActApplyMessage = BaseClass("DsbActApplyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbActApplyMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("team", param.team)
end

function DsbActApplyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == 458258 or errCode == "458258" then
      local time = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k7", 24)
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString(errCode, time))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    BattlefieldDsbDuelUtils.ActInfo:OnGetActApplyMsg(t)
  end
end

return DsbActApplyMessage
