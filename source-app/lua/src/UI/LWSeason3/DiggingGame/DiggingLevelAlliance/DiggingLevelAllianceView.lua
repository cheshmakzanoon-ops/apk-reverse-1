local base = UIBaseView
local DiggingLevelAllianceView = BaseClass("DiggingLevelAllianceView", base)
local Localization = CS.GameEntry.Localization
local DiggingMap = require("UI.LWSeason3.DiggingGame.DiggingMap.DiggingMap")
local LevelReward = require("UI.LWSeason3.DiggingGame.DiggingLevelAlliance.Component.DiggingLevelReward")
local LevelRewardPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/DiggingGame/Component/DiggingLevelReward.prefab"
local TitleText_path = "Root/Title"
local TimeText_path = "Root/TimeInfoItem/timeBg2/TimeText"
local CloseBtn_path = "Root/CloseBtn"
local Content1_path = "Root/Content/Content1"
local Content2_path = "Root/Content/Content2"
local Toggle1_path = "Root/Toggle/Toggle1"
local Toggle2_path = "Root/Toggle/Toggle2"
local OwnerName_path = "Root/Content/Content1/OwnerName"
local IntroBtn_path = "Root/InfoBtn"
local ToggleHead_path = "Root/Content/Content1/ToggleHead"
local BotTips_path = "Root/Content/Content1/Tips"
local DiggingMap_path = "Root/Content/Content1/DiggingMap"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.mapData = self:GetUserData()
  self:OnRefresh()
end

local function OnDestroy(self)
  DataCenter.DiggingDataManager.curMapData = nil
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
  self.TitleText = self:AddComponent(UIText, TitleText_path)
  self.TimeText = self:AddComponent(UIText, TimeText_path)
  self.CloseBtn = self:AddComponent(UIButton, CloseBtn_path)
  self.Content1 = self:AddComponent(UIBaseContainer, Content1_path)
  self.Content2 = self:AddComponent(UIBaseContainer, Content2_path)
  self.Toggle1 = self:AddComponent(UIButton, Toggle1_path)
  self.Toggle2 = self:AddComponent(UIButton, Toggle2_path)
  self.OwnerName = self:AddComponent(UIText, OwnerName_path)
  self.IntroBtn = self:AddComponent(UIButton, IntroBtn_path)
  self.ToggleHead = self:AddComponent(UIToggle, ToggleHead_path)
  self.BotTips = self:AddComponent(UIText, BotTips_path)
  self.CloseBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.IntroBtn:SetOnClick(function()
    local activityData = DataCenter.DiggingDataManager:GetActivityData()
    if activityData then
      local param = {}
      param.activityId = activityData.id
      param.activityRulesStr = CS.GameEntry.Localization:GetString(activityData.story)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
    end
  end)
  self.ToggleHead:SetOnValueChanged(function(value)
    self:OnToggleHead(value)
  end)
  self.DiggingMap = self:AddComponent(DiggingMap, DiggingMap_path)
  self.togglesTbN = {}
  for i = 1, 2 do
    local toggle = self["Toggle" .. i]
    toggle:SetOnClick(function()
      self:ChangeShowType(i)
    end)
    local newTog = {}
    newTog.toggleN = toggle
    newTog.chooseN = toggle:AddComponent(UIBaseContainer, "select")
    newTog.redN = toggle:AddComponent(UIBaseContainer, "RedPoint")
    newTog.redNumN = toggle:AddComponent(UIText, "RedPoint/RedNum")
    newTog.nameN = toggle:AddComponent(UIText, "activityName")
    newTog.showNewN = toggle:AddComponent(UIBaseContainer, "NewDot")
    newTog.showNewN:SetActive(false)
    newTog.ShowNewTxtN = toggle:AddComponent(UIText, "NewDot/Bg/Text")
    self.togglesTbN[i] = newTog
  end
end

local function ComponentDestroy(self)
  self.TitleText = nil
  self.TimeText = nil
  self.CloseBtn = nil
  self.Content1 = nil
  self.Content2 = nil
  self.Toggle1 = nil
  self.Toggle2 = nil
  self.OwnerName = nil
  self.IntroBtn = nil
  self.ToggleHead = nil
  self.BotTips = nil
  self.togglesTbN = nil
  if self.reqContent then
    self.reqContent:Destroy()
    self.reqContent = nil
  end
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function DiggingLevelAllianceView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DiggingGameMapDataGetReward, self.RefreshReward)
  self:AddUIListener(EventId.DiggingGameRedUpdate, self.RefreshRedPoint)
  self:AddUIListener(EventId.DiggingShowOrHideCheck, self.ShowOrHideCheck)
  self:AddUIListener(EventId.DiggingGetBlockAnim, self.OnGetBlockAnim)
end

function DiggingLevelAllianceView:OnRemoveListener()
  self:RemoveUIListener(EventId.DiggingGameMapDataGetReward, self.RefreshReward)
  self:RemoveUIListener(EventId.DiggingGameRedUpdate, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.DiggingShowOrHideCheck, self.ShowOrHideCheck)
  self:RemoveUIListener(EventId.DiggingGetBlockAnim, self.OnGetBlockAnim)
  base.OnRemoveListener(self)
end

function DiggingLevelAllianceView:OnRefresh()
  if self.tabIndex == nil then
    self.tabIndex = 1
  end
  self:ChangeShowType(self.tabIndex)
  local mapInfo = DataCenter.DiggingDataManager:GetMapDataByUuid(self.mapData.uuid)
  if mapInfo then
    self.StartTime = mapInfo.startTime
    self.EndTime = mapInfo.endTime
  end
  self:RefreshView()
  self:Update1000MS()
