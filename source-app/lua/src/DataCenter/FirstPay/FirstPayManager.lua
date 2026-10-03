local FirstPayManager = BaseClass("FirstPayManager", CEventable)
local Localization = CS.GameEntry.Localization
local FirstPayBuildExpData = require("DataCenter.FirstPay.FirstPayBuildExpData")
FirstPayManager.HeroId = 50009

local function OnUnlockArea(self, landId)
  local firstPayLandId = self:GetFirstPayLandId()
  if landId == firstPayLandId then
    local pack, rechargeId = self:GetFirstPayPack()
    if pack ~= nil then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UIHeroExhibitPanel, {anim = false}, 50009, {50009}, nil, true)
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UIFirstPay, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllHide
      }, {delay = 0.5})
      DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.FirstPayShowHero, false)
      PostEventLog.Track(PostEventLog.Defines.PlayFirstPayTimeline, {
        param1 = tostring(DataCenter.MonopolyManager.player.curId)
      })
    end
  end
end

function FirstPayManager:OnFirstPayBuildAdd()
end

local function DeleteDelayTimer(self)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function AddDelayTimer(self)
  DeleteDelayTimer(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local delayTime = (self.endTime - curTime) / 1000 + 1
  if 0 < delayTime then
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:UpdateBuildingState()
    end, delayTime)
    self.delayTimer:Start()
  end
end

local function SetFirstPayBuildFixingState(self, building, state)
  if not IsNull(CS.SceneManager.World) and building then
    local buildData = building
    local build = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
    if build and not IsNull(build.gameObject) then
      local effectParent = build.gameObject.transform:Find("ModelGo/EffectGo")
      local fixingEffect = build.gameObject.transform:Find("ModelGo/EffectGo/Eff_vehicle_weixiu")
      if not IsNull(effectParent) and not IsNull(fixingEffect) then
        effectParent.gameObject:SetActive(state)
        fixingEffect.gameObject:SetActive(state)
        if state then
          AddDelayTimer(self)
        end
      end
    end
  end
end

local function OnBuildInView(self, uid)
  local bUuid = tonumber(uid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData and buildData.itemId == BuildingTypes.LW_FIRST_PAY then
    local status = false
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.status == FirstPayState.Repairing and curTime < self.endTime then
      status = true
    end
    SetFirstPayBuildFixingState(self, buildData, status)
  end
end

local function UpdateBuildingState(self)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_FIRST_PAY)
  if buildData then
    local status = false
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.status == FirstPayState.Repairing and curTime < self.endTime then
      status = true
    end
    SetFirstPayBuildFixingState(self, buildData, status)
  else
    DeleteDelayTimer(self)
  end
end

