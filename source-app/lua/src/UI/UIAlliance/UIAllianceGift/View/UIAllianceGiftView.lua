local AllianceGiftItem = require("UI.UIAlliance.UIAllianceGift.Component.AllianceGiftItem")
local UIAllianceGiftView = BaseClass("UIAllianceGiftView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local scrollView_path = "ImgBg/ScrollView"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local back_btn_path = "UICommonPopUpTitle/BtnBack"
local content_path = "ImgBg/ScrollView/contentWithEff"
local return_btn_path = "UICommonPopUpTitle/panel"
local slider_path = "ImgBg/TopGift/Slider"
local slider_txt_path = "ImgBg/TopGift/Slider/Num"
local level_num_path = "ImgBg/TopGift/levelNum"
local set_toggle_path = "ImgBg/TopGift/setToggle"
local set_toggle_label_path = "ImgBg/TopGift/setToggle/Label"
local toggle_1_path = "ImgBg/ToggleGroup/Toggle1"
local toggle_1_txt_path = "ImgBg/ToggleGroup/Toggle1/toggleLabel1"
local toggleRedPoint_path = "ImgBg/ToggleGroup/Toggle%s/redPoint%s"
local toggle_2_path = "ImgBg/ToggleGroup/Toggle2"
local toggle_2_txt_path = "ImgBg/ToggleGroup/Toggle2/toggleLabel2"
local empty_txt_path = "ImgBg/TxtEmpty"
local get_all_btn_path = "ImgBg/getAllBtn"
local get_all_btn_txt_path = "ImgBg/getAllBtn/getTxt"
local getAllRed_path = "ImgBg/getAllBtn/red"
local getAllRedCount_path = "ImgBg/getAllBtn/red/redNum"
local del_all_btn_path = "ImgBg/delAllBtn"
local tips_obj_path = "ImgBg/tips"
local des_txt_path = "ImgBg/tips/Content/desTxt"
local info_btn_path = "ImgBg/TopGift/infoBtn"
local close_info_btn_path = "ImgBg/tips/closePanel"
local scoreFlyTarget_path = "ImgBg/TopGift/Image_exp"
local TabToGiftType = {
  [1] = 2,
  [2] = 1
}

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl:InitData()
  self.isGetBtnReady = true
  self.giftGoList = {}
  
  function self.animator_timer_action(temp)
    self:AnimatorTime()
  end
  
  function self.timer_action(temp)
    self:DoQuestShowAnimation()
  end
  
  function self.getBtnTimerAction(temp)
    self.isGetBtnReady = true
    self:DelGetBtnTimer()
  end
  
  self.title = self:AddComponent(UIText, txt_title_path)
  self.title:SetLocalText(390445)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:Close()
  end)
  self.backBtn = self:AddComponent(UIButton, back_btn_path)
  self.backBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_txt = self:AddComponent(UIText, slider_txt_path)
  self.empty_txt = self:AddComponent(UIText, empty_txt_path)
  self.empty_txt:SetLocalText(390447)
  self.level_num = self:AddComponent(UIText, level_num_path)
  self.hideNameState = LuaEntry.Player.alGiftHideName == 1
  self.set_toggle = self:AddComponent(UIToggle, set_toggle_path)
  self.set_toggle:SetIsOn(self.hideNameState)
  self.set_toggle:SetOnValueChanged(function(tf)
    self:SetNoName(tf)
  end)
  self.set_toggle:SetActive(false)
  self.set_toggle_label = self:AddComponent(UIText, set_toggle_label_path)
  self.set_toggle_label:SetLocalText(390810)
  self.toggleRedPoint = {}
  for i = 1, 2 do
    local tempRed = self:AddComponent(UIBaseContainer, string.format(toggleRedPoint_path, i, i))
    tempRed:SetActive(false)
    self.toggleRedPoint[i] = tempRed
  end
  self.toggle1 = self:AddComponent(UIToggle, toggle_1_path)
  self.toggle1:SetIsOn(true)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toggle1_text = self:AddComponent(UIText, toggle_1_txt_path)
  self.toggle1_text:SetLocalText(110136)
  self.toggle2 = self:AddComponent(UIToggle, toggle_2_path)
  self.toggle2:SetIsOn(false)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toggle2_text = self:AddComponent(UIText, toggle_2_txt_path)
  self.toggle2_text:SetLocalText(110135)
  self.tips_obj = self:AddComponent(UIBaseContainer, tips_obj_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.des_txt:SetLocalText(129088)
  self.get_all_btn = self:AddComponent(UIButton, get_all_btn_path)
  self.get_all_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
    self:OnGetAllBtnClick()
  end)
  self.get_all_btn_txt = self:AddComponent(UIText, get_all_btn_txt_path)
  self.get_all_btn_txt:SetLocalText(110132)
  self.getAllRedN = self:AddComponent(UIBaseContainer, getAllRed_path)
  self.getAllRedCountN = self:AddComponent(UIText, getAllRedCount_path)
  self.del_all_btn = self:AddComponent(UIButton, del_all_btn_path)
  self.del_all_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDelAllBtnClick()
  end)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OpenTips()
  end)
  self.close_info_btn = self:AddComponent(UIButton, close_info_btn_path)
  self.close_info_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:CloseTips()
  end)
  self.tabIndex = 1
  self.tips_obj:SetActive(false)
  self.scoreFlyTarget = self:AddComponent(UIBaseContainer, scoreFlyTarget_path)
  self.scrollView = self:AddComponent(UIScrollRect, scrollView_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.content:Init(bindFunc1, bindFunc2, bindFunc3)
end

local function OnDestroy(self)
  self:ClearScroll()
  self.giftGoList = nil
  self.title = nil
  self.content = nil
  self.return_btn = nil
  self.close_btn = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ToggleControlBorS(self)
  if self.toggle1:GetIsOn() then
    self.tabIndex = 1
  elseif self.toggle2:GetIsOn() then
    self.tabIndex = 2
  end
  self:OnRefresh(true)
end

local function SetNoName(self, isShow)
  if isShow ~= self.hideNameState then
    self.ctrl:SetNoName(isShow)
  end
end

local function OnRefresh(self, reSort)
  local data = self.view.ctrl:GetAllianceGiftData(TabToGiftType[self.tabIndex])
  local percent = data.curExp / math.max(1, data.maxExp)
  self.slider:SetValue(percent)
  self.slider_txt:SetText(string.GetFormattedSeperatorNum(data.curExp) .. "/" .. string.GetFormattedSeperatorNum(data.maxExp))
  self.level_num:SetText(Localization:GetString(GameDialogDefine.LEVEL) .. data.curLevel)
  self:UpdateGiftList()
  local giftCount = table.length(self.list)
  if self.list ~= nil and 0 < giftCount then
    self.content:SetActive(true)
    self.empty_txt:SetActive(false)
    self.content:SetItemCount(giftCount)
  else
    self.content:SetActive(false)
    self.empty_txt:SetActive(true)
  end
  self:RefreshRedPoint()
end

local function UpdateGiftList(self)
  local data = self.view.ctrl:GetAllianceGiftData(TabToGiftType[self.tabIndex])
  self.list = data.list
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  table.sort(self.list, function(a, b)
    local overTimeA = a.endTime - serverTime > 0 and 1 or -1
    local overTimeB = b.endTime - serverTime > 0 and 1 or -1
    if overTimeA ~= overTimeB then
      return overTimeA > overTimeB
    elseif a.receiveState ~= b.receiveState then
      return a.receiveState < b.receiveState
    elseif a.receiveState == 0 then
      if a.endTime ~= b.endTime then
        return a.endTime < b.endTime
      else
        return false
      end
    elseif a.receiveTime ~= b.receiveTime then
      return a.receiveTime > b.receiveTime
    else
      return false
    end
  end)
end

local function RefreshRedPoint(self)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local showGetAll = false
  for i = 1, 2 do
    local data = self.view.ctrl:GetAllianceGiftData(TabToGiftType[i])
    local redCount = 0
    for id, gift in ipairs(data.list) do
      if gift.receiveState == 0 and serverTime < gift.endTime then
        redCount = redCount + 1
      end
    end
    self.toggleRedPoint[i]:SetActive(0 < redCount)
    if i == 1 then
      if 0 < redCount and self.tabIndex == 1 then
        self.get_all_btn:SetActive(true)
        self.getAllRedN:SetActive(true)
        self.getAllRedCountN:SetText(redCount)
      else
        self.get_all_btn:SetActive(false)
        self.getAllRedN:SetActive(false)
      end
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshAllianceGift, self.OnRefresh)
  self:AddUIListener(EventId.AlGiftHideNameStateUpdate, self.UpdateHideNameState)
  self:AddUIListener(EventId.OnTaskForceRefreshFinish, self.DelayRefreshUI)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshAllianceGift, self.OnRefresh)
  self:RemoveUIListener(EventId.AlGiftHideNameStateUpdate, self.UpdateHideNameState)
  self:RemoveUIListener(EventId.OnTaskForceRefreshFinish, self.DelayRefreshUI)
