local ValentineGetActivityInfoMessage = BaseClass("ValentineGetActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineGetActivityInfoMessage:OnCreate(activityId, clearReceiveGiftDataFlag)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("client_para", clearReceiveGiftDataFlag)
end

function ValentineGetActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId then
    local activityId = toInt(t.activityId)
    DataCenter.ValentineDataManager:UpdateReceiveActivityData(activityId, t)
  end
end

return ValentineGetActivityInfoMessage
