local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local StrongestCommanderMain = BaseClass("StrongestCommanderMain", base)
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local UIStageToggle = require("UI.UIActivityCenterTable.Component.StrongestCommander.UIStageToggle")
local UIStageGiftPackItem = require("UI.UIActivityCenterTable.Component.StrongestCommander.UIStageGiftPackItem")
local UIStageMissionItem = require("UI.UIActivityCenterTable.Component.StrongestCommander.UIStageMissionItem")
local UIGiftPackContentItem = require("UI.UIActivityCenterTable.Component.StrongestCommander.UIGiftPackContentItem")
local titleTextPath = "Root/TitleBg/Txt_ActName"
local subTitleTextPath = "Root/TitleBg/Txt_ActTime"
local actCountDownTimePath = "Root/TitleBg/CountDownTime"
local actCountDownTimeTextPath = "Root/TitleBg/CountDownTime/Txt_Times"
local chartBtnPath = "Root/TitleBg/ChartBtn"
local heroSpineContainerPath = "Root/TitleBg/HeroSpineContainer"
local playerInfoPath = "Root/ActInfo/PlayerInfo"
local current_point_group_path = "Root/ActInfo/PlayerInfo/CurrentPointGroup"
local curPointTextPath = "Root/ActInfo/PlayerInfo/CurrentPointGroup/CurrentPointValueText"
local current_ranking_group_path = "Root/ActInfo/PlayerInfo/CurrentRankingGroup"
local curRankingTextPath = "Root/ActInfo/PlayerInfo/CurrentRankingGroup/CurrentRankingValueText"
local tipArrowPath = "Root/ActInfo/PlayerInfo/TipContainer/TipArrow"
local tipDescTextPath = "Root/ActInfo/PlayerInfo/TipContainer/ContentBg/TipTextGroup/TipText1"
local tipCountDownTextPath = "Root/ActInfo/PlayerInfo/TipContainer/ContentBg/TipTextGroup/TipText2"
local tipDetailBtnPath = "Root/ActInfo/PlayerInfo/TipContainer/ContentBg/DetailBtn"
local infoBtnPath = "Root/TitleBg/Intro"
local stageTogglePath = "Root/ActInfo/StageBar/Stage%dBtn"
local stageToggleRedPointPath = "Root/ActInfo/StageBar/Stage%dBtn/Stage%dRedPointNum"
local stageToggleRedPointNumTextPath = "Root/ActInfo/StageBar/Stage%dBtn/Stage%dRedPointNum/Text%d"
local missionsScrollPath = "Root/ActInfo/MissionsScroll"
local missionsContentPath = "Root/ActInfo/MissionsScroll/Viewport/MissionsContent"
local giftPackItemPath = "Root/ActInfo/GiftPackItem"
local giftPackContentPath = "GiftPackContent"
local giftPackContentMaskPath = "GiftPackContent/Mask"
local giftPackContentTipPath = "GiftPackContent/Tip"
local giftPackContentTipBgPath = "GiftPackContent/Tip/Bg"
local giftPackContentScrollContentPath = "GiftPackContent/Tip/Bg/ItemScroll/Viewport/Content"
local giftPackContentScrollItemPath = "GiftPackContent/Tip/Bg/ItemScroll/Item"

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.missionDataList then
    return nil
  end
  local missionId = self.missionDataList[index]
  local item = loopScroll:NewListViewItem("MissionItem")
  local script = self.missionContent:GetComponent(item.gameObject.name, UIStageMissionItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.missionContent:AddComponent(UIStageMissionItem, objectName)
  end
  script:SetActive(true)
  script:SetData(missionId, self.selectedStage, self.curStage, self.openScoreMethodPanel)
  self.missionItems[missionId] = script
  return item
end

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self:ClearScroll()
  self:DelCountDownTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OpenScoreMethodPanel(self)
  if not self.activityData or not self.selectedStage then
    return
  end
  local methods = DataCenter.StrongestCommanderDataManager:GetStageScoreMethods(self.selectedStage)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIStrComScoreDescPanel, {anim = true}, methods, self.selectedStage, self.curStage)
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, titleTextPath)
  self.subTitleText = self:AddComponent(UIText, subTitleTextPath)
  self.actCountDownTime = self:AddComponent(UIBaseContainer, actCountDownTimePath)
  self.actCountDownTimeText = self:AddComponent(UIText, actCountDownTimeTextPath)
  self.chartBtn = self:AddComponent(UIButton, chartBtnPath)
  self.chartBtn:SetOnClick(function()
    if self.activityData and self.selectedStage then
      local stage = self.selectedStage
      if self.selectedStage > self.curStage then
        stage = self.curStage
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIStrComLeaderBoardPanel, {anim = true}, self.activityData.id, stage, self.curStage)
    end
  end)
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainerPath)
  self.playerInfo = self:AddComponent(UIBaseContainer, playerInfoPath)
  self.current_point_group = self:AddComponent(UIBaseContainer, current_point_group_path)
  self.curPointText = self:AddComponent(UIText, curPointTextPath)
  self.current_ranking_group = self:AddComponent(UIBaseContainer, current_ranking_group_path)
  self.curRankingText = self:AddComponent(UIText, curRankingTextPath)
  self.tipArrow = self:AddComponent(UIBaseContainer, tipArrowPath)
  self.tipDescText = self:AddComponent(UIText, tipDescTextPath)
  self.stageCountDownTimeText = self:AddComponent(UIText, tipCountDownTextPath)
  self.tipDetailBtn = self:AddComponent(UIButton, tipDetailBtnPath)
  self.tipDetailBtn:SetOnClick(function()
    OpenScoreMethodPanel(self)
  end)
  self.infoBtn = self:AddComponent(UIButton, infoBtnPath)
  self.infoBtn:SetOnClick(function()
    if self.activityData then
      local param = {}
      param.activityRulesStr = Localization:GetString(self.activityData.story)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
    end
  end)
  self.stageToggles = {}
  self.stageTogglesRedPoint = {}
  self.stageTogglesRedPointNumText = {}
  for i = 1, 7 do
    local stageToggle = self:AddComponent(UIStageToggle, string.format(stageTogglePath, i))
    stageToggle:SetIndex(i)
    stageToggle:SetCallBack(self.selectStageCallBack)
    table.insert(self.stageToggles, stageToggle)
    local stageToggleRedPoint = self:AddComponent(UIBaseContainer, string.format(stageToggleRedPointPath, i, i))
    stageToggleRedPoint:SetActive(false)
    table.insert(self.stageTogglesRedPoint, stageToggleRedPoint)
    local stageToggleRedPointNumText = self:AddComponent(UIText, string.format(stageToggleRedPointNumTextPath, i, i, i))
    stageToggleRedPointNumText:SetText("")
    table.insert(self.stageTogglesRedPointNumText, stageToggleRedPointNumText)
  end
  self.missionScroll = self:AddComponent(UILoopListView2, missionsScrollPath)
  self.missionScroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.missionContent = self:AddComponent(UIBaseContainer, missionsContentPath)
  self.giftPackItem = self:AddComponent(UIStageGiftPackItem, giftPackItemPath)
  self.giftPackContent = self:AddComponent(UIBaseContainer, giftPackContentPath)
  self.giftPackContent:SetActive(false)
  self.giftPackContentMask = self:AddComponent(UIButton, giftPackContentMaskPath)
  self.giftPackContentMask:SetOnClick(function()
    self:HideTip()
  end)
  self.giftPackContentTip = self:AddComponent(UIText, giftPackContentTipPath)
  self.giftPackContentTipBg = self:AddComponent(UIImage, giftPackContentTipBgPath)
  self.giftPackContentScrollContent = self:AddComponent(UIBaseContainer, giftPackContentScrollContentPath)
  self.giftPackItem_prefab = self.transform:Find(giftPackContentScrollItemPath).gameObject
  self.giftPackItem_prefab:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.subTitleText = nil
  self.actCountDownTime = nil
  self.actCountDownTimeText = nil
  self.chartBtn = nil
  self.heroSpineContainer = nil
  self.playerInfo = nil
  self.current_point_group = nil
  self.curPointText = nil
  self.current_ranking_group = nil
  self.curRankingText = nil
  self.tipArrow = nil
  self.tipDescText = nil
  self.stageCountDownTimeText = nil
  self.tipDetailBtn = nil
  self.stageToggles = nil
  self.stageTogglesRedPoint = nil
  self.stageTogglesRedPointNumText = nil
  self.missionScroll = nil
  self.missionContent = nil
  self.giftPackItem = nil
  self.giftPackContent = nil
  self.giftPackContentMask = nil
  self.giftPackContentTip = nil
  self.giftPackContentTipBg = nil
  self.giftPackContentScrollContent:RemoveComponents(UIGiftPackContentItem)
  self.giftPackContentScrollContent = nil
  self.giftPackItem_prefab.gameObject:GameObjectRecycleAll()
  self.giftPackItem_prefab = nil
