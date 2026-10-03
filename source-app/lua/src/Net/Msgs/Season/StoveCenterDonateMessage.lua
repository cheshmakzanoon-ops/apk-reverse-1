local StoveCenterDonateMessage = BaseClass("StoveCenterDonateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function StoveCenterDonateMessage:OnCreate(buildingUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("buildingUuid", buildingUuid)
end

function StoveCenterDonateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if LuaEntry.Player:IsInSourceServer() then
      UIUtil.ShowTipsId(errCode)
    else
      UIUtil.ShowTipsId("season_tips166")
    end
    return
  end
  if t.accInfo and t.accInfo.accPoint then
    DataCenter.AllianceBaseDataManager:UpdateAccPoint(t.accInfo.accPoint)
  end
  if t.donateCount then
    DataCenter.AllianceMineManager.allianceDonateCount = toInt(t.donateCount)
    EventManager:GetInstance():Broadcast(EventId.AllianceStoveCenterDonateUpdate)
  end
end

return StoveCenterDonateMessage
