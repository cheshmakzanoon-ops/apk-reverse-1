local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ActSevenDayDoomVanguard = BaseClass("ActSevenDayDoomVanguard", base)
local ActSevenDayDoomVanguarSliderItem = require("UI.UIDoomVanguard.SevenDay.Component.ActSevenDayDoomVanguarSliderItem")
local ActSevenDayDoomVanguarDayItem = require("UI.UIDoomVanguard.SevenDay.Component.ActSevenDayDoomVanguarDayItem")
local ActSevenDayDoomVanguarListDayItem = require("UI.UIDoomVanguard.SevenDay.Component.ActSevenDayDoomVanguarListDayItem")
local ActSevenDayDoomVanguardItem = require("UI.UIDoomVanguard.SevenDay.Component.ActSevenDayDoomVanguardItem")
local ItemPath = "Assets/Main/Prefabs/UI/DoomVanguard/SevenDay/UIActSevenDayDoomVanguardItem.prefab"
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self._title_txt = self:AddComponent(UIText, "RightView/Rect_Top/Txt_Title")
  self._time_txt = self:AddComponent(UIText, "RightView/Rect_Top/Txt_Time")
  self._progress_txt = self:AddComponent(UIText, "RightView/Rect_Top/ProgressContent/Icon/Txt_Progress")
  self._progress_icon = self:AddComponent(UIImage, "RightView/Rect_Top/ProgressContent/Icon")
  self._progress_slider = self:AddComponent(UISlider, "RightView/Rect_Top/ProgressContent/Slider")
  self.lineContent = self:AddComponent(UIBaseContainer, "RightView/Rect_Top/ProgressContent/Slider/LineContent")
  self.Txt_Info = self:AddComponent(UIText, "RightView/Rect_Top/Txt_Info")
  self.rectBottom = self:AddComponent(UIBaseContainer, "RightView/Rect_Bottom")
  self.rectLockBottom = self:AddComponent(UIBaseContainer, "RightView/Rect_LockBottom")
  self._progress_tipTxt = self:AddComponent(UIText, "RightView/Rect_Top/ProgressContent/ProgressTipText")
  self._progress_valueTxt = self:AddComponent(UIText, "RightView/Rect_Top/ProgressContent/ProgressTipText/ProgressText")
  self.day_TogTab = {}
  for i = 1, 5 do
    local togglepath = "RightView/Rect_Top/Rect_Group/Toggle_Tab" .. i
    self.day_TogTab[i] = self:AddComponent(ActSevenDayDoomVanguarDayItem, togglepath)
    self.day_TogTab[i]:SetData(i, function()
      self:ToggleControl(i)
    end)
  end
  self.listDay_togTab = {}
  for i = 1, 3 do
    local togglepath = "RightView/Rect_Bottom/Rect_List/Toggle_List" .. i
    self.listDay_togTab[i] = self:AddComponent(ActSevenDayDoomVanguarListDayItem, togglepath)
    self.listDay_togTab[i]:SetData(i, function()
      local isOn = self.listDay_togTab[i].Toggle:GetIsOn()
      if isOn and self.childTabIndex ~= i then
        self.childTabIndex = i
        self:RefreshSelectData(i)
      end
    end)
  end
  self.content = self:AddComponent(UIBaseContainer, "RightView/Rect_Bottom/ScrollView/Viewport/Content")
  self.detailInfoBtn = self:AddComponent(UIButton, "RightView/Rect_Top/InfoBtn")
  self.detailInfoBtn:SetOnClick(function()
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if activityData == nil then
      return
    end
    local param = {}
    param.activityRulesStr = Localization:GetString(activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
  end)
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, "HeroSpineContainer")
  self.heroBtn = self:AddComponent(UIButton, "HeroSpineContainer/HeroBtn")
  self.heroBtn:SetOnClick(function()
    if self.actListData and not string.IsNullOrEmpty(self.actListData.para_3) then
      GoToUtil.GoHeroDetails(self.actListData.para_3, HeroDetailGuideArrowType.Upgrade)
    end
  end)
  self.rewardBtn = self:AddComponent(UIButton, "RightView/Rect_Top/ProgressContent/ReawrdBtn")
  self.rewardBtnText = self:AddComponent(UIButton, "RightView/Rect_Top/ProgressContent/ReawrdBtn/RewardText")
  self.rewardBtn:SetOnClick(function()
    local sevenDayInfo = self.sevenDayInfo
    local activityId = self.activityId
    if sevenDayInfo and activityId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSevenDayDoomVanguardReward, {anim = true}, sevenDayInfo, activityId)
    end
  end)
  self.reawrdBtnRed = self:AddComponent(UICommonRedPoint, "RightView/Rect_Top/ProgressContent/ReawrdBtn/CommonRedPoint")
  self.reawrdBtnRed:SetType(CommonRedPointPriority.Level1)
  self.reawrdBtnSuo = self:AddComponent(UIImage, "RightView/Rect_Top/ProgressContent/ReawrdBtn/ReawrdBtnSuoImg")
  self.rewardBtnEffect = self:AddComponent(UIImage, "RightView/Rect_Top/ProgressContent/ReawrdBtn/RewardBtnEffect")
  self.progress_rewardTab = {}
  for i = 1, 5 do
    self.progress_rewardTab[i] = self:AddComponent(ActSevenDayDoomVanguarSliderItem, "RightView/Rect_Top/ProgressContent/Slider/LineContent/ProgressLine" .. i)
  end
  self.lockTipText1 = self:AddComponent(UIText, "RightView/Rect_LockBottom/LockTipText1")
  self.lockTipText2 = self:AddComponent(UIText, "RightView/Rect_LockBottom/LockTipText2")
  self.lockTipText3 = self:AddComponent(UIText, "RightView/Rect_LockBottom/ScrollBg/LockTipText3")
  self.lockJifenNum = self:AddComponent(UIText, "RightView/Rect_LockBottom/LockJifenNum")
  self.lockRewardContent = self:AddComponent(UIBaseContainer, "RightView/Rect_LockBottom/ScrollBg/LockRewardScrollView/Viewport/LockRewardScrollContent")
  self.lockTipText2:SetLocalText("sevenday_event_des48")
  self.lockTipText3:SetLocalText("sevenday_event_des49")
  self.rectBottom:SetActive(true)
  self.rectLockBottom:SetActive(false)
  self._progress_tipTxt:SetLocalText("sevenday_event_des50")
