local GetStoveCenterInfoMessage = BaseClass("GetStoveCenterInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetStoveCenterInfoMessage:OnCreate()
  base.OnCreate(self)
end

function GetStoveCenterInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.rank then
    DataCenter.SeasonFactionWarDataManager.myAliRankIndex = t.rank
  end
  if t.alResItem then
    DataCenter.AllianceBaseDataManager:UpdateResource(t.alResItem)
  end
  if t.donateCount then
    DataCenter.AllianceMineManager.allianceDonateCount = toInt(t.donateCount)
  end
  DataCenter.AllianceMineManager:UpdateFurnaceInfos(t.furnaceInfos)
end

return GetStoveCenterInfoMessage
