local CreditManager = BaseClass("CreditManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.creditValue = nil
end

local function __delete(self)
  self.creditValue = nil
end

local function OnUpdateCreditValue(self, msg, isInit)
  if not msg then
    return
  end
  local prevCreditValue = self.creditValue
  self.creditValue = msg.creditExp or 0
  if not CS.ApplicationLaunch.Instance.Loading.IsLoading and (prevCreditValue and 0 <= prevCreditValue and self.creditValue < 0 or prevCreditValue and prevCreditValue < 0 and self.creditValue >= 0) then
    CS.ApplicationLaunch.Instance:ReloadGame()
    return
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateCreditValue)
end

local function GetCreditValue(self)
  return self.creditValue or 0
end

CreditManager.__init = __init
CreditManager.__delete = __delete
CreditManager.OnUpdateCreditValue = OnUpdateCreditValue
CreditManager.GetCreditValue = GetCreditValue
return CreditManager