end

local function DataDefine(self)
  self.taskList = {}
  self.dayTabIndex = 1
  self.childTabIndex = 1
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self:InitSliderData()
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnAddListener(self)
  self:AddUIListener(EventId.MainTaskSuccess, self.UpdateTaskState)
  self:AddUIListener(EventId.ActSevenDay, self.RefreshUI)
  self:AddUIListener(EventId.ActSevenDayScore, self.UpdateRewardScore)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.MainTaskSuccess, self.UpdateTaskState)
  self:RemoveUIListener(EventId.ActSevenDay, self.RefreshUI)
  self:RemoveUIListener(EventId.ActSevenDayScore, self.UpdateRewardScore)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDestroy(self)
  self._title_txt = nil
  self._time_txt = nil
  self._progress_txt = nil
  self._progress_slider = nil
  self.lineContent = nil
  self.Txt_Info = nil
  self.rectBottom = nil
  self.rectLockBottom = nil
  self.day_TogTab = nil
  self.listDay_togTab = nil
  self.content = nil
  self.detailInfoBtn = nil
  self.heroSpineContainer = nil
  self.progress_rewardTab = nil
  self.rewardBtn = nil
  self.rewardBtnText = nil
  self.reawrdBtnRed = nil
  self.reawrdBtnSuo = nil
  self.rewardBtnEffect = nil
  self.lockTipText1 = nil
  self.lockTipText2 = nil
  self.lockTipText3 = nil
  self.lockTipText4 = nil
  self.lockJifenNum = nil
  self.lockRewardContent = nil
