local Season6CampDestroyGetRankMessage = BaseClass("Season6CampDestroyGetRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function Season6CampDestroyGetRankMessage:OnCreate(rankId)
  base.OnCreate(self)
  self.sfsObj:PutInt("rankId", rankId)
end

function Season6CampDestroyGetRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
  DataCenter.SeasonCampDestroyManager:OnGetRankCallback(t)
end

return Season6CampDestroyGetRankMessage