end

function DiggingLevelAllianceView:RefreshView()
  local levelConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(self.mapData.mapConfigId)
  if not levelConfig then
    self.ctrl:CloseSelf()
    UIUtil.ShowTipsId("120632")
    return
  end
  self.DiggingMap:OnRefresh(self.mapData)
  self.ToggleHead:SetIsOn(false)
  self:RefreshRedPoint()
  self.TitleText:SetLocalText(levelConfig.name)
  local allianceMember = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(self.mapData.uid)
  if allianceMember then
    local text = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(allianceMember.uid, allianceMember.name)
    self.OwnerName:SetLocalText("season_activity_1000070_desc11", text)
  else
    self.OwnerName:SetLocalText("season_activity_1000070_name")
  end
end

function DiggingLevelAllianceView:Update1000MS()
  if self.EndTime ~= nil and self.TimeText and self.TimeText.SetText then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.StartTime then
      deltaTime = self.StartTime - curTime
    elseif curTime < self.EndTime then
      deltaTime = self.EndTime - curTime
    end
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.TimeText:SetText(showTime)
    else
      self.TimeText:SetText("00:00:00")
    end
  end
end

function DiggingLevelAllianceView:RefreshMap()
  if self.tabIndex ~= 1 then
    return
  end
  self.Content1:SetActive(true)
  self.Content2:SetActive(false)
end

function DiggingLevelAllianceView:RefreshReward(_, isInit)
  if self.tabIndex ~= 2 then
    return
  end
  self.Content1:SetActive(false)
  self.Content2:SetActive(true)
  self.DiggingMap:CancelDig()
  if self.rewardPanel then
    self.rewardPanel:ReInit(self.mapData, isInit)
  end
end

function DiggingLevelAllianceView:RefreshRedPoint()
  for i, v in ipairs(self.togglesTbN) do
    local redCount = self:GetRedCountByType(i)
    if redCount and 0 < redCount then
      v.redN:SetActive(true)
      v.redNumN:SetText(redCount)
    else
      v.redN:SetActive(false)
    end
  end
  local mapInfo = DataCenter.DiggingDataManager:GetMapDataByUuid(self.mapData.uuid)
  if mapInfo and mapInfo.redNum == 1 then
    self.BotTips:SetLocalText("season_activity_1000070_desc13")
  else
    self.BotTips:SetLocalText("season_activity_1000070_desc26")
  end
end

function DiggingLevelAllianceView:GetRedCountByType(index)
  if index == 1 then
    local mapInfo = DataCenter.DiggingDataManager:GetMapDataByUuid(self.mapData.uuid)
    if mapInfo then
      return mapInfo.redNum == 1 and 1 or 0
    end
  elseif index == 2 then
    local mapInfo = DataCenter.DiggingDataManager:GetMapDataByUuid(self.mapData.uuid)
    if mapInfo then
      return mapInfo.redNum == 2 and 1 or 0
    end
  end
  return 0
end

function DiggingLevelAllianceView:ChangeShowType(tabIndex)
  for i = 1, #self.togglesTbN do
    self.togglesTbN[i].chooseN:SetActive(i == tabIndex)
  end
  self.tabIndex = tabIndex
  if tabIndex == 1 then
    self:RefreshMap()
  elseif self.rewardPanel then
    self:RefreshReward(nil, true)
  else
    if self.reqContent then
      return
    end
    self.reqContent = self:GameObjectInstantiateAsync(LevelRewardPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.Content2.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      self.rewardPanel = self.Content2:AddComponent(LevelReward, go)
      self.rewardPanel:SetActive(true)
      self:RefreshReward(nil, true)
    end)
  end
end

function DiggingLevelAllianceView:OnToggleHead(value)
  self.DiggingMap:ShowOrHideHead(value)
end

function DiggingLevelAllianceView:ShowOrHideCheck(show)
  self.CloseBtn:SetActive(not show)
end

function DiggingLevelAllianceView:OnGetBlockAnim(param)
  if not param or not param.blockInfo then
    return
  end
  local target = self.togglesTbN[2] and self.togglesTbN[2].chooseN
  if target and param.fly and param.fly.transform then
    self.tweenSeq = DOTween.Sequence()
    self.tweenSeq:AppendInterval(1.5)
    param.fly:SetActive(false)
    self.tweenSeq:AppendCallback(function()
      param.fly:SetActive(true)
    end)
    self.tweenSeq:Append(param.fly.transform:DOMove(target.transform.position, 0.8)):SetEase(CS.DG.Tweening.Ease.InOutCubic)
    self.tweenSeq:AppendCallback(function()
      param.fly:SetActive(false)
    end)
  end
end

DiggingLevelAllianceView.OnCreate = OnCreate
DiggingLevelAllianceView.OnDestroy = OnDestroy
DiggingLevelAllianceView.OnEnable = OnEnable
DiggingLevelAllianceView.OnDisable = OnDisable
DiggingLevelAllianceView.ComponentDefine = ComponentDefine
DiggingLevelAllianceView.ComponentDestroy = ComponentDestroy
DiggingLevelAllianceView.DataDefine = DataDefine
DiggingLevelAllianceView.DataDestroy = DataDestroy
return DiggingLevelAllianceView
