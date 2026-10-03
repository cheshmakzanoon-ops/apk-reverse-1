local AllianceFunItem = BaseClass("AllianceFunItem", UIBaseContainer)
local base = UIBaseContainer
local img_path = "iconBg/icon"
local red_pot_path = "ImgWarn"
local red_pot_txt_path = "ImgWarn/TxtNum"
local name_path = "name"
local btn_path = "iconBg"
local countDown_path = "countDown"
local countDownTip_path = "countDown/tipTxt"
local countDownTxt_path = "countDown/timeTxt"

local function OnCreate(self, data)
  base.OnCreate(self)
  self.itemData = data
  self.name = self:AddComponent(UIText, name_path)
  self.img = self:AddComponent(UIImage, img_path)
  self.red_pot = self:AddComponent(UIBaseContainer, red_pot_path)
  self.red_pot_txt = self:AddComponent(UIText, red_pot_txt_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClick()
  end)
  self.name:SetText(self.itemData.name)
  self.img:LoadSprite(self.itemData.pic)
  self.countDown = self:AddComponent(UIBaseContainer, countDown_path)
  self.countDownTip = self:AddComponent(UIText, countDownTip_path)
  self.countDownTxt = self:AddComponent(UIText, countDownTxt_path)
  self:RefreshUI()
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnDestroy(self)
  self:DelTimer()
  self.itemData = nil
  self.name = nil
  self.img = nil
  self.red_pot_txt = nil
  self.red_pot = nil
  self.btn = nil
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AlSysStateChange, self.RefreshUI)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AlSysStateChange, self.RefreshUI)
end

local function RefreshUI(self)
  self:SetActive(true)
  self.countDown:SetActive(false)
end

local function OnRefreshRedPot(self, type)
  local count = self.view.ctrl:GetRedPotCount(type)
  if 0 < count then
    self.red_pot:SetActive(true)
    if type == AllianceButtonType.AllianceBattle then
      self.red_pot_txt:SetText("")
    else
      self.red_pot_txt:SetText(count)
    end
  else
    self.red_pot:SetActive(false)
  end
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
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.countDownTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self:RefreshUI()
  end
end

local function DelTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnClick(self)
  if self.itemData.type == AllianceButtonType.AllianceCity then
    self.red_pot:SetActive(false)
  end
  self.view.ctrl:OnGotoClick(self.itemData.type)
end

AllianceFunItem.OnCreate = OnCreate
AllianceFunItem.OnDestroy = OnDestroy
AllianceFunItem.OnRefreshRedPot = OnRefreshRedPot
AllianceFunItem.OnEnable = OnEnable
AllianceFunItem.OnDisable = OnDisable
AllianceFunItem.AddTimer = AddTimer
AllianceFunItem.SetRemainTime = SetRemainTime
AllianceFunItem.DelTimer = DelTimer
AllianceFunItem.RefreshUI = RefreshUI
AllianceFunItem.OnAddListener = OnAddListener
AllianceFunItem.OnRemoveListener = OnRemoveListener
AllianceFunItem.OnClick = OnClick
return AllianceFunItem
