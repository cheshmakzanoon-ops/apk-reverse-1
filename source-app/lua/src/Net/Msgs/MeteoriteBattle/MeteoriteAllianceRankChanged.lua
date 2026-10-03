local MeteoriteAllianceRankChanged = BaseClass("MeteoriteAllianceRankChanged", SFSBaseMessage)
local base = SFSBaseMessage

function MeteoriteAllianceRankChanged:OnCreate()
  base.OnCreate(self)
end

function MeteoriteAllianceRankChanged:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActMeteoriteBattleManager:OnAllianceRankChanged(t)
  end
end

return MeteoriteAllianceRankChanged
