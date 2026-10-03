local p_comp_slider_path = "panel/root/progress/img_bg/slider/p_comp_slider"
local has_unlocked_path = "panel/root/useBtn/hasUnlocked"
local use_text_path = "panel/root/useBtn/hasUnlocked/useText"
local has_unlocked_value_path = "panel/root/useBtn/hasUnlocked/hasUnlockedValue"
local p_btn_how_to_play_path = "panel/root/p_btn_how_to_play"
local p_text_how_to_play_path = "panel/root/p_btn_how_to_play/BtnInfoIcon/p_text_how_to_play"
local base = UIBaseView
local LWMakingCoffeeView = BaseClass("LWMakingCoffeeView", base)
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local CoffeeLoopView = require("UI/LWSeason5/LWMakingCoffee/Component/CoffeeLoopView")
local redText = "<color=#FF0000>%s</color>"
local whiteText = "<color=#FFFFFF>%s</color>"
local CLICK_CD = 1000
local INFO_MAX_WIDTH = 1200
local titleMaxWidth = 280

function LWMakingCoffeeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  UIUtil.CheckEventTrigger(OpMode.ClickBtnShowMakingCoffeeView)
end

function LWMakingCoffeeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWMakingCoffeeView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textNpc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textProgressTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnArrow = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnArrow:SetOnClick(function()
    self:OnBtnArrowClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "panelBtn")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.notUnlocked = self:AddComponent(UIBaseContainer, "panel/root/useBtn/notUnlocked")
  self.goodsIcon = self:AddComponent(UIImage, "panel/root/useBtn/notUnlocked/notUnlockedValue/goodsIcon")
  self.notUnlockedText = self:AddComponent(UITextMeshProUGUIEx, "panel/root/useBtn/notUnlocked/notUnlockedValue")
  self.useBtn = self:AddComponent(UIButton, "panel/root/useBtn")
  self.useBtnImg = self:AddComponent(UIImage, "panel/root/useBtn")
  self.briefTitle = self:AddComponent(UIText, "panel/root/BriefTitle")
  self.useBtn:SetOnClick(function()
    self:OnBtnUseClick()
  end)
  
  function self.timer_action()
    self:UpdateTimeText()
  end
  
  self.coffeeLoopView = self:AddComponent(CoffeeLoopView, "panel/root/Scroll_View_mainView")
  self.has_unlocked = self:AddComponent(UIBaseContainer, has_unlocked_path)
  self.use_text = self:AddComponent(UITextMeshProUGUIEx, use_text_path)
  self.has_unlocked_value = self:AddComponent(UITextMeshProUGUIEx, has_unlocked_value_path)
  self.p_comp_slider = self:AddComponent(UISlider, p_comp_slider_path)
  self.p_btn_how_to_play = self:AddComponent(UIButton, p_btn_how_to_play_path)
  self.p_btn_how_to_play:SetOnClick(BindCallback(self, self.OnHelpClicked))
  self.p_text_how_to_play = self:AddComponent(UITextMeshProUGUIEx, p_text_how_to_play_path)
end

function LWMakingCoffeeView:ComponentDestroy()
  self.viewSkin = nil
  self.textNpc = nil
  self.textTitle = nil
  self.textProgressTitle = nil
  self.btnClose = nil
  self.textProgress = nil
  self.btnArrow = nil
  self.btnPanel = nil
  self.useBtn = nil
  self.useBtnImg = nil
  self.coffeeLoopView = nil
  self.briefTitle = nil
  self.has_unlocked = nil
  self.use_text = nil
  self.has_unlocked_value = nil
  self.p_comp_slider = nil
  self.p_btn_how_to_play = nil
  self.p_text_how_to_play = nil
end

function LWMakingCoffeeView:DataDefine()
  self.curCoffee = nil
end

function LWMakingCoffeeView:DataDestroy()
  self.curCoffee = nil
  self:SetInfoTextTimerActive(false)
  if self.effectDelay then
    self.effectDelay:Stop()
    self.effectDelay = nil
  end
end

function LWMakingCoffeeView:ReInit()
  self.textTitle:SetLocalText("season_coffee_title")
  self.use_text:SetLocalText("season_coffee_drink_button")
  local preferredValues = self.textTitle.unity_tmpro:GetPreferredValues(titleMaxWidth, 0)
  if preferredValues.x > titleMaxWidth then
    self.textTitle:SetActive(true)
    self.briefTitle:SetActive(false)
  else
    self.briefTitle:SetLocalText("season_coffee_title")
    self.textTitle:SetActive(false)
    self.briefTitle:SetActive(true)
  end
  local rowList, showIndex, targetConfig = self.ctrl:GetAllCoffee()
  self.coffeeLoopView:RefreshList(rowList)
  self.coffeeLoopView:MoveToIndex(showIndex - 1)
  self:SetCurCoffee(targetConfig)
  self:UpdateArrow()
