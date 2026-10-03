local MeteoritePlayerRankChanged = BaseClass("MeteoritePlayerRankChanged", SFSBaseMessage)
local base = SFSBaseMessage

function MeteoritePlayerRankChanged:OnCreate()
  base.OnCreate(self)
end

function MeteoritePlayerRankChanged:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActMeteoriteBattleManager:OnPlayerRankChanged(t)
  end
end

return MeteoritePlayerRankChanged