end

local function DataDefine(self)
  self.activityId = nil
  self.activityData = nil
  self.CountDownTimerAction = nil
  self.countDownTimer = nil
  self.itemIndex = 0
  self.missionItems = {}
  self.selectedStage = nil
  self.actCountDownTimeActive = true
  self.selectStageCallBack = BindCallback(self, self.SelectStage)
  self.clickIconCallBack = BindCallback(self, self.ShowTip)
  self.openScoreMethodPanel = BindCallback(self, self.OpenScoreMethodPanel)
  self.heroSpineLoadRequest = nil
  self.latSpinePath = nil
end

local function DataDestroy(self)
  self.activityId = nil
  self.activityData = nil
  self.CountDownTimerAction = nil
  self.countDownTimer = nil
  self.itemIndex = nil
  self.missionItems = nil
  self.selectedStage = nil
  self.actCountDownTimeActive = nil
  self.selectStageCallBack = nil
  self.clickIconCallBack = nil
  self.openScoreMethodPanel = nil
  self.heroSpineLoadRequest = nil
  self.lastSpinePath = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnClaimRewardEffFinish, self.ShowTasks)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.RefreshAll)
  self:AddUIListener(EventId.UpdateGiftPackData, self.OnGiftPackUpdate)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnClaimRewardEffFinish, self.ShowTasks)
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.RefreshAll)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnGiftPackUpdate)
  base.OnRemoveListener(self)
