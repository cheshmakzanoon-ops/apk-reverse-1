local PlaneFeatureUserInfoMessage = BaseClass("PlaneFeatureUserInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PlaneFeatureUserInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PlaneFeatureUserInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local data = {}
    data.helpTimes = t.helpTimes or 0
    data.beHelpedTimes = t.beHelpedTimes or 0
    data.shareTimes = t.shareTimes or 0
    data.lastShareTime = t.lastShareTime or 0
    DataCenter.LWStageFeatureChapterManager:OnGetHelpUserInfo(data)
  end
end

return PlaneFeatureUserInfoMessage
