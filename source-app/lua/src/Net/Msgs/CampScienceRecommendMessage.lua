local CampScienceRecommendMessage = BaseClass("CampScienceRecommendMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CampScienceRecommendMessage:OnCreate(scienceId, cancel)
  base.OnCreate(self)
  self.sfsObj:PutInt("scienceId", scienceId)
  self.sfsObj:PutBool("cancel", cancel)
end

function CampScienceRecommendMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CampScienceDataManager:ReqRecommendMessage(t)
  end
end

return CampScienceRecommendMessage
