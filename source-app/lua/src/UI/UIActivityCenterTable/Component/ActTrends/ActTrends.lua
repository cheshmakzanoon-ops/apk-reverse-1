local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ActTrends = BaseClass("ActTrends", base)
local Localization = CS.GameEntry.Localization
local trendsItem = require("UI.UIActivityCenterTable.Component.ActTrends.ActTrendsItem")
local ActTrendsWeekInfo = require("UI.UIActivityCenterTable.Component.ActTrends.ActTrendsWeekInfo")
local scroll_path = "Root/Container/ScrollView"
local group_flag_path = "Root/weekRoot/flag"
local group_btn_path = "Root/weekRoot/btns/btn"
local group_root_path = "Root/weekRoot"
local btnList_root_path = "Root/weekRoot/btns"
local week_info_path = "Root/weekRoot/WeekInfo"
local story_content_path = "Root/StoryContent"
local story_btn_path = "Root/StoryContent/storyBtn"
local group_count = 4

function ActTrends:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.trendsData = nil
  self.groupIndex = nil
  self.maxTabIndex = 0
end

function ActTrends:OnDestroy()
  self.groupIndex = nil
  self.trendsData = nil
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActTrends:OnEnable()
  base.OnEnable(self)
end

function ActTrends:OnDisable()
  base.OnDisable(self)
end

function ActTrends:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWActTrendDataInit, self.LWActTrendDataChange)
  self:AddUIListener(EventId.LWActTrendsRewardRedPoint, self.UpdateRedPoint)
end

function ActTrends:OnRemoveListener()
  self:RemoveUIListener(EventId.LWActTrendDataInit, self.LWActTrendDataChange)
  self:RemoveUIListener(EventId.LWActTrendsRewardRedPoint, self.UpdateRedPoint)
  base.OnRemoveListener(self)
end

function ActTrends:ComponentDefine()
  self.groupIndexBtnTable = {}
  for i = 1, group_count do
    local btn = self:AddComponent(UIButton, group_btn_path .. i)
    local red_point = btn:AddComponent(UIImage, "RedPoint")
    local red_num = btn:AddComponent(UIText, "RedPoint/RedNum")
    btn:SetOnClick(BindCallback(self, self.GroupIndexBtnClick, i))
    self.groupIndexBtnTable[i] = {
      btn = btn,
      redRoot = red_point,
      redNum = red_num
    }
  end
  self.groupRoot = self:AddComponent(UIBaseContainer, group_root_path)
  self.btnList = self:AddComponent(UIBaseContainer, btnList_root_path)
  self.groupFlag = self:AddComponent(UIBaseContainer, group_flag_path)
  self.groupFlag:SetActive(false)
  self.itemScroll = self:AddComponent(UIScrollView, scroll_path)
  self.itemScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.itemScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.week_info = self:AddComponent(ActTrendsWeekInfo, week_info_path)
  self.story_content = self:AddComponent(UIBaseContainer, story_content_path)
  self.story_btn = self:AddComponent(UIButton, story_btn_path)
  self.story_btn:SetOnClick(function()
    self:OnStoryBtnClick()
  end)
end

function ActTrends:ComponentDestroy()
  self.groupFlag = nil
  self.week_info = nil
  self.groupIndexBtnTable = nil
  self.trendsData = nil
  self.itemScroll = nil
  self.groupRoot = nil
  self.jumpId = nil
  self.story_content = nil
  self.story_btn = nil
end

