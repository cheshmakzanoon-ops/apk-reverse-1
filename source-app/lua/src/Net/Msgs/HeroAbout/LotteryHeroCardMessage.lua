local LotteryHeroCardMessage = BaseClass("LotteryHeroCardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, id, isTen, useFree, itemId, jigsawCount)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("id", id)
  self.sfsObj:PutInt("isTen", isTen)
  self.sfsObj:PutInt("useFree", useFree)
  self.sfsObj:PutSFSObject("aiPushStatus", DataCenter.LWChatAIManager:GetPushSwitchStatus())
  if itemId ~= nil then
    self.sfsObj:PutUtfString("itemId", itemId)
  end
  if jigsawCount ~= nil and 0 < jigsawCount then
    self.sfsObj:PutInt("lotteryCount", jigsawCount)
  end
  HeroUtils.IsInTheLottery = true
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local lang = Localization:GetString(message.errorCode)
    UIUtil.ShowTips(lang or message.errorCode)
    return
  end
  if message.lotteryCount ~= nil and message.lotteryCount > 0 then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UINewHero)
    if window == nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroJigsawReward, {anim = true}, message)
    end
  else
    DataCenter.LotteryDataManager:UpdateOneLottery(message)
    if message.totalLotteryNum ~= nil then
      DataCenter.LotteryDataManager:SetLotteryTotalNum(message.totalLotteryNum)
    end
    EventManager:GetInstance():Broadcast(EventId.HeroicRecruitmentData, message)
  end
  EventManager:GetInstance():Broadcast(EventId.CheckPubBubble, true)
  EventManager:GetInstance():Broadcast(EventId.HeroStationUpdate)
  HeroUtils.IsInTheLottery = false
end

LotteryHeroCardMessage.OnCreate = OnCreate
LotteryHeroCardMessage.HandleMessage = HandleMessage
return LotteryHeroCardMessage