end

local function GetTaskListSorted(self)
  if not self.activityData or not self.selectedStage then
    return {}
  end
  local tasks = {}
  local taskList = DataCenter.StrongestCommanderDataManager:GetQuests(self.selectedStage)
  for m, taskId in pairs(taskList) do
    local taskInfo = DataCenter.TaskManager:FindTaskInfo(taskId)
    if taskInfo then
      table.insert(tasks, taskId)
    end
  end
  table.sort(tasks, function(a, b)
    local taskValueA = DataCenter.TaskManager:FindTaskInfo(a)
    local taskValueB = DataCenter.TaskManager:FindTaskInfo(b)
    if not taskValueA then
      return false
    elseif not taskValueB then
      return true
    elseif taskValueA.state ~= taskValueB.state then
      if taskValueA.state == 1 then
        return true
      elseif taskValueB.state == 1 then
        return false
      elseif taskValueA.state == 2 then
        return false
      elseif taskValueB.state == 2 then
        return true
      end
    else
      return tonumber(a) < tonumber(b)
    end
  end)
  return tasks
end

local function ShowTasks(self)
  if not self.activityData or not self.selectedStage then
    return
  end
  self.missionDataList = self:GetTaskListSorted()
  self:ClearScroll()
  if self.missionDataList == nil or #self.missionDataList == 0 then
    self.missionScroll:SetActive(false)
    return
  end
  self.missionScroll:SetActive(true)
  self.missionScroll:SetListItemCount(#self.missionDataList, false, false)
  self:RefreshStageRedPoint()
end

local function RefreshStageToggle(self)
  for i = 1, #self.stageToggles do
    if self.isAtFinishStage then
      self.stageToggles[i]:SetSelected(i == self.selectedStage, true)
    else
      self.stageToggles[i]:SetSelected(i == self.selectedStage, i <= self.curStage)
    end
  end
end

local function SelectStage(self, index)
  if self.selectedStage == index then
    return
  end
  self.selectedStage = index
  for i = 1, #self.stageToggles do
    if self.isAtFinishStage then
      self.stageToggles[i]:SetSelected(i == index, true)
    else
      self.stageToggles[i]:SetSelected(i == index, i <= self.curStage)
    end
  end
  self:RefreshStageDetail()
end

local function RequestActivityDetialInfo(self)
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.activityId))
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
  if rectTransform ~= nil and self.activityData then
    local posAndScaleStr = self.activityData.hero_para
    local spinePos = {0, 0}
    local spineScale = 1
    if posAndScaleStr then
      local posAndScale = string.split(posAndScaleStr, "|")
      if not table.IsNullOrEmpty(posAndScale) then
        local spinePosTable = string.split(posAndScale[1], ";")
        if not table.IsNullOrEmpty(spinePosTable) and table.count(spinePosTable) >= 2 then
          spinePos = {
            tonumber(spinePosTable[1]),
            tonumber(spinePosTable[2])
          }
        end
        if table.count(posAndScale) >= 2 then
          spineScale = tonumber(posAndScale[2])
        end
      end
    end
    rectTransform:SetParent(parent.transform)
    rectTransform:Set_localScale(spineScale, spineScale, 1)
    rectTransform:Set_anchoredPosition(spinePos[1], spinePos[2], 0)
  end
