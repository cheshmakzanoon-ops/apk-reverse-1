local DsbActAssignMessage = BaseClass("DsbActAssignMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbActAssignMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("team", param.team)
  self.sfsObj:PutUtfString("targetUid", param.targetUid)
  self.sfsObj:PutInt("state", param.state)
end

function DsbActAssignMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == 458258 or errCode == "458258" then
      local time = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k7", 24)
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString(errCode, time))
    else
      UIUtil.ShowTipsId(errCode)
    end
    BattlefieldDsbDuelUtils.ActInfo:SendActPlayerListMsg()
  else
    BattlefieldDsbDuelUtils.ActInfo:OnGetActAssignMsg(t)
  end
end

return DsbActAssignMessage
