local UILWFactionWarGroupView = BaseClass("UILWFactionWarGroupView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local UILWFactionWarGroupPage = require("UI.LWSeason4.UILWFactionWarGroup.Component.UILWFactionWarGroupPage")
local panel_path = "panel"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local page_cell_path = "PopUpTitle/ScrollView/Viewport/Content/PageCell"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local desc_text_path = "PopUpTitle/Common_img_title/descText"
local time_text_path = "PopUpTitle/Common_img_title/timeText"
local btn_prev_path = "PopUpTitle/BtnPrev"
local btn_next_path = "PopUpTitle/BtnNext"
local scroll_view_path = "PopUpTitle/ScrollView"
local icon_prev_path = "PopUpTitle/BtnPrev/IconPrev"
local icon_next_path = "PopUpTitle/BtnNext/IconNext"

function UILWFactionWarGroupView:OnCreate()
  base.OnCreate(self)
  self.PageList = nil
  self.dataCount = 0
  self:ComponentDefine()
  self:UpdateData()
end

function UILWFactionWarGroupView:OnDestroy()
  self.content:RemoveComponents(UILWFactionWarGroupPage)
  self.thePageItem:GameObjectRecycleAll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWFactionWarGroupView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.thePageItem = self.transform:Find(page_cell_path).gameObject
  self.thePageItem:GameObjectCreatePool()
  self.scroll_view = self:AddComponent(UIScrollPage, scroll_view_path)
  self.scroll_view:SetPageChangedCallback(BindCallback(self, self.OnUpdateScroll))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.btn_prev = self:AddComponent(UIButton, btn_prev_path)
  self.btn_next = self:AddComponent(UIButton, btn_next_path)
  self.icon_prev = self:AddComponent(UIImage, icon_prev_path)
  self.icon_next = self:AddComponent(UIImage, icon_next_path)
  self.btn_prev:SetOnClick(function()
    if self.scroll_view.currentPageIndex > 1 then
      self.scroll_view:SmoothScrollToPage(self.scroll_view.currentPageIndex - 1)
    end
    self:OnUpdateScroll(self.scroll_view.currentPageIndex)
  end)
  self.btn_next:SetOnClick(function()
    if self.scroll_view.currentPageIndex < self.scroll_view.cell_count then
      self.scroll_view:SmoothScrollToPage(self.scroll_view.currentPageIndex + 1)
    end
    self:OnUpdateScroll(self.scroll_view.currentPageIndex)
  end)
end

function UILWFactionWarGroupView:ComponentDestroy()
  self.btn_back = nil
  self.content = nil
  self.page_cell = nil
  self.close_btn = nil
  self.title_text = nil
  self.desc_text = nil
  self.time_text = nil
  self.btn_prev = nil
  self.btn_next = nil
  self.icon_prev = nil
  self.icon_next = nil
  self.scroll_view = nil
end

function UILWFactionWarGroupView:Update1000MS()
  if self.battleWeek ~= nil then
    local nextWeekDayTime = UITimeManager:GetInstance():GetNextWeekDay(1)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = nextWeekDayTime - curTime
    if 0 < remainTime then
      local remainTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
      self.time_text:SetLocalText("season_s4_activity_1200005_tips2", self.battleWeek, remainTimeStr, self.battleWeek + 1)
    else
      self.time_text:SetText("")
    end
  else
    self.time_text:SetText("")
  end
end

function UILWFactionWarGroupView:UpdateData()
  self.title_text:SetLocalText("season_s4_activity_1200005_tips4")
  self.desc_text:SetLocalText("season_s4_activity_1200005_tips1")
  self.time_text:SetText("")
  self.content:RemoveComponents(UILWFactionWarGroupPage)
  self.thePageItem:GameObjectRecycleAll()
  local season, seasonWeek = DataCenter.SeasonDataManager:GetSeasonWeekInfo()
  local battleWeek = seasonWeek - 3
  local factionWarActivityType = SeasonUtil.GetFactionWarActivityType()
  local dataAct = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(factionWarActivityType)
  if dataAct and dataAct.startTime then
    local actStartTime = dataAct.startTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local elapsedTime = curTime - actStartTime
    if 0 <= elapsedTime then
      battleWeek = math.floor(elapsedTime / (7 * OneDayTime * 1000)) + 1
    end
  end
  self.battleWeek = battleWeek
  local bestCountStr = LuaEntry.DataConfig:TryGetStr("s4_faction_war", "k9", "30|30|30|30")
  local itemMaxCountStr = LuaEntry.DataConfig:TryGetStr("s4_faction_war", "k10", "10|6|3|1")
  local maxCount = 100
  local groupCountSetting = LuaEntry.DataConfig:TryGetNum("s4_faction_war", "k11", "1-68;69-9999|50;100")
  local bestCountList = string.split_ii_array(bestCountStr, "|")
  local itemMaxCountList = string.split_ii_array(itemMaxCountStr, "|")
  local dataCount = math.min(#bestCountList, #itemMaxCountList)
  if groupCountSetting then
    local t1, t2 = string.split_ss(groupCountSetting, "|")
    if t1 and t2 then
      local t3 = string.split_ss_array(t1, ";")
      local t4 = string.split_ss_array(t2, ";")
      if t3 and t4 and #t3 == #t4 then
        local serverId = LuaEntry.Player:GetCurServerId()
        for index, t5 in ipairs(t3) do
          if t5 then
            local t6, t7 = string.split_ss(t5, "-")
            if serverId >= toInt(t6) and serverId <= toInt(t7) then
              maxCount = math.max(toInt(t4[index]), 50)
              break
            end
          end
        end
      end
    end
  end
  local goItem, theItem
  for i = 1, dataCount do
    goItem = self.thePageItem:GameObjectSpawn(self.content.transform)
    goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
    goItem:SetActive(true)
    theItem = self.content:AddComponent(UILWFactionWarGroupPage, goItem.name)
    theItem:ReInit(i, bestCountList[i], itemMaxCountList[i], maxCount, self.scroll_view, battleWeek)
  end
  local index = math.min(math.max(1, battleWeek), dataCount)
  self.scroll_view:SetPageCount(dataCount)
  self.scroll_view:PageTo(1)
  self:OnUpdateScroll(1)
  self:Update1000MS()
  TimerManager:GetInstance():DelayInvoke(function()
    self.scroll_view:PageTo(index)
    self:OnUpdateScroll(index)
  end, 0.1)
end

function UILWFactionWarGroupView:OnUpdateScroll(index)
  UIGray.SetGray(self.icon_prev.transform, index == 1, false)
  UIGray.SetGray(self.icon_next.transform, index == self.scroll_view.cell_count, false)
end

return UILWFactionWarGroupView
