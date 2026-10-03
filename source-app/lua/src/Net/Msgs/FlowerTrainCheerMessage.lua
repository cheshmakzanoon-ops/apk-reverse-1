local FlowerTrainCheerMessage = BaseClass("FlowerTrainCheerMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function FlowerTrainCheerMessage:OnCreate(carUuid, targetUid, trainItemId)
  base.OnCreate(self)
  self.sfsObj:PutLong("trainUuid", carUuid)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutInt("trainItemId", trainItemId)
end

function FlowerTrainCheerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    if t.addExp then
      local addExp = t.addExp or 0
      local info = Localization:GetString("2025halloween_treasure_cheer_alert", addExp)
      UIUtil.ShowTips(info)
    end
    EventManager:GetInstance():Broadcast(EventId.FlowerTrainSuccessCheer)
  end
end

return FlowerTrainCheerMessage
