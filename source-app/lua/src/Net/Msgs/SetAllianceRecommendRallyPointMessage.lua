local SetAllianceRecommendRallyPointMessage = BaseClass("SetAllianceRecommendRallyPointMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SetAllianceRecommendRallyPointMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("markType", param or MarkType.Alliance_rally)
end

function SetAllianceRecommendRallyPointMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceRallyPointDataManager:HandleSetRecommendRallyPoint(t)
  end
end

return SetAllianceRecommendRallyPointMessage
