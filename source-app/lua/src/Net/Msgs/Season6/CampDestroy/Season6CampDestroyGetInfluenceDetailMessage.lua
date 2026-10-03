local Season6CampDestroyGetInfluenceDetailMessage = BaseClass("Season6CampDestroyGetInfluenceDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function Season6CampDestroyGetInfluenceDetailMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetAllianceId", param.targetAllianceId)
end

function Season6CampDestroyGetInfluenceDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonCampDestroyManager:OnGetInfluenceDetailCallback(t)
end

return Season6CampDestroyGetInfluenceDetailMessage
