local UIPersonalArmsCalendarExchangeView = BaseClass("UIPersonalArmsCalendarExchangeView", UIBaseView)
local base = UIBaseView
local UIPersonalArmsCalendarExchangeItem = require("UI.UIActivityPersonalArms.UIPersonalArmsCalendarExchange.Comp.UIPersonalArmsCalendarExchangeItem")
local bgPanelPath = "Panel"
local closeBtnPath = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local p_btn_switch_time_path = "UICommonPopUpTitle/Common_bg_orange/Common_bg_orange2/Root/titleItem/timeContent/p_btn_switch_time"
local exchange_tips_content_path = "UICommonPopUpTitle/Common_bg_orange/exchange_tips_content"
local p_text_exchange_tips_path = "UICommonPopUpTitle/Common_bg_orange/exchange_tips_content/p_text_exchange_tips"
local p_btn_exchange_help_path = "UICommonPopUpTitle/Common_bg_orange/exchange_tips_content/content_btn/p_btn_exchange_help"

function UIPersonalArmsCalendarExchangeView:OnCreate()
  base.OnCreate(self)
  self.param = self:GetUserData()
  self.IsServerTime = DataCenter.ActivityPersonalArmsDataManager.isShowSvrTimeDesc
  self:ComponentDefine()
  self:RefreshView()
end

function UIPersonalArmsCalendarExchangeView:OnDestroy()
  self.param = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPersonalArmsCalendarExchangeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityPersonalArmsCalenderUpdate, self.OnDataUpdate)
end

function UIPersonalArmsCalendarExchangeView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActivityPersonalArmsCalenderUpdate, self.OnDataUpdate)
end

function UIPersonalArmsCalendarExchangeView:OnDataUpdate()
  self:RefreshView()
end

function UIPersonalArmsCalendarExchangeView:ComponentDefine()
  self.bgPanel = self:AddComponent(UIButton, bgPanelPath)
  self.bgPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, closeBtnPath)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.weekText = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_bg_orange2/Root/titleItem/weekText")
  self.timeContent = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Common_bg_orange2/Root/titleItem/timeContent")
  self.timeText = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_bg_orange2/Root/titleItem/timeContent/timeText")
  self.p_btn_switch_time = self:AddComponent(UIButton, p_btn_switch_time_path)
  self.p_btn_switch_time:SetOnClick(BindCallback(self, self.OnSwitchTimeClicked))
  self.nameText = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_bg_orange2/Root/titleItem/nameText")
  self.weekText:SetLocalText(2000378)
  self.nameText:SetLocalText(2000377)
  self.exchange_tips_content = self:AddComponent(UIBaseContainer, exchange_tips_content_path)
  self.p_text_exchange_tips = self:AddComponent(UITextMeshProUGUIEx, p_text_exchange_tips_path)
  self.p_btn_exchange_help = self:AddComponent(UIButton, p_btn_exchange_help_path)
  self.p_btn_exchange_help:SetOnClick(BindCallback(self, self.OnHelpClicked))
  self.content = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Common_bg_orange2/Root/MethodScroll/Viewport/Content")
  self.item = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Common_bg_orange2/Root/MethodScroll/item")
  self.item.gameObject:GameObjectCreatePool()
end

function UIPersonalArmsCalendarExchangeView:ComponentDestroy()
  self.bgPanel = nil
  self.closeBtn = nil
  self.weekText = nil
  self.timeText = nil
  self.p_btn_switch_time = nil
  self.nameText = nil
  self.exchange_tips_content = nil
  self.p_text_exchange_tips = nil
  self.p_btn_exchange_help = nil
  self.content:RemoveComponents(UIPersonalArmsCalendarExchangeItem)
  self.content = nil
  self.item.gameObject:GameObjectRecycleAll()
  self.item = nil
end