end

function LWMakingCoffeeView:OnEnable()
  base.OnEnable(self)
  self:UpdateArrow()
end

function LWMakingCoffeeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MakingCoffeeUnlock, self.OnMakingCoffeeUnlock)
  self:AddUIListener(EventId.MakingCoffeeUpdate, self.OnUpdateCoffeeCount)
  self:AddUIListener(EventId.CoffeeDrink, self.UpdateInfoText)
end

function LWMakingCoffeeView:OnRemoveListener()
  self:RemoveUIListener(EventId.MakingCoffeeUnlock, self.OnMakingCoffeeUnlock)
  self:RemoveUIListener(EventId.CoffeeDrink, self.UpdateInfoText)
  self:RemoveUIListener(EventId.MakingCoffeeUpdate, self.OnUpdateCoffeeCount)
  base.OnRemoveListener(self)
end

function LWMakingCoffeeView:OnMakingCoffeeUnlock(coffeeId)
  self.coffeeLoopView:UnlockCoffee(coffeeId)
  self.effectDelay = TimerManager:GetInstance():DelayInvoke(function()
    local rowList, moveIndex = self.ctrl:GetAllCoffee(coffeeId)
    self.coffeeLoopView:RefreshList(rowList)
    self.coffeeLoopView:MoveToIndex(moveIndex - 1)
    self:SetCurCoffee(self.curCoffee, true)
  end, 1.5)
end

function LWMakingCoffeeView:SetInfoTextTimerActive(flag)
  if flag then
    if not self.timer then
      self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
    end
    self.timer:Start()
  elseif self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function LWMakingCoffeeView:UpdateInfoText()
  self:SetInfoTextTimerActive(false)
  local state = DataCenter.MakingCoffeeManager:GetCoffeeState()
  if state == CoffeeState.EMPTY then
    self.curCount = DataCenter.MakingCoffeeManager:GetCurCount()
    self:UpdateTimeText()
    self:SetInfoTextTimerActive(true)
  elseif state == CoffeeState.FULL then
    self:SetProgress(1)
    self:SetInfoText("season_coffee_count_tips_fullcoffee", "")
  elseif state == CoffeeState.AVAILABLE then
    self.curCount = DataCenter.MakingCoffeeManager:GetCurCount()
    self:UpdateTimeText()
    self:SetInfoTextTimerActive(true)
  end
end

function LWMakingCoffeeView:SetProgress(value)
  if IsNull(self.p_comp_slider) then
    return
  end
  self.p_comp_slider:SetValue(value)
end

function LWMakingCoffeeView:SetInfoText(title, time)
  self.textProgressTitle:SetLocalText(title)
  self.textProgress:SetText(time)
end

function LWMakingCoffeeView:OnUpdateCoffeeCount()
  self:UpdateCurCoffeeViewInfo()
  self:UpdateInfoText()
end

function LWMakingCoffeeView:UpdateTimeText()
  local count = DataCenter.MakingCoffeeManager:GetCurCount()
  local nextTime = DataCenter.MakingCoffeeManager:GetNextTime()
  local time = UITimeManager:GetInstance():MilliSecondToFmtString(nextTime)
  if count ~= self.curCount then
    self.curCount = count
    DataCenter.MakingCoffeeManager:UpdateTimerTask()
    self:UpdateInfoText()
    self:UpdateCurCoffeeViewInfo()
    return
  end
  self:SetInfoText("season_coffee_count_tips_empty", time)
  local percent = DataCenter.MakingCoffeeManager:GetCurCoffeePercent()
  self:SetProgress(percent)
end

function LWMakingCoffeeView:SetCurCoffee(data, refresh)
  if not data then
    return
  end
  if not self.curCoffee or self.curCoffee.id ~= data.id or refresh then
    self.curCoffee = data
    self:UpdateCurCoffeeViewInfo()
    self:UpdateInfoText()
  end
end

function LWMakingCoffeeView:UpdateCurCoffeeViewInfo()
  self.textNpc:SetLocalText(self.curCoffee.info)
  self.coffeeLoopView:ChangeCoffee(self.curCoffee.id)
  local isUnlock = DataCenter.MakingCoffeeManager:GetIsUnlock(self.curCoffee.id)
  self.has_unlocked:SetActive(isUnlock)
  UIGray.SetGray(self.useBtn.transform, false, true)
  if isUnlock then
    local count = DataCenter.MakingCoffeeManager:GetCurCount()
    local maxCount = DataCenter.MakingCoffeeManager:GetMaxCoffeeCount()
    if count == 0 then
      UIGray.SetGray(self.useBtn.transform, true, true)
    end
    self.has_unlocked_value:SetText(string.format("%s/%s", count, maxCount))
  end
  self.useBtnImg:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_5"))
  self.notUnlocked:SetActive(not isUnlock)
  if not isUnlock then
    self:UpdateLockedUI()
  end
