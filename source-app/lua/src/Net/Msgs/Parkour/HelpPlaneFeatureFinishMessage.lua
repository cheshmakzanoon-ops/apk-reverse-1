local HelpPlaneFeatureFinishMessage = BaseClass("HelpPlaneFeatureFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HelpPlaneFeatureFinishMessage:OnCreate(uuid, stageId, remainSoldierCount, overPlayer)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("stageId", stageId)
  self.sfsObj:PutInt("soldier", remainSoldierCount)
  self.sfsObj:PutInt("overPlayer", overPlayer)
end

function HelpPlaneFeatureFinishMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return HelpPlaneFeatureFinishMessage