local function OnBuildOutView(self, bUuid)
  local bUuid = tonumber(bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData and buildData.itemId == BuildingTypes.LW_FIRST_PAY then
    DeleteDelayTimer(self)
  end
end

local function __init(self)
  self.status = FirstPayState.DontHaveBuilding
  self.time = 0
  self.endTime = 0
  self.viewRewards = nil
  self.viewExtraxRewards = nil
  self.is_new = false
end

local function __delete(self)
  DeleteDelayTimer(self)
  self.viewRewards = {}
  self.viewExtraxRewards = {}
  self.is_new = false
end

local function IsNewFirstPay(self)
  if self.is_new then
    return self.is_new
  end
  return false
end

local function InitData(self, message)
  local firstPayMessage = message.limit_time_gift
  if not table.IsNullOrEmpty(firstPayMessage) then
    if firstPayMessage.is_new ~= nil then
      self.is_new = firstPayMessage.is_new == 1
    else
      local prevStatus = self.status
      self.status = firstPayMessage.status
      self.time = firstPayMessage.time
      self.endTime = firstPayMessage.end_time
      EventManager:GetInstance():Broadcast(EventId.UpdateFirstPayState)
      if self.status ~= prevStatus then
        self:UpdateBuildingState()
      end
    end
  end
  self:RegisterEvent(EventId.GF_monopoly_new_grid_arrived, self.OnUnlockArea)
  self:RegisterEvent(EventId.FIRST_PAY_BUILD_ADD, self.OnFirstPayBuildAdd)
  self:RegisterEvent(EventId.OnRewardGetPanelClose, self.OnRewardGetPanelClose)
  Logger.Log("IsBuildingUpgradeGetExpFunctionOn:" .. tostring(self:IsBuildingUpgradeGetExpFunctionOn()))
  self.buildExpData = FirstPayBuildExpData.New()
  self.buildExpData:InitData(message)
end

local function UpdateData(self, message)
  local firstPayMessage = message
  if not table.IsNullOrEmpty(firstPayMessage) then
    if firstPayMessage.is_new ~= nil then
      self.is_new = firstPayMessage.is_new == 1
    else
      local prevStatus = self.status
      self.status = firstPayMessage.status
      self.time = firstPayMessage.time
      self.endTime = firstPayMessage.end_time
      EventManager:GetInstance():Broadcast(EventId.UpdateFirstPayState)
      if self.status ~= prevStatus then
        self:UpdateBuildingState()
      end
    end
  end
end

local function GetState(self)
  return self.status
end

local function GetFixEndTime(self)
  return self.endTime
end

local function GetRewardList(self)
  if table.IsNullOrEmpty(self.viewRewards) then
    local rewardList = LuaEntry.DataConfig:TryGetStr("first_pay_lw", "k5", "")
    self.viewRewards = DataCenter.RewardManager:ParseRewardsStr(rewardList)
  end
  return self.viewRewards
end

local function GetExtraRewardList(self)
  if table.IsNullOrEmpty(self.viewExtraxRewards) then
    local rewardList = LuaEntry.DataConfig:TryGetStr("first_pay_lw", "k6", "")
    self.viewExtraxRewards = DataCenter.RewardManager:ParseRewardsStr(rewardList)
  end
  return self.viewExtraxRewards
end

local function GetFirstPayPack(self)
  if self:IsNewFirstPay() then
    local rechargeIds = GiftPackageData.GetRechargeIdListByType(WelfareTagType.FirstCharge)
    if 0 < #rechargeIds then
      local packs = GiftPackageData.GetAllAvailablePackageByRechargeId(rechargeIds[1], false)
      if not table.IsNullOrEmpty(packs) then
        return packs[1], rechargeIds[1]
      end
    end
    return nil
  else
    local packId = LuaEntry.DataConfig:TryGetStr("first_pay_lw", "k2")
    local packData = GiftPackageData.get(tostring(packId))
    return packData
  end
end

local function CheckCanShow(self)
  local unlocked = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_FirstPay)
  local canShow = false
  local isNew = self:IsNewFirstPay()
  if isNew then
    local firstChargePack = self:GetFirstPayPack()
    if firstChargePack then
      canShow = true
    end
  else
    local firstPayState = self:GetState()
    if firstPayState > FirstPayState.DontHaveBuilding and firstPayState <= FirstPayState.Repairing then
      canShow = true
    end
  end
  return unlocked and canShow
end

function FirstPayManager:IsExistFirstPayPackage()
  local isNew = self:IsNewFirstPay()
  if isNew then
    local firstChargePack = self:GetFirstPayPack()
    return firstChargePack ~= nil
  else
    local firstPayState = self:GetState()
    if firstPayState > FirstPayState.DontHaveBuilding and firstPayState <= FirstPayState.Repairing then
      return true
    end
  end
end

function FirstPayManager:IsHasBoughtFirstPay()
  local unlocked = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_FirstPay)
  if not unlocked then
    return false
  end
  local isLandUnlock = self:CheckLandUnlock()
  if not isLandUnlock then
    return false
  end
  local isExistFirstPayPack = self:IsExistFirstPayPackage()
  return not isExistFirstPayPack
end

