local BuyFreeWeeklyPackageMessage = BaseClass("BuyFreeWeeklyPackageMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local _isAutoClaim = false

local function OnCreate(self, isAutoClaim)
  base.OnCreate(self)
  _isAutoClaim = isAutoClaim
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    GiftPackageData.UpdateClaimFreeWeeklyPackageT(t, _isAutoClaim)
  end
end

BuyFreeWeeklyPackageMessage.OnCreate = OnCreate
BuyFreeWeeklyPackageMessage.HandleMessage = HandleMessage
return BuyFreeWeeklyPackageMessage