end

local function OnGetAllBtnClick(self)
  self.ctrl:OnGetAllBtnClick(TabToGiftType[self.tabIndex])
end

local function OnDelAllBtnClick(self)
  UIUtil.ShowMessage(Localization:GetString("390844"), 2, nil, nil, function()
    self.ctrl:OnDelAllBtnClick(TabToGiftType[self.tabIndex])
  end, nil, nil)
end

local function OpenTips(self)
  self.tips_obj:SetActive(true)
end

local function CloseTips(self)
  self.tips_obj:SetActive(false)
end

local function UpdateHideNameState(self)
  self.hideNameState = LuaEntry.Player.alGiftHideName == 1
end

local function OnGetClick(self, uuid)
  if not self.isGetBtnReady then
    return false
  end
  for i, v in ipairs(self.list) do
    if v.uuid == uuid then
      self.animIndex = i
    end
  end
  self.isGetBtnReady = false
  self:AddGetBtnTimer()
  self.ctrl:OnGetClick(uuid)
  self:OnGetOneAllianceGift()
  return true
end

local function AddGetBtnTimer(self)
  if self.getBtnTimer == nil then
    self.getBtnTimer = TimerManager:GetInstance():GetTimer(0.4, self.getBtnTimerAction, self, true, false, false)
    self.getBtnTimer:Start()
  end
