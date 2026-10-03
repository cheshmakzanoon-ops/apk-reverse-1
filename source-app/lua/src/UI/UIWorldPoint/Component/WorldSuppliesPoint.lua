local base = UIBaseContainer
local WorldSuppliesPoint = BaseClass("WorldSuppliesPoint", base)
local WorldSuppliesRewardItem = require("UI.UIWorldPoint.Component.WorldSuppliesRewardItem")
local Localization = CS.GameEntry.Localization
local animator_path = ""
local rewardParent_path = "BuildInfo/content/rewardParent"
local rewardItem_path = "BuildInfo/content/WorldSuppliesRewardItem"
local lookRoot_path = "BuildInfo/content/lock"
local iceDurability_path = "BuildInfo/content/lock/info/iceDurability"
local endTime_path = "BuildInfo/content/lock/info/meltingEndTime"
local unfrozen_path = "BuildInfo/content/Unfrozen"
local progress_path = "BuildInfo/content/lock/info/Background/progress"
local front_path = "BuildInfo/content/lock/info/Background/Frontground"
local disappearanceRoot_path = "BuildInfo/disappearance"
local disappearanceWarn_path = "BuildInfo/disappearance/warnning/disapearnceWarn"
local des_path = "BuildDetails/ScrollView/Viewport/Content/desTxt"
local imagePath_path = "BuildInfo/content/ImagePath"
local content_path = "BuildInfo/content"
local remain_path = "BuildInfo/content/remain"
local triggerInfo_path = "BuildInfo/content/triggerInfo"
local triggerName_path = "BuildInfo/content/triggerInfo/triggerName"
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
  self.rewardItem = self:AddComponent(WorldSuppliesRewardItem, rewardItem_path)
  self.lookRoot = self:AddComponent(UIBaseContainer, lookRoot_path)
  self.iceDurability = self:AddComponent(UIText, iceDurability_path)
  self.endTime = self:AddComponent(UIText, endTime_path)
  self.unfrozen = self:AddComponent(UIText, unfrozen_path)
  self.progress = self:AddComponent(UIText, progress_path)
  self.front = self:AddComponent(UIBaseContainer, front_path)
  self.disappearanceRoot = self:AddComponent(UIBaseContainer, disappearanceRoot_path)
  self.disappearanceWarn = self:AddComponent(UIText, disappearanceWarn_path)
  self.des = self:AddComponent(UIText, des_path)
  self.imagePath = self:AddComponent(UIImage, imagePath_path)
  self.remain = self:AddComponent(UIText, remain_path)
  self.triggerInfo = self:AddComponent(UIBaseContainer, triggerInfo_path)
  self.triggerName = self:AddComponent(UIText, triggerName_path)
  self.contentElement = self:AddComponent(UILayoutElement, content_path)
  self.rewardItem:SetActive(false)
end

local function ComponentDestroy(self)
  self.animator = nil
  self.rewardParent = nil
  self.rewardItem = nil
  self.lookRoot = nil
  self.iceDurability = nil
  self.endTime = nil
  self.unfrozen = nil
  self.progress = nil
  self.front = nil
  self.disappearanceRoot = nil
  self.disappearanceWarn = nil
  self.des = nil
  self.imagePath = nil
  self.content = nil
  self.remain = nil
  self.triggerInfo = nil
  self.triggerName = nil
end

local function DataDefine(self)
  self.rewardItem.gameObject:GameObjectCreatePool()
  self.rewardCom = {}
  for i = 1, rewardCount do
    local goItem = self.rewardItem.gameObject:GameObjectSpawn(self.rewardParent.transform)
    goItem.name = "reward_" .. i
    local rewardItemCom = self.rewardParent:AddComponent(WorldSuppliesRewardItem, goItem.name)
    rewardItemCom:SetActive(false)
    self.rewardCom[i] = rewardItemCom
  end
  self.expireTime = nil
end

local function DataDestroy(self)
  self.rewardParent:RemoveComponents(WorldSuppliesRewardItem)
  self.rewardItem.gameObject:GameObjectRecycleAll()
  self.rewardCom = nil
end

function WorldSuppliesPoint:OnInfoClick()
  self.animator:Enable(true)
  self.animator:Play("switchEnter", 0, 0)
end

function WorldSuppliesPoint:OnReturnClick()
  self.animator:Enable(true)
  self.animator:Play("switchOut", 0, 0)
