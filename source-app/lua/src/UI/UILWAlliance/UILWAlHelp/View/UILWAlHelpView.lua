local UILWAlHelpView = BaseClass("UILWAlHelpView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIAlHelpItem = require("UI.UILWAlliance.UILWAlHelp.Component.UILWAlHelpItem")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local txt_title_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local close_btn_path = "Panel"
local return_btn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local icon_btn_path = "Root/Content/Up/IconBtn"
local slider_path = "Root/Content/Up/Slider"
local slider_txt_path = "Root/Content/Up/Slider/ProgressText"
local info_btn_path = "Root/Content/Up/InfoBtn"
local scroll_path = "Root/Content/Mid/ScrollView"
local empty_txt_path = "Root/Content/Mid/EmptyTxt"
local refresh_time_txt_path = "Root/Content/Mid/RefreshText"
local help_btn_path = "Root/Content/Bottom/HelpAllBtn"
local help_txt_path = "Root/Content/Bottom/HelpAllBtn/HelpAllText"
local TITLE_TXT = 390110
local EMPTY_TXT = 390120
local HELP_ALL_TXT = 390112

function UILWAlHelpView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.AllianceShowHelp)
end

function UILWAlHelpView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlHelpView:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, txt_title_path)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.returnBtn = self:AddComponent(UIButton, return_btn_path)
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.iconBtn = self:AddComponent(UIButton, icon_btn_path)
  self.iconBtn:SetOnClick(function()
    self:OnClickIcon()
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.sliderProgressTxt = self:AddComponent(UIText, slider_txt_path)
  self.refreshTimeTxt = self:AddComponent(UIText, refresh_time_txt_path)
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.infoBtn:SetOnClick(function()
    self:OnClickInfo()
  end)
  self.scrollView = self:AddComponent(UIScrollView, scroll_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnHelpItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnHelpItemMoveOut(itemObj, index)
  end)
  self.emptyTxt = self:AddComponent(UIText, empty_txt_path)
  self.helpAllBtn = self:AddComponent(UIButton, help_btn_path)
  self.helpAllBtn:SetOnClick(function()
    self.ctrl:OnClickHelpAll(self.helpAllBtn.transform.position, self.iconBtn.transform.position)
  end)
  self.helpAllTxt = self:AddComponent(UIText, help_txt_path)
  self.titleTxt:SetLocalText(TITLE_TXT)
  self.emptyTxt:SetLocalText(EMPTY_TXT)
  self.helpAllTxt:SetLocalText(HELP_ALL_TXT)
end

function UILWAlHelpView:ComponentDestroy()
  self:DelTimer()
  self:DelLoopTimer()
  self.titleTxt = nil
  self.closeBtn = nil
  self.returnBtn = nil
  self.iconBtn = nil
  self.slider = nil
  self.sliderProgressTxt = nil
  self.refreshTimeTxt = nil
  self.infoBtn = nil
  self.scrollView = nil
  self.emptyTxt = nil
  self.helpAllBtn = nil
  self.helpAllTxt = nil
end

function UILWAlHelpView:DataDefine()
  self.ctrl:SetView(self)
  self.helpList = {}
  self.helpItemList = {}
  self.showReduce = true
end

function UILWAlHelpView:DataDestroy()
  self.ctrl:ClearView()
  self.helpList = nil
  self.helpItemList = nil
  self.showReduce = nil
end

function UILWAlHelpView:OnEnable()
  base.OnEnable(self)
end

function UILWAlHelpView:OnDisable()
  self:ClearScroll()
  base.OnDisable(self)
end

function UILWAlHelpView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceHelpSever, self.RefreshAllianceHelpList)
end

function UILWAlHelpView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceHelpSever, self.RefreshAllianceHelpList)
end

function UILWAlHelpView:RefreshAllianceHelpList()
  self:RefreshTop()
  self:ClearScroll()
  self.helpList = DataCenter.AllianceHelpDataManager:GetAllianceHelpList()
  if #self.helpList > 0 then
    self.scrollView:SetTotalCount(#self.helpList)
    self.scrollView:RefillCells()
    self.emptyTxt:SetActive(false)
  else
    self.emptyTxt:SetActive(true)
  end
  self:RefreshLoopTimer()
end

function UILWAlHelpView:RefreshTop()
  local sliderData = DataCenter.AllianceHelpDataManager:GetAllianceHelpSliderData()
  if sliderData ~= nil then
    local percent = sliderData.todayHelpPoint / math.max(1, sliderData.maxHelpCount)
    self.slider:SetValue(percent)
    local strProg = string.GetFormattedSeperatorNum(sliderData.todayHelpPoint) .. "/" .. string.GetFormattedSeperatorNum(sliderData.maxHelpCount)
    self.sliderProgressTxt:SetText(Localization:GetString("391087", strProg))
  else
    self.slider:SetValue(0)
    self.sliderProgressTxt:SetText("0/0")
  end
  self:RefreshTimer()
end

function UILWAlHelpView:RefreshTimer()
  self.cdEndTime = UITimeManager:GetInstance():GetNextDayMs()
  self:AddTimer()
  self:SetRemainTime()
end

function UILWAlHelpView:AddTimer()
  function self.TimerAction()
    self:SetRemainTime()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
end

function UILWAlHelpView:SetRemainTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.cdEndTime - curTime
  if 0 <= remainTime then
    self.refreshTimeTxt:SetText(Localization:GetString("320318", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)))
  else
    DataCenter.AllianceHelpDataManager:ResetTodayHelpPoint()
    self:RefreshTop()
  end
end

function UILWAlHelpView:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UILWAlHelpView:RefreshLoopTimer()
  self:AddLoopTimer()
  self:LoopShow(false)
end

function UILWAlHelpView:AddLoopTimer()
  function self.LoopTimerAction()
    self:LoopShow(true)
  end
  
  if self.loopTimer == nil then
    self.loopTimer = TimerManager:GetInstance():GetTimer(5, self.LoopTimerAction, self, false, false, false)
  end
  self.loopTimer:Start()
end

function UILWAlHelpView:LoopShow(has_duration)
  self.showReduce = not self.showReduce
  if self.helpItemList and table.count(self.helpItemList) > 0 then
    table.walk(self.helpItemList, function(k, v)
      if v ~= nil and v.activeSelf then
        v:SetShowReduce(self.showReduce, has_duration)
      end
    end)
  end
end

function UILWAlHelpView:DelLoopTimer()
  if self.loopTimer ~= nil then
    self.loopTimer:Stop()
    self.loopTimer = nil
  end
end

function UILWAlHelpView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIAlHelpItem)
end

function UILWAlHelpView:OnHelpItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UIAlHelpItem, itemObj)
  cellItem:SetItemShow(self.helpList[index])
  cellItem:SetShowReduce(self.showReduce, false)
  self.helpItemList[index] = cellItem
end

function UILWAlHelpView:OnHelpItemMoveOut(itemObj, index)
  self.helpItemList[index] = nil
  self.scrollView:RemoveComponent(itemObj.name, UIAlHelpItem)
end

function UILWAlHelpView:OnClickInfo()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.infoBtn.transform.position + Vector3.New(-20 * CommonUtil.ArabicAutoMirrorFactor(), 0, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("391088")
  param.dir = UIHeroTipView.Direction.LEFT
  param.defWidth = 440
  param.pivot = 0.7
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

function UILWAlHelpView:OnClickIcon()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.iconBtn.transform.position + Vector3.New(20, 0, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("391085")
  param.dir = UIHeroTipView.Direction.RIGHT
  param.defWidth = 440
  param.pivot = 0.7
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

return UILWAlHelpView
