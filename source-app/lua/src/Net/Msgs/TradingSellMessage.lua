local TradingSellMessage = BaseClass("TradingSellMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, sellRes)
  base.OnCreate(self, sellRes)
  if sellRes ~= nil then
    print(sellRes)
    local array = SFSArray.New()
    table.walk(sellRes, function(k, v)
      local obj = SFSObject.New()
      obj:PutInt("resourceType", k)
      obj:PutInt("rtNum", v)
      array:AddSFSObject(obj)
    end)
    self.sfsObj:PutSFSArray("sellResources", array)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  Logger.Log(t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.resource ~= nil then
      LuaEntry.Resource:UpdateResource(t.resource)
    end
    if t.resourceExchangeInfo ~= nil then
      DataCenter.TradeCenterDataManager:UpdateData(t.resourceExchangeInfo)
    end
    if t.accPoint ~= nil then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(t.accPoint)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RES_SELL_MSG)
  UIUtil.ShowTipsId(120144)
end

TradingSellMessage.OnCreate = OnCreate
TradingSellMessage.HandleMessage = HandleMessage
return TradingSellMessage
