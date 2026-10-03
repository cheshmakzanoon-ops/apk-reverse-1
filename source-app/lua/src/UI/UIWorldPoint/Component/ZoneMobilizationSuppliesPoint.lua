local base = UIBaseContainer
local ZoneMobilizationSuppliesPoint = BaseClass("ZoneMobilizationSuppliesPoint", base)
local ZoneMobilizationSuppliesRewardItem = require("UI.UIWorldPoint.Component.ZoneMobilizationSuppliesRewardItem")
local Localization = CS.GameEntry.Localization
local animator_path = ""
local rewardParent_path = "BuildInfo/content/rewardParent"
local rewardItem_path = "BuildInfo/content/WorldSuppliesRewardItem"
local unfrozen_path = "BuildInfo/content/TipsRoot/Unfrozen"
local selfGotCountText_path = "BuildInfo/content/GameObject/Bg/SelfGotCountText"
local discovererNameText_path = "BuildInfo/content/Discoverer/NameText"
local des_path = "BuildDetails/ScrollView/Viewport/Content/desTxt"
local discovererHead_path = "BuildInfo/content/Discoverer/UIPlayerHead"
local remind_tips_path = "BuildInfo/content/TipsRoot/RemindTips"
local rewardCount = 12

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.rewardParent = self:AddComponent(UIBaseContainer, rewardParent_path)
  self.rewardItem = self:AddComponent(ZoneMobilizationSuppliesRewardItem, rewardItem_path)
  self.unfrozen = self:AddComponent(UIText, unfrozen_path)
  self.selfGotCountText = self:AddComponent(UIText, selfGotCountText_path)
  self.discovererNameText = self:AddComponent(UIText, discovererNameText_path)
  self.des = self:AddComponent(UIText, des_path)
  self.discovererHead = self:AddComponent(UICommonHead, discovererHead_path)
  self.discovererHead:SetEnableClickShowInfo(true, true)
  self.rewardItem:SetActive(false)
  self.remind_tips = self:AddComponent(UITextMeshProUGUIEx, remind_tips_path)
  self.remind_tips:SetLocalText("zone_mobilization_supplies_red_tips")
  self.remind_tips:SetActive(DataCenter.LWZoneMobilizationManager:GetIsNewFunc())
end

local function ComponentDestroy(self)
  self.animator = nil
  self.rewardParent = nil
  self.rewardItem = nil
  self.unfrozen = nil
  self.selfGotCountText = nil
  self.discovererNameText = nil
  self.des = nil
  self.discovererHead = nil
  self.remind_tips = nil
end

local function DataDefine(self)
  self.rewardItem.gameObject:GameObjectCreatePool()
  self.rewardCom = {}
  for i = 1, rewardCount do
    local goItem = self.rewardItem.gameObject:GameObjectSpawn(self.rewardParent.transform)
    goItem.name = "reward_" .. i
    local rewardItemCom = self.rewardParent:AddComponent(ZoneMobilizationSuppliesRewardItem, goItem.name)
    rewardItemCom:SetActive(false)
    self.rewardCom[i] = rewardItemCom
  end
  self.expireTime = nil
end

local function DataDestroy(self)
  self.rewardParent:RemoveComponents(ZoneMobilizationSuppliesRewardItem)
  self.rewardItem.gameObject:GameObjectRecycleAll()
  self.rewardCom = nil
end

function ZoneMobilizationSuppliesPoint:OnInfoClick()
  self.animator:Enable(true)
  self.animator:Play("switchEnter", 0, 0)
end

function ZoneMobilizationSuppliesPoint:OnReturnClick()
  self.animator:Enable(true)
  self.animator:Play("switchOut", 0, 0)
end

function ZoneMobilizationSuppliesPoint:RefreshData(param)
  self.data = param
  self.lock = false
  self.des:SetText(self.data.detailInfo)
end

function ZoneMobilizationSuppliesPoint:DataIndex2ComIndex(index)
  local t = toInt((index - 1) / 4)
  if t % 2 == 0 then
    return index
  else
    local v = (t + 1) * 4 - (index - 1) % 4
    return v
  end
end

