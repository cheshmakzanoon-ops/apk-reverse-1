local LWSeasonTrendsMainView = BaseClass("LWSeasonTrendsMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local trendsItem = require("UI.LWSeason.LWSeasonTrends.Component.LWSeasonTrendsItem")
local LWSeasonWeekInfo = require("UI.LWSeason.LWSeasonWeekInfo")
local btn_back_path = "Root/BottomBar/BtnBack"
local scroll_path = "Root/Container/ScrollView"
local group_flag_path = "Root/weekRoot/flag"
local group_btn_path = "Root/weekRoot/btns/btn"
local group_root_path = "Root/weekRoot"
local btnList_root_path = "Root/weekRoot/btns"
local week_info_path = "Root/weekRoot/WeekInfo"
local group_count = 8

function LWSeasonTrendsMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.trendsData = nil
  self.groupIndex = nil
  self.maxTabIndex = 0
end

function LWSeasonTrendsMainView:OnDestroy()
  self.groupIndex = nil
  self.trendsData = nil
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonTrendsMainView:OnEnable()
  base.OnEnable(self)
  local getUserData, jumpId = self:GetUserData()
  local season, seasonWeek = DataCenter.SeasonDataManager:GetSeasonWeekInfo()
  self.maxTabIndex = seasonWeek + 1
  self.jumpId = jumpId
  if getUserData and getUserData <= self.maxTabIndex and 0 < getUserData then
    if getUserData < 1 then
      getUserData = 1
    elseif getUserData > group_count then
      getUserData = group_count
    end
    self:GroupIndexBtnClick(getUserData)
    self.groupIndex = getUserData
  else
    if seasonWeek < 1 then
      seasonWeek = 1
    elseif seasonWeek > group_count then
      seasonWeek = group_count
    end
    self:GroupIndexBtnClick(seasonWeek)
    self.groupIndex = seasonWeek
  end
  SFSNetwork.SendMessage(MsgDefines.LwSeasonTrendInfo)
end

function LWSeasonTrendsMainView:OnDisable()
  base.OnDisable(self)
end

function LWSeasonTrendsMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonTrendDataInit, self.LWSeasonTrendDataChange)
  self:AddUIListener(EventId.LWSeasonTrendsRewardRedPoint, self.UpdateRedPoint)
end

function LWSeasonTrendsMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonTrendDataInit, self.LWSeasonTrendDataChange)
  self:RemoveUIListener(EventId.LWSeasonTrendsRewardRedPoint, self.UpdateRedPoint)
  base.OnRemoveListener(self)
end

function LWSeasonTrendsMainView:ComponentDefine()
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
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.itemScroll = self:AddComponent(UIScrollView, scroll_path)
  self.itemScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.itemScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.week_info = self:AddComponent(LWSeasonWeekInfo, week_info_path)
end

function LWSeasonTrendsMainView:ComponentDestroy()
  self.groupFlag = nil
  self.week_info = nil
  self.groupIndexBtnTable = nil
  self.trendsData = nil
  self.btn_back = nil
  self.itemScroll = nil
  self.groupRoot = nil
  self.jumpId = nil
end

function LWSeasonTrendsMainView:UpdateRedPoint()
  if self.groupIndexBtnTable then
    for groupIndex, v in pairs(self.groupIndexBtnTable) do
      if v and v.btn and v.redRoot and v.redNum then
        local num = DataCenter.LWSeasonTrendsManager:GetTrendsDataRedPointCount(groupIndex)
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

function LWSeasonTrendsMainView:ClearScroll()
  self.itemScroll:ClearCells()
  self.itemScroll:RemoveComponents(trendsItem)
end

function LWSeasonTrendsMainView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local trendsData = self.trendsData[index]
  local cellItem = self.itemScroll:AddComponent(trendsItem, itemObj)
  cellItem:SetSeasonTrendsItem(trendsData, index)
  cellItem:SetActive(true)
end

function LWSeasonTrendsMainView:OnItemMoveOut(itemObj, index)
  self.itemScroll:RemoveComponent(itemObj.name, trendsItem)
end

function LWSeasonTrendsMainView:RefreshList()
  self.trendsData = DataCenter.LWSeasonTrendsManager:GetTrendsData(self.groupIndex)
  if self.trendsData then
    local dataCount = #self.trendsData
    self.dataCountNow = dataCount
    self.itemScroll:SetTotalCount(dataCount)
    self.itemScroll:RefillCells(1, true)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.itemScroll ~= nil then
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
        if 1 < startIndex then
          self.itemScroll:ScrollToCell(startIndex, 200000)
        end
      end
    end, 0.1)
    local queryList = {}
    for _, value in ipairs(self.trendsData) do
      table.insert(queryList, toInt(value.config_id))
    end
    if 0 < #queryList then
      DataCenter.LWSeasonTrendsManager:FetchTrendFirstRank(queryList)
    end
  else
    self:ClearScroll()
  end
end

function LWSeasonTrendsMainView:GroupIndexBtnClick(index, force)
  if index <= self.maxTabIndex or CS.CommonUtils.IsDebug() then
    local flag = false
    local groupIndexNow = self.groupIndex
    if DataCenter.LWSeasonTrendsManager:IsInitData() and self.groupIndex ~= index or force then
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
      if force and groupIndexNow == index and self.groupIndex then
        self.trendsData = DataCenter.LWSeasonTrendsManager:GetTrendsData(self.groupIndex)
        if self.trendsData and toInt(self.dataCountNow) == #self.trendsData then
          self.itemScroll:RefreshCells()
        else
          self:RefreshList()
        end
      else
        self:RefreshList()
      end
    end
  else
    local strTips = Localization:GetString("801141")
    UIUtil.ShowTips(strTips)
  end
end

local function LWSeasonTrendDataChange(self)
  self:GroupIndexBtnClick(self.groupIndex, true)
end

LWSeasonTrendsMainView.LWSeasonTrendDataChange = LWSeasonTrendDataChange
return LWSeasonTrendsMainView
