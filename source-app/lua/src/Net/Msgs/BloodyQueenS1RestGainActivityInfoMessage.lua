local BloodyQueenS1RestGainActivityInfoMessage = BaseClass("BloodyQueenS1RestGainActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BloodyQueenS1RestGainActivityInfoMessage:OnCreate(updateType, extendInfo)
  base.OnCreate(self)
  if updateType then
    self.sfsObj:PutInt("updateType", updateType)
  end
  if extendInfo then
    self.sfsObj:PutUtfString("extendInfo", extendInfo)
  end
end

function BloodyQueenS1RestGainActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.updateType then
    if t.updateType == QueenOfBloodUpdateType.SPACIAL_MONSTER_UPDATE then
      DataCenter.OffSeason1QueenOfBloodManager:QueenOfBloodActivityInfoAllMonsterMessage(t)
    elseif t.updateType == QueenOfBloodUpdateType.SPACIAL_MONSTER_SINGLE_UPDATE then
      DataCenter.OffSeason1QueenOfBloodManager:QueenOfBloodActivityInfoSingleMonsterMessage(t)
    elseif t.updateType == QueenOfBloodUpdateType.NORMAL then
      DataCenter.OffSeason1QueenOfBloodManager:QueenOfBloodActivityInfoMessage(t)
    end
  else
    DataCenter.OffSeason1QueenOfBloodManager:QueenOfBloodActivityInfoMessage(t)
  end
end

return BloodyQueenS1RestGainActivityInfoMessage