end

local function DataDestroy(self)
  self.lastSpinePath = nil
  self.heroSpineLoadRequest = nil
  self.define = nil
  self.taskList = nil
  self.dayTabIndex = nil
  self.childTabIndex = nil
  self.timer_action = nil
  self.sliderFullLen = nil
  self.sliderNodeLens = nil
  self:DeleteTimer()
end

local function OnDestroy(self)
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self:DestoryLockReward()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  SFSNetwork.SendMessage(MsgDefines.GetSevenDayActInfo, activityId)
  self.actListData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(activityId))
  if self.actListData then
    self:ReloadHeroSpine(self.actListData.activity_hero)
  end
  self._title_txt:SetLocalText(self.actListData.name)
  self.Txt_Info:SetLocalText(self.actListData.desc_info)
end

local function ReloadHeroSpine(self, spinePath)
  if string.IsNullOrEmpty(spinePath) then
    return
  end
  if self.lastSpinePath ~= spinePath then
    if self.heroSpineLoadRequest ~= nil then
      self.heroSpineLoadRequest:Destroy()
      self.heroSpineLoadRequest = nil
    end
    local request = ResourceManager:InstantiateAsync(spinePath)
    self.heroSpineLoadRequest = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.heroSpineLoadRequest = nil
        return
      end
      self:ResetSpineTransform(request.gameObject)
    end)
    self.lastSpinePath = spinePath
  elseif self.heroSpineLoadRequest then
    self:ResetSpineTransform(self.heroSpineLoadRequest.gameObject)
  end
end

local function ResetSpineTransform(self, obj)
  if not obj then
    return
  end
  local parent = self.heroSpineContainer
  if not parent then
    return
  end
  obj:SetActive(true)
  local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if rectTransform ~= nil and self.actListData then
    local spinePos = {69, 148}
    rectTransform:SetParent(parent.transform)
    rectTransform:Set_localScale(-1.15, 1.15, 1)
    rectTransform:Set_anchoredPosition(spinePos[1], spinePos[2], 0)
  end
end

local function ToggleControl(self, index)
  if self.sevenDayInfo == nil then
    return
  end
  local isOn = self.day_TogTab[index].toggle:GetIsOn()
  if isOn and self.dayTabIndex ~= index then
    self.dayTabIndex = index
    for i = 1, 5 do
      if i == self.dayTabIndex then
        self.day_TogTab[i]:OnSelect(true)
      else
        self.day_TogTab[i]:OnSelect(false)
      end
    end
    if index > self.sevenDayInfo.days then
      self.rectBottom:SetActive(false)
      self.rectLockBottom:SetActive(true)
      self:RefreshLockPanel()
    else
      self.rectBottom:SetActive(true)
      self.rectLockBottom:SetActive(false)
      if self.childTabIndex ~= 1 then
        self.childTabIndex = 1
        self.listDay_togTab[1]:OnSelect(true)
      end
      self:RefreshSelectData()
    end
  end
end

local function RefreshSelectData(self)
  if self.sevenDayInfo == nil then
    return
  end
  for i = 1, 3 do
    if i == self.childTabIndex then
      self.listDay_togTab[i]:OnSelect(true)
    else
      self.listDay_togTab[i]:OnSelect(false)
    end
  end
  local tasks = self.sevenDayInfo.dayActs[self.dayTabIndex][self.childTabIndex].tasks
  self.taskList = self.sevenDayInfo:SortTask(tasks)
  for i = 1, 3 do
    self.listDay_togTab[i]:ReInit(self.sevenDayInfo.dayActs[self.dayTabIndex][i].type2_text)
  end
  self:RedListDayRefresh()
  self:SetItemData()
end