function ActTrends:SetData(activityId, activityData, groupIndex, jumpId)
  base.SetData(self, activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  if self.activityInfo ~= nil and not string.IsNullOrEmpty(self.activityInfo.plot) then
    local key = "S1_PlayPlot_" .. self.activityId
    local cache = Setting:GetPrivateString(key)
    if cache ~= "ok" then
      self:PlayCgOrPlot()
      Setting:SetPrivateString(key, "ok")
    end
  end
  self.maxTabIndex = group_count
  self.jumpId = nil
  self.groupIndex = -1
  local curGroupIndex = 1
  local trendStartTime = DataCenter.ActTrendsDataManager:GetTrendsStartTime()
  if 0 < trendStartTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    curGroupIndex = math.floor((curTime - trendStartTime) / 604800000) + 1
  end
  if curGroupIndex > group_count then
    curGroupIndex = group_count
  end
  self.maxTabIndex = curGroupIndex + 1
  if self.maxTabIndex > group_count then
    self.maxTabIndex = group_count
  end
  if groupIndex then
    self:GroupIndexBtnClick(groupIndex)
    self.groupIndex = groupIndex
  else
    local targetGroupIndex = curGroupIndex
    self:GroupIndexBtnClick(targetGroupIndex)
    self.groupIndex = targetGroupIndex
  end
  if jumpId then
    self.jumpId = jumpId
  end
  if self.activityInfo.plot then
    self.story_content:SetActive(true)
  else
    self.story_content:SetActive(false)
  end
  SFSNetwork.SendMessage(MsgDefines.ActivityTrendInfo, self.activityId)
end

function ActTrends:UpdateRedPoint()
  if self.groupIndexBtnTable then
    for groupIndex, v in pairs(self.groupIndexBtnTable) do
      if v and v.btn and v.redRoot and v.redNum then
        local num = DataCenter.ActTrendsDataManager:GetTrendsDataRedPointCount(groupIndex)
        if num then
          v.redRoot:SetActive(0 < num)
          v.redNum:SetText(num)
        else
          v.redRoot:SetActive(false)
        end
      end
    end
  end
end

function ActTrends:ClearScroll()
  self.itemScroll:ClearCells()
  self.itemScroll:RemoveComponents(trendsItem)
end

function ActTrends:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local trendsData = self.trendsData[index]
  local cellItem = self.itemScroll:AddComponent(trendsItem, itemObj)
  cellItem:SetActTrendsItem(trendsData, index)
end

function ActTrends:OnItemMoveOut(itemObj, index)
  self.itemScroll:RemoveComponent(itemObj.name, trendsItem)
end

function ActTrends:RefreshList()
  self.trendsData = DataCenter.ActTrendsDataManager:GetTrendsData(self.groupIndex)
  if self.trendsData then
    local dataCount = #self.trendsData
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local startIndex = 1
    if self.jumpId then
      for index, value in ipairs(self.trendsData) do
        if self.jumpId == value.config_id then
          startIndex = index
          break
        end
      end
      self.jumpId = nil
    else
      for index, value in ipairs(self.trendsData) do
        if curTime >= value.start_time and curTime < value.end_time then
          startIndex = index
          break
        end
      end
    end
    self.itemScroll:SetTotalCount(dataCount)
    self.itemScroll:RefillCells(1, true)
    if 1 < startIndex then
      self.itemScroll:ScrollToCell(startIndex, 200000)
    end
  else
    self:ClearScroll()
  end
  self:UpdateRedPoint()
end

function ActTrends:GroupIndexBtnClick(index, force)
  if index <= self.maxTabIndex then
    local flag = false
    if DataCenter.ActTrendsDataManager:IsInitData() and self.groupIndex ~= index or force then
      local parent = self.week_info:GetDayTrans(index)
      self.groupFlag:SetActive(true)
      self.groupFlag.transform:SetParent(parent.transform)
      self.groupFlag:SetAnchoredPositionXY(0, 3)
      self.groupFlag.transform:SetParent(self.groupRoot.transform)
      self.btnList.transform:SetAsLastSibling()
      self.groupIndex = index
      flag = true
    end
    if flag or force then
      self:RefreshList()
    end
  else
    local strTips = Localization:GetString("801141")
    UIUtil.ShowTips(strTips)
  end
end

function ActTrends:LWActTrendDataChange()
  self:GroupIndexBtnClick(self.groupIndex, true)
end

function ActTrends:OnStoryBtnClick()
  self:PlayCgOrPlot()
end

function ActTrends:PlayCgOrPlot()
  if not self.activityInfo then
    Logger.LogError("ActTrends:OnStoryBtnClick activityInfo is null")
    return
  end
  local plotInfo = self.activityInfo.plot
  if string.IsNullOrEmpty(plotInfo) then
    Logger.LogError("ActTrends:OnStoryBtnClick plotInfo is null")
    return
  end
  local data = self:ParsePlotStr(plotInfo)
  
  local function playPlotFunc()
    if data.plotId and data.plotId > 0 then
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
        plotGroupId = data.plotId,
        hideMainUI = false
      })
    end
  end
  
  if string.IsNullOrEmpty(data.cgPath) then
    playPlotFunc()
    return
  end
  local params = {}
  params.path = data.cgPath
  params.onVideoCloseCallback = playPlotFunc
  UIManager:GetInstance():OpenWindow(UIWindowNames.FullScreenVideoView, {anim = true}, params)
end

function ActTrends:ParsePlotStr(plotStr)
  if not plotStr then
    return nil
  end
  local data = {}
  local plotStrArr = string.split(plotStr, "|")
  if #plotStrArr <= 1 then
    data.plotId = tonumber(plotStr)
    return data
  end
  data.plotId = tonumber(plotStrArr[1])
  data.cgPath = plotStrArr[2]
  return data
end

return ActTrends