end

local function ReloadHeroSpine(self, spinePath)
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
      ResetSpineTransform(self, request.gameObject)
    end)
    self.lastSpinePath = spinePath
  elseif self.heroSpineLoadRequest then
    ResetSpineTransform(self, self.heroSpineLoadRequest.gameObject)
  end
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(self.activityId)
  if not self.activityData then
    return
  end
  ReloadHeroSpine(self, self.activityData.activity_hero)
  local defaultSelectStage = 1
  self.curStage = DataCenter.StrongestCommanderDataManager:GetCurStage()
  self.isAtFinishStage = DataCenter.StrongestCommanderDataManager:IsAtFinishStage()
  if not self.isAtFinishStage then
    defaultSelectStage = self.curStage
  end
  self:RefreshAll()
  SelectStage(self, defaultSelectStage)
  RequestActivityDetialInfo(self)
end

local function RefreshBaseInfo(self)
  if not self.activityData then
    return
  end
  self.titleText:SetText(Localization:GetString(self.activityData.name))
  local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityData.startTime)
  local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityData.endTime)
  self.subTitleText:SetText(Localization:GetString(self.activityData.desc_info, startT, endT))
end

local function OnGiftPackUpdate(self)
  local prevGiftPackId
  if self.giftPackData then
    prevGiftPackId = self.giftPackData:getID()
  end
  self:RefreshGiftPackInfo()
  if self.giftPackData and prevGiftPackId and prevGiftPackId ~= self.giftPackData:getID() then
    RequestActivityDetialInfo(self)
  elseif prevGiftPackId ~= nil and self.giftPackData == nil then
    RequestActivityDetialInfo(self)
  end
end

local function RefreshGiftPackInfo(self)
  if self.isAtFinishStage then
    self.giftPackItem:SetActive(false)
    return false
  else
    self.giftPackItem:SetActive(true)
    self.giftPackData = nil
    local giftPackGroupId = DataCenter.StrongestCommanderDataManager:GetStageGiftPackGroupId(self.selectedStage)
    if giftPackGroupId then
      local packs = GiftPackManager.GetPacksByGroupId(giftPackGroupId, false)
      if not table.IsNullOrEmpty(packs) then
        self.giftPackData = packs[1]
      end
    end
    self.giftPackItem:SetData(self.giftPackData, self.clickIconCallBack)
    return self.giftPackData ~= nil
  end
end

