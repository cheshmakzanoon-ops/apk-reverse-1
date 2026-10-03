local GetWeekCardListMessage = BaseClass("GetWeekCardListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, isLogin)
  base.OnCreate(self)
  local isLoginFlag = 0
  if isLogin == true then
    isLoginFlag = 1
  end
  self.sfsObj:PutInt("isLogin", isLoginFlag)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.buyAllExchangeId then
      DataCenter.WeekCardManager:UpdateBuyAllPackageId(t.buyAllExchangeId)
    end
    if t.weekCards then
      DataCenter.WeekCardManager:OnInitWeekCardList(t.weekCards)
    end
    if t.dailyFree then
      DataCenter.WeekCardManager:UpdateWeekCardFreeReward(t.dailyFree)
    end
  end
end

GetWeekCardListMessage.OnCreate = OnCreate
GetWeekCardListMessage.HandleMessage = HandleMessage
return GetWeekCardListMessage
