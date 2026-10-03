local BloodNightRankViewMessage = BaseClass("BloodNightRankViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BloodNightRankViewMessage:OnCreate(planId, rankId)
  base.OnCreate(self)
  self.sfsObj:PutInt("planId", planId)
  self.sfsObj:PutInt("rankId", rankId)
end

function BloodNightRankViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BloodyNightDataManager:HandleRankMessage(t)
  end
end

return BloodNightRankViewMessage
