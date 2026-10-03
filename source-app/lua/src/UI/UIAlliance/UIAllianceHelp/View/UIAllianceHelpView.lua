local AllianceHelpItem = require("UI.UIAlliance.UIAllianceHelp.Component.AllianceHelpItem")
local UIAllianceHelpView = BaseClass("UIAllianceHelpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local back_btn_path = "ImgBg/BtnBack"
local return_btn_path = "UICommonPopUpTitle/panel"
local scroll_path = "ImgBg/ScrollView"
local empty_txt_path = "ImgBg/TxtEmpty"
local help_btn_path = "ImgBg/helpAllButton"
local help_txt_path = "ImgBg/helpAllButton/helpText"
local slider_path = "ImgBg/sliderBg/Slider"
local scoreIcon_path = "ImgBg/sliderBg/icon"
local slider_txt_path = "ImgBg/sliderBg/Slider/sliderText"
local refreshTime_path = "ImgBg/cdTime"
local infoBtn_path = "ImgBg/infoBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl:InitData()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(390110)
  self.empty_txt = self:AddComponent(UIText, empty_txt_path)
  self.empty_txt:SetLocalText(390120)
  self.help_btn = self:AddComponent(UIButton, help_btn_path)
  self.help_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:OnHelpAllClick(self.help_btn.transform.position)
  end)
  self.help_txt = self:AddComponent(UIText, help_txt_path)
  self.help_txt:SetLocalText(390112)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:Close()
  end)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnHelpItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnHelpItemMoveOut(itemObj, index)
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.scoreBtnN = self:AddComponent(UIButton, scoreIcon_path)
  self.scoreBtnN:SetOnClick(function()
    self:OnClickPersonalScoreBtn()
  end)
  self.slider_txt = self:AddComponent(UIText, slider_txt_path)
  self.help_list = {}
  self.refreshTimeN = self:AddComponent(UIText, refreshTime_path)
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
end

local function OnDestroy(self)
  self:DelTimer()
  self.txt_title = nil
  self.empty_txt = nil
  self.help_btn = nil
  self.help_txt = nil
  self.close_btn = nil
  self.back_btn = nil
  self.return_btn = nil
  self.ScrollView = nil
  self.help_list = nil
  base.OnDestroy(self)
end

local function RefreshAllianceHelpList(self)
  self:RefreshTop()
  self:ClearScroll(self)
  self.help_list = self.ctrl:GetAllianceHelpList()
  self.help_btn:SetActive(false)
  if #self.help_list > 0 then
    self.ScrollView:SetTotalCount(#self.help_list)
    self.ScrollView:RefillCells()
    table.walk(self.help_list, function(k, v)
      if v.isSelf == false then
        self.help_btn:SetActive(true)
      end
    end)
    self.empty_txt:SetActive(false)
  else
    self.empty_txt:SetActive(true)
  end
end

local function RefreshTop(self)
  local sliderData = self.ctrl:GetAllianceHelpSliderData()
  if sliderData ~= nil then
    local percent = sliderData.todayHelpPoint / math.max(1, sliderData.maxHelpCount)
    self.slider:SetValue(percent)
    local strProg = string.GetFormattedSeperatorNum(sliderData.todayHelpPoint) .. "/" .. string.GetFormattedSeperatorNum(sliderData.maxHelpCount)
    self.slider_txt:SetText(Localization:GetString("391087", strProg))
  else
    self.slider:SetValue(0)
    self.slider_txt:SetText("0/0")
  end
  self:RefreshTimer()
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self:ClearScroll(self)
  base.OnDisable(self)
end

local function OnHelpItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(AllianceHelpItem, itemObj)
  cellItem:SetItemShow(self.help_list[index])
end

local function OnHelpItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, AllianceHelpItem)
end

local function ClearScroll(self)
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(AllianceHelpItem)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceHelpSever, self.RefreshAllianceHelpList)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceHelpSever, self.RefreshAllianceHelpList)
end

local function OnClickInfoBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.infoBtnN.transform.position + Vector3.New(-20, 0, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("391088")
  param.dir = UIHeroTipView.Direction.LEFT
  param.defWidth = 440
  param.pivot = 0.7
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnClickPersonalScoreBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.scoreBtnN.transform.position + Vector3.New(20, 0, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("391085")
  param.dir = UIHeroTipView.Direction.RIGHT
  param.defWidth = 440
  param.pivot = 0.7
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function RefreshTimer(self)
  self.cdEndTime = UITimeManager:GetInstance():GetNextDayMs()
  self:AddTimer()
  self:SetRemainTime()
end

local function AddTimer(self)
  function self.TimerAction()
    self:SetRemainTime()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
end

local function SetRemainTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.cdEndTime - curTime
  if 0 <= remainTime then
    self.refreshTimeN:SetText(Localization:GetString("320318", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)))
  else
    DataCenter.AllianceHelpDataManager:ResetTodayHelpPoint()
    self:RefreshTop()
  end
end

local function DelTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

UIAllianceHelpView.OnCreate = OnCreate
UIAllianceHelpView.OnDestroy = OnDestroy
UIAllianceHelpView.RefreshAllianceHelpList = RefreshAllianceHelpList
UIAllianceHelpView.OnEnable = OnEnable
UIAllianceHelpView.OnDisable = OnDisable
UIAllianceHelpView.OnHelpItemMoveIn = OnHelpItemMoveIn
UIAllianceHelpView.OnHelpItemMoveOut = OnHelpItemMoveOut
UIAllianceHelpView.ClearScroll = ClearScroll
UIAllianceHelpView.OnAddListener = OnAddListener
UIAllianceHelpView.OnRemoveListener = OnRemoveListener
UIAllianceHelpView.OnClickInfoBtn = OnClickInfoBtn
UIAllianceHelpView.OnClickPersonalScoreBtn = OnClickPersonalScoreBtn
UIAllianceHelpView.AddTimer = AddTimer
UIAllianceHelpView.SetRemainTime = SetRemainTime
UIAllianceHelpView.DelTimer = DelTimer
UIAllianceHelpView.RefreshTimer = RefreshTimer
UIAllianceHelpView.RefreshTop = RefreshTop
return UIAllianceHelpView
