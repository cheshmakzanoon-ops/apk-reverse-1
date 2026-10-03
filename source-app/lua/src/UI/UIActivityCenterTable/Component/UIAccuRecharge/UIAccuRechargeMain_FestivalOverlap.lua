local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIAccuRechargeMain_FestivalOverlap = BaseClass("UIAccuRechargeMain_FestivalOverlap", base)
local Localization = CS.GameEntry.Localization
local UIAccuRechargeTargetItem = require("UI.UIActivityCenterTable.Component.UIAccuRecharge.UIAccuRechargeTargetItem_Common")
local ActBannerEffectContent = require("UI.UIActivityCenterTable.Component.LimitedTimeFeast.ActBannerEffectContent")
local AccuRechargeTargetTitleLineItem = require("UI.UIActivityCenterTable.Component.UIAccuRecharge.AccuRechargeTargetTitleLineItem")
local LWUIActivityRewardChangePreviewEntranceComponent = require("UI/LWUIActivityRewardChangePreview/AccuRecharge/Component/LWUIActivityRewardChangePreviewEntranceComponent")
local titleTextPath = "RightView/Top/title"
local subTitleTextPath = "RightView/Top/subTitle"
local remainTimeTextPath = "RightView/Top/TimeContent/openTime"
local infoBtnPath = "RightView/Top/InfoBtn"
local pointNumTextPath = "RightView/Top/ResBar/root/resourceNum"
local targetListPath = "RightView/Rect_Bottom/ScrollView"
local targetListContentPath = "RightView/Rect_Bottom/ScrollView/Viewport/Content"
local progressSldierPath = "RightView/Rect_Bottom/ScrollView/Viewport/Content/Slider"
local resetTimePath = "RightView/Top/ResetTime"
local resetTimeCountDownTextPath = "RightView/Top/ResetTime/ResetCountDownText"
local rechargePointIconPath = "RightView/Top/ResBar/root/resourceIcon"
local act_banner_effect_content_path = "ActBannerEffectContent"
local time_content_path = "RightView/Top/timeContent"
local SCROLL_LIST_ITEM_TYPE = {Normal = 0, Title = 1}

function UIAccuRechargeMain_FestivalOverlap:OnCreate()
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
  return item
end

function UIAccuRechargeMain_FestivalOverlap:OnScrollMove()
end

function UIAccuRechargeMain_FestivalOverlap:ComponentDefine()
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
    param.activityId = self.activityId
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailCommon, {anim = true}, param)
  end)
  self.pointNumText = self:AddComponent(UIText, pointNumTextPath)
  self.targetList = self:AddComponent(UIBaseContainer, targetListPath)
  self.stageListContent = self:AddComponent(UIBaseContainer, targetListContentPath)
  self.progressSldier = self:AddComponent(UISlider, progressSldierPath)
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
  self.newBg5 = self:AddComponent(UIImage, "bg5")
  self.newBg6 = self:AddComponent(UIRawImage, "bg6")
  self.act_banner_effect_content = self:AddComponent(ActBannerEffectContent, act_banner_effect_content_path)
  self.time_content = self:AddComponent(UIBaseContainer, time_content_path)
  local hLayout = typeof(CS.BidirectionalHorizontalLayoutGroup)
  self.time_content_h_layout = self.time_content.gameObject:GetComponent(hLayout)
  if CommonUtil.IsArabic() and not CommonUtil.GetAutoArabicMirrorSwitch() then
    self.time_content_h_layout.childAlignment = CS.UnityEngine.TextAnchor.UpperRight
  else
    self.time_content_h_layout.childAlignment = CS.UnityEngine.TextAnchor.UpperLeft
  end
  self.rewardChangeBtn = self:AddComponent(LWUIActivityRewardChangePreviewEntranceComponent, "RightView/Top/BtnLayout/rewardChangeBtn")
  self.overlapTipsBtn = self:AddComponent(UIButton, "RightView/Top/BtnLayout/overlapTipsBtn")
  self.overlapTipsBtn:SetOnClick(function()
    self:OnOverlapTipsBtnClick()
  end)
  self.overlapTipsBtn:SetActive(false)
  self.stageCells = {}
  self.stageCellReqs = {}
  self.secondTitle = self:AddComponent(AccuRechargeTargetTitleLineItem, "RightView/Rect_Bottom/ScrollView/secondTitle")
  self.secondTitleAni = self:AddComponent(UISimpleAnimation, "RightView/Rect_Bottom/ScrollView/secondTitle")
  self.scrollViewHeight = self.targetList.rectTransform.rect.height
