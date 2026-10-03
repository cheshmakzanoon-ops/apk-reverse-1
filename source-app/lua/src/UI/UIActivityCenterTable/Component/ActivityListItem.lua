local ActivityListItem = BaseClass("ActivityListItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local name_path = "activityName"
local red_point_path = "RedPoint"
local red_num_path = "RedPoint/RedNum"
local new_dot_path = "NewDot"
local select_img_path = "select"
local btn_path = "TypeButton"
local icon_path = "Mask/Icon"
local get_all_common_red_point_path = "CommonRedPoint"
local unselectColor = Color.New(1, 0.8901961, 0.7921569, 1)
local unselectAlpha = 0.7

local function OnCreate(self, id)
  base.OnCreate(self)
  self.id = id
  self.canvasGroup = self:AddComponent(UICanvasGroup, this_path)
  self.name = self:AddComponent(UIText, name_path)
  self.redPoint = self:AddComponent(UIImage, red_point_path)
  self.redNum = self:AddComponent(UIText, red_num_path)
  self.newDot = self:AddComponent(UIBaseContainer, new_dot_path)
  self.select = self:AddComponent(UIImage, select_img_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.select:SetActive(false)
  self.getAllCommonRedPoint = self:AddComponent(UICommonRedPoint, get_all_common_red_point_path)
  self.getAllCommonRedPoint:SetType(CommonRedPointPriority.Level1)
end

local function OnDestroy(self)
  self.id = nil
  self.canvasGroup = nil
  self.name = nil
  self.redPoint = nil
  self.redNum = nil
  self.newDot = nil
  self.select = nil
  self.btn = nil
  self.getAllCommonRedPoint = nil
  self.icon = nil
  base.OnDestroy(self)
end

local function SetData(self)
  if string.endswith(tostring(self.id), "fake") then
    self.data = self.view.ctrl:GetFakeActivityDataById(self.id)
    self.name:SetLocalText(self.data.name)
  else
    self.data = self.view.ctrl:GetActivityDataById(self.id)
    if self.data then
      local raceTemplate = RaceEntranceUtil.GetOneTemplate(self.data.type)
      if raceTemplate then
        self.name:SetText(self.data.bannerTittle)
      else
        self.name:SetText(self.data.name)
      end
    end
  end
  local isNew = DataCenter.ActivityListDataManager:IsActivityNew(self.id)
  if isNew then
    self.newDot:SetActive(true)
    self.redPoint:SetActive(false)
    self.getAllCommonRedPoint.gameObject:SetActive(false)
  else
    self.newDot:SetActive(false)
    if self.data and self.data.type == EnumActivity.PersonalArmsNew.Type or self.data and self.data.type == EnumActivity.LeadingQuestV2.Type then
      if self.data.canGet then
        self.getAllCommonRedPoint:SetNum(self.data.canGet)
      else
        self.getAllCommonRedPoint.gameObject:SetActive(false)
      end
    elseif self.data and self.data.type == EnumActivity.ActEpidemic.Type then
      self.getAllCommonRedPoint:SetNum(0, LittleRedUtils.GetCount(LittleRedConst.NameActEpidemicMain))
      LittleRedUtils.AddListener(LittleRedConst.NameActEpidemicMain, nil, self, self.RefreshRedCount)
      self.redToken = self.RefreshRedCount
    elseif self.data and self.data.canGet then
      if self.data.type == EnumActivity.WorldBoss.Type then
        local allNum, rewardNum, tipNum = DataCenter.ActBossDataManager:GetActRedNum()
        if 0 < rewardNum then
          self.getAllCommonRedPoint:SetNum(rewardNum)
        else
          self.getAllCommonRedPoint:SetDefaultVisible(0 < tipNum)
        end
      else
        self.getAllCommonRedPoint:SetNum(nil, self.data.canGet)
      end
    else
      self.getAllCommonRedPoint.gameObject:SetActive(false)
    end
  end
  local currentId = self.view.ctrl:GetCurrentActivityId()
  if self.data and currentId == self.data.id then
    self:SetSelect()
  else
    self:SetUnSelect()
  end
  if self.data and not string.IsNullOrEmpty(self.data.list_icon) then
    self.icon:LoadSprite(string.format(LoadPath.ActivityIconPath, self.data.list_icon))
  end
end

function ActivityListItem:RefreshRedCount()
  if not self.data or not self.getAllCommonRedPoint then
    return
  end
  if self.data.type == EnumActivity.ActEpidemic.Type then
    self.getAllCommonRedPoint:SetNum(0, LittleRedUtils.GetCount(LittleRedConst.NameActEpidemicMain))
  end
end

local function SetUnSelect(self)
  self.select:SetActive(false)
  self.icon:SetActive(false)
  self.name:SetActive(true)
end

local function SetSelect(self)
  self.select:SetActive(true)
  self.icon:SetActive(true)
  self.name:SetActive(false)
end

local function OnClick(self)
  DataCenter.ArrowManager:RemoveArrow()
  self.view:OnActivityItemClick(self.id)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.MSG_FRESH_SURVIVAL_VIEW_GET, self.RefreshSurvivalItemState)
  self:AddUIListener(EventId.ZONE_CONTRIBUTE_RANK_UPDATE, self.RefreshStrongestCommandItemState)
  self:AddUIListener(EventId.MainTaskSuccess, self.UpdateTaskState)
  self:AddUIListener(EventId.SevenDayGetReward, self.UpdateTaskState)
  self:AddUIListener(EventId.ActRewardState, self.UpdateActSevenDay)
  self:AddUIListener(EventId.RefreshDataPersonalArms, self.RefreshPersonalArms)
  self:AddUIListener(EventId.RefreshDataAllianceArms, self.RefreshAllianceArms)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.SetData)
  self:AddUIListener(EventId.ResourceUpdated, self.SetData)
  self:AddUIListener(EventId.RefreshResourceItem, self.SetData)
  self:AddUIListener(EventId.OnPayActivityTaskUpdated, self.SetData)
  self:AddUIListener(EventId.ActBattlePassRed, self.RefreshBattlePass)
  self:AddUIListener(EventId.UpdateGold, self.SetData)
  self:AddUIListener(EventId.OnActBossAttackTimesRefresh, self.OnActBossAttackTimesRefresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MSG_FRESH_SURVIVAL_VIEW_GET, self.RefreshSurvivalItemState)
  self:RemoveUIListener(EventId.ZONE_CONTRIBUTE_RANK_UPDATE, self.RefreshStrongestCommandItemState)
  self:RemoveUIListener(EventId.MainTaskSuccess, self.UpdateTaskState)
  self:RemoveUIListener(EventId.SevenDayGetReward, self.UpdateTaskState)
  self:RemoveUIListener(EventId.ActRewardState, self.UpdateActSevenDay)
  self:RemoveUIListener(EventId.RefreshDataPersonalArms, self.RefreshPersonalArms)
  self:RemoveUIListener(EventId.RefreshDataAllianceArms, self.RefreshAllianceArms)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.SetData)
  self:RemoveUIListener(EventId.ResourceUpdated, self.SetData)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.SetData)
  self:RemoveUIListener(EventId.OnPayActivityTaskUpdated, self.SetData)
  self:RemoveUIListener(EventId.ActBattlePassRed, self.RefreshBattlePass)
  self:RemoveUIListener(EventId.UpdateGold, self.SetData)
  self:RemoveUIListener(EventId.OnActBossAttackTimesRefresh, self.OnActBossAttackTimesRefresh)
  if self.redToken then
    LittleRedUtils.ClearListener(LittleRedConst.NameActEpidemicMain, self.redToken)
    self.redToken = nil
  end
