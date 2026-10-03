local base = UIBaseContainer
local LWSeasonSpreadVirusView = BaseClass("LWSeasonSpreadVirusView", base)
local LWSeasonSpreadVirusTaskItem = require("UI.LWSeason1.LWSeasonSpreadVirus.Component.LWSeasonSpreadVirusTaskItem")
local Localization = CS.GameEntry.Localization
local txt_collect_count_path = "Content/Bottom/ItemPanel/txt_collect_count"
local txt_remainTime_path = "Content/Detail/ContentTime/TimeTextBg/remainTime"
local go_UICommonResItem_path = "Content/Bottom/ItemPanel/UICommonResItem"
local sv_sv_path = "Bottom2/ContentPanel/sv"
local txt_title_path = "Content/Detail/txt_title"
local btn_IntroBtn_path = "Content/Detail/IntroBtn"
local txt_ContentDes_path = "Content/Detail/ContentDes"

function LWSeasonSpreadVirusView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWSeasonSpreadVirusView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonSpreadVirusView:ComponentDefine()
  self.txt_collect_count = self:AddComponent(UIText, txt_collect_count_path)
  self.txt_remainTime = self:AddComponent(UIText, txt_remainTime_path)
  self.go_UICommonResItem = self:AddComponent(UICommonResItem, go_UICommonResItem_path)
  self.sv_sv = self:AddComponent(UIScrollView, sv_sv_path)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.btn_IntroBtn = self:AddComponent(UIButton, btn_IntroBtn_path)
  self.txt_ContentDes = self:AddComponent(UIText, txt_ContentDes_path)
  self.sv_sv:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.sv_sv:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
  
  self.btn_IntroBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTip()
  end)
end

function LWSeasonSpreadVirusView:ComponentDestroy()
  self.txt_collect_count = nil
  self.txt_remainTime = nil
  self.go_UICommonResItem = nil
  self.sv_sv = nil
  self.txt_title = nil
  self.btn_IntroBtn = nil
  self.txt_ContentDes = nil
  self.timer_action = nil
  self.activityId = nil
  self.data = nil
  self:DeleteTimer()
end

function LWSeasonSpreadVirusView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.RefreshView)
  self:AddUIListener(EventId.MainTaskSuccess, self.RefreshView)
  self:AddUIListener(EventId.RefreshLimitedDropWayNum, self.RefreshView)
end

function LWSeasonSpreadVirusView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.RefreshView)
  self:RemoveUIListener(EventId.MainTaskSuccess, self.RefreshView)
  self:RemoveUIListener(EventId.RefreshLimitedDropWayNum, self.RefreshView)
  base.OnRemoveListener(self)
end

function LWSeasonSpreadVirusView:ClickTip()
  if self.showDatalist and #self.showDatalist > 0 then
    local dataList = {}
    for i, v in ipairs(self.showDatalist) do
      if 0 < v.drop_info_para then
        table.insert(dataList, v)
      end
    end
    local param = {}
    param.activityId = self.activityId
    param.dataList = dataList
    param.season = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.LimitedTimeFeastNotice, {anim = true}, param)
  end
end

function LWSeasonSpreadVirusView:SetData(activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.data == nil then
    return
  end
  if self.data then
    local name = Localization:GetString(self.data.name)
    self.txt_title:SetText(name)
    self.txt_ContentDes:SetLocalText(self.data.bannerTittle)
    self:AddTimer(self.data)
  end
  self.startTime = self.data.startTime
  self.endTime = self.data.endTime
  self:RefreshView()
  self:RefreshTime()
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.activityId))
end

function LWSeasonSpreadVirusView:ClearScroll()
  self.sv_sv:ClearCells()
  self.sv_sv:RemoveComponents(LWSeasonSpreadVirusTaskItem)
  self.showDatalist = {}
end

function LWSeasonSpreadVirusView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.sv_sv:AddComponent(LWSeasonSpreadVirusTaskItem, itemObj)
  cellItem:SetData(self.showDatalist[index], self.activityId)
end

function LWSeasonSpreadVirusView:OnItemMoveOut(itemObj, index)
  self.sv_sv:RemoveComponent(itemObj.name, LWSeasonSpreadVirusTaskItem)
end

function LWSeasonSpreadVirusView:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function LWSeasonSpreadVirusView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function LWSeasonSpreadVirusView:RefreshTime()
  local data = self.data
  if data then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.startTime then
      deltaTime = self.startTime - curTime
    elseif curTime < self.endTime then
      deltaTime = self.endTime - curTime
    end
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.txt_remainTime:SetText(showTime)
    else
      self.txt_remainTime:SetText("00:00:00")
      self:DeleteTimer()
    end
  else
    self:DeleteTimer()
  end
end

function LWSeasonSpreadVirusView:RefreshView()
  if not self.activityId then
    return
  end
  if self.data == nil then
    return
  end
  self:ClearScroll()
  self.sv_sv:SetActive(true)
  self.showDatalist = self:CreateMethodsData()
  if #self.showDatalist > 0 then
    self.sv_sv:SetTotalCount(#self.showDatalist)
    self.sv_sv:RefillCells()
  else
    self.sv_sv:SetActive(false)
  end
  local str = string.split(self.data.para_2, "|")
  local itemData = {}
  itemData.rewardType = RewardType.GOODS
  itemData.itemId = tonumber(str[1])
  self.go_UICommonResItem:ReInit(itemData)
  local cur, max = DataCenter.ActLimitedTimeFeastData:GetCurAndMax(tonumber(self.activityId))
  self.txt_collect_count:SetLocalText("135225", cur, max)
end

function LWSeasonSpreadVirusView:CreateMethodsData()
  if self.data then
    local dropId = self.data.subType
    local showDatalist = {}
    local methodsData = DataCenter.ActivityDropTemplateManager:GetTemplatesByDropId(dropId)
    for i = 1, #methodsData do
      local dropWayInfo = DataCenter.ActLimitedTimeFeastData:GetDropInfoById(tonumber(self.activityId), methodsData[i].id)
      if dropWayInfo then
        table.insert(showDatalist, methodsData[i])
      end
    end
    return showDatalist
  end
end

return LWSeasonSpreadVirusView