end

function UIAccuRechargeMain_FestivalOverlap:OnDestroy()
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

function UIAccuRechargeMain_FestivalOverlap:ClearScroll()
  if self.stageCellReqs then
    for i, v in ipairs(self.stageCellReqs) do
      if v then
        v:Destroy()
      end
    end
    self.stageCellReqs = nil
  end
  self.stageCells = nil
  self.stageListContent:RemoveComponents(AccuRechargeTargetTitleLineItem)
end

function UIAccuRechargeMain_FestivalOverlap:ComponentDestroy()
  self.titleText = nil
  self.subTitleText = nil
  self.remainText = nil
  self.infoBtn = nil
  self.pointNumText = nil
  self.targetList = nil
  self.targetListContent = nil
  self.targetScrollRect = nil
  self.progressSldier = nil
  self.resetTime = nil
  self.resetTimeCountDownText = nil
  self.rechargePointIcon = nil
  self.newBg5 = nil
  self.newBg6 = nil
  self.act_banner_effect_content = nil
  self.time_content = nil
end

local ITEM_HEIGHT = 122
local ITEM_SPACING = 10
local TITLE_HEIGHT = 66

function UIAccuRechargeMain_FestivalOverlap:InitProgress(count)
  if self.progressSldier then
    local height = count * ITEM_HEIGHT + ITEM_SPACING * (count - 1) - 60
    height = height < 0 and 0 or height
    self.progressSldier.transform:Set_sizeDelta(36, height)
  end
end

function UIAccuRechargeMain_FestivalOverlap:OnEnable()
  base.OnEnable(self)
end

function UIAccuRechargeMain_FestivalOverlap:OnDisable()
  base.OnDisable(self)
end

function UIAccuRechargeMain_FestivalOverlap:OnGetData(rechargeId)
  if not rechargeId then
    return
  end
  if self.activityId and tonumber(self.activityId) == tonumber(rechargeId) then
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

function UIAccuRechargeMain_FestivalOverlap:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CumulativeReward, self.OnReward)
  self:AddUIListener(EventId.RefreshAccuRechargePoint, self.RefreshScore)
  self:AddUIListener(EventId.UpdateAccuRechargeData, self.OnGetData)
end

function UIAccuRechargeMain_FestivalOverlap:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CumulativeReward, self.OnReward)
  self:RemoveUIListener(EventId.RefreshAccuRechargePoint, self.RefreshScore)
  self:RemoveUIListener(EventId.UpdateAccuRechargeData, self.OnGetData)
end

function UIAccuRechargeMain_FestivalOverlap:OnReward(stageId)
  self:RefreshStageList(false)
end

function UIAccuRechargeMain_FestivalOverlap:RefreshStageList(jump)
  if not self.actInfo then
    return
  end
  if not self.totalStageList then
    self:InitTotalStageList()
    self:InitAniTitle()
    self:InitProgressSlider()
    self:InitSecondTitlePos()
    self:InitContentSize()
  else
    self:InitTotalStageList()
  end
  if table.IsNullOrEmpty(self.totalStageList) then
    self.targetList:SetActive(false)
    return
  end
  if table.IsNullOrEmpty(self.stageCellReqs) then
    self:CreateStageItem(self.totalStageList, 1)
  else
    self:RefreshItemData()
  end
  if jump then
    self:JumpToUnRewardFirst()
  end
end

