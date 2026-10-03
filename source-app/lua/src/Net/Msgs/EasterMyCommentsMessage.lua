local EasterMyCommentsMessage = BaseClass("EasterMyCommentsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterMyCommentsMessage:OnCreate(activityId, startNum, endNum)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("startIndex", startNum)
  self.sfsObj:PutInt("endIndex", endNum)
end

function EasterMyCommentsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActEasterEggManager:OnRecMyCommentEggsData(t)
  end
end

return EasterMyCommentsMessage
