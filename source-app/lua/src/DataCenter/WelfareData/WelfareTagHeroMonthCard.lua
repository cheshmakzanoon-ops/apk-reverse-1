local WelfareTagHeroMonthCard = BaseClass("WelfareTagHeroMonthCard", WelfareTagInfo)
local M = WelfareTagHeroMonthCard

function M:isShow()
  local info = self:getInfo()
  local isShow = false
  if info ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now < info.startTime or now > info.endTime then
      return false
    end
    local exchangeId = info.exchangeId
    local packageInfo = GiftPackageData.get(exchangeId)
    if packageInfo ~= nil then
      isShow = true
    end
  end
  return LuaEntry.DataConfig:CheckSwitch("hero_monthcard") and isShow and WelfareTagInfo.isShow(self)
end

function M:hasRedPoint()
  local rechargeId = self:getID()
  local lineData = DataCenter.RechargeManager:GetLine(rechargeId)
  local para1 = lineData.para1
  local activityId = DataCenter.HeroMonthCardManager:GetActivityIdByExchangeId(para1)
  return DataCenter.HeroMonthCardManager:GetUnReceivedReward(activityId) > 0
end

function M:getInfo()
  local rechargeId = self:getID()
  local lineData = DataCenter.RechargeManager:GetLine(rechargeId)
  local para1 = lineData.para1
  local activityId = DataCenter.HeroMonthCardManager:GetActivityIdByExchangeId(para1)
  local data = DataCenter.HeroMonthCardManager:GetHeroMonthCardInfo(activityId)
  return data
end

function M:getRedDotNum()
  local rechargeId = self:getID()
  local lineData = DataCenter.RechargeManager:GetLine(rechargeId)
  local para1 = lineData.para1
  local activityId = DataCenter.HeroMonthCardManager:GetActivityIdByExchangeId(para1)
  return DataCenter.HeroMonthCardManager:GetUnReceivedReward(activityId)
end

function M:isShowIcon()
  local info = self:getInfo()
  return info ~= nil and WelfareTagInfo.isShowIcon(self)
end

return M
