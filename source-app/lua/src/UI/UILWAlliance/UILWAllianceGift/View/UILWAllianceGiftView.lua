local AllianceGiftItem = require("UI/UILWAlliance/UILWAllianceGift/Component/LWAllianceGiftItem")
local UILWAlliancePrivilegeBubbleContent = require("UI.UILWAlliance.UILWAllianceGift.Component.UILWAlliancePrivilegeBubbleContent")
local UILWAllianceGiftView = BaseClass("UILWAllianceGiftView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local scrollView_path = "UICommonPopUpTitle/ImgBg/ScrollView"
local back_btn_path = "UICommonPopUpTitle/BtnBack"
local content_path = "UICommonPopUpTitle/ImgBg/ScrollView/contentWithEff"
local slider_path = "UICommonPopUpTitle/ImgBg/TopGift/Slider"
local slider_txt_path = "UICommonPopUpTitle/ImgBg/TopGift/Slider/Num"
local level_num_path = "UICommonPopUpTitle/ImgBg/TopGift/levelNum"
local set_toggle_path = "UICommonPopUpTitle/ImgBg/TopGift/setToggle"
local set_toggle_label_path = "UICommonPopUpTitle/ImgBg/TopGift/setToggle/Label"
local toggle_1_path = "UICommonPopUpTitle/ImgBg/ToggleGroup/Toggle1"
local toggle_1_txt_path = "UICommonPopUpTitle/ImgBg/ToggleGroup/Toggle1/toggleLabel1"
local toggleRedPoint_path = "UICommonPopUpTitle/ImgBg/ToggleGroup/Toggle%s/CommonRedPoint%s"
local toggle_2_path = "UICommonPopUpTitle/ImgBg/ToggleGroup/Toggle2"
local toggle_2_txt_path = "UICommonPopUpTitle/ImgBg/ToggleGroup/Toggle2/toggleLabel2"
local empty_txt_path = "UICommonPopUpTitle/ImgBg/TxtEmpty"
local get_all_btn_path = "UICommonPopUpTitle/ImgBg/getAllBtn"
local get_all_btn_txt_path = "UICommonPopUpTitle/ImgBg/getAllBtn/getTxt"
local getAllRed_path = "UICommonPopUpTitle/ImgBg/getAllBtn/red"
local getAllRedCount_path = "UICommonPopUpTitle/ImgBg/getAllBtn/red/redNum"
local del_all_btn_path = "UICommonPopUpTitle/ImgBg/delAllBtn"
local tips_obj_path = "UICommonPopUpTitle/ImgBg/tips"
local des_txt_path = "UICommonPopUpTitle/ImgBg/tips/Content/desTxt"
local scoreFlyTarget_path = "UICommonPopUpTitle/ImgBg/TopGift/Image_exp"
local txtdesc_path = "UICommonPopUpTitle/ImgBg/TopGift/txtdesc"
local tip_txt_path = "UICommonPopUpTitle/ImgBg/tipBg/tipTxt"
local tip_go_btn_path = "UICommonPopUpTitle/ImgBg/tipBg/tipGoBtn"
local tip_go_btn_txt_path = "UICommonPopUpTitle/ImgBg/tipBg/tipGoBtn/tipGoBtnTxt"
local checkbox_path = "UICommonPopUpTitle/ImgBg/bottom/HorLayout/CheckBoxContent/checkbox"
local get_all_advanced_gift_btn_path = "UICommonPopUpTitle/ImgBg/bottom/HorLayout/GetAllAdvancedGiftBtn"
local advanced_gift_red_path = "UICommonPopUpTitle/ImgBg/bottom/HorLayout/GetAllAdvancedGiftBtn/AdvancedGiftRed"
local advanced_gift_red_num_text_path = "UICommonPopUpTitle/ImgBg/bottom/HorLayout/GetAllAdvancedGiftBtn/AdvancedGiftRed/AdvancedGiftRedNumText"
local info_btn_path = "UICommonPopUpTitle/ImgBg/InfoBtn"
local gift_btn_path = "UICommonPopUpTitle/ImgBg/TopGift/GiftBtn"
local alliance_privilege_bubble_content_path = "UICommonPopUpTitle/ImgBg/AlliancePrivilegeBubbleContent"
local TabToGiftType = {
  [1] = 2,
  [2] = 1
}

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl:InitData()
  self.isGetBtnReady = true
  self.giftGoList = {}
  
  function self.getBtnTimerAction(temp)
    self.isGetBtnReady = true
    self:DelGetBtnTimer()
  end
  
  self.title = self:AddComponent(UIText, txt_title_path)
  self.title:SetLocalText(390445)
  self.backBtn = self:AddComponent(UIButton, back_btn_path)
  self.backBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_txt = self:AddComponent(UIText, slider_txt_path)
  self.empty_txt = self:AddComponent(UIText, empty_txt_path)
  self.empty_txt:SetLocalText(390447)
  self.desc_txt = self:AddComponent(UIText, txtdesc_path)
  self.desc_txt:SetLocalText(390446)
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
    local tempRed = self:AddComponent(UICommonRedPoint, string.format(toggleRedPoint_path, i, i))
    tempRed:SetType(CommonRedPointPriority.Level1)
    tempRed:SetActive(false)
    self.toggleRedPoint[i] = tempRed
  end
  self.toggle1 = self:AddComponent(UIToggle, toggle_1_path)
  self.toggle1:SetIsOn(true)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      if not self.toggle1.selecting then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
      end
      self:ToggleControlBorS()
    end
    self.toggle1.selecting = false
  end)
  self.toggle1_text = self:AddComponent(UIText, toggle_1_txt_path)
  self.toggle1_text:SetLocalText("alliance_system026")
  self.toggle2 = self:AddComponent(UIToggle, toggle_2_path)
  self.toggle2:SetIsOn(false)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      if not self.toggle2.selecting then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
      end
      self:ToggleControlBorS()
    end
    self.toggle2.selecting = false
  end)
  self.toggle2_text = self:AddComponent(UIText, toggle_2_txt_path)
  self.toggle2_text:SetLocalText("alliance_system027")
  self.tips_obj = self:AddComponent(UIBaseContainer, tips_obj_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.des_txt:SetLocalText(129088)
  self.get_all_btn = self:AddComponent(UIButton, get_all_btn_path)
  self.get_all_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
    self:OnGetAllBtnClick()
    self:OnDelAllBtnClick()
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
  self.tabIndex = 1
  self.list = {}
  self.scoreFlyTarget = self:AddComponent(UIBaseContainer, scoreFlyTarget_path)
  self.scrollView = self:AddComponent(UIScrollRect, scrollView_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.content:Init(bindFunc1, bindFunc2, bindFunc3)
  self.tip_txt = self:AddComponent(UIText, tip_txt_path)
  self.tip_go_btn = self:AddComponent(UIButton, tip_go_btn_path)
  self.tip_go_btn:SetOnClick(function()
    self:OnClickSearch()
  end)
  self.tip_go_btn_txt = self:AddComponent(UIText, tip_go_btn_txt_path)
  self.tip_go_btn_txt:SetLocalText(110003)
  self.checkbox = self:AddComponent(UIToggle, checkbox_path)
  self.hideNameState = LuaEntry.Player.alGiftHideName == 1
  self.checkbox:SetIsOn(self.hideNameState)
  self.checkbox:SetOnValueChanged(function(tf)
    self:OnGiftHideNameClick(tf)
  end)
  self.get_all_advanced_gift_btn = self:AddComponent(UIButton, get_all_advanced_gift_btn_path)
  self.get_all_advanced_gift_btn:SetOnClick(function()
    self:OnGetAllBtnClick()
  end)
  self.advanced_gift_red = self:AddComponent(UIImage, advanced_gift_red_path)
  self.advanced_gift_red_num_text = self:AddComponent(UIText, advanced_gift_red_num_text_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    UIUtil.ShowBubbleTips(Localization:GetString("alliance_system023"), self.info_btn.transform.position, 0, -30, -30)
  end)
  self.gift_btn = self:AddComponent(UIButton, gift_btn_path)
  self.gift_btn:SetOnClick(function()
    self.alliance_privilege_bubble_content:ShowView()
  end)
  self.alliance_privilege_bubble_content = self:AddComponent(UILWAlliancePrivilegeBubbleContent, alliance_privilege_bubble_content_path)
  self.alliance_privilege_bubble_content:SetActive(false)
end

local function OnDestroy(self)
  self:ClearScroll()
  self.giftGoList = nil
  self.title = nil
  self.content = nil
  self.tip_txt = nil
  self.tip_go_btn = nil
  self.tip_go_btn_txt = nil
  self.get_all_advanced_gift_btn = nil
  self.advanced_gift_red = nil
  self.advanced_gift_red_num_text = nil
  self.backBtn = nil
  self.gift_btn = nil
  self.alliance_privilege_bubble_content = nil
  if self.rotationTime then
    self.rotationTime:Stop()
    self.rotationTime = nil
  end
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
  local data = self.ctrl:GetAllianceGiftData(TabToGiftType[self.tabIndex])
  local percent = data.curExp / math.max(1, data.maxExp)
  self.slider:SetValue(percent)
  self.slider_txt:SetText(string.GetFormattedSeperatorNum(data.curExp) .. "/" .. string.GetFormattedSeperatorNum(data.maxExp))
  self.level_num:SetText(Localization:GetString(GameDialogDefine.LEVEL) .. " " .. data.curLevel)
  self.giftLevel = data.curLevel
  self:UpdateGiftList(data.list)
  local giftCount = table.length(self.list)
  if self.list ~= nil and 0 < giftCount then
    self.content:SetActive(true)
    self.empty_txt:SetActive(false)
    self.content:SetItemCount(giftCount)
  else
    self.content:SetActive(false)
    self.empty_txt:SetActive(true)
  end
  if self.tabIndex == 1 then
    self.tip_txt:SetLocalText(455059)
  elseif self.tabIndex == 2 then
    self.tip_txt:SetLocalText(455060)
  end
  self.checkbox:SetActive(self.tabIndex == 2)
  self:RefreshRedPoint(data.list)
end

function UILWAllianceGiftView:OnGiftHideNameClick(tf)
  if tf then
    SFSNetwork.SendMessage(MsgDefines.AllianceRewardHideName, 1)
  else
    SFSNetwork.SendMessage(MsgDefines.AllianceRewardHideName, 0)
  end
end

local function UpdateGiftList(self, dataList)
  self.list = {}
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  table.sort(dataList, function(a, b)
    local overTimeA = a.endTime - serverTime > 0 and 1 or -1
    local overTimeB = b.endTime - serverTime > 0 and 1 or -1
    if overTimeA ~= overTimeB then
      return overTimeA > overTimeB
    elseif a.receiveState ~= b.receiveState then
      return a.receiveState < b.receiveState
    elseif a.receiveState == 0 then
      if a.endTime ~= b.endTime then
        return a.endTime > b.endTime
      else
        return false
      end
    elseif a.receiveTime ~= b.receiveTime then
      return a.receiveTime > b.receiveTime
    elseif a.endTime ~= b.endTime then
      return a.endTime > b.endTime
    else
      return false
    end
  end)
  local giftMax = LuaEntry.DataConfig:TryGetNum("alliance_gift", "k4", 500)
  if giftMax < #dataList then
    local deleteList = {}
    for i, v in ipairs(dataList) do
      if i <= giftMax then
        table.insert(self.list, v)
      elseif v.receiveState == 1 then
        table.insert(deleteList, v.uuid)
      end
    end
    DataCenter.AllianceGiftDataManager:RemoveAllianceGiftListData(deleteList, TabToGiftType[self.tabIndex])
  else
    self.list = dataList
  end
end

local function RefreshRedPoint(self, giftList)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  for i = 1, 2 do
    local data
    if i == self.tabIndex and giftList then
      data = giftList
    else
      data = self.ctrl:GetAllianceGiftData(TabToGiftType[i]).list
    end
    local redCount = DataCenter.AllianceGiftDataManager:GetRedPointNum(TabToGiftType[i])
    self.toggleRedPoint[i]:SetNum(redCount)
    if i == 1 then
      if 0 < redCount and self.tabIndex == 1 then
        self.get_all_btn:SetActive(true)
        self.getAllRedN:SetActive(true)
        self.getAllRedCountN:SetText(redCount)
      else
        self.get_all_btn:SetActive(false)
        self.getAllRedN:SetActive(false)
      end
    elseif self.tabIndex == 2 then
      local limitLevel = LuaEntry.DataConfig:TryGetNum("alliance_gift", "k5")
      self.get_all_advanced_gift_btn:SetActive(limitLevel <= self.giftLevel and 0 < redCount)
      self.advanced_gift_red:SetActive(0 < redCount)
      if 0 < redCount then
        self.advanced_gift_red_num_text:SetText(redCount)
      end
    else
      self.get_all_advanced_gift_btn:SetActive(false)
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshAllianceGift, self.OnRefresh)
  self:AddUIListener(EventId.AlGiftHideNameStateUpdate, self.UpdateHideNameState)
  self:AddUIListener(EventId.UpdateAllianceGiftNum, self.OnRefresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshAllianceGift, self.OnRefresh)
  self:RemoveUIListener(EventId.AlGiftHideNameStateUpdate, self.UpdateHideNameState)
  self:RemoveUIListener(EventId.UpdateAllianceGiftNum, self.OnRefresh)
end

local function OnGetAllBtnClick(self)
  self.ctrl:OnGetAllBtnClick(TabToGiftType[self.tabIndex])
end

local function OnDelAllBtnClick(self)
  self.ctrl:OnDelAllBtnClick(TabToGiftType[self.tabIndex])
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
  self.isGetBtnReady = false
  self:AddGetBtnTimer()
  self.ctrl:OnGetClick(uuid, TabToGiftType[self.tabIndex])
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

local function OnGetOneAllianceGift(self)
  self.scrollView:StopMovement()
end

local function TargetToNext(self)
end

local function GetOneUnclaimedIndex(self)
  local targetIndex = -1
  return targetIndex
end

local function AnimatorTime(self)
  self:DeleteAnimatorTimer()
end

local function DeleteAnimatorTimer(self)
  if self.animator_timer ~= nil then
    self.animator_timer:Stop()
    self.animator_timer = nil
  end
end

local function OnInitScroll(self, go, index)
  local item = self.scrollView:AddComponent(AllianceGiftItem, go)
  self.giftGoList[go] = item
end

local function OnUpdateScroll(self, go, index)
  if self.list == nil or self.list[index + 1] == nil then
    go:SetActive(false)
    return
  end
  local sub = self.list[index + 1]
  local cellItem = self.giftGoList[go]
  go:SetActive(true)
  cellItem:RefreshData(sub)
end

local function OnDestroyScrollItem(self, go, index)
end

local function ClearScroll(self)
  self.scrollView:RemoveComponents(AllianceGiftItem)
  self.content:DestroyChildNode()
end

local function OnClickSearch(self)
  if self.tabIndex == 1 then
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    SceneUtils.ChangeToWorld(function()
      GoToUtil.GotoOpenView(UIWindowNames.UISearch, UISearchType.Boss)
    end)
  elseif self.tabIndex == 2 then
    local pack = self.ctrl:CheckHasFirstPay()
    if pack ~= nil then
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoOpenView(UIWindowNames.UIFirstPay, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllHide
      }, {delay = 0.5})
    else
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoOpenView(UIWindowNames.LWBuyDiamond, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllHide
      }, nil, nil, RechargeEntryType.Store)
    end
  end