local function RedListDayRefresh(self)
  local redData = self.sevenDayInfo.taskRed
  for i = 1, 3 do
    if i <= #redData[self.dayTabIndex] then
      self.listDay_togTab[i]:ShowRed(redData[self.dayTabIndex][i] == 1)
    else
      self.listDay_togTab[i]:ShowRed(false)
    end
  end
end

local function SetItemData(self)
  self:SetAllCellDestroy()
  self.model = {}
  local scoreIcon = self:GetScoreIcon()
  local goodsId = self.actListData.para_1
  local targetPos = self._progress_icon.transform.position
  if next(self.taskList) then
    for i = 1, table.length(self.taskList) do
      self.model[i] = self:GameObjectInstantiateAsync(ItemPath, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = i
        self.taskList[i].flyPos = targetPos
        self.taskList[i].day = self.dayTabIndex
        local cell = self.content:AddComponent(ActSevenDayDoomVanguardItem, go.name)
        cell:RefreshData(self.taskList[i], self.sevenDayInfo.days, scoreIcon, goodsId, targetPos)
      end)
    end
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.sevenDayInfo.endTime then
    self._time_txt:SetText("")
    self:DeleteTimer()
  else
    self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.sevenDayInfo.endTime - curTime))
  end
end

local function RefreshUI(self)
  self.sevenDayInfo = DataCenter.ActSevenDayData:GetInfoByActId(tonumber(self.activityId))
  if self.sevenDayInfo then
    self.sevenDayInfo:CalculateDate()
  end
  self:RefreshTime()
  self:AddTimer()
  local days = CommonUtil.PlayerPrefsGetInt("doomActDays", 0)
  if days ~= self.sevenDayInfo.days then
    CommonUtil.PlayerPrefsSetInt("doomActDays", self.sevenDayInfo.days)
    PostEventLog.Track(PostEventLog.Defines.DoomDayWhenOpenUI, {
      param1 = tostring(self.sevenDayInfo.days)
    })
  end
  for i = 1, #self.sevenDayInfo.dayActs do
    local isLock = i > self.sevenDayInfo.days
    self.day_TogTab[i]:ReInit(isLock, self.sevenDayInfo.dayActs[i][1].type1_text)
  end
  self.sevenDayInfo:CheckRedDot()
  local last = DataCenter.ActSevenDayData:GetLastVisitTab(tonumber(self.activityId))
  if last and next(last) then
    self.dayTabIndex = last[1]
    self.childTabIndex = last[2]
  else
    self.dayTabIndex = 1
    self.childTabIndex = 1
  end
  self.day_TogTab[self.sevenDayInfo.days]:OnSelect(true)
  self:ToggleControl(self.sevenDayInfo.days)
  self:RedDayRefresh()
  self.listDay_togTab[self.childTabIndex]:OnSelect(true)
  self:SetSliderValue()
  self:RefreshSelectData()
end

local function UpdateTaskState(self)
  self.sevenDayInfo = DataCenter.ActSevenDayData:GetInfoByActId(tonumber(self.activityId))
  if not table.IsNullOrEmpty(self.sevenDayInfo) then
    self.sevenDayInfo:CheckRedDot()
    self:RedDayRefresh()
    self:RefreshSelectData()
  end
end

