local base = UIBaseContainer
local DarknessSuppliesPoint = BaseClass("DarknessSuppliesPoint", base)
local WorldSuppliesRewardItem = require("UI.UIWorldPoint.Component.WorldSuppliesRewardItem")
local Localization = CS.GameEntry.Localization
local animator_path = ""
local rewardParent_path = "BuildInfo/content/rewardParent"
local rewardItem_path = "BuildInfo/content/rewardParent/WorldSuppliesRewardItem"
local des_path = "BuildDetails/ScrollView/Viewport/Content/desTxt"
local imagePath_path = "BuildInfo/content/rewardParent/ImagePath"
local content_path = "BuildInfo/content"
local remain_path = "BuildInfo/content/remain"
local infoContent_path = "BuildInfo/content/infoContent"
local progressNum_path = "BuildInfo/content/infoContent/progress/progressNum"
local progress_path = "BuildInfo/content/infoContent/progress"
local progress2_path = "BuildInfo/content/infoContent/progress/progress2"
local icon_path = "BuildInfo/content/infoContent/progress/progress2/icon"
local memberNumInfo_path = "BuildInfo/content/infoContent/membeNumInfo"
local memberTip_path = "BuildInfo/content/infoContent/membeNumInfo/memberTip"
local memberNum_path = "BuildInfo/content/infoContent/membeNumInfo/memberNum"
local speed_path = "BuildInfo/content/infoContent/membeNumInfo/speedTip"
local triggerInfo_path = "BuildInfo/content/triggerInfo"
local triggerName_path = "BuildInfo/content/triggerInfo/triggerName"
local triggerIcon_path = "BuildInfo/content/triggerInfo/triggerIcon"
local __lineCount = 4

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
  self.rewardItem = self:AddComponent(WorldSuppliesRewardItem, rewardItem_path)
  self.des = self:AddComponent(UIText, des_path)
  self.imagePath = self:AddComponent(UIImage, imagePath_path)
  self.remain = self:AddComponent(UIText, remain_path)
  self.infoContent = self:AddComponent(UIBaseContainer, infoContent_path)
  self.progressNum = self:AddComponent(UIText, progressNum_path)
  self.progress = self:AddComponent(UISlider, progress_path)
  self.progress2 = self:AddComponent(UISlider, progress2_path)
  self.icon = self:AddComponent(UIBaseContainer, icon_path)
  self.memberNumInfo = self:AddComponent(UIBaseContainer, memberNumInfo_path)
  self.memberTip = self:AddComponent(UIText, memberTip_path)
  self.memberNum = self:AddComponent(UIText, memberNum_path)
  self.speed = self:AddComponent(UIText, speed_path)
  self.triggerInfo = self:AddComponent(UIButton, triggerInfo_path)
  self.triggerName = self:AddComponent(UIText, triggerName_path)
  self.triggerIcon = self:AddComponent(UIBaseContainer, triggerIcon_path)
  self.contentElement = self:AddComponent(UILayoutElement, content_path)
  self.rewardItem.gameObject:GameObjectCreatePool()
  self.rewardItem:SetActive(false)
  self.triggerInfo:SetOnClick(function()
    UIUtil.ShowBubbleTips(Localization:GetString("season4_supplies_UI_21"), self.triggerIcon.transform.position, 0, -30, 0)
  end)
  self.infoContent:SetActive(false)
end

local function ComponentDestroy(self)
  self.animator = nil
  self.rewardParent = nil
  self.rewardItem = nil
  self.des = nil
  self.imagePath = nil
  self.content = nil
  self.remain = nil
  self.infoContent = nil
  self.progressNum = nil
  self.progress = nil
  self.progress2 = nil
  self.icon = nil
  self.memberNumInfo = nil
  self.memberTip = nil
  self.memberNum = nil
  self.speed = nil
  self.triggerInfo = nil
  self.triggerName = nil
  self.triggerIcon = nil
end

local function DataDefine(self)
  self.expireTime = nil
end

local function DataDestroy(self)
  self.rewardParent:RemoveComponents(WorldSuppliesRewardItem)
  self.rewardItem.gameObject:GameObjectRecycleAll()
  self.rewardCom = nil
end

function DarknessSuppliesPoint:Update1000MS()
  if self.infoContent and self.infoContent.activeSelf then
    self:RefreshProgress()
  end
  self:RefreshExpireTime()
end

function DarknessSuppliesPoint:RefreshServerData(serverData)
  UIUtil.CheckEventTrigger(OpMode.ClickBtnS4LuckyCat)
  self.serverData = serverData
  self:RefreshList()
  local detailData = serverData.detailData
  if detailData.type == WorldSuppliesType.DarknessSeasonSmallType then
    self:RefreshSmallType(detailData)
    return
  end
  self.triggerInfo:SetActive(false)
  if self:RefreshExpireTime(detailData.expireTime) then
    self.infoContent:SetActive(false)
    self.contentElement:SetPreferredHeight(self.height - 110)
    return
  end
  self.remain:SetText("")
  if self:RefreshProgress() then
    self.memberTip:SetLocalText(self.memberCount > 0 and "season4_supplies_UI_12" or "season4_supplies_tips_2")
    self.memberNum:SetText(string.format("(%s)", self.memberCount))
    self.speed:SetText(Localization:GetString("season4_supplies_UI_14", string.format("(%d%%)", self.memberCount * 100)))
    self.infoContent:SetActive(true)
    self.memberNumInfo:SetActive(true)
    self.contentElement:SetPreferredHeight(self.height)
  else
    local use = self.serverData.detailData.rewardCount or 0
    local max = self.serverData.detailData.rewardMax or 0
    if self.serverData.detailData.rewardLeftCount then
      self.remain:SetLocalText("season4_supplies_UI_28", self.serverData.detailData.rewardLeftCount, max)
    else
      self.remain:SetLocalText("season_oasis_UI_15", max - use, max)
    end
    self.infoContent:SetActive(false)
    self.contentElement:SetPreferredHeight(self.height - 110)
  end
