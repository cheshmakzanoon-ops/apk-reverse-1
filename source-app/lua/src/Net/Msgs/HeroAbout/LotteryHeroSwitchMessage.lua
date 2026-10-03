local LotteryHeroSwitchMessage = BaseClass("LotteryHeroSwitchMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, originalId, targetId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("originalId", originalId)
  self.sfsObj:PutUtfString("targetId", targetId)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local lang = Localization:GetString(message.errorCode)
    UIUtil.ShowTips(lang or message.errorCode)
    return
  end
  local lotteryId = message.targetId
  if message.gold ~= nil then
  end
  if message.free then
    local freeCount = 0
    local freeMax = 0
    if message.freeCount then
      freeCount = message.freeCount
    end
    if message.freeMax then
      freeMax = message.freeMax
    end
    DataCenter.LotteryDataManager:SetCampChangeInfo(freeCount, freeMax)
  end
  local leftCount = DataCenter.LotteryDataManager:GetLeftCampChangeFreeCount()
  EventManager:GetInstance():Broadcast(EventId.RecruitCampChange, lotteryId, leftCount)
end

LotteryHeroSwitchMessage.OnCreate = OnCreate
LotteryHeroSwitchMessage.HandleMessage = HandleMessage
return LotteryHeroSwitchMessage
