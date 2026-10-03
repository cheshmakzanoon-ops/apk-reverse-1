local UIPVEAddEnergyView = BaseClass("UIPVEAddEnergyView", UIBaseView)
local base = UIBaseView
local EnergyItem = require("UI.UIPVE.UIPVEAddEnergy.Component.EnergyItem")
local Localization = CS.GameEntry.Localization
local panel_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local title_text_path = "UICommonPopUpTitle/Common_img_title/titleText"
local slider_path = "Bg/sliderBg/Slider"
local total_num_path = "Bg/sliderBg/totalNum"
local more_btn_go_path = "MoreBtn"
local use_count_btn_path = "MoreBtn/UseCountBtn"
local use_count_btn_name_path = "MoreBtn/UseCountBtn/UseCountBtnName"
local use_max_btn_path = "MoreBtn/UseMaxBtn"
local use_max_btn_name_path = "MoreBtn/UseMaxBtn/UseMaxBtnName"
local scrollview_path = "Bg/ScrollViews"
local content_path = "Bg/ScrollViews/Content"
local resume_tip_text_path = "Bg/sliderBg/ResumeTipText"
local all_resume_text_path = "Bg/sliderBg/ResumeTipText/AllResumeText"
local infoBtn_path = "Bg/btn_detail"
local gold_go_path = "goldObj"
local gold_num_path = "goldObj/goldNum"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self.content:SetAnchoredPosition(Vector2.New(0, 0))
  self.content:Dispose()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.total_num = self:AddComponent(UIText, total_num_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.more_btn_go = self:AddComponent(UIAnimator, more_btn_go_path)
  self.use_count_btn = self:AddComponent(UIButton, use_count_btn_path)
  self.use_count_btn_name = self:AddComponent(UIText, use_count_btn_name_path)
  self.use_max_btn = self:AddComponent(UIButton, use_max_btn_path)
  self.use_max_btn_name = self:AddComponent(UIText, use_max_btn_name_path)
  self.gold_btn = self:AddComponent(UIButton, gold_go_path)
  self.gold_num = self:AddComponent(UIText, gold_num_path)
  self.gold_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, {anim = true})
  end)
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.use_count_btn:SetOnClick(function()
    self:MoreBtnClick()
  end)
  
  function self.timer_action(temp)
    self:RefreshFormationStamina()
  end
  
  self.scrollview = self:AddComponent(UIBaseContainer, scrollview_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  self.resume_tip_text = self:AddComponent(UIText, resume_tip_text_path)
  self.all_resume_text = self:AddComponent(UIText, all_resume_text_path)
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnStateBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.more_btn_go.transform:SetParent(self.transform)
  self.more_btn_go:SetActive(false)
  self.btn = nil
  self.close_btn = nil
  self.title_text = nil
  self.slider = nil
  self.total_num = nil
  self.scrollview = nil
  self.content = nil
  self.more_btn_go = nil
  self.more_btn = nil
  self.more_btn_name = nil
  self.use_count_btn = nil
  self.use_count_btn_name = nil
  self.use_max_btn = nil
  self.use_max_btn_name = nil
  self.resume_tip_text = nil
  self.all_resume_text = nil
  self.all_resume_time = nil
end

local function DataDefine(self)
  self.moreItemId = nil
  self.moreBtnMax = nil
  self.moreIndex = nil
  self.items = {}
  self.cells = {}
  self.moreParent = nil
  self.isCreateScroll = false
  self.sendMessage = false
  self.isShowMore = false
  self.listGO = {}
  self.resumeSpeed = 0
  self.resumeIsTrue = nil
end

local function DataDestroy(self)
  self.moreItemId = nil
  self.moreBtnMax = nil
  self.moreIndex = nil
  self.items = nil
  self.cells = nil
  self.moreParent = nil
  self.resumeSpeed = nil
  self.resumeIsTrue = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
  self:AddTimer()
end

local function OnDisable(self)
  self:DeleteTimer()
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:AddUIListener(EventId.FormationStaminaUpdate, self.OnUseCallBack)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:RemoveUIListener(EventId.FormationStaminaUpdate, self.OnUseCallBack)
end

local function RefreshFormationStamina(self)
  local curNum = LuaEntry.Player:GetCurPveStamina()
  if self.curNum ~= curNum then
    self.curNum = curNum
    local maxNum = LuaEntry.Player:GetMaxPveStamina()
    if 0 < maxNum then
      local dur = self.curNum / maxNum
      self.slider:SetValue(dur)
      self.total_num:SetLocalText(GameDialogDefine.SPLIT, self.curNum, maxNum)
    end
  end
end

local function MoreBtnClick(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Speed_Button, false)
  local item = DataCenter.ItemData:GetItemById(self.moreItemId)
  if item ~= nil then
    SFSNetwork.SendMessage(MsgDefines.ItemUse, {
      uuid = item.uuid,
      num = self.moreBtnMax
    })
  end
end

local function OnUseCallBack(self)
  self.sendMessage = false
  self:RefreshFormationStamina()
  self.items = self.ctrl:GetItemList()
  self.content:SetItemCount(#self.items)
  self.content:ForceUpdate()
end

local function OnUseGoldCallBack(self)
  self.sendMessage = false
  self:RefreshFormationStamina()
  for k, v in pairs(self.cells) do
    v:RefreshGoldData()
  end
end

local function ReInit(self)
  self.title_text:SetLocalText(134002)
  self.more_btn_go:SetActive(false)
  self:ShowCells()
  self:RefreshFormationStamina()
  self.gold_num:SetText(string.GetFormattedSeperatorNum(LuaEntry.Player.gold))
end

local function ShowCells(self)
  self.items = self.ctrl:GetItemList()
  self.more_btn_go:SetActive(false)
  local count = #self.items
  if not self.isCreateScroll then
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    self.content:Init(bindFunc1, bindFunc2, bindFunc3)
  end
  self.content:SetAnchoredPosition(Vector2.New(0, 0))
  self.content:SetItemCount(count)
  self.content:ForceUpdate()
  self.isCreateScroll = true
end

local function ClearScroll(self)
  self.scrollview:RemoveComponents(EnergyItem)
  self.content:DestroyChildNode()
end

local function OnInitScroll(self, go, index)
  local item = self.scrollview:AddComponent(EnergyItem, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  local param = self.items[index + 1]
  
  function param.callBack(_index, index, template, pos, isBuy)
    self:CellsCallBack(_index, index, template, pos, isBuy)
  end
  
  cellItem:ReInit(param)
  self.cells[index + 1] = cellItem
end

local function OnDestroyScrollItem(self, go, index)
  if self.showTimer == nil then
    self:HideMoreBtn()
  end
end

local function CellsCallBack(self, index, template, pos, isBuy)
  if self.sendMessage == true then
    return
  end
  if isBuy then
    self:HideMoreBtn()
    if LuaEntry.Player.gold >= template.price then
      self.sendMessage = true
      UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING, string.GetFormattedSeperatorNum(template.price), Localization:GetString(GameDialogDefine.DIAMOND), DataCenter.ItemTemplateManager:GetName(template.id)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.ItemBuyAndUse, {
          itemId = template.id,
          num = 1
        })
      end)
    else
      GoToUtil.GotoPayTips(template.price)
    end
  else
    self.moreItemId = template.id
    self.moreIndex = index
    local item = DataCenter.ItemData:GetItemById(template.id)
    self.sendMessage = true
    SFSNetwork.SendMessage(MsgDefines.ItemUse, {
      uuid = item.uuid,
      num = 1
    })
  end
end

local function ShowMoreBtn(self)
end

local function HideMoreBtn(self)
  if self.moreParent then
    self.moreParent = nil
    self.more_btn_go.transform:SetParent(self.transform)
    self.more_btn_go.transform:SetAsFirstSibling()
    self.more_btn_go:Play("CloseMoreBtn", 0, 0)
  end
  self.isShowMore = false
end

local function ShowMoreBtnName(self, item)
end

local function UpdateGoldSignal(self)
  self.gold_num:SetText(string.GetFormattedSeperatorNum(LuaEntry.Player.gold))
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnStateBtnClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.infoBtnN.gameObject.transform.position + Vector3.New(180, -50, 0) * scaleFactor
  local endTime = 0
  local timeBase = LuaEntry.DataConfig:TryGetNum("pve_energy", "k2")
  local title = Localization:GetString("134007", math.floor(timeBase))
  local content0 = ""
  local content1 = ""
  local content2 = Localization:GetString("134003")
  local param = {}
  param.title = title
  param.content0 = content0
  param.content1 = content1
  param.content2 = content2
  param.endTime = endTime
  param.position = position
  param.isLeft = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTip, {anim = false}, param)
