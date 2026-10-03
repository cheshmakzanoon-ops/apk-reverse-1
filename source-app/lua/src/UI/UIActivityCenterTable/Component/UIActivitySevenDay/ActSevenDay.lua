local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ActSevenDay = BaseClass("ActSevenDay", base)
local UIActivitySevenDayBoxItem = require("UI.UIActivityCenterTable.Component.UIActivitySevenDay.ActSevenDayBoxItem")
local UIActivitySevenDayItem = require("UI.UIActivityCenterTable.Component.UIActivitySevenDay.ActSevenDayItem")
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local Localization = CS.GameEntry.Localization
local boxItemPath = "RightView/Rect_Top/ProgressContent/RewardContent/UIActivitySevenDayBoxItem%s"

function ActSevenDay:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.taskList = {}
  self.dayTabIndex = 1
  self.childTabIndex = 1
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

function ActSevenDay:ComponentDefine()
  self._title_txt = self:AddComponent(UIText, "RightView/Rect_Top/Txt_Title")
  self._time_txt = self:AddComponent(UIText, "RightView/Rect_Top/Txt_Time")
  self._init_txt = self:AddComponent(UIText, "RightView/Rect_Top/inteText")
  self._init_txt:SetLocalText(100105)
  self._progress_bg = self:AddComponent(UIImage, "RightView/Rect_Top/Progress_Bg")
  self._progress_txt = self:AddComponent(UIText, "RightView/Rect_Top/ProgressContent/Icon/Txt_Progress")
  self._progress_slider = self:AddComponent(UISlider, "RightView/Rect_Top/ProgressContent/Slider")
  self.box_rectTab = self:AddComponent(UIActivitySevenDayBoxItem, "RightView/iconCell/Img_Iconbg1/UICommonResItem1")
  self.box_rectTabEffect = self:AddComponent(UIAnimator, "RightView/iconCell/Img_Iconbg1/SevenDayBoxEffect1/Rect_Effect1/Rect_anim1")
  self.boxItemList = {}
  for i = 1, 6 do
    local boxItem = self:AddComponent(UIActivitySevenDayBoxItem, string.format(boxItemPath, i))
    boxItem.transform:Set_localScale(0.6, 0.6, 1)
    table.insert(self.boxItemList, boxItem)
  end
  self.hero_btn = self:AddComponent(UIButton, "RightView/iconCell/Rect_Hero1")
  self.hero_rect = self:AddComponent(UIHeroCellSmall, "RightView/iconCell/Rect_Hero1/UIHeroCellSmall1")
  self.hero_rece = self:AddComponent(UIImage, "RightView/iconCell/Rect_Hero1/ImgRece1")
  self.hero_effect = self:AddComponent(UIAnimator, "RightView/iconCell/Rect_Hero1/SevenDayHeroEffect1/Rect_Effect1/Rect_anim_h1")
  self.hero_btn:SetOnClick(function()
    self:OnHeroBtnClick()
  end)
  self.day_togTab = {}
  self.day_togTabRed = {}
  self.day_togTabBack = {}
  for i = 1, 5 do
    local togglepath = "RightView/Rect_Top/Rect_Group/Toggle_Tab" .. i
    local txtpath = "RightView/Rect_Top/Rect_Group/Toggle_Tab" .. i .. "/Rect_Lock/Txt_Toggle" .. i
    local lockpath = "RightView/Rect_Top/Rect_Group/Toggle_Tab" .. i .. "/Rect_Lock/Img_Lock" .. i
    self.day_togTabRed[i] = self:AddComponent(UIImage, "RightView/Rect_Top/Rect_Group/Toggle_Tab" .. i .. "/Red" .. i)
    self.day_togTabBack[i] = self:AddComponent(UIImage, "RightView/Rect_Top/Rect_Group/Toggle_Tab" .. i .. "/Background" .. i)
    self.day_togTab[i] = {
      toggle = self:AddComponent(UIToggle, togglepath),
      txt = self:AddComponent(UIText, txtpath),
      lock = self:AddComponent(UIImage, lockpath)
    }
  end
  for i = 1, 5 do
    self.day_togTab[i].toggle:SetOnValueChanged(function(tf)
      if tf then
        self.content:SetAnchoredPosition(Vector2.New(0, 0))
        self:ToggleControl(i)
      end
    end)
  end
  self.listDay_togTab = {}
  for i = 1, 3 do
    local togglepath = "RightView/Rect_Bottom/Rect_List/Toggle_List" .. i
    local txtpath = "RightView/Rect_Bottom/Rect_List/Toggle_List" .. i .. "/Txt_ListToggle" .. i
    local red = "RightView/Rect_Bottom/Rect_List/Toggle_List" .. i .. "/Img_RedList" .. i
    self.listDay_togTab[i] = {
      toggle = self:AddComponent(UIToggle, togglepath),
      txt = self:AddComponent(UIText, txtpath),
      red = self:AddComponent(UIImage, red)
    }
  end
  for i = 1, 3 do
    self.listDay_togTab[i].toggle:SetOnValueChanged(function(tf)
      if tf then
        local isOn = self.listDay_togTab[i].toggle:GetIsOn()
        if isOn then
          self.content:SetAnchoredPosition(Vector2.New(0, 0))
          if self.childTabIndex ~= i then
            self.childTabIndex = i
            self:RefreshSelectData(i)
          end
        end
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
  self.banner = self:AddComponent(UIRawImage, "ImageBg2")
  self.scoreIcon = self:AddComponent(UIImage, "RightView/Rect_Top/ProgressContent/Icon")
end

function ActSevenDay:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  self.define = nil
  self.taskList = nil
  self.dayTabIndex = nil
  self.childTabIndex = nil
  self.timer_action = nil
  self:DeleteTimer()
  base.OnDestroy(self)
end

function ActSevenDay:ComponentDestroy()
  self.boxItemList = nil
  self._time_txt = nil
  self._progress_bg = nil
  self._progress_txt = nil
  self._box_rectTab = nil
  self.day_togTab = nil
  self.listDay_togTab = nil
  self._hero_rect = nil
  self.content = nil
  self.box_rectTabEffect = nil
  self.box_rectTab = nil
  self.hero_btn = nil
  self.hero_rect = nil
  self.hero_rece = nil
  self.hero_effect = nil
  self.hero_btn = nil
  self.detailInfoBtn = nil
  self.banner = nil
end

function ActSevenDay:OnEnable()
  base.OnEnable(self)
end

function ActSevenDay:OnDisable()
  base.OnDisable(self)
end

function ActSevenDay:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MainTaskSuccess, self.UpdateTaskState)
  self:AddUIListener(EventId.ActSevenDay, self.RefreshUI)
  self:AddUIListener(EventId.ActSevenDayScore, self.UpdateRewardScore)
