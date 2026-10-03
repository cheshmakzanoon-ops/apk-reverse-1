local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIAccuRechargeMain = BaseClass("UIAccuRechargeMain", base)
local Localization = CS.GameEntry.Localization
local UIAccuRechargeTargetItem = require("UI.UIActivityCenterTable.Component.UIAccuRecharge.UIAccuRechargeTargetItem")
local LWUIActivityRewardChangePreviewEntranceComponent = require("UI/LWUIActivityRewardChangePreview/AccuRecharge/Component/LWUIActivityRewardChangePreviewEntranceComponent")
local titleTextPath = "RightView/Top/title"
local subTitleTextPath = "RightView/Top/subTitle"
local remainTimeTextPath = "RightView/Top/TimeBase/RemainTime"
local infoBtnPath = "RightView/Top/InfoBtn"
local pointNumTextPath = "RightView/Top/ResBar/root/resourceNum"
local targetListPath = "RightView/Rect_Bottom/ScrollView"
local targetListContentPath = "RightView/Rect_Bottom/ScrollView/Viewport/Content"
local progressSldierPath = "RightView/Rect_Bottom/ScrollView/Viewport/Content/Slider"
local bgPath = "Bg2"
local bg1Path = "Bg1"
local resetTimePath = "RightView/Top/ResetTime"
local resetTimeCountDownTextPath = "RightView/Top/ResetTime/ResetCountDownText"
local rechargePointIconPath = "RightView/Top/ResBar/root/resourceIcon"
local reward_change_entrance_path = "RightView/Top/RewardChangeBtn"

