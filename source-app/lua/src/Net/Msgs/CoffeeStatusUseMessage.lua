local CoffeeStatusUseMessage = BaseClass("CoffeeStatusUseMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, coffeeId)
  base.OnCreate(self)
  if coffeeId then
    self.sfsObj:PutInt("coffeeId", coffeeId)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.MakingCoffeeManager:OnCoffeeStatusUseMessage(t)
  end
end

CoffeeStatusUseMessage.OnCreate = OnCreate
CoffeeStatusUseMessage.HandleMessage = HandleMessage
return CoffeeStatusUseMessage