end

function ActSevenDay:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MainTaskSuccess, self.UpdateTaskState)
  self:RemoveUIListener(EventId.ActSevenDay, self.RefreshUI)
  self:RemoveUIListener(EventId.ActSevenDayScore, self.UpdateRewardScore)
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

function ActSevenDay:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  SFSNetwork.SendMessage(MsgDefines.GetSevenDayActInfo, activityId)
  self.actListData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(activityId))
  self._title_txt:SetLocalText(self.actListData.name)
  if not string.IsNullOrEmpty(self.actListData.activity_pic) then
  end
  self.scoreIcon:LoadSprite(GetScoreIcon(self))
end

function ActSevenDay:UpdateTaskState()
  self.sevenDayInfo = DataCenter.ActSevenDayData:GetInfoByActId(tonumber(self.activityId))
  if not table.IsNullOrEmpty(self.sevenDayInfo) then
    self.sevenDayInfo:CheckRedDot()
    self:RedDayRefresh()
    self:RefreshSelectData()
  end
end

function ActSevenDay:UpdateRewardScore()
  self.sevenDayInfo = DataCenter.ActSevenDayData:GetInfoByActId(tonumber(self.activityId))
  self:RedListDayRefresh()
  self:SetSliderValue()
end

function ActSevenDay:SendData()
  SFSNetwork.SendMessage(MsgDefines.UserDayActInfo)
end