function UIAccuRechargeMain:OnCreate()
  base.OnCreate(self)
  self.itemIndex = 0
  self.initProgress = false
  self.remainLocalText = Localization:GetString(302173)
  
  function self.timer_action()
    self:RefreshTime()
  end
  
  self:ComponentDefine()
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rechargeStages then
    return nil
  end
  local packData = self.rechargeStages[index]
  local item = loopScroll:NewListViewItem("TargetItem")
  local script = self.targetListContent:GetComponent(item.gameObject.name, UIAccuRechargeTargetItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.targetListContent:AddComponent(UIAccuRechargeTargetItem, objectName)
  end
  script:SetActive(true)
  script:RefreshData(packData, self.actInfo.score, self.activityId, self.rechargePointIconPath, index, #self.rechargeStages)
  local stageUpdateData = self:GetUpdateShowDataByScoreAndRemove(packData.needScore)
  local stageNewData = self:GetNewShowDataByScoreAndRemove(packData.needScore)
  script:TriggerRewardChangeEffect(stageUpdateData, stageNewData)
  return item
end

function UIAccuRechargeMain:OnScrollMove()
end

function UIAccuRechargeMain:ComponentDefine()
  self.titleText = self:AddComponent(UIText, titleTextPath)
  self.subTitleText = self:AddComponent(UIText, subTitleTextPath)
  self.remainText = self:AddComponent(UIText, remainTimeTextPath)
  self.infoBtn = self:AddComponent(UIButton, infoBtnPath)
  self.infoBtn:SetOnClick(function()
    if not self.activityId then
      return
    end
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if activityData == nil then
      return
    end
    local param = {}
    param.activityRulesStr = Localization:GetString(activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
  end)
  self.pointNumText = self:AddComponent(UIText, pointNumTextPath)
  self.targetList = self:AddComponent(UILoopListView2, targetListPath)
  self.targetList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.targetListContent = self:AddComponent(UIBaseContainer, targetListContentPath)
  self.targetScrollRect = self:AddComponent(UIScrollRect, targetListPath)
  self.targetScrollRect:AddValueChangeListener(function()
    self:OnScrollMove()
  end)
  self.progressSldier = self:AddComponent(UISlider, progressSldierPath)
  self.bg = self:AddComponent(UIRawImage, bgPath)
  self.bg1 = self:AddComponent(UIRawImage, bg1Path)
  self.resetTime = self:AddComponent(UIBaseContainer, resetTimePath)
  self.resetTimeCountDownText = self:AddComponent(UIText, resetTimeCountDownTextPath)
  self.rechargePointIcon = self:AddComponent(UIImage, rechargePointIconPath)
  self.skinEffect = self:AddComponent(UIText, "RightView/Top/SkinEffect")
  self.effectUse = self:AddComponent(UIText, "RightView/Top/SkinEffect/UsingEffect/UseEffectText")
  self.effectUseTitle = self:AddComponent(UIText, "RightView/Top/SkinEffect/UsingEffect/Title/UseTitle")
  self.effectHave = self:AddComponent(UIText, "RightView/Top/SkinEffect/OwnEffect/OwnEffectText")
  self.effectHaveTitle = self:AddComponent(UIText, "RightView/Top/SkinEffect/OwnEffect/Title/OwnTitle")
  self.buildEffect = self:AddComponent(UIText, "RightView/Top/BuildEffect")
  self.buildName = self:AddComponent(UIText, "RightView/Top/BuildEffect/BuildName")
  self.buildEffectTxt = self:AddComponent(UIText, "RightView/Top/BuildEffect/TextScroll/ViewPort/BuildEffectTxt")
  self.comp_reward_change_entrance = self:AddComponent(LWUIActivityRewardChangePreviewEntranceComponent, reward_change_entrance_path)
end

function UIAccuRechargeMain:OnDestroy()
  self.remainLocalText = nil
  self.lastTimeRequestInfo = nil
  self:DeleteTimer()
  self:ClearScroll()
  self:ComponentDestroy()
  self.itemIndex = nil
  self.initProgress = nil
  self.timer_action = nil
  base.OnDestroy(self)
end

function UIAccuRechargeMain:ClearScroll()
  self.targetListContent:RemoveComponents(UIAccuRechargeTargetItem)
  self.targetList:ClearAllItems()
end

function UIAccuRechargeMain:ComponentDestroy()
  self.titleText = nil
  self.subTitleText = nil
  self.remainText = nil
  self.infoBtn = nil
  self.pointNumText = nil
  self.targetList = nil
  self.targetListContent = nil
  self.targetScrollRect = nil
  self.progressSldier = nil
  self.bg = nil
  self.resetTime = nil
  self.resetTimeCountDownText = nil
  self.rechargePointIcon = nil
  self.comp_reward_change_entrance = nil
end

local itemHeight = 120
local spacing = 10

function UIAccuRechargeMain:InitProgress(count)
  if self.progressSldier then
    local height = count * itemHeight + spacing * (count - 1) - 60
    height = height < 0 and 0 or height
    self.progressSldier.transform:Set_sizeDelta(36, height)
  end
end

function UIAccuRechargeMain:OnEnable()
  base.OnEnable(self)
end

function UIAccuRechargeMain:OnDisable()
  base.OnDisable(self)
end

function UIAccuRechargeMain:OnGetData(rechargeId)
  if not rechargeId then
    return
  end
  if self.activityId and self.activityId == tostring(rechargeId) then
    self.actInfo = DataCenter.CumulativeRechargeManager:GetRechargeStage(self.activityId)
    if not self.actInfo then
      return
    end
    self.hasReset = self.actInfo.nextResetTime > 0
    if self.hasReset then
      self.resetTime:SetActive(true)
      self.resetTimeCountDownText:SetText("")
    else
      self.resetTime:SetActive(false)
    end
    self:Refresh(false)
  end
end

function UIAccuRechargeMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CumulativeReward, self.OnReward)
  self:AddUIListener(EventId.RefreshAccuRechargePoint, self.RefreshScore)
  self:AddUIListener(EventId.UpdateAccuRechargeData, self.OnGetData)
end

function UIAccuRechargeMain:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CumulativeReward, self.OnReward)
  self:RemoveUIListener(EventId.RefreshAccuRechargePoint, self.RefreshScore)
  self:RemoveUIListener(EventId.UpdateAccuRechargeData, self.OnGetData)
end

function UIAccuRechargeMain:OnReward(stageId)
  self:RefreshRewardList(false)
end

function UIAccuRechargeMain:RefreshRewardList(jump)
  if not self.actInfo then
    return
  end
  self.rechargeStages = self.actInfo.stageInfo
  if table.IsNullOrEmpty(self.rechargeStages) then
    self.targetList:SetActive(false)
  else
    self.targetList:SetActive(true)
    self.targetList:SetListItemCount(#self.rechargeStages, false, false)
    self.targetList:RefreshAllShownItem()
    if not self.initProgress then
      self:InitProgress(#self.rechargeStages)
      self.initProgress = true
    end
    if jump then
      local jumpIndex = 1
      for i, v in ipairs(self.rechargeStages) do
        if v.state == 0 then
          jumpIndex = i
          break
        end
      end
      jumpIndex = math.max(0, jumpIndex - 1)
      self.targetList:MovePanelToItemIndex(jumpIndex)
    end
  end
end

function UIAccuRechargeMain:RefreshScore()
  if not self.actInfo then
    return
  end
  self.pointNumText:SetText(self.actInfo.score)
  local progress = 0
  if not table.IsNullOrEmpty(self.rechargeStages) and self.targetList then
    self.targetList:RefreshAllShownItem()
    local step = 1 / #self.rechargeStages
    local firstStep = step / 2
    local otherStep = (1 - firstStep) / (#self.rechargeStages - 1)
    local lastNeedScore = 0
    for i, v in pairs(self.rechargeStages) do
      local curStageStep = i == 1 and firstStep or otherStep
      if v.state == 1 or v.needScore <= self.actInfo.score then
        progress = progress + curStageStep
        lastNeedScore = v.needScore
      else
        progress = progress + curStageStep * (self.actInfo.score - lastNeedScore) / (v.needScore - lastNeedScore)
        break
      end
    end
    progress = 1 < progress and 1 or progress
  end
  self.progressSldier:SetValue(progress)
end

function UIAccuRechargeMain:Refresh(jump)
  self:RefreshRewardList(jump)
  self:RefreshScore()
end

function UIAccuRechargeMain:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIAccuRechargeMain:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, nil, false, false, false)
    self.timer:Start()
  end
end

function UIAccuRechargeMain:RefreshTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.actBaseData then
    if curTime > self.actBaseData.endTime then
      self:DeleteTimer()
      self.remainText:SetLocalText(2000409)
    else
      self.remainText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.actBaseData.endTime - curTime))
    end
  else
    self:DeleteTimer()
    self.remainText:SetText("")
  end
  local curSeconds = curTime / 1000
  if self.hasReset then
    if curSeconds > self.actInfo.nextResetTime then
      self.resetTime:SetActive(false)
      self.hasReset = false
    else
      self.resetTimeCountDownText:SetText(UITimeManager:GetInstance():SecondToFmtString(self.actInfo.nextResetTime - curSeconds))
    end
  end
end

function UIAccuRechargeMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.actBaseData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.rechargePointIconPath = DefaultRechargePointIconPath
  if self.actBaseData then
    self.titleText:SetLocalText(self.actBaseData.name)
    self.subTitleText:SetLocalText(self.actBaseData.desc_info)
    if not string.IsNullOrEmpty(self.actBaseData.para) then
      self.rechargePointIconPath = self.actBaseData.para
    end
  end
  self.rechargePointIcon:LoadSprite(string.format(LoadPath.ItemPath, self.rechargePointIconPath))
  self.rechargePointIcon:SetNativeSize()
  self.comp_reward_change_entrance:ReInit(self.actBaseData, function(updateShowData, newShowData)
    self:OnRewardChangeClose(updateShowData, newShowData)
  end, true)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.skinEffect:SetActive(false)
  self.buildEffect:SetActive(false)
  if self.actBaseData then
    if curTime > self.actBaseData.endTime then
      self.remainText:SetLocalText(2000409)
    else
      self:AddTimer()
    end
    self.bg:LoadSpriteAuto(string.format(LoadPath.UIAccuRechargeBanner, self.actBaseData.activity_pic))
    self.bg1:SetActive(not string.IsNullOrEmpty(self.actBaseData.para_1))
    if not string.IsNullOrEmpty(self.actBaseData.para_1) then
      self.bg1:LoadSpriteAuto(string.format(LoadPath.UIAccuRechargeBanner, self.actBaseData.para_1))
    end
    if not string.IsNullOrEmpty(self.actBaseData.para_5) then
      self.skinEffect:SetActive(true)
      local effects = DecorationUtil.GetEffectDesc(tonumber(self.actBaseData.para_5))
      local ownEffectStr = effects.ownEffect
      self.effectHave:SetText(string.IsNullOrEmpty(ownEffectStr) and "" or ownEffectStr)
      if string.IsNullOrEmpty(ownEffectStr) then
        self.effectHaveTitle:SetText("")
      else
        self.effectHaveTitle:SetLocalText("2000472")
      end
      local useEffectStr = effects.useEffect
      self.effectUse:SetText(string.IsNullOrEmpty(useEffectStr) and "" or useEffectStr)
      if string.IsNullOrEmpty(useEffectStr) then
        self.effectUseTitle:SetText("")
      else
        self.effectUseTitle:SetLocalText("2000471")
      end
    end
    if not string.IsNullOrEmpty(self.actBaseData.para_6) then
      self.buildEffect:SetActive(true)
      local effects = DecorationUtil.GetBuildingEffectDesc(tonumber(self.actBaseData.para_6))
      self.buildName:SetText(string.IsNullOrEmpty(effects.name) and "" or effects.name)
      self.buildEffectTxt:SetText(string.IsNullOrEmpty(effects.buffStr) and "" or effects.buffStr)
    end
  else
    self.remainText:SetText("")
  end
  self.resetTime:SetActive(false)
  self.actInfo = DataCenter.CumulativeRechargeManager:GetRechargeStage(self.activityId)
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(self.activityId)
  if not self.actInfo then
    return
  end
  self.hasReset = self.actInfo.nextResetTime > 0
  if self.hasReset then
    self.resetTime:SetActive(true)
    self.resetTimeCountDownText:SetText("")
  else
    self.resetTime:SetActive(false)
  end
  if self.actBaseData and self.actBaseData:IsValid() then
    local needRequest = false
    if not self.lastTimeRequestInfo then
      needRequest = true
    else
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      local isSameDay = UITimeManager:GetInstance():IsSameDayForServer(self.lastTimeRequestInfo, curTime)
      if not isSameDay then
        needRequest = true
      end
    end
    if needRequest then
      DataCenter.CumulativeRechargeManager:SendGetRechargeInfo(self.activityId)
      self.lastTimeRequestInfo = UITimeManager:GetInstance():GetServerSeconds()
    end
  end
  self:Refresh(true)
  self.updateShowData = nil
  self.newShowData = nil
end

function UIAccuRechargeMain:OnRewardChangeClose(updateShowData, newShowData)
  local needShow = false
  if not table.IsNullOrEmpty(updateShowData) then
    self.updateShowData = updateShowData
    needShow = true
  end
  if not table.IsNullOrEmpty(newShowData) then
    self.newShowData = newShowData
    needShow = true
  end
  if needShow then
    self.targetList:RefreshAllShownItem()
  end
end

function UIAccuRechargeMain:GetUpdateShowDataByScoreAndRemove(score)
  local res
  if not table.IsNullOrEmpty(self.updateShowData) then
    for i, v in ipairs(self.updateShowData) do
      if v.score == score then
        res = v
        table.remove(self.updateShowData, i)
        break
      end
    end
  end
  return res
end

function UIAccuRechargeMain:GetNewShowDataByScoreAndRemove(score)
  local res
  if not table.IsNullOrEmpty(self.newShowData) then
    for i, v in ipairs(self.newShowData) do
      if v.score == score then
        res = v
        table.remove(self.newShowData, i)
        break
      end
    end
  end
  return res
end

return UIAccuRechargeMain