end

local function DelGetBtnTimer(self)
  if self.getBtnTimer ~= nil then
    self.getBtnTimer:Stop()
    self.getBtnTimer = nil
  end
end

local function DelayRefreshUI(self)
  self:AddTimer()
end

local function DoQuestShowAnimation(self)
  for i, v in pairs(self.giftGoList) do
    v:PlayShowAnimation(5)
  end
  self:OnRefresh()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnGetOneAllianceGift(self)
  self.scrollView:StopMovement()
  self:TargetToNext()
  self:RefreshRedPoint()
end

local function TargetToNext(self)
  local targetIndex = self:GetOneUnclaimedIndex()
  if 0 < targetIndex then
    self.content:MoveItemByIndex(targetIndex - 1, 0.2)
  end
end

local function GetOneUnclaimedIndex(self)
  local targetIndex = -1
  for i = self.animIndex, #self.list do
    if self.list[i].receiveState == 0 then
      targetIndex = i
      break
    end
  end
  if targetIndex <= 0 then
    for i = self.animIndex, 1, -1 do
      if self.list[i].receiveState == 0 then
        targetIndex = i
        break
      end
    end
  end
  if targetIndex > #self.list - 2 then
    targetIndex = #self.list - 2
  end
  return targetIndex
end

local function AnimatorTime(self)
  self:DeleteAnimatorTimer()
  self.content:LaterItemByIndex(self.animIndex, 0.2)
end

local function DeleteAnimatorTimer(self)
  if self.animator_timer ~= nil then
    self.animator_timer:Stop()
    self.animator_timer = nil
  end
end

local function AddTimer(self)
  for i, v in pairs(self.giftGoList) do
    v:PlayShowAnimation(5)
  end
  self:OnRefresh()
end

local function OnInitScroll(self, go, index)
  local item = self.scrollView:AddComponent(AllianceGiftItem, go)
  self.giftGoList[go] = item
end

local function OnUpdateScroll(self, go, index)
  if not self.list then
    return
  end
  local sub = self.list[index + 1]
  local cellItem = self.giftGoList[go]
  cellItem:RefreshData(sub)
end

local function OnDestroyScrollItem(self, go, index)
end

local function ClearScroll(self)
  self.scrollView:RemoveComponents(AllianceGiftItem)
  self.content:DestroyChildNode()
end

UIAllianceGiftView.OnCreate = OnCreate
UIAllianceGiftView.OnDestroy = OnDestroy
UIAllianceGiftView.OnRefresh = OnRefresh
UIAllianceGiftView.OnEnable = OnEnable
UIAllianceGiftView.OnDisable = OnDisable
UIAllianceGiftView.OnAddListener = OnAddListener
UIAllianceGiftView.OnRemoveListener = OnRemoveListener
UIAllianceGiftView.ToggleControlBorS = ToggleControlBorS
UIAllianceGiftView.SetNoName = SetNoName
UIAllianceGiftView.OnGetAllBtnClick = OnGetAllBtnClick
UIAllianceGiftView.OnDelAllBtnClick = OnDelAllBtnClick
UIAllianceGiftView.OpenTips = OpenTips
UIAllianceGiftView.CloseTips = CloseTips
UIAllianceGiftView.UpdateHideNameState = UpdateHideNameState
UIAllianceGiftView.RefreshRedPoint = RefreshRedPoint
UIAllianceGiftView.OnGetOneAllianceGift = OnGetOneAllianceGift
UIAllianceGiftView.UpdateGiftList = UpdateGiftList
UIAllianceGiftView.OnInitScroll = OnInitScroll
UIAllianceGiftView.OnUpdateScroll = OnUpdateScroll
UIAllianceGiftView.OnDestroyScrollItem = OnDestroyScrollItem
UIAllianceGiftView.TargetToNext = TargetToNext
UIAllianceGiftView.AnimatorTime = AnimatorTime
UIAllianceGiftView.DeleteAnimatorTimer = DeleteAnimatorTimer
UIAllianceGiftView.OnGetClick = OnGetClick
UIAllianceGiftView.DoQuestShowAnimation = DoQuestShowAnimation
UIAllianceGiftView.ClearScroll = ClearScroll
UIAllianceGiftView.DelayRefreshUI = DelayRefreshUI
UIAllianceGiftView.AddTimer = AddTimer
UIAllianceGiftView.DelGetBtnTimer = DelGetBtnTimer
UIAllianceGiftView.AddGetBtnTimer = AddGetBtnTimer
UIAllianceGiftView.GetOneUnclaimedIndex = GetOneUnclaimedIndex
return UIAllianceGiftView