local function GetIsRedReward(redRewardList, target)
  if redRewardList then
    for i, v in ipairs(redRewardList) do
      if target < v then
        return false
      end
      if v == target then
        return true
      end
    end
  end
  return false
end

function ZoneMobilizationSuppliesPoint:RefreshServerData(serverData)
  self.serverData = serverData
  self.expireTime = nil
  if serverData == nil then
    return
  end
  local redRewardList = self.serverData.detailData.redRewardList
  for i = 1, rewardCount do
    local comIndex = self:DataIndex2ComIndex(i)
    local item = self.rewardCom[comIndex]
    if item then
      local luckIndex = self.serverData.detailData.luckyRewardIndex[i]
      local reward
      local isRed = GetIsRedReward(redRewardList, i)
      local player = self.serverData.detailData:GetPlayerByIndex(i)
      if isRed then
        reward = self.serverData.detailData.redReward
      elseif luckIndex then
        reward = self.serverData.detailData.luckyReward
      else
        reward = self.serverData.detailData.commonReward
      end
      item:SetData(reward, luckIndex, player, comIndex, isRed)
      item:SetActive(true)
    end
  end
  if self.serverData.detailData.expireTime > 0 then
    self.expireTime = self.serverData.detailData.expireTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.expireTime then
      local StrRemainTime = "<color=#F53C3D>" .. UITimeManager:GetInstance():MilliSecondToFmtString(self.expireTime - curTime) .. "</color>"
      self.unfrozen:SetLocalText("season_s2_ice_supplies_32", StrRemainTime)
      self.unfrozen:SetActive(true)
    else
      self.expireTime = nil
      self.unfrozen:SetActive(false)
    end
  else
    self.expireTime = nil
    self.unfrozen:SetActive(false)
  end
  local configId = serverData.detailData.configId
  if configId then
    local line = LocalController:instance():tryGetLine(TableName.LWIceSupplies, configId)
    if line then
      if line.type == WorldSuppliesType.ZoneMobilizationType then
        local maxNum = DataCenter.LWZoneMobilizationManager.allianceMax
        self.selfGotCountText:SetText(Localization:GetString("zone_mobilization_donated_supplies_rule_2", serverData.detailData.suppliesRewardTimes, maxNum))
      elseif line.type == WorldSuppliesType.ZoneMobilizationSmallType then
        local maxNum = DataCenter.LWZoneMobilizationManager.personalMax
        self.selfGotCountText:SetText(Localization:GetString("zone_mobilization_donated_supplies_rule_3", serverData.detailData.playerSuppliesRewardTimes, maxNum))
      end
    end
  end
  local discovererInfo = serverData.detailData.discovererInfo
  self.discovererHead:SetData(discovererInfo.uid, discovererInfo.pic, discovererInfo.picVer, nil, discovererInfo:GetHeadBgImg())
  self.discovererNameText:SetText(UIUtil.FormatAllianceAndName(discovererInfo.alAbbr, discovererInfo.name))
end

function ZoneMobilizationSuppliesPoint:Update1000MS()
  if self.expireTime and self.expireTime > 0 then
    self.expireTime = self.serverData.detailData.expireTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.expireTime then
      local StrRemainTime = "<color=#F53C3D>" .. UITimeManager:GetInstance():MilliSecondToFmtString(self.expireTime - curTime) .. "</color>"
      self.unfrozen:SetLocalText("season_s2_ice_supplies_32", StrRemainTime)
    else
      self.expireTime = nil
      self.unfrozen:SetActive(false)
    end
  else
    self.expireTime = nil
  end
end

ZoneMobilizationSuppliesPoint.OnCreate = OnCreate
ZoneMobilizationSuppliesPoint.OnDestroy = OnDestroy
ZoneMobilizationSuppliesPoint.OnEnable = OnEnable
ZoneMobilizationSuppliesPoint.OnDisable = OnDisable
ZoneMobilizationSuppliesPoint.ComponentDefine = ComponentDefine
ZoneMobilizationSuppliesPoint.ComponentDestroy = ComponentDestroy
ZoneMobilizationSuppliesPoint.DataDefine = DataDefine
ZoneMobilizationSuppliesPoint.DataDestroy = DataDestroy
return ZoneMobilizationSuppliesPoint