local function UpdateRewardScore(self)
  self.sevenDayInfo = DataCenter.ActSevenDayData:GetInfoByActId(tonumber(self.activityId))
  self:RedListDayRefresh()
  self:SetSliderValue()
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(ActSevenDayDoomVanguardItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function RedDayRefresh(self)
  local redData = self.sevenDayInfo.taskRed
  for i = 1, #redData do
    self.day_TogTab[i]:ShowRed(false)
    for j = 1, #redData[i] do
      if redData[i][j] == 1 then
        self.day_TogTab[i]:ShowRed(true)
        local tab = DataCenter.ActSevenDayData:GetLastVisitTab(tonumber(self.activityId))
        if tab == nil or not next(tab) then
          DataCenter.ActSevenDayData:SetLastVisitTab(tonumber(self.activityId), {i, j})
        end
        break
      end
    end
  end
end

local function SetSliderValue(self)
  local count = #self.sevenDayInfo.scoreReward
  self._progress_txt:SetText(string.format("%d/%d", self.sevenDayInfo.score, self.sevenDayInfo.scoreReward[count].needScore))
  local nowIndex = 1
  for i = 1, count do
    self.progress_rewardTab[i]:ReInit(self.sevenDayInfo.scoreReward[i], self.sevenDayInfo, self.activityId)
    if self.sevenDayInfo.score >= self.sevenDayInfo.scoreReward[i].needScore and self.sevenDayInfo.scoreReward[i].rewardFlag ~= 0 then
      nowIndex = i + 1
      if count < nowIndex then
        nowIndex = count
      end
    end
  end
  self._progress_valueTxt:SetText(string.format("%d/%d", self.sevenDayInfo.score, self.sevenDayInfo.scoreReward[nowIndex].needScore))
  local value = self:GetNowSliderValue()
  self._progress_slider:SetValue(value)
  self.reawrdBtnRed:SetNum((0 < self.sevenDayInfo:GetRewardRed() or 0 < self.sevenDayInfo:GetVipRewardRed()) and 1 or 0)
  self.reawrdBtnSuo:SetActive(0 < self.sevenDayInfo:GetVipLockRed())
  self.rewardBtnEffect:SetActive(0 < self.sevenDayInfo:GetRewardRed() or 0 < self.sevenDayInfo:GetVipRewardRed())
end

local function InitSliderData(self)
  self.sliderFullLen = self.lineContent:GetSizeDelta().x
  self.sliderNodeLens = {}
  for i = 1, #self.progress_rewardTab do
    local posX = self.progress_rewardTab[i]:GetAnchoredPositionX()
    table.insert(self.sliderNodeLens, posX)
  end
end

local function GetNowSliderValue(self)
  local nowIndex = 0
  local nowScore = self.sevenDayInfo.score
  local score = nowScore
  for i = 1, #self.sevenDayInfo.scoreReward do
    local needScore = self.sevenDayInfo.scoreReward[i].needScore
    if nowScore >= needScore then
      nowIndex = i
    else
      if 1 < i then
        score = nowScore - self.sevenDayInfo.scoreReward[i - 1].needScore
      end
      break
    end
  end
  local value = 0
  if nowIndex == #self.sevenDayInfo.scoreReward then
    value = 1
  else
    local preScore = 0
    if 0 < nowIndex then
      preScore = self.sevenDayInfo.scoreReward[nowIndex].needScore
    end
    local nodeRatio = score / (self.sevenDayInfo.scoreReward[nowIndex + 1].needScore - preScore)
    local prePosX = 0
    if 0 < nowIndex then
      prePosX = self.sliderNodeLens[nowIndex]
    end
    value = (prePosX + (self.sliderNodeLens[nowIndex + 1] - prePosX) * nodeRatio) / self.sliderFullLen
  end
  return value
end

local function GetScoreIcon(self)
  if not self.actListData then
    return string.format(LoadPath.ItemPath, "7tianle_jifen_icon")
  end
  if not string.IsNullOrEmpty(self.actListData.para_1) then
    local goodsId = tonumber(self.actListData.para_1)
    if 0 <= goodsId then
      return DataCenter.RewardManager:GetPicByType(RewardType.GOODS, goodsId)
    end
    return ""
  end
  return ""
end

local function RefreshLockPanel(self)
  if self.sevenDayInfo == nil then
    return
  end
  self.lockTipText1:SetLocalText("sevenday_event_des47", self.dayTabIndex)
  local dayTasks = self.sevenDayInfo.dayActs[self.dayTabIndex]
  local pointNum = 0
  local rewardTemp = {}
  for _, dayTask in ipairs(dayTasks) do
    for _, task in ipairs(dayTask.tasks) do
      pointNum = pointNum + task.point
      local taskValue = DataCenter.TaskManager:FindTaskInfo(task.id)
      local rewardList = taskValue:GetFinalReward()
      for _, reward in ipairs(rewardList) do
        if rewardTemp[reward.itemId] == nil then
          rewardTemp[reward.itemId] = reward
        else
          rewardTemp[reward.itemId].count = rewardTemp[reward.itemId].count + reward.count
        end
      end
    end
  end
  self.lockJifenNum:SetText("x" .. pointNum)
  self:DestoryLockReward()
  self.lockRewardModel = {}
  local showList = self.view.ctrl:RewardItemList(rewardTemp)
  table.sort(showList, function(a, b)
    if a.rewardType ~= b.rewardType then
      return tonumber(a.rewardType) > tonumber(b.rewardType)
    else
      return tonumber(a.itemId) < tonumber(b.itemId)
    end
  end)
  if showList ~= nil then
    for i = 1, table.length(showList) do
      self.lockRewardModel[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.lockRewardContent.transform)
        go.transform:Set_localScale(0.7, 0.7, 1)
        go.transform.pivot = Vector2.New(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.lockRewardContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(showList[i])
      end)
    end
  end
end

local function DestoryLockReward(self)
  self.lockRewardContent:RemoveComponents(UICommonResItem)
  if self.lockRewardModel ~= nil then
    for k, v in pairs(self.lockRewardModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.lockRewardModel = nil
  end
end

ActSevenDayDoomVanguard.OnCreate = OnCreate
ActSevenDayDoomVanguard.OnEnable = OnEnable
ActSevenDayDoomVanguard.OnAddListener = OnAddListener
ActSevenDayDoomVanguard.OnRemoveListener = OnRemoveListener
ActSevenDayDoomVanguard.OnDisable = OnDisable
ActSevenDayDoomVanguard.ComponentDefine = ComponentDefine
ActSevenDayDoomVanguard.ComponentDestroy = ComponentDestroy
ActSevenDayDoomVanguard.ComponentDestroy = ComponentDestroy
ActSevenDayDoomVanguard.DataDefine = DataDefine
ActSevenDayDoomVanguard.DataDestroy = DataDestroy
ActSevenDayDoomVanguard.OnDestroy = OnDestroy
ActSevenDayDoomVanguard.SetData = SetData
ActSevenDayDoomVanguard.ReloadHeroSpine = ReloadHeroSpine
ActSevenDayDoomVanguard.ResetSpineTransform = ResetSpineTransform
ActSevenDayDoomVanguard.ToggleControl = ToggleControl
ActSevenDayDoomVanguard.RefreshSelectData = RefreshSelectData
ActSevenDayDoomVanguard.RedListDayRefresh = RedListDayRefresh
ActSevenDayDoomVanguard.SetItemData = SetItemData
ActSevenDayDoomVanguard.DeleteTimer = DeleteTimer
ActSevenDayDoomVanguard.AddTimer = AddTimer
ActSevenDayDoomVanguard.RefreshTime = RefreshTime
ActSevenDayDoomVanguard.RefreshUI = RefreshUI
ActSevenDayDoomVanguard.UpdateTaskState = UpdateTaskState
ActSevenDayDoomVanguard.UpdateRewardScore = UpdateRewardScore
ActSevenDayDoomVanguard.SetAllCellDestroy = SetAllCellDestroy
ActSevenDayDoomVanguard.RedDayRefresh = RedDayRefresh
ActSevenDayDoomVanguard.SetSliderValue = SetSliderValue
ActSevenDayDoomVanguard.GetScoreIcon = GetScoreIcon
ActSevenDayDoomVanguard.InitSliderData = InitSliderData
ActSevenDayDoomVanguard.GetNowSliderValue = GetNowSliderValue
ActSevenDayDoomVanguard.RefreshLockPanel = RefreshLockPanel
ActSevenDayDoomVanguard.DestoryLockReward = DestoryLockReward
return ActSevenDayDoomVanguard