local function RefreshStageDetail(self)
  if not self.activityData then
    return
  end
  if not self.selectedStage then
    return
  end
  self:ShowTasks()
  self.openCountDownTime = 0
  self.isActiveStage = self.selectedStage == self.curStage
  local pos = self.stageToggles[self.selectedStage].transform.position
  self.tipArrow.transform.position = Vector3.New(pos.x, pos.y + 3.5, pos.z)
  self.current_ranking_group:SetActive(self.isActiveStage or self.selectedStage < self.curStage)
  self.current_point_group:SetActive(self.isActiveStage or self.selectedStage < self.curStage)
  if self.isActiveStage or self.selectedStage < self.curStage then
    self.curPointText:SetText(DataCenter.StrongestCommanderDataManager:GetSelfStageScore(self.selectedStage))
    self.curRankingText:SetText(DataCenter.StrongestCommanderDataManager:GetSelfStageRank(self.selectedStage))
  end
  self.tipDetailBtn:SetActive(self.isActiveStage or self.selectedStage > self.curStage)
  if self.isActiveStage then
    self.giftPackItem:SetActive(true)
    local showPack = RefreshGiftPackInfo(self)
    self.tipDescText:SetLocalText(DataCenter.StrongestCommanderDataManager:GetStageDesc(self.selectedStage))
    if showPack then
      local minx, miny = self.missionScroll:GetOffsetMinXY()
      local maxx, maxy = self.missionScroll:GetOffsetMaxXY()
      self.missionScroll:SetOffsetMinXY(minx, 92)
      self.missionScroll:SetOffsetMaxXY(maxx, -207)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.missionScroll.rectTransform)
    else
      local minx, miny = self.missionScroll:GetOffsetMinXY()
      local maxx, maxy = self.missionScroll:GetOffsetMaxXY()
      self.missionScroll:SetOffsetMinXY(minx, 30)
      self.missionScroll:SetOffsetMaxXY(maxx, -207)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.missionScroll.rectTransform)
    end
    self:RefreshRemainTime(false)
  else
    self.giftPackItem:SetActive(false)
    if self.selectedStage < self.curStage then
      self.tipDescText:SetLocalText(2000223)
      self.stageCountDownTimeText:SetText("")
    else
      self.tipDescText:SetLocalText(DataCenter.StrongestCommanderDataManager:GetStageDesc(self.selectedStage))
      self.stageCountDownTimeText:SetLocalText("activity_commander_tips1")
      local num = self.selectedStage - self.curStage
      local stageRemainTime = DataCenter.StrongestCommanderDataManager:GetCurStageRemainTime()
      self.openCountDownTime = (num - 1) * 24 * 60 * 60 * 1000 + stageRemainTime
      self:RefreshRemainTime(false)
    end
    local minx, miny = self.missionScroll:GetOffsetMinXY()
    local maxx, maxy = self.missionScroll:GetOffsetMaxXY()
    self.missionScroll:SetOffsetMinXY(minx, 30)
    self.missionScroll:SetOffsetMaxXY(maxx, -207)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.missionScroll.rectTransform)
  end
end

local function RefreshStageRedPoint(self)
  for i = 1, #self.stageToggles do
    local count = DataCenter.StrongestCommanderDataManager:GetStageCanRewardCount(i)
    self.stageTogglesRedPoint[i]:SetActive(0 < count)
    self.stageTogglesRedPointNumText[i]:SetText(count)
  end
end

local function RefreshAll(self)
  self.curStage = DataCenter.StrongestCommanderDataManager:GetCurStage()
  self.isAtFinishStage = DataCenter.StrongestCommanderDataManager:IsAtFinishStage()
  RefreshBaseInfo(self)
  RefreshStageDetail(self)
  RefreshStageToggle(self)
  RefreshStageRedPoint(self)
  self:AddCountDownTimer()
end

local function AddCountDownTimer(self)
  if self.activityData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.activityData.endTime then
    return
  end
  
  function self.CountDownTimerAction()
    self:RefreshRemainTime(true)
  end
  
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction, self, false, false, false)
  end
  self.countDownTimer:Start()
end

local function RefreshRemainTime(self, requestData)
  if not self.activityData then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.activityData.endTime - curTime
  if 0 < remainTime then
    if not self.actCountDownTimeActive then
      self.actCountDownTimeActive = true
      self.actCountDownTime:SetActive(true)
    end
    self.actCountDownTimeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    if not self.isAtFinishStage then
      local stageRemainTime = DataCenter.StrongestCommanderDataManager:GetCurStageRemainTime()
      if 0 < stageRemainTime then
        if self.isActiveStage then
          self.stageCountDownTimeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(stageRemainTime))
        end
      else
        if self.isActiveStage then
          self.stageCountDownTimeText:SetText("")
        end
        if requestData then
          RequestActivityDetialInfo(self)
        end
      end
      if not self.isActiveStage and self.selectedStage and self.curStage and self.selectedStage > self.curStage then
        if self.openCountDownTime and 0 < self.openCountDownTime then
          self.stageCountDownTimeText:SetLocalText("activity_commander_tips2", UITimeManager:GetInstance():MilliSecondToFmtString(self.openCountDownTime))
          self.openCountDownTime = self.openCountDownTime - 1000
        else
          self.stageCountDownTimeText:SetText("")
        end
      end
    end
  else
    self.actCountDownTimeText:SetText("")
    if self.actCountDownTimeActive then
      self.actCountDownTimeActive = false
      self.actCountDownTime:SetActive(false)
    end
    self:DelCountDownTimer()
    if requestData then
      RequestActivityDetialInfo(self)
    end
  end
