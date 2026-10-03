local PushAllianceFurnaceInfoMessage = BaseClass("PushAllianceFurnaceInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceFurnaceInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllianceFurnaceInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.AllianceBaseDataManager:UpdateResource(t.alResItem)
  DataCenter.AllianceMineManager:UpdateFurnaceInfos(t.furnaceInfos)
end

return PushAllianceFurnaceInfoMessage