function UIPersonalArmsCalendarExchangeView:RefreshView()
  self:UpdateTimeZoneTitle()
  self.content:SetAnchoredPositionXY(0, 0)
  local activityId = self.param
  local calendarData = DataCenter.ActivityPersonalArmsDataManager:GetCalenderData(activityId)
  if calendarData == nil then
    SFSNetwork.SendMessage(MsgDefines.ActivityHeroCalender, toInt(activityId))
    return
  end
  local curDay = calendarData.curDay
  local curStage = calendarData.curStage
  local activityData = DataCenter.ActivityPersonalArmsDataManager:GetCurData(activityId)
  if activityData then
    curDay = activityData.curDay
    curStage = activityData.curStage
  end
  local curIndex = 0
  self.showDataList = {}
  local dayArr = calendarData.dayArr
  for i = 1, #dayArr do
    local dayData = dayArr[i]
    local dayNum = dayData.day
    local eventArr = dayData.eventArr
    for j = 1, #eventArr do
      local realStageOrder = dayData.exchangeList
      if table.count(realStageOrder) < 6 then
        realStageOrder = {
          0,
          1,
          2,
          3,
          4,
          5
        }
      end
      local stageNum = realStageOrder[j]
      local eventData = eventArr[stageNum + 1]
      local eventTimeData = eventArr[j]
      local isShowWeek = j == 1
      local isCur = dayNum == curDay and stageNum == curStage
      if isCur then
        curIndex = #self.showDataList
      end
      local showDataItem = {
        dayNum = dayNum,
        stageNum = stageNum,
        isShowWeek = isShowWeek,
        isCurDay = dayNum == curDay,
        isCur = isCur,
        activityId = activityId,
        eventId = eventData.eventId,
        name = eventData.name,
        startTime = eventTimeData.startTime * 1000,
        endTime = eventTimeData.endTime * 1000,
        index = j - 1
      }
      table.insert(self.showDataList, showDataItem)
    end
  end
  self.content:RemoveComponents(UIPersonalArmsCalendarExchangeItem)
  self.item.gameObject:GameObjectRecycleAll()
  local list = self.showDataList
  if list ~= nil then
    local isShowSvrTimeDesc = DataCenter.ActivityPersonalArmsDataManager.isShowSvrTimeDesc
    for i = 1, table.length(list) do
      local item = self.item.gameObject:GameObjectSpawn(self.content.transform)
      item.name = tostring(i)
      local cell = self.content:AddComponent(UIPersonalArmsCalendarExchangeItem, item.name, list[i])
      cell:SetData(list[i], isShowSvrTimeDesc)
    end
  end
  local isExchangeFuncOpen = DataCenter.ActivityPersonalArmsDataManager:IsExchangeFuncOpen(activityId)
  if isExchangeFuncOpen then
    self.exchange_tips_content:SetActive(true)
    local curExchangeTimes = activityData ~= nil and checknumber(activityData.exchangeNum) or 0
    local maxExchangeTimes = LuaEntry.DataConfig:TryGetNum("person_arms_race", "k7", 0)
    local leftTime = math.max(0, maxExchangeTimes - curExchangeTimes)
    local color = 0 < leftTime and "#099b4a" or "#f53c3d"
    local leftTimeStr = string.format("<color=%s>%s</color>/%s", color, leftTime, maxExchangeTimes)
    self.p_text_exchange_tips:SetLocalText("arms_race_calendar_tips", leftTimeStr)
  else
    self.exchange_tips_content:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  self.content:SetAnchoredPositionXY(0, curIndex * 74)
  if DataCenter.ActivityPersonalArmsDataManager:NeedExchangeGuide(activityId) then
    self:OnHelpClicked()
    DataCenter.ActivityPersonalArmsDataManager:SetExchangeGuided(true)
  end
end

function UIPersonalArmsCalendarExchangeView:UpdateTimeZoneTitle()
  local isServerTime = DataCenter.ActivityPersonalArmsDataManager.isShowSvrTimeDesc
  local timeKey = "s5_alliance_battle_time_ui02"
  if not isServerTime then
    timeKey = "s5_alliance_battle_time_ui03"
  end
  self.timeText:SetLocalText(timeKey)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.timeContent.rectTransform)
end

function UIPersonalArmsCalendarExchangeView:OnSwitchTimeClicked()
  local isServerTime = DataCenter.ActivityPersonalArmsDataManager.isShowSvrTimeDesc
  DataCenter.ActivityPersonalArmsDataManager:SetIsShowSvrTimeDesc(not isServerTime)
  EventManager:GetInstance():Broadcast(EventId.ActivityPersonalArmsCalenderSwitchTime)
  self:UpdateTimeZoneTitle()
end

function UIPersonalArmsCalendarExchangeView:OnHelpClicked()
  local param = {}
  param.howToPlayList = {101010}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

return UIPersonalArmsCalendarExchangeView