function FirstPayManager:CheckLandUnlock()
  local firstPayExchangeId
  if self:IsNewFirstPay() then
    local rechargeIds = GiftPackageData.GetRechargeIdListByType(WelfareTagType.FirstCharge)
    if 0 < #rechargeIds then
      local packageIds = DataCenter.RechargeManager:GetSplitedPara1(rechargeIds[1])
      if packageIds and 0 < #packageIds then
        firstPayExchangeId = packageIds[1]
      end
    else
      return true
    end
  else
    firstPayExchangeId = LuaEntry.DataConfig:TryGetStr("first_pay_lw", "k2")
  end
  if not firstPayExchangeId then
    return true
  end
  local lineData = LocalController:instance():getLine(TableName.Exchange, firstPayExchangeId)
  if not lineData then
    return true
  end
  local unlockCondition = lineData.condition
  if not unlockCondition then
    return true
  end
  local conditionStrArr = string.split(unlockCondition, "|")
  if not conditionStrArr or #conditionStrArr == 0 then
    return true
  end
  for _, conditionStr in ipairs(conditionStrArr) do
    local infoArr = string.split(conditionStr, ";")
    local conditionType = infoArr[1]
    local needUnlockLandId = infoArr[2]
    if toInt(conditionType) == ExchangeUnlockConditionType.LandUnlock then
      local landData = DataCenter.MonopolyManager:GetPlacealityDataById(tonumber(needUnlockLandId))
      if landData then
        local curUnlockId = -1
        if DataCenter.MonopolyManager.maxUnlockEndId then
          curUnlockId = DataCenter.MonopolyManager.maxUnlockEndId + 1
        else
          curUnlockId = DataCenter.MonopolyManager.player.curId
        end
        if curUnlockId <= toInt(needUnlockLandId) then
          return false
        end
      end
    end
  end
  return true
end

function FirstPayManager:GetPackageItems()
  local extraRewardList = {}
  local packageInfo, _ = DataCenter.FirstPayManager:GetFirstPayPack()
  local isNewFirstPay = DataCenter.FirstPayManager:IsNewFirstPay()
  if isNewFirstPay and packageInfo then
    extraRewardList = packageInfo:getItems()
  else
    local data = DataCenter.FirstPayManager:GetExtraRewardList()
    for _, v in ipairs(data) do
      table.insert(extraRewardList, v)
    end
  end
  if DataCenter.MaxAdManager:IsAdsComponentCanShow() then
    local data = DataCenter.MaxAdManager:GetPrivilegeItemData()
    if data then
      table.insert(extraRewardList, math.min(4, #extraRewardList + 1), data)
    end
  end
  return extraRewardList
end

function FirstPayManager:GetFirstPayLandId()
  local landId = DataCenter.LWCivilizationSparkExtend:FirstPayManager_getFirstPayLandId()
  if landId then
    return landId
  end
  if DataCenter.HeroTryOutManager:IsKatyushaSpecialBonusFunctionOn() and not DataCenter.HeroTryOutManager:IsHasBoughtFirstPay() then
    return LuaEntry.DataConfig:TryGetNum("herokim_timeline_control", "k11")
  end
  return LuaEntry.DataConfig:TryGetNum("first_pay_lw", "k7")
end

function FirstPayManager:TryOpenNewSkillPreview()
  local isOpenNew = false
  if self:IsNewSkillPreviewFunctionOn() then
    local previewSkillId, addSkillInfo = self:GetSkillPreviewAddSkillInfo()
    if previewSkillId and addSkillInfo then
      local heroId = self.HeroId
      local skillId = previewSkillId
      local skillLv = 1
      local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
      local skillMaxLv = skillTemplate.maxLevel
      local customTitle = Localization:GetString("hero_unique_weapon_title2")
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPreviewSkillWindow_Long, {anim = true}, heroId, skillId, skillLv, skillMaxLv, nil, {addSkillInfo}, customTitle, 9, false)
      isOpenNew = true
    end
  end
  if not isOpenNew then
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(50009)
    local heroId = 50009
    local skillId = heroTemplate.skills[2]
    local skillLv = 1
    local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    local skillMaxLv = skillTemplate.maxLevel
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPreviewSkillWindow, {anim = true}, heroId, skillId, skillLv, skillMaxLv)
  end
