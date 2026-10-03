local LWZoneMobilizationDonatedInfo = BaseClass("LWZoneMobilizationDonatedInfo")
local LWZoneMobilizationStageRewardInfo = require("DataCenter.LWZoneMobilizationManager.LWZoneMobilizationStageRewardInfo")

function LWZoneMobilizationDonatedInfo:__init()
  self.donateProgress = 0
  self.maxProgress = 0
  self.donateStageEndTime = 0
  self.isAutoFill = false
  self.stageRewardList = {}
  self.personalDonateInfo = {
    boxNum = 0,
    progress = 0,
    rewardPreview = {}
  }
  self.allianceDonateInfo = {
    boxNum = 0,
    progress = 0,
    rewardPreview = {},
    limitEndTime = 0
  }
  self.donateResourceNum = 0
  self.donateSuppliesNum = 0
  self.playerDonateResourceNum = 0
  self.playerDonateSuppliesNum = 0
  self.surpriseGuaranteeNum = 0
end

function LWZoneMobilizationDonatedInfo:__delete()
  self.donateProgress = nil
  self.maxProgress = nil
  self.donateStageEndTime = nil
  self.isAutoFill = nil
  self.stageRewardList = nil
  self.personalDonateInfo = nil
  self.allianceDonateInfo = nil
  self.donateResourceNum = nil
  self.donateSuppliesNum = nil
  self.personalBoxNeedIntegralNum = nil
  self.allianceBoxNeedIntegralNum = nil
  self.playerDonateResourceNum = nil
  self.playerDonateSuppliesNum = nil
  self.surpriseGuaranteeNum = nil
end

function LWZoneMobilizationDonatedInfo:RefreshData(message)
  local preDonateProgress = self.donateProgress
  self.donateProgress = message.donateProgress or 0
  self.maxProgress = message.maxProgress or 0
  self.donateStageEndTime = message.donateStageEndTime or 0
  self.isAutoFill = message.isAutoFill or false
  if message.donateResourceNum and self.donateResourceNum ~= message.donateResourceNum then
    local addNum = message.donateResourceNum - self.donateResourceNum
    self.donateResourceNum = message.donateResourceNum
    if 0 < addNum then
      EventManager:GetInstance():Broadcast(EventId.ZoneMobilizationResourcePointsCountChanged, {
        addNum = addNum,
        type = ZoneMobilizationSuppliesType.Alliance
      })
    end
  end
  if message.playerDonateResourceNum and self.playerDonateResourceNum ~= message.playerDonateResourceNum then
    local addNum = message.playerDonateResourceNum - self.playerDonateResourceNum
    self.playerDonateResourceNum = message.playerDonateResourceNum
    if 0 < addNum then
      EventManager:GetInstance():Broadcast(EventId.ZoneMobilizationResourcePointsCountChanged, {
        addNum = addNum,
        type = ZoneMobilizationSuppliesType.Personal
      })
    end
  end
  if message.donateSuppliesNum and self.donateSuppliesNum ~= message.donateSuppliesNum then
    local addNum = message.donateSuppliesNum - self.donateSuppliesNum
    self.donateSuppliesNum = message.donateSuppliesNum
    if 0 < addNum then
      EventManager:GetInstance():Broadcast(EventId.ZoneMobilizationSuppliesPointsCountChanged, {
        addNum = addNum,
        type = ZoneMobilizationSuppliesType.Alliance
      })
    end
  end
  if message.playerDonateSuppliesNum and self.playerDonateSuppliesNum ~= message.playerDonateSuppliesNum then
    local addNum = message.playerDonateSuppliesNum - self.playerDonateSuppliesNum
    self.playerDonateSuppliesNum = message.playerDonateSuppliesNum
    if 0 < addNum then
      EventManager:GetInstance():Broadcast(EventId.ZoneMobilizationSuppliesPointsCountChanged, {
        addNum = addNum,
        type = ZoneMobilizationSuppliesType.Personal
      })
    end
  end
  self.surpriseGuaranteeNum = message.surpriseGuaranteeNum or 0
  self:CheckIsNoticePanelDoDonatedProgressEffect(preDonateProgress)
  self:HandleUpdateDonatedProgressRewardData(message.stageReward)
  self.personalDonateInfo.boxNum = message.personalDonateInfo and message.personalDonateInfo.boxNum or 0
  if message.personalDonateInfo and self.personalDonateInfo.progress ~= message.personalDonateInfo.progress then
    local param = {}
    param.boxType = ZoneMobilizationDonatedBoxType.Personal
    param.addValue = message.personalDonateInfo.progress - self.personalDonateInfo.progress
    self.personalDonateInfo.progress = message.personalDonateInfo.progress
    EventManager:GetInstance():Broadcast(EventId.ZoneMobilizationPersonalOrAllianceBoxDonatedProgressChanged, param)
  end
  self.personalDonateInfo.rewardPreview = {}
  if message.personalDonateInfo and message.personalDonateInfo.rewardPreview then
    self.personalDonateInfo.rewardPreview = DataCenter.RewardManager:ReturnRewardParamForMessage(message.personalDonateInfo.rewardPreview)
  end
  self.allianceDonateInfo.boxNum = message.allianceDonateInfo and message.allianceDonateInfo.boxNum or 0
  if message.allianceDonateInfo and self.allianceDonateInfo.progress ~= message.allianceDonateInfo.progress then
    local param = {}
    param.boxType = ZoneMobilizationDonatedBoxType.Alliance
    param.addValue = message.allianceDonateInfo.progress - self.allianceDonateInfo.progress
    self.allianceDonateInfo.progress = message.allianceDonateInfo.progress
    EventManager:GetInstance():Broadcast(EventId.ZoneMobilizationPersonalOrAllianceBoxDonatedProgressChanged, param)
  end
  self.allianceDonateInfo.rewardPreview = {}
  if message.allianceDonateInfo and message.allianceDonateInfo.rewardPreview then
    self.allianceDonateInfo.rewardPreview = DataCenter.RewardManager:ReturnRewardParamForMessage(message.allianceDonateInfo.rewardPreview)
  end
  if message.allianceDonateInfo and message.allianceDonateInfo.limitEndTime then
    self.allianceDonateInfo.limitEndTime = message.allianceDonateInfo.limitEndTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
  end