end

function WorldSuppliesPoint:RefreshData(param)
  self.data = param
  self.lock = false
  self.des:SetText(self.data.detailInfo)
end

function WorldSuppliesPoint:DataIndex2ComIndex(index)
  local t = toInt((index - 1) / 4)
  if t % 2 == 0 then
    return index
  else
    local v = (t + 1) * 4 - (index - 1) % 4
    return v
  end
end

function WorldSuppliesPoint:RefreshServerData(serverData)
  self.serverData = serverData
  self:RefreshSeason()
  for i = 1, rewardCount do
    local comIndex = self:DataIndex2ComIndex(i)
    local item = self.rewardCom[comIndex]
    if item then
      local luckIndex = self.serverData.detailData.luckyRewardIndex[i]
      local reward
      local player = self.serverData.detailData:GetPlayerByIndex(i)
      if luckIndex then
        reward = self.serverData.detailData.luckyReward
      else
        reward = self.serverData.detailData.commonReward
      end
      item:SetData(reward, luckIndex, player, comIndex)
      item:SetActive(true)
    end
  end
  self.expireTime = nil
  if self.serverData.detailData.expireTime > 0 then
    self.expireTime = self.serverData.detailData.expireTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.expireTime then
      local StrRemainTime = "<color=#F53C3D>" .. UITimeManager:GetInstance():MilliSecondToFmtString(self.expireTime - curTime) .. "</color>"
      self.unfrozen:SetLocalText("season_s2_ice_supplies_32", StrRemainTime)
      self.lookRoot:SetActive(false)
    else
      self.expireTime = nil
      self.unfrozen:SetLocalText("season_s2_ice_supplies_28")
    end
  else
    self.expireTime = nil
    self.meltingEndTime = nil
    self.unfrozen:SetLocalText("season_s2_ice_supplies_28")
  end
  if self.expireTime == nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local info = CS.SceneManager.World:GetPointInfo(self.data.pointId)
    Logger.Log("open suppuies .....:" .. tostring(self.data.pointId))
    cast(info, typeof(CS.ExplorePointInfo))
    if info then
      local conductor = info.thermalConductor
      if conductor ~= nil then
        local state = 0
        if conductor.phase == ThermalPhase.Normal then
          if conductor.nextPhase == ThermalPhase.Frozen then
            if curTime < conductor.nextPhaseEndTime then
              state = 3
            else
              state = 1
            end
          else
            state = 2
          end
        elseif conductor.phase == ThermalPhase.Frozen then
          if conductor.nextPhase == ThermalPhase.Normal then
            if curTime < conductor.nextPhaseEndTime then
              state = 4
            else
              state = 2
            end
          else
            state = 1
          end
        else
          state = 0
        end
        self.lock = false
        self.state = state
        if state == 1 or state == 4 then
          self.lock = true
          if 0 < conductor.nextPhaseEndTime then
            self.nextPhaseEndTime = nil
            if curTime < conductor.nextPhaseEndTime then
              local nextPhaseEndTime = conductor.nextPhaseEndTime
              local StrRemainTime = UITimeManager:GetInstance():MilliSecondToFmtString(nextPhaseEndTime - curTime)
              self.nextPhaseEndTime = nextPhaseEndTime
              self.endTime:SetText(Localization:GetString("season_s2_ice_supplies_30", StrRemainTime))
            else
              self.lock = false
            end
          else
            self.endTime:SetText("")
          end
          self.progress:SetText(conductor.hp .. "/" .. conductor.maxHp)
          local r = 1
          if 0 < conductor.maxHp then
            r = conductor.hp / conductor.maxHp
          end
          self.front.transform:Set_localScale(r, 1, 1)
        elseif state == 2 then
        elseif state == 3 then
          self.lock = false
          if 0 < conductor.nextPhaseEndTime then
            self.nextPhaseEndTime = nil
            if curTime < conductor.nextPhaseEndTime then
              local nextPhaseEndTime = conductor.nextPhaseEndTime
              self.nextPhaseEndTime = nextPhaseEndTime
              local StrRemainTime = "<color=#F53C3D>" .. UITimeManager:GetInstance():MilliSecondToFmtString(nextPhaseEndTime - curTime) .. "</color>"
              self.unfrozen:SetText(Localization:GetString("season_s2_ice_supplies_40", StrRemainTime))
            else
              self.lock = true
            end
          else
            self.endTime:SetText("")
          end
        end
        self.lookRoot:SetActive(self.lock)
      else
        self.lock = false
        self.state = 2
        self.lookRoot:SetActive(false)
      end
    else
      self.lookRoot:SetActive(true)
    end
  end