function ActSevenDay:RefreshUI()
  self.sevenDayInfo = DataCenter.ActSevenDayData:GetInfoByActId(tonumber(self.activityId))
  if self.sevenDayInfo then
    self.sevenDayInfo:CalculateDate()
  end
  self:RefreshTime()
  self:AddTimer()
  for i = 1, #self.sevenDayInfo.dayActs do
    self.day_togTab[i].txt:SetLocalText(self.sevenDayInfo.dayActs[i][1].type1_text)
    if i <= self.sevenDayInfo.days then
      self.day_togTab[i].txt:SetColor(Color.New(1, 1, 1, 1))
      self.day_togTab[i].lock:SetActive(false)
    else
      self.day_togTab[i].txt:SetColor(Color.New(0.8588, 0.8549, 0.8627, 1))
      self.day_togTab[i].lock:SetActive(true)
    end
    if i == 1 then
      self.day_togTabBack[i]:LoadSprite(string.format(LoadPath.UIActivity, "lyp_huodong_7tianle_yeqian_4"))
    elseif 2 <= i and i <= 4 then
      self.day_togTabBack[i]:LoadSprite(string.format(LoadPath.UIActivity, "lyp_huodong_7tianle_yeqian_5"))
    elseif i == 5 then
      self.day_togTabBack[i]:LoadSprite(string.format(LoadPath.UIActivity, "lyp_huodong_7tianle_yeqian_6"))
    end
    self.day_togTabBack[i]:SetNativeSize()
  end
  self.sevenDayInfo:CheckRedDot()
  self:RedDayRefresh()
  local last = DataCenter.ActSevenDayData:GetLastVisitTab(tonumber(self.activityId))
  if last and next(last) then
    self.dayTabIndex = last[1]
    self.childTabIndex = last[2]
  else
    self.dayTabIndex = 1
    self.childTabIndex = 1
  end
  self.day_togTab[self.dayTabIndex].toggle:SetIsOn(true)
  self.listDay_togTab[self.childTabIndex].toggle:SetIsOn(true)
  self:SetSliderValue()
  self:RefreshSelectData()
end

function ActSevenDay:SetBoxItem(i)
  if self.sevenDayInfo.scoreReward[i].reward[1].rewardType == RewardType.HERO then
    self.hero_btn:SetActive(true)
    self.hero_rect:InitWithConfigId(self.sevenDayInfo.scoreReward[i].reward[1].itemId)
    self.hero_rece:SetActive(self.sevenDayInfo.scoreReward[i].rewardFlag == 1)
    self.hero_effect:SetActive(false)
    if self.sevenDayInfo.scoreReward[i].rewardFlag == 0 then
      self._hero_effect:SetActive(self.sevenDayInfo.score >= self.sevenDayInfo.scoreReward[i].needScore)
    end
  else
    self.hero_btn:SetActive(false)
    self.box_rectTabEffect:SetActive(false)
    self.box_rectTabEffect:Enable(false)
    self.box_rectTab:RefreshData(i, self.sevenDayInfo.scoreReward[i], self.sevenDayInfo.score, self.box_rectTabEffect, tonumber(self.activityId))
  end
end

function ActSevenDay:SetSliderValue()
  local count = #self.sevenDayInfo.scoreReward
  local hasNextItem = false
  for i = 1, count do
    if self.sevenDayInfo.scoreReward[i].rewardFlag == 0 then
      self:SetBoxItem(i)
      hasNextItem = true
      self.nextBoxItemId = i
      break
    end
  end
  if not hasNextItem then
    self.hero_btn:SetActive(false)
  end
  for k, v in ipairs(self.boxItemList) do
    v:RefreshData(k, self.sevenDayInfo.scoreReward[k], self.sevenDayInfo.score, self.box_rectTabEffect, tonumber(self.activityId))
  end
  local haveReachedIndex = 0
  local nextIndex = 0
  for k, v in ipairs(self.boxItemList) do
    if self.sevenDayInfo.score >= self.sevenDayInfo.scoreReward[k].needScore then
      haveReachedIndex = k
    else
      nextIndex = k
      break
    end
  end
  self._progress_txt:SetText(string.format("%d/%d", self.sevenDayInfo.score, self.sevenDayInfo.scoreReward[count].needScore))
  if nextIndex == 0 then
    self._progress_slider:SetValue(1)
  else
    local curStageScore = 0
    if 0 < haveReachedIndex then
      curStageScore = self.sevenDayInfo.scoreReward[haveReachedIndex].needScore
    end
    local nextStageScore = self.sevenDayInfo.scoreReward[nextIndex].needScore
    self._progress_slider:SetValue(haveReachedIndex / count + (self.sevenDayInfo.score - curStageScore) / (nextStageScore - curStageScore) / count)
  end
