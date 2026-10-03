local TradingBuyMessage = BaseClass("TradingBuyMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, buyRes)
  base.OnCreate(self, buyRes)
  if buyRes ~= nil then
    print(buyRes)
    local array = SFSArray.New()
    table.walk(buyRes, function(k, v)
      local obj = SFSObject.New()
      obj:PutInt("resourceType", k)
      obj:PutInt("rtNum", v)
      array:AddSFSObject(obj)
    end)
    self.sfsObj:PutSFSArray("buyResources", array)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  Logger.Log(t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.resourceExchangeInfo ~= nil then
    DataCenter.TradeCenterDataManager:UpdateData(t.resourceExchangeInfo)
  end
  EventManager:GetInstance():Broadcast(EventId.RES_SELL_MSG)
  UIUtil.ShowTipsId(120144)
end

TradingBuyMessage.OnCreate = OnCreate
TradingBuyMessage.HandleMessage = HandleMessage
return TradingBuyMessage
