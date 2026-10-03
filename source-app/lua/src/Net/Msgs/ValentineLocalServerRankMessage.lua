local ValentineLocalServerRankMessage = BaseClass("ValentineLocalServerRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineLocalServerRankMessage:OnCreate(param)
  base.OnCreate(self)
  if not (param and param.activityId and param.start) or not param["end"] then
    Logger.LogError("param is wrong")
    return
  end
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutInt("start", param.start)
  self.sfsObj:PutInt("end", param["end"])
end

function ValentineLocalServerRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ValentineDataManager:UpdateRankData(ValentineRankType.SelfServer, t)
  end
end

return ValentineLocalServerRankMessage