end

function WorldSuppliesPoint:Update1000MS()
  if self.nextPhaseEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.nextPhaseEndTime - curTime
    if 0 <= deltaTime then
      if self.state == 4 then
        self.endTime:SetText(Localization:GetString("season_s2_ice_supplies_30", UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)))
      elseif self.state == 3 then
        local StrRemainTime = "<color=#F53C3D>" .. UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime) .. "</color>"
        self.unfrozen:SetLocalText("season_s2_ice_supplies_40", StrRemainTime)
      end
    else
      self.nextPhaseEndTime = nil
      self:RefreshServerData(self.serverData)
    end
  end
  if self.expireTime and 0 < self.expireTime then
    self.expireTime = self.serverData.detailData.expireTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.expireTime then
      local StrRemainTime = "<color=#F53C3D>" .. UITimeManager:GetInstance():MilliSecondToFmtString(self.expireTime - curTime) .. "</color>"
      self.unfrozen:SetLocalText("season_s2_ice_supplies_32", StrRemainTime)
    else
      self.expireTime = nil
      self.unfrozen:SetLocalText("season_s2_ice_supplies_28")
    end
  else
    self.meltingEndTime = nil
    self.expireTime = nil
  end
end

function WorldSuppliesPoint:RefreshSeason()
  local detailData = self.serverData and self.serverData.detailData
  local type = detailData and detailData.type or WorldSuppliesType.IceSeasonType
  if type == WorldSuppliesType.DesertSeasonType then
    UIUtil.CheckEventTrigger(OpMode.ClickBtnDesertSupplies)
    self.contentElement:SetPreferredHeight(470)
    self.imagePath:LoadSprite(string.format(LoadPath.UISeason3Path, "SeasonPoint/mcj_S3_gjlz_pop_xian"))
    local discovererInfo = self.serverData.detailData.discovererInfo
    if discovererInfo and not string.IsNullOrEmpty(discovererInfo.name) then
      if string.IsNullOrEmpty(discovererInfo.alAbbr) then
        self.triggerName:SetText(discovererInfo.name)
      else
        self.triggerName:SetText(string.format("[%s]%s", discovererInfo.alAbbr, discovererInfo.name))
      end
      self.triggerInfo:SetActive(true)
    else
      self.triggerInfo:SetActive(false)
    end
    local showTime = false
    if self.serverData.detailData.expireTime > 0 then
      self.expireTime = self.serverData.detailData.expireTime
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < self.expireTime then
        showTime = true
      end
    end
    if not showTime then
      local use = self.serverData.detailData.rewardCount or 0
      local max = self.serverData.detailData.rewardMax or 0
      if self.serverData.detailData.rewardLeftCount then
        self.remain:SetLocalText("season4_supplies_UI_28", self.serverData.detailData.rewardLeftCount, max)
      else
        self.remain:SetLocalText("season_oasis_UI_15", max - use, max)
      end
    end
    self.remain:SetActive(not showTime)
    self.unfrozen:SetActive(showTime)
    return
  end
  self.contentElement:SetPreferredHeight(420)
  self.remain:SetActive(false)
  self.triggerInfo:SetActive(false)
  if type == WorldSuppliesType.IceSeasonType then
    self.imagePath:LoadSprite(string.format(LoadPath.UISeason2Path, "FX_S2saiji_caijiziyuan01"))
    self.unfrozen:SetActive(true)
  else
    self.unfrozen:SetActive(false)
  end
end

WorldSuppliesPoint.OnCreate = OnCreate
WorldSuppliesPoint.OnDestroy = OnDestroy
WorldSuppliesPoint.OnEnable = OnEnable
WorldSuppliesPoint.OnDisable = OnDisable
WorldSuppliesPoint.ComponentDefine = ComponentDefine
WorldSuppliesPoint.ComponentDestroy = ComponentDestroy
WorldSuppliesPoint.DataDefine = DataDefine
WorldSuppliesPoint.DataDestroy = DataDestroy
return WorldSuppliesPoint