end

function LWZoneMobilizationDonatedInfo:HandleUpdateDonatedBoxNumData(boxType, boxNum)
  if boxType == ZoneMobilizationDonatedBoxType.Personal then
    self.personalDonateInfo.boxNum = boxNum
  elseif boxType == ZoneMobilizationDonatedBoxType.Alliance then
    self.allianceDonateInfo.boxNum = boxNum
  end
end

function LWZoneMobilizationDonatedInfo:HandleUpdateDonatedProgressRewardData(stageRewardList)
  self.stageRewardList = {}
  if stageRewardList then
    for k, v in pairs(stageRewardList) do
      local stageRewardInfo = LWZoneMobilizationStageRewardInfo.New()
      stageRewardInfo:RefreshData(v)
      table.insert(self.stageRewardList, stageRewardInfo)
    end
  end
end

function LWZoneMobilizationDonatedInfo:CheckIsNoticePanelDoDonatedProgressEffect(preDonateProgress)
  local isSendNotice = false
  if preDonateProgress ~= self.donateProgress then
    local startValue = 0
    if preDonateProgress < self.donateProgress then
      startValue = preDonateProgress
      isSendNotice = true
    elseif not self.isAutoFill then
      isSendNotice = true
    end
    if isSendNotice then
      EventManager:GetInstance():Broadcast(EventId.ZoneMobilizationDonatedProgressChanged, startValue)
    end
  end
end

function LWZoneMobilizationDonatedInfo:DonatedStageIsEnd()
  if self.donateStageEndTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    return curTime >= self.donateStageEndTime
  end
  return false
end

function LWZoneMobilizationDonatedInfo:IsCanReceiveDonatedStageReward()
  local canReceiveReward = false
  if not self:IsReceiveAllDonatedStageReward() then
    if self.donateProgress >= self.maxProgress then
      local stageId = DataCenter.LWZoneMobilizationManager.stage
      canReceiveReward = not self:HasAlreadyReceiveDonatedStageReward(stageId)
    end
    if not canReceiveReward then
      for i = 1, table.count(self.stageRewardList) do
        local stageRewardInfo = self.stageRewardList[i]
        if stageRewardInfo.state == TaskState.CanReceive then
          canReceiveReward = true
          break
        end
      end
    end
  end
  return canReceiveReward
end

function LWZoneMobilizationDonatedInfo:HasAlreadyReceiveDonatedStageReward(stageId)
  for i = 1, table.count(self.stageRewardList) do
    local stageRewardInfo = self.stageRewardList[i]
    if stageRewardInfo.target == stageId then
      return stageRewardInfo.state == TaskState.Received
    end
  end
  return false
end

function LWZoneMobilizationDonatedInfo:IsCurStageFullProgress()
  local isFullProgress = false
  local stageId = DataCenter.LWZoneMobilizationManager.stage
  local stageTemplate = DataCenter.LWZoneMobilizationStageTemplateManager:GetTemplate(stageId)
  if stageTemplate and self.donateProgress then
    isFullProgress = self.donateProgress >= stageTemplate.progress
  end
  return isFullProgress
end

function LWZoneMobilizationDonatedInfo:IsReceiveAllDonatedStageReward()
  for i = 1, table.count(self.stageRewardList) do
    local stageRewardInfo = self.stageRewardList[i]
    if stageRewardInfo.state ~= TaskState.Received then
      return false
    end
  end
  return true
end

function LWZoneMobilizationDonatedInfo:GetPersonalBoxNeedIntegralNum()
  if not self.personalBoxNeedIntegralNum then
    local str = LuaEntry.DataConfig:TryGetStr("zone_mobilization", "k3", 0)
    if not string.IsNullOrEmpty(str) then
      local strArr = string.split(str, "|")
      if 0 < table.count(strArr) then
        self.personalBoxNeedIntegralNum = tonumber(strArr[1])
      end
    end
  end
  return self.personalBoxNeedIntegralNum
end

function LWZoneMobilizationDonatedInfo:GetAllianceBoxNeedIntegralNum()
  if not self.allianceBoxNeedIntegralNum then
    local str = LuaEntry.DataConfig:TryGetStr("zone_mobilization", "k4", 0)
    if not string.IsNullOrEmpty(str) then
      local strArr = string.split(str, "|")
      if 0 < table.count(strArr) then
        self.allianceBoxNeedIntegralNum = tonumber(strArr[1])
      end
    end
  end
  return self.allianceBoxNeedIntegralNum
end

function LWZoneMobilizationDonatedInfo:IsDonateLimited()
  if self.allianceDonateInfo and self.allianceDonateInfo.limitEndTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    return curTime < self.allianceDonateInfo.limitEndTime
  end
  return false
end

function LWZoneMobilizationDonatedInfo:GetSuppliesRedPoint(checkSupplies, checkPersonSupplies)
  if self.donateResourceNum > 0 or 0 < self.playerDonateResourceNum then
    return true
  end
  if checkSupplies and 0 < self.donateSuppliesNum then
    return true
  end
  if checkPersonSupplies and 0 < self.playerDonateSuppliesNum then
    return true
  end
  return false
end

return LWZoneMobilizationDonatedInfo
