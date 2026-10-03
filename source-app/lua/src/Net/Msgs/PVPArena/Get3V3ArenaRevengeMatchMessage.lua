local Get3V3ArenaRevengeMatchMessage = BaseClass("Get3V3ArenaRevengeMatchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function Get3V3ArenaRevengeMatchMessage:OnCreate(revengeUid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("revengeUid", revengeUid)
end

function Get3V3ArenaRevengeMatchMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LW3V3Manager:ParseWeaponInfo(t.otherInfo)
    DataCenter.LW3V3ArenaManager:ParseOpponentData(t, true)
  end
end

return Get3V3ArenaRevengeMatchMessage
