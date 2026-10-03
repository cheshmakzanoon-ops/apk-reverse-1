local SoldierElevenChangeMessage = BaseClass("SoldierElevenChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SoldierElevenChangeMessage:OnCreate(changeType, isFirst)
  base.OnCreate(self)
  self.sfsObj:PutInt("changeType", changeType)
  self.sfsObj:PutBool("isFirst", isFirst or false)
end

function SoldierElevenChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if not t.elevenCd then
      Logger.LogError("SoldierElevenChangeMessage:HandleMessage - elevenCd is nil")
    else
      DataCenter.T11DataManager:UpdateNextSwitchTime(t.elevenCd)
    end
    local isFirst = false
    if t.isFirst then
      isFirst = t.isFirst
    end
    EventManager:GetInstance():Broadcast(EventId.T11SuccessChangeSoldierMode, isFirst)
    if SceneUtils.GetIsInCity() then
      EventManager:GetInstance():Broadcast(EventId.SoldierDataChanged)
    end
  end
end

return SoldierElevenChangeMessage