end

local function DelCountDownTimer(self)
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

local function ClearScroll(self)
  self.missionContent:RemoveComponents(UIStageMissionItem)
  self.missionScroll:ClearAllItems()
  self.missionItems = {}
end

local function ShowReward(self, itemList)
  self.giftPackContentScrollContent:RemoveComponents(UIGiftPackContentItem)
  self.giftPackItem_prefab.gameObject:GameObjectRecycleAll()
  local list = itemList
  if list ~= nil then
    for i = 1, table.length(list) do
      local item = self.giftPackItem_prefab:GameObjectSpawn(self.giftPackContentScrollContent.transform)
      item.name = tostring(i)
      local cell = self.giftPackContentScrollContent:AddComponent(UIGiftPackContentItem, item.name, list[i])
      cell:SetData(list[i])
    end
  end
end

local function ResizeTip(self, rewards)
  local height = 80
  if rewards then
    height = height + 82 * table.length(rewards) + 5 * (table.length(rewards) - 1)
  end
  if 586 < height then
    height = 586
  end
  self.giftPackContentTipBg.rectTransform:Set_sizeDelta(432, height)
  self.giftPackContentScrollContent.rectTransform:Set_localPosition(0, 0, 0)
end

local function ShowTip(self, pos)
  self.giftPackContent:SetActive(true)
  self.giftPackContentTip.transform.position = pos
  if self.giftPackData then
    local rewardItems = self.giftPackData:getItems()
    ResizeTip(self, rewardItems)
    ShowReward(self, self.giftPackData:getItems())
  else
    self:HideTip()
  end
end

local function HideTip(self)
  self.giftPackContent:SetActive(false)
end

StrongestCommanderMain.OnCreate = OnCreate
StrongestCommanderMain.OnDestroy = OnDestroy
StrongestCommanderMain.ComponentDefine = ComponentDefine
StrongestCommanderMain.ComponentDestroy = ComponentDestroy
StrongestCommanderMain.DataDefine = DataDefine
StrongestCommanderMain.DataDestroy = DataDestroy
StrongestCommanderMain.OnAddListener = OnAddListener
StrongestCommanderMain.OnRemoveListener = OnRemoveListener
StrongestCommanderMain.OpenScoreMethodPanel = OpenScoreMethodPanel
StrongestCommanderMain.SetData = SetData
StrongestCommanderMain.RefreshAll = RefreshAll
StrongestCommanderMain.ShowTasks = ShowTasks
StrongestCommanderMain.AddCountDownTimer = AddCountDownTimer
StrongestCommanderMain.RefreshRemainTime = RefreshRemainTime
StrongestCommanderMain.DelCountDownTimer = DelCountDownTimer
StrongestCommanderMain.GetTaskListSorted = GetTaskListSorted
StrongestCommanderMain.ClearScroll = ClearScroll
StrongestCommanderMain.RefreshStageDetail = RefreshStageDetail
StrongestCommanderMain.RefreshGiftPackInfo = RefreshGiftPackInfo
StrongestCommanderMain.SelectStage = SelectStage
StrongestCommanderMain.RefreshStageToggle = RefreshStageToggle
StrongestCommanderMain.RefreshStageRedPoint = RefreshStageRedPoint
StrongestCommanderMain.OnGiftPackUpdate = OnGiftPackUpdate
StrongestCommanderMain.ShowTip = ShowTip
StrongestCommanderMain.HideTip = HideTip
return StrongestCommanderMain