end

UIPVEAddEnergyView.OnCreate = OnCreate
UIPVEAddEnergyView.OnDestroy = OnDestroy
UIPVEAddEnergyView.OnEnable = OnEnable
UIPVEAddEnergyView.OnDisable = OnDisable
UIPVEAddEnergyView.ComponentDefine = ComponentDefine
UIPVEAddEnergyView.ComponentDestroy = ComponentDestroy
UIPVEAddEnergyView.DataDefine = DataDefine
UIPVEAddEnergyView.DataDestroy = DataDestroy
UIPVEAddEnergyView.OnAddListener = OnAddListener
UIPVEAddEnergyView.OnRemoveListener = OnRemoveListener
UIPVEAddEnergyView.MoreBtnClick = MoreBtnClick
UIPVEAddEnergyView.ClearScroll = ClearScroll
UIPVEAddEnergyView.ReInit = ReInit
UIPVEAddEnergyView.ShowCells = ShowCells
UIPVEAddEnergyView.CellsCallBack = CellsCallBack
UIPVEAddEnergyView.ShowMoreBtn = ShowMoreBtn
UIPVEAddEnergyView.ShowMoreBtnName = ShowMoreBtnName
UIPVEAddEnergyView.UpdateGoldSignal = UpdateGoldSignal
UIPVEAddEnergyView.HideMoreBtn = HideMoreBtn
UIPVEAddEnergyView.OnInitScroll = OnInitScroll
UIPVEAddEnergyView.OnUpdateScroll = OnUpdateScroll
UIPVEAddEnergyView.OnDestroyScrollItem = OnDestroyScrollItem
UIPVEAddEnergyView.DeleteTimer = DeleteTimer
UIPVEAddEnergyView.AddTimer = AddTimer
UIPVEAddEnergyView.OnUseGoldCallBack = OnUseGoldCallBack
UIPVEAddEnergyView.OnUseCallBack = OnUseCallBack
UIPVEAddEnergyView.RefreshFormationStamina = RefreshFormationStamina
UIPVEAddEnergyView.OnStateBtnClick = OnStateBtnClick
return UIPVEAddEnergyView
