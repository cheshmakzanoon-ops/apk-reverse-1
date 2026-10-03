local FlowerTrainCheerGmMessage = BaseClass("FlowerTrainCheerGmMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FlowerTrainCheerGmMessage:OnCreate(flowerTrainUuid, playerUidArr)
  base.OnCreate(self)
  self.sfsObj:PutLong("trainUuid", flowerTrainUuid)
  self.sfsObj:PutUtfStringArray("uidArr", playerUidArr)
end

function FlowerTrainCheerGmMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return FlowerTrainCheerGmMessage
