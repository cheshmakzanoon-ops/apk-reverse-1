local Get3V3ArenaRevengeListMessage = BaseClass("Get3V3ArenaRevengeListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function Get3V3ArenaRevengeListMessage:OnCreate()
  base.OnCreate(self)
end

function Get3V3ArenaRevengeListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LW3V3ArenaManager:ParseRevengeList(t)
  end
end

return Get3V3ArenaRevengeListMessage