function UIAccuRechargeMain_FestivalOverlap:JumpToUnRewardFirst()
  if not self.totalStageList then
    return
  end
  
  local function condition(data)
    if data and data.state == 0 then
      return false
    end
    return true
  end
  
  if self.actInfo.score == 0 then
    self.stageListContent:SetAnchoredPositionXY(0, 0)
  else
    local height = self:GetHeight(self.totalStageList, condition)
    self.stageListContent:SetAnchoredPositionXY(0, height)
  end
end

function UIAccuRechargeMain_FestivalOverlap:JumToSecondListStart()
  if not self.actInfo.stageInfoExtend or not self.normalLineData then
    return
  end
  if not self.secondTitlePosY then
    local festivalDataList = {}
    table.insert(festivalDataList, self.festivalLineData)
    for i, v in ipairs(self.actInfo.stageInfo) do
      table.insert(festivalDataList, v)
    end
    self.secondTitlePosY = self:GetHeight(festivalDataList)
  end
  self.stageListContent:SetAnchoredPositionXY(0, self.secondTitlePosY)
end

function UIAccuRechargeMain_FestivalOverlap:InitAniTitle()
  if self.normalLineData then
    self.secondTitle:RefreshData(self.normalLineData)
  end
  self.secondTitle:SetActive(false)
end

function UIAccuRechargeMain_FestivalOverlap:InitProgressSlider()
  if not self.totalStageList or not self.progressSldier then
    return
  end
  local height = self:GetHeight(self.totalStageList)
  height = height - ITEM_HEIGHT * 0.5
  self.progressSldier.transform:Set_sizeDelta(36, height)
end

function UIAccuRechargeMain_FestivalOverlap:InitContentSize()
  if not self.totalStageList then
    return
  end
  local height = self:GetHeight(self.totalStageList)
  self.stageListContent.transform:Set_sizeDelta(766, height)
end

function UIAccuRechargeMain_FestivalOverlap:InitSecondTitlePos()
  if not self.normalLineData then
    return
  end
  local festivalDataList = {}
  table.insert(festivalDataList, self.festivalLineData)
  for i, v in ipairs(self.actInfo.stageInfo) do
    table.insert(festivalDataList, v)
  end
  self.secondTitlePosY = self:GetHeight(festivalDataList)
end

function UIAccuRechargeMain_FestivalOverlap:GetHeight(dataList, condition)
  if not dataList then
    return 0
  end
  local height = 0
  local index = 0
  for i, v in ipairs(dataList) do
    if condition and condition(v) == false then
      break
    end
    if v and v.type == SCROLL_LIST_ITEM_TYPE.Title then
      height = height + TITLE_HEIGHT
    else
      height = height + ITEM_HEIGHT
    end
    index = i
  end
  height = height + (index - 1) * ITEM_SPACING
  height = math.max(0, height)
  return height
end

