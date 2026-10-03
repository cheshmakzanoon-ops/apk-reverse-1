local AlShopShowMessage = BaseClass("AlShopShowMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.alliancePoint ~= nil then
      local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if data ~= nil then
        data.alliancePoint = t.alliancepoint
      end
      DataCenter.AllianceShopDataManager:SetAlliancePoint(t.alliancePoint)
    end
    if t.accPoint ~= nil then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(t.accPoint)
    end
    DataCenter.AllianceShopDataManager:RefreshAllianceShopList(t)
    EventManager:GetInstance():Broadcast(EventId.AllianceShopShow)
  end
end

AlShopShowMessage.OnCreate = OnCreate
AlShopShowMessage.HandleMessage = HandleMessage
return AlShopShowMessage