end

function FirstPayManager:GetSkillPreviewAddSkillInfo()
  local previewSkillId = LuaEntry.DataConfig:TryGetNum("kim_gift_skill_config", "k1", 0)
  local addSkillStr = LuaEntry.DataConfig:TryGetStr("kim_gift_skill_config", "k2", "")
  local addSkillArr = string.split(addSkillStr, ";")
  if 0 < previewSkillId and #addSkillArr == 2 then
    local skillId = checknumber(addSkillArr[1])
    local preCd = checknumber(addSkillArr[2])
    local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    if skillTemplate then
      local skillInfo = SkillInfo.New()
      local skillInfoParam = {}
      skillInfoParam.skillId = skillId
      skillInfoParam.level = 1
      skillInfoParam.state = 1
      skillInfo:UpdateSkillInfo(skillInfoParam)
      local heroSkillTemplate = DeepCopy(skillInfo.skillTemplateData)
      heroSkillTemplate.pre_cd = preCd * 0.001
      skillInfo.skillTemplateData = heroSkillTemplate
      return previewSkillId, skillInfo
    end
  end
end

function FirstPayManager:IsNewSkillPreviewFunctionOn()
  if not LuaEntry.DataConfig:CheckSwitch("kim_gift_skill") then
    return false
  end
  return true
end

function FirstPayManager:IsBuildingUpgradeGetExpFunctionOn()
  local unlocked = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_FirstPay)
  if not unlocked then
    return false
  end
  local isTargetLandUnlock = self:CheckLandUnlock()
  if not isTargetLandUnlock then
    return false
  end
  if not self.buildExpData or not self.buildExpData:IsOpen() then
    return false
  end
  return true
end

function FirstPayManager:IsShowGetExpGetMore()
  local functionOn = self:IsBuildingUpgradeGetExpFunctionOn()
  if not functionOn then
    return false
  end
  if not self.buildExpData then
    return false
  end
  if self.buildExpData:IsReceivedBigReward() then
    return false
  end
  return true
end

function FirstPayManager:UpdateBuildExpData(t)
  if not self.buildExpData then
    return
  end
  self.buildExpData:UpdateExpData(t)
  EventManager:GetInstance():Broadcast(EventId.BuildExpDataUpdated)
end

function FirstPayManager:GetCurBuildExpData()
  return self.buildExpData
end

function FirstPayManager:SetFirstPayLastRewardCacheFlag(rewardData)
  self.firstPayExpLastReward = rewardData
end

function FirstPayManager:OnRewardGetPanelClose()
  if not self.firstPayExpLastReward then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstPayBuildingExpLastReward, {anim = true}, self.firstPayExpLastReward)
  self:SetFirstPayLastRewardCacheFlag(nil)
end

FirstPayManager.__init = __init
FirstPayManager.__delete = __delete
FirstPayManager.InitData = InitData
FirstPayManager.UpdateData = UpdateData
FirstPayManager.InitData = InitData
FirstPayManager.GetState = GetState
FirstPayManager.GetFixEndTime = GetFixEndTime
FirstPayManager.GetRewardList = GetRewardList
FirstPayManager.GetExtraRewardList = GetExtraRewardList
FirstPayManager.GetFirstPayPack = GetFirstPayPack
FirstPayManager.OnBuildInView = OnBuildInView
FirstPayManager.OnBuildOutView = OnBuildOutView
FirstPayManager.UpdateBuildingState = UpdateBuildingState
FirstPayManager.IsNewFirstPay = IsNewFirstPay
FirstPayManager.OnUnlockArea = OnUnlockArea
FirstPayManager.CheckCanShow = CheckCanShow
return FirstPayManager