function UIAccuRechargeMain_FestivalOverlap:CreateStageItem(dataList, index)
  if not (index and dataList) or index > #dataList then
    return
  end
  local data = dataList[index]
  local assetPath, Cpt = self:GetAssetAndCpt(data)
  self.stageCellReqs[index] = self:GameObjectInstantiateAsync(assetPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.stageListContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local nameStr = tostring(index)
    go.name = nameStr
    local script = self.stageListContent:AddComponent(Cpt, nameStr)
    script:RefreshData(data, self.actInfo.score, self.activityId, self.rechargePointIconPath, index, #dataList)
    if script.SetCustomBg and data.type ~= SCROLL_LIST_ITEM_TYPE.Title then
      local normalBg, specialBg = self:GetItemBgPath(index)
      script:SetCustomBg(normalBg, specialBg)
    end
    self.stageCells[index] = script
    self:CreateStageItem(dataList, index + 1)
  end)
end

function UIAccuRechargeMain_FestivalOverlap:RefreshItemData()
  if not self.stageCells or not self.totalStageList then
    return
  end
  for i, v in ipairs(self.stageCells) do
    local data = self.totalStageList[i]
    v:RefreshData(data, self.actInfo.score, self.activityId, self.rechargePointIconPath, i, #self.totalStageList)
    if v.SetCustomBg and data.type ~= SCROLL_LIST_ITEM_TYPE.Title then
      local normalBg, specialBg = self:GetItemBgPath(i)
      v:SetCustomBg(normalBg, specialBg)
    end
  end
end

function UIAccuRechargeMain_FestivalOverlap:GetItemBgPath(dataIndex)
  local festivalStageList = self.actInfo.stageInfo
  if not festivalStageList then
    return
  end
  local mergeTemplate = LocalController:instance():getLine(TableName.RECHARGE_MERGE, self.activityId)
  if not mergeTemplate then
    Logger.LogError("mergeTemplate not find,  id:" .. tostring(self.activityId))
    return
  end
  local dataNum = #festivalStageList + 1
  if dataIndex <= dataNum then
    return mergeTemplate.front_di, mergeTemplate.front_special_di
  else
    return mergeTemplate.next_di, mergeTemplate.next_special_di
  end
end

function UIAccuRechargeMain_FestivalOverlap:GetAssetAndCpt(data)
  if data.type == SCROLL_LIST_ITEM_TYPE.Title then
    return UIAssets.AccuRechargeTargetTitleLineItem, AccuRechargeTargetTitleLineItem
  end
  return UIAssets.AccuRechargeFestivalOverlapRewardLine, UIAccuRechargeTargetItem
end

function UIAccuRechargeMain_FestivalOverlap:GetFestivalStageFinalNeedScore()
  local festivalStageList = self.actInfo.stageInfo
  if table.IsNullOrEmpty(festivalStageList) then
    Logger.LogError("\229\159\186\231\161\128\230\149\176\230\141\174\230\178\161\230\156\137\229\176\177\229\164\170\231\166\187\232\176\177\228\186\134")
    return 0
  end
  return festivalStageList[#festivalStageList].needScore
end

function UIAccuRechargeMain_FestivalOverlap:InitTotalStageList()
  local festivalStageList = self.actInfo.stageInfo
  if table.IsNullOrEmpty(festivalStageList) then
    Logger.LogError("\229\159\186\231\161\128\230\149\176\230\141\174\230\178\161\230\156\137\229\176\177\229\164\170\231\166\187\232\176\177\228\186\134")
    return
  end
  self.totalStageList = {}
  local festivalStageFinalNeedScore = festivalStageList[#festivalStageList].needScore
  local festivalLineData = {
    icon = "Assets/Main/TextureEx/ActChristmas2025/zxl_sd25_fenlan_jieri.png",
    title = "2025christmas_front_tab_text1",
    rangeMin = 0,
    rangeMax = festivalStageFinalNeedScore,
    type = SCROLL_LIST_ITEM_TYPE.Title
  }
  self.festivalLineData = festivalLineData
  table.insert(self.totalStageList, festivalLineData)
  for i, v in ipairs(festivalStageList) do
    table.insert(self.totalStageList, v)
  end
  local normalStageList = self.actInfo.stageInfoExtend
  if not table.IsNullOrEmpty(normalStageList) then
    local normalStageFinalNeedScore = normalStageList[#normalStageList].needScore
    local normalLineData = {
      icon = "Assets/Main/TextureEx/ActChristmas2025/zxl_sd25_fenlan_jieri.png",
      title = "2025christmas_next_tab_text1",
      rangeMin = festivalStageFinalNeedScore + 1,
      rangeMax = normalStageFinalNeedScore,
      type = SCROLL_LIST_ITEM_TYPE.Title
    }
    self.normalLineData = normalLineData
    table.insert(self.totalStageList, normalLineData)
    for i, v in ipairs(normalStageList) do
      table.insert(self.totalStageList, v)
    end
  end
  local mergeTemplate = LocalController:instance():getLine(TableName.RECHARGE_MERGE, self.activityId)
  if not mergeTemplate then
    Logger.LogError("mergeTemplate not find,  id:" .. tostring(self.activityId))
  else
    self.festivalLineData.icon = mergeTemplate.front_pic
    self.festivalLineData.title = mergeTemplate.front_tab_text
    if self.normalLineData then
      self.normalLineData.icon = mergeTemplate.next_pic
      self.normalLineData.title = mergeTemplate.next_tab_text
    end
  end
end

function UIAccuRechargeMain_FestivalOverlap:RefreshScore()
  if not self.actInfo or not self.totalStageList then
    return
  end
  self.pointNumText:SetText(self.actInfo.score)
  local festivalStageList = self.actInfo.stageInfo
  if not festivalStageList then
    return
  end
  local progress = 0
  local total = self:GetHeight(self.totalStageList) - ITEM_HEIGHT * 0.5
  local itemPercent = ITEM_HEIGHT / total
  local spacingPercent = ITEM_SPACING / total
  local titlePercent = TITLE_HEIGHT / total
  local title1Delta = titlePercent + itemPercent * 0.5 + spacingPercent
  local title2Delta = titlePercent + itemPercent + spacingPercent * 2
  local normalDelta = itemPercent + spacingPercent
  local lastNeedScore = 0
  local dataIndex = 0
  for i, v in ipairs(self.totalStageList) do
    if v.type ~= SCROLL_LIST_ITEM_TYPE.Title then
      dataIndex = dataIndex + 1
      local curStageStep = normalDelta
      if dataIndex == 1 then
        curStageStep = title1Delta
      elseif dataIndex == #festivalStageList + 1 then
        curStageStep = title2Delta
      end
      if v.state == 1 or v.needScore <= self.actInfo.score then
        progress = progress + curStageStep
        lastNeedScore = v.needScore
      else
        progress = progress + curStageStep * (self.actInfo.score - lastNeedScore) / (v.needScore - lastNeedScore)
        break
      end
    end
  end
  progress = 1 < progress and 1 or progress
  self.progressSldier:SetValue(progress)
end

function UIAccuRechargeMain_FestivalOverlap:Refresh(jump)
  self:RefreshStageList(jump)
  self:RefreshScore()
end

function UIAccuRechargeMain_FestivalOverlap:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIAccuRechargeMain_FestivalOverlap:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, nil, false, false, false)
    self.timer:Start()
  end
end

function UIAccuRechargeMain_FestivalOverlap:RefreshTime()
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

function UIAccuRechargeMain_FestivalOverlap:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.actBaseData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.actBaseData == nil then
    return
  end
  self.rechargePointIconPath = DefaultRechargePointIconPath
  if self.actBaseData then
    self.titleText:SetLocalText(self.actBaseData.name)
    self.subTitleText:SetLocalText(self.actBaseData.desc_info)
    if not string.IsNullOrEmpty(self.actBaseData.para) then
      self.rechargePointIconPath = self.actBaseData.para
    end
  end
  self.rechargePointIcon:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.ItemPath, self.rechargePointIconPath))
  self.rechargePointIcon:SetNativeSize()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.skinEffect:SetActive(false)
  self.buildEffect:SetActive(false)
  if self.actBaseData then
    if curTime > self.actBaseData.endTime then
      self.remainText:SetLocalText(2000409)
    else
      self:AddTimer()
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
      local effects = DecorationUtil.GetBuildingEffectDescWithBuffTextColor(tonumber(self.actBaseData.para_6))
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
  self:RefreshCommonNode(self.actBaseData:GetShowConfigTemp())
  self:Refresh(true)
  self.act_banner_effect_content:SetData(self.actBaseData)
  local packingParams = {
    activityId = self.activityId,
    isShowItemTopBar = false
  }
  EventManager:GetInstance():Broadcast(EventId.ActivityCommonGroupView_FestivalPackagingModify, packingParams)
  if self.normalLineData then
    self.overlapTipsBtn:SetActive(true)
    local showOverlap = self:IsNeedAutoShowOverlap()
    if showOverlap then
      self:OnOverlapTipsBtnClick()
      self:SetAutoShowOverlapFlag()
    end
  end
  local baseScore = self:GetFestivalStageFinalNeedScore() or 0
  if self.actInfo and self.actInfo.subActivityData then
    self.rewardChangeBtn:ReInit(self.actInfo.subActivityData, function(updateShowData, newShowData)
      self:OnRewardChangeClose(updateShowData, newShowData)
    end, false, baseScore)
  else
    self.rewardChangeBtn:SetActive(false)
  end
end

function UIAccuRechargeMain_FestivalOverlap:RefreshCommonNode(showTemp)
  if not showTemp then
    return
  end
  if not string.IsNullOrEmpty(showTemp.pic_spec1) then
    local picNameList = string.split(showTemp.pic_spec1, "|")
    local name1 = picNameList[1]
    if name1 and not string.IsNullOrEmpty(name1) then
      self.newBg6:LoadSpriteAuto(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.UIAccuRechargeFestival, name1))
    end
    local name2 = picNameList[2]
    if name2 and not string.IsNullOrEmpty(name2) then
      self.newBg5:LoadSpriteAuto(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.UIAccuRechargeFestival, name2))
    end
  end
  local title_text = self.titleText
  local targetColor = {
    255,
    255,
    255,
    255
  }
  if #showTemp.title_color_tab == 4 then
    targetColor = showTemp.title_color_tab
    title_text:SetColorRGBA255(targetColor[1], targetColor[2], targetColor[3], targetColor[4])
  end
  local time_text = self.remainText
  targetColor = {
    255,
    255,
    255,
    255
  }
  if #showTemp.time_color_tab == 4 then
    targetColor = showTemp.time_color_tab
    if not IsNull(time_text) then
      time_text:SetColorRGBA255(targetColor[1], targetColor[2], targetColor[3], targetColor[4])
    end
    self.buildName:SetColorRGBA255(targetColor[1], targetColor[2], targetColor[3], targetColor[4])
  end