end

UILWAllianceGiftView.OnCreate = OnCreate
UILWAllianceGiftView.OnDestroy = OnDestroy
UILWAllianceGiftView.OnRefresh = OnRefresh
UILWAllianceGiftView.OnEnable = OnEnable
UILWAllianceGiftView.OnDisable = OnDisable
UILWAllianceGiftView.OnAddListener = OnAddListener
UILWAllianceGiftView.OnRemoveListener = OnRemoveListener
UILWAllianceGiftView.ToggleControlBorS = ToggleControlBorS
UILWAllianceGiftView.SetNoName = SetNoName
UILWAllianceGiftView.OnGetAllBtnClick = OnGetAllBtnClick
UILWAllianceGiftView.OnDelAllBtnClick = OnDelAllBtnClick
UILWAllianceGiftView.OpenTips = OpenTips
UILWAllianceGiftView.CloseTips = CloseTips
UILWAllianceGiftView.UpdateHideNameState = UpdateHideNameState
UILWAllianceGiftView.RefreshRedPoint = RefreshRedPoint
UILWAllianceGiftView.OnGetOneAllianceGift = OnGetOneAllianceGift
UILWAllianceGiftView.UpdateGiftList = UpdateGiftList
UILWAllianceGiftView.OnInitScroll = OnInitScroll
UILWAllianceGiftView.OnUpdateScroll = OnUpdateScroll
UILWAllianceGiftView.OnDestroyScrollItem = OnDestroyScrollItem
UILWAllianceGiftView.TargetToNext = TargetToNext
UILWAllianceGiftView.AnimatorTime = AnimatorTime
UILWAllianceGiftView.DeleteAnimatorTimer = DeleteAnimatorTimer
UILWAllianceGiftView.OnGetClick = OnGetClick
UILWAllianceGiftView.ClearScroll = ClearScroll
UILWAllianceGiftView.DelGetBtnTimer = DelGetBtnTimer
UILWAllianceGiftView.AddGetBtnTimer = AddGetBtnTimer
UILWAllianceGiftView.GetOneUnclaimedIndex = GetOneUnclaimedIndex
UILWAllianceGiftView.OnClickSearch = OnClickSearch
return UILWAllianceGiftView
