local ValentineFollowMatchMarkMessage = BaseClass("ValentineFollowMatchMarkMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineFollowMatchMarkMessage:OnCreate(activityId, uidArr)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  if not table.IsNullOrEmpty(uidArr) then
    local list = SFSArray.New()
    table.walk(uidArr, function(_, v)
      list:AddUtfString(v)
    end)
    self.sfsObj:PutSFSArray("uidArr", list)
  end
end

function ValentineFollowMatchMarkMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return ValentineFollowMatchMarkMessage