end

function UIAccuRechargeMain_FestivalOverlap:OnRewardChangeClose(updateShowData, newShowData)
  if IsNull(self.gameObject) then
    return
  end
  self:JumToSecondListStart()
  if not self.stageListContent then
    return
  end
  local items = self.stageListContent:GetComponents(UIAccuRechargeTargetItem)
  if items then
    for i, item in pairs(items) do
      if item.TriggerRewardChangeEffect then
        item:TriggerRewardChangeEffect(updateShowData, newShowData)
      end
    end
  end
end

function UIAccuRechargeMain_FestivalOverlap:OnOverlapTipsBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.AccuRechargeOverlapDisplay, {anim = true}, self.activityId)
end

function UIAccuRechargeMain_FestivalOverlap:IsNeedAutoShowOverlap()
  if not self.activityId then
    return
  end
  local key = "UIAccuRechargeMain_FestivalOverlap" .. self.activityId .. LuaEntry.Player.uid
  return CS.GameEntry.Setting:GetBool(key, true)
end

function UIAccuRechargeMain_FestivalOverlap:SetAutoShowOverlapFlag()
  if not self.activityId then
    return
  end
  local key = "UIAccuRechargeMain_FestivalOverlap" .. self.activityId .. LuaEntry.Player.uid
  CS.GameEntry.Setting:SetBool(key, false)
end

function UIAccuRechargeMain_FestivalOverlap:PlaySecondTitleAni(isUp)
  if isUp then
    self.secondTitleAni:Play("up")
  else
    self.secondTitleAni:Play("down")
  end
end

function UIAccuRechargeMain_FestivalOverlap:Update()
  if not self.secondTitlePosY or not self.normalLineData then
    return
  end
  local titlePosY = self.secondTitlePosY + TITLE_HEIGHT + ITEM_SPACING
  local limit = titlePosY - self.scrollViewHeight
  local contentPos = self.stageListContent:GetAnchoredPositionY()
  if limit > contentPos then
    self.secondTitle:SetActive(true)
    self:PlaySecondTitleAni(true)
  else
    self.secondTitle:SetActive(false)
  end
end

return UIAccuRechargeMain_FestivalOverlap