end

function DarknessSuppliesPoint:RefreshSmallType(detailData)
  self:RefreshExpireTime(detailData.expireTime)
  local discovererInfo = detailData.discovererInfo
  if discovererInfo and not string.IsNullOrEmpty(discovererInfo.name) then
    if string.IsNullOrEmpty(discovererInfo.alAbbr) then
      self.triggerName:SetText(discovererInfo.name)
    else
      self.triggerName:SetText(Localization:GetString("season4_supplies_UI_22", string.format("[%s]%s", discovererInfo.alAbbr, discovererInfo.name)))
    end
    self.triggerInfo:SetActive(true)
  else
    self.triggerInfo:SetActive(false)
  end
  self.memberNumInfo:SetActive(false)
  if self:RefreshProgress() then
    self.infoContent:SetActive(true)
    self.contentElement:SetPreferredHeight(self.height)
  else
    self.infoContent:SetActive(false)
    self.contentElement:SetPreferredHeight(self.height - 70)
  end
end

function DarknessSuppliesPoint:RefreshData(param)
  self.data = param
  self.des:SetText(self.data.detailInfo)
end

function DarknessSuppliesPoint:RefreshList()
  local curCount = self.serverData.detailData.totalLimit
  local line = math.ceil(curCount / __lineCount)
  self.height = 150 + line * 120
  self.imagePath:SetActive(3 <= line)
  local lastCount = self.rewardCom and #self.rewardCom or 0
  if curCount ~= lastCount then
    self.rewardParent:RemoveComponents(WorldSuppliesRewardItem)
    self.rewardItem.gameObject:GameObjectRecycleAll()
    self.rewardCom = {}
    for i = 1, curCount do
      local goItem = self.rewardItem.gameObject:GameObjectSpawn(self.rewardParent.transform)
      goItem.name = "reward_" .. i
      local rewardItemCom = self.rewardParent:AddComponent(WorldSuppliesRewardItem, goItem.name)
      rewardItemCom.luckIcon = rewardItemCom:AddComponent(UIImage, "luckIcon")
      rewardItemCom:SetActive(false)
      self.rewardCom[i] = rewardItemCom
    end
  end
  local memberCount = 0
  for i = 1, curCount do
    local comIndex = self:DataIndex2ComIndex(i)
    local item = self.rewardCom[comIndex]
    if item then
      local luckIndex = self.serverData.detailData.luckyRewardIndex[i]
      local reward
      if luckIndex then
        reward = self.serverData.detailData.luckyReward
        item.luckIcon:SetActive(true)
      else
        reward = self.serverData.detailData.commonReward
        item.luckIcon:SetActive(false)
      end
      local player = self.serverData.detailData:GetPlayerByIndex(i)
      if player then
        memberCount = memberCount + 1
      end
      item:SetData(reward, luckIndex, player, comIndex)
      item:SetActive(true)
    end
  end
  self.memberCount = memberCount
end

function DarknessSuppliesPoint:RefreshProgress()
  local detailData = self.serverData and self.serverData.detailData
  local chargeData = detailData and detailData.chargeData
  if not chargeData then
    return
  end
  local curPercent = chargeData:GetPercent()
  self.progress:SetValue(curPercent)
  self.progressNum:SetText(string.format("%0.1f%%", curPercent * 100))
  self.progress2:SetValue(curPercent)
  self.icon:SetActive(chargeData:IsCharging())
  return curPercent < 1
end

function DarknessSuppliesPoint:RefreshExpireTime(expireTime)
  if expireTime then
    self.expireTime = expireTime
  end
  if self.expireTime and self.expireTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.expireTime then
      local StrRemainTime = "<color=#F53C3D>" .. UITimeManager:GetInstance():MilliSecondToFmtString(self.expireTime - curTime) .. "</color>"
      self.remain:SetLocalText("season_s2_ice_supplies_32", StrRemainTime)
    else
      self.expireTime = nil
      self.remain:SetLocalText("season_s2_ice_supplies_28")
    end
  else
    self.expireTime = nil
  end
  return self.expireTime ~= nil
end

function DarknessSuppliesPoint:DataIndex2ComIndex(index)
  local t = toInt((index - 1) / __lineCount)
  if t % 2 == 0 then
    return index
  else
    return (t + 1) * __lineCount - (index - 1) % __lineCount
  end
end

function DarknessSuppliesPoint:OnInfoClick()
  self.animator:Enable(true)
  self.animator:Play("switchEnter", 0, 0)
end

function DarknessSuppliesPoint:OnReturnClick()
  self.animator:Enable(true)
  self.animator:Play("switchOut", 0, 0)
end

DarknessSuppliesPoint.OnCreate = OnCreate
DarknessSuppliesPoint.OnDestroy = OnDestroy
DarknessSuppliesPoint.OnEnable = OnEnable
DarknessSuppliesPoint.OnDisable = OnDisable
DarknessSuppliesPoint.ComponentDefine = ComponentDefine
DarknessSuppliesPoint.ComponentDestroy = ComponentDestroy
DarknessSuppliesPoint.DataDefine = DataDefine
DarknessSuppliesPoint.DataDestroy = DataDestroy
return DarknessSuppliesPoint