end

function LWMakingCoffeeView:UpdateLockedUI()
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(self.curCoffee.unlock_goods)
  self.goodsIcon:LoadSpriteAsync(iconPath)
  local curNum = DataCenter.ItemData:GetItemCount(self.curCoffee.unlock_goods)
  local textFormat = redText
  local imgName = "tongyong_cfm_anniu_5"
  if 0 < curNum then
    textFormat = whiteText
    imgName = "tongyong_cfm_anniu_1"
  end
  self.useBtnImg:LoadSprite(string.format(LoadPath.LWCommonPath, imgName))
  local format = 0 < curNum and whiteText or redText
  self.notUnlockedText:SetText(string.format(format, curNum) .. "/1")
end

function LWMakingCoffeeView:OnBtnUseClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.clickTime and curTime - self.clickTime < CLICK_CD then
    return
  end
  self.clickTime = curTime
  if not DataCenter.MakingCoffeeManager:GetIsUnlock(self.curCoffee.id) then
    self:TryUnlockCoffee()
  else
    self:TryDrinkCoffee()
  end
end

function LWMakingCoffeeView:TryUnlockCoffee()
  local curNum = DataCenter.ItemData:GetItemCount(self.curCoffee.unlock_goods)
  if curNum and 0 < curNum then
    DataCenter.MakingCoffeeManager:SendUnlockMessage(self.curCoffee.id)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGoodsLack, {anim = true}, {
      type = ResLackContextType.Good,
      id = self.curCoffee.unlock_goods,
      need = 1
    })
  end
end

function LWMakingCoffeeView:TryDrinkCoffee()
  local count = DataCenter.MakingCoffeeManager:GetCurCount()
  if count <= 0 then
    local nextTime = DataCenter.MakingCoffeeManager:GetNextTime()
    local time = UITimeManager:GetInstance():MilliSecondToFmtString(nextTime)
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString("season_coffee_count_tips_empty_new", time))
    return
  end
  if DataCenter.MakingCoffeeManager:HasCoffeeStatus() then
    self:OpenConfirmation()
  else
    self:DrinkCoffee()
  end
end

function LWMakingCoffeeView:OpenConfirmation()
  local localDay = CommonUtil.PlayerPrefsGetInt("COFFEE_STATUS", -1)
  local today = UITimeManager:GetInstance():GetDayOfYear(UITimeManager:GetInstance():GetServerTime())
  if localDay == -1 or today ~= localDay then
    local param = {
      contentText = Localization:GetString("season_coffee_drink_tips"),
      btnNum = 2,
      showToggle = true,
      confirmBtnParam = {
        action = function()
          self:DrinkCoffee()
        end
      },
      toggleParam = {
        toggleAction = function(flag)
          if not flag then
            local day = UITimeManager:GetInstance():GetDayOfYear(UITimeManager:GetInstance():GetServerTime())
            CommonUtil.PlayerPrefsSetInt("COFFEE_STATUS", day)
          end
        end
      }
    }
    UIUtil.ShowConfirmNew(param)
  else
    self:DrinkCoffee()
  end
end

function LWMakingCoffeeView:DrinkCoffee()
  DataCenter.MakingCoffeeManager:SendCoffeeStatusUse(self.curCoffee.id)
end

function LWMakingCoffeeView:OnBtnArrowClick()
  local masteryId = 1707
  local isShow = DataCenter.MasteryManager:IsS5MakingCoffeeShowTip(masteryId)
  if not isShow then
    masteryId = 1807
    isShow = DataCenter.MasteryManager:IsS5MakingCoffeeShowTip(masteryId)
  end
  if isShow then
    local masteryData = DataCenter.MasteryManager:GetData()
    local params = {}
    params.tabType = MasteryTabType.MasterSkillTab
    params.data = {
      homeId = masteryData.home_id,
      jumpMasteryId = masteryId,
      autoOpen = true
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryCenterTab, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, params)
  end
end

function LWMakingCoffeeView:OnHelpClicked()
  local param = {}
  param.howToPlayList = {500012}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function LWMakingCoffeeView:OnBtnCloseClick()
  self.ctrl.CloseSelf()
end

function LWMakingCoffeeView:OnBtnPanelClick()
  self.ctrl.CloseSelf()
end

function LWMakingCoffeeView:UpdateArrow()
  local isShow = DataCenter.MasteryManager:IsS5MakingCoffeeShowTip(1707)
  isShow = isShow or DataCenter.MasteryManager:IsS5MakingCoffeeShowTip(1807)
  self.btnArrow:SetActive(isShow)
end

return LWMakingCoffeeView
