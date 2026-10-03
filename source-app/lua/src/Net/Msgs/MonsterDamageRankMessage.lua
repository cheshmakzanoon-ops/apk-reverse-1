local MonsterDamageRankMessage = BaseClass("MonsterDamageRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MonsterDamageRankMessage:OnCreate(uuid, max)
  base.OnCreate(self)
  self.sfsObj:PutInt("max", max or 100)
  self.sfsObj:PutLong("uuid", uuid)
end

function MonsterDamageRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FlowerCarDataManager:HandleRankMessage(t)
  end
end

return MonsterDamageRankMessage
