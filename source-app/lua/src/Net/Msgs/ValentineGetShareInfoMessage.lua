local ValentineGetShareInfoMessage = BaseClass("ValentineGetShareInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineGetShareInfoMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function ValentineGetShareInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local param = {}
    param.sourceType = 1
    if t.userInfo then
      local userData = t.userInfo
      param.uid = userData.uid
      param.pic = userData.pic
      param.picVer = userData.picVer
      param.name = userData.name
      param.allianceAbbrName = userData.allianceAbbrName
      param.allianceName = userData.allianceName
      param.serverId = userData.serverId
      param.power = userData.power
      param.gender = userData.gender
    end
    if t.rank then
      param.rank = t.rank
    end
    if t.curRankId then
      param.curRankId = t.curRankId
    end
    if t.activityId then
      param.activityId = t.activityId
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.ValentineShareRank, {anim = true}, param)
  end
end

return ValentineGetShareInfoMessage