end

local function RefreshSurvivalItemState(self)
  if self.data.type == 29 then
    self:SetData()
  end
end

local function RefreshStrongestCommandItemState(self)
  if self.data.type == 14 then
    self:SetData()
  end
end

local function UpdateTaskState(self)
  if self.data.activityId == EnumActivity.SevenDay.Type then
    local seventDayinfo = DataCenter.ActivityListDataManager:GetSevenDayList()
    if next(seventDayinfo) then
      seventDayinfo:CheckRedDot()
      self:SetData()
    end
  end
end

local function UpdateActSevenDay(self)
  if self.data.type == EnumActivity.ActSevenDay.Type then
    local sevenDay = DataCenter.ActSevenDayData:GetInfoByActId(tonumber(self.data.activityId))
    if sevenDay and next(sevenDay) then
      sevenDay:CheckRedDot()
      self:SetData()
    end
  end
end

local function RefreshPersonalArms(self)
  if self.data.type == EnumActivity.Arms.Type then
    self:SetData()
  end
end

local function RefreshAllianceArms(self)
  if self.data.type == EnumActivity.AllianceCompete.Type then
    self:SetData()
  end
end

local function RefreshBattlePass(self)
  if self.data.type == EnumActivity.BattlePass.Type then
    self:SetData()
  end
end

function ActivityListItem:OnActBossAttackTimesRefresh()
  if self.data.type == EnumActivity.WorldBoss.Type then
    self:SetData()
  end
end

ActivityListItem.OnCreate = OnCreate
ActivityListItem.OnDestroy = OnDestroy
ActivityListItem.SetData = SetData
ActivityListItem.SetRedPot = SetRedPot
ActivityListItem.SetUnSelect = SetUnSelect
ActivityListItem.SetSelect = SetSelect
ActivityListItem.OnClick = OnClick
ActivityListItem.OnAddListener = OnAddListener
ActivityListItem.OnRemoveListener = OnRemoveListener
ActivityListItem.RefreshSurvivalItemState = RefreshSurvivalItemState
ActivityListItem.RefreshStrongestCommandItemState = RefreshStrongestCommandItemState
ActivityListItem.UpdateTaskState = UpdateTaskState
ActivityListItem.UpdateActSevenDay = UpdateActSevenDay
ActivityListItem.RefreshPersonalArms = RefreshPersonalArms
ActivityListItem.RefreshAllianceArms = RefreshAllianceArms
ActivityListItem.RefreshBattlePass = RefreshBattlePass
return ActivityListItem