end

function ActSevenDay:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function ActSevenDay:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function ActSevenDay:RefreshTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.sevenDayInfo.endTime then
    self._time_txt:SetText("")
    self:DeleteTimer()
  else
    self._time_txt:SetLocalText(2000044, UITimeManager:GetInstance():MilliSecondToFmtString(self.sevenDayInfo.endTime - curTime))
  end
end

function ActSevenDay:ToggleControl(index)
  if self.sevenDayInfo and index > self.sevenDayInfo.days then
    UIUtil.ShowTipsId(2000012)
    if self.dayTabIndex then
      self.day_togTab[self.dayTabIndex].toggle:SetIsOn(true)
    end
    self.day_togTab[index].toggle:SetIsOn(false)
    return
  end
  local isOn = self.day_togTab[index].toggle:GetIsOn()
  if isOn and self.dayTabIndex ~= index then
    self.dayTabIndex = index
    if self.childTabIndex ~= 1 then
      self.childTabIndex = 1
      self.listDay_togTab[1].toggle:SetIsOn(true)
    end
    self:RefreshSelectData()
  end
end

function ActSevenDay:RefreshSelectData()
  if self.sevenDayInfo == nil then
    return
  end
  for i = 1, 3 do
    if i == self.childTabIndex then
      self.listDay_togTab[i].txt:SetColor(Color.New(0.1647, 0.1569, 0.1882, 1))
    else
      self.listDay_togTab[i].txt:SetColor(Color.New(0.4667, 0.4431, 0.4431, 1))
    end
  end
  local tasks = self.sevenDayInfo.dayActs[self.dayTabIndex][self.childTabIndex].tasks
  self.taskList = self.sevenDayInfo:SortTask(tasks)
  for i = 1, 3 do
    self.listDay_togTab[i].txt:SetLocalText(self.sevenDayInfo.dayActs[self.dayTabIndex][i].type2_text)
  end
  self:RedListDayRefresh()
  self:SetItemData()
end

function ActSevenDay:SetAllCellDestroy()
  self.content:RemoveComponents(UIActivitySevenDayItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function ActSevenDay:SetItemData()
  self:SetAllCellDestroy()
  self.model = {}
  local scoreIcon = GetScoreIcon(self)
  if next(self.taskList) then
    for i = 1, table.length(self.taskList) do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UIActivitySevenDayItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = i
        self.taskList[i].flyPos = self.gameObject.transform:Find("RightView/Rect_Top/inteCoin")
        self.taskList[i].day = self.dayTabIndex
        local cell = self.content:AddComponent(UIActivitySevenDayItem, go.name)
        cell:RefreshData(self.taskList[i], self.sevenDayInfo.days, scoreIcon)
      end)
    end
  end
end

function ActSevenDay:OnHeroBtnClick()
  if self.nextBoxItemId == nil then
    return
  end
  local rewardData = self.sevenDayInfo.scoreReward[self.nextBoxItemId]
  if rewardData.rewardFlag == 0 and self.sevenDayInfo.score >= rewardData.needScore then
    self.view.ctrl:GetSevenDayBoxReward(self.nextBoxItemId)
    return
  end
end

function ActSevenDay:RedDayRefresh()
  local redData = self.sevenDayInfo.taskRed
  for i = 1, #redData do
    self.day_togTabRed[i]:SetActive(false)
    for j = 1, #redData[i] do
      if redData[i][j] == 1 then
        self.day_togTabRed[i]:SetActive(true)
        local tab = DataCenter.ActSevenDayData:GetLastVisitTab(tonumber(self.activityId))
        if tab == nil or not next(tab) then
          DataCenter.ActSevenDayData:SetLastVisitTab(tonumber(self.activityId), {i, j})
        end
        break
      end
    end
  end
end

function ActSevenDay:RedListDayRefresh()
  local redData = self.sevenDayInfo.taskRed
  for i = 1, 3 do
    if i <= #redData[self.dayTabIndex] then
      self.listDay_togTab[i].red:SetActive(redData[self.dayTabIndex][i] == 1)
    else
      self.listDay_togTab[i].red:SetActive(false)
    end
  end
end

return ActSevenDay
