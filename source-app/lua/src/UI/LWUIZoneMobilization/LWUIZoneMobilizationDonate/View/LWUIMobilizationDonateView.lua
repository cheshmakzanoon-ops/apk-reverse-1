local LWUIMobilizationDonateView = BaseClass("LWUIMobilizationDonateView", UIBaseView)
local Localization = CS.GameEntry.Localization
local base = UIBaseView
local UIGray = CS.UIGray
local panel_path = "Root/panel"
local close_btn_path = "Root/Common_bg_orange/CloseBtn"
local frame_path = "Root/Common_bg_orange/CenterContent/Item/Frame"
local icon_path = "Root/Common_bg_orange/CenterContent/Item/Icon"
local donate_get_path = "Root/Common_bg_orange/CenterContent/DonateGet"
local get_num_text_path = "Root/Common_bg_orange/CenterContent/DonateGet/GetNumText"
local slider_path = "Root/Common_bg_orange/CenterContent/InfoInput/Slider"
local dec_btn_path = "Root/Common_bg_orange/CenterContent/InfoInput/DecBtn"
local add_btn_path = "Root/Common_bg_orange/CenterContent/InfoInput/AddBtn"
local count_text_path = "Root/Common_bg_orange/CenterContent/InfoInput/TextBg/CountText"
local donate_btn_path = "Root/Common_bg_orange/BottomGroup/DonateBtn"
local have_num_path = "Root/Common_bg_orange/BottomGroup/HaveNumGroup/HaveNum"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, panel_path)
  self.btnPanel:SetOnClick(BindCallback(self, self.OnCloseBtnClick))
  self.costFrame = self:AddComponent(UIImage, frame_path)
  self.costIcon = self:AddComponent(UIImage, icon_path)
  self.donate_get = self:AddComponent(UIBaseContainer, donate_get_path)
  self.get_num_text = self:AddComponent(UITextMeshProUGUIEx, get_num_text_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider:SetOnValueChanged(function(value)
    self:OnInputSliderChanged(value)
  end)
  self.dec_btn = self:AddComponent(UIButton, dec_btn_path)
  self.dec_btn:SetOnClick(BindCallback(self, self.OnDecBtnClick))
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(BindCallback(self, self.OnAddBtnClick))
  self.count_text = self:AddComponent(UITextMeshProUGUIEx, count_text_path)
  self.donate_btn = self:AddComponent(UIButton, donate_btn_path)
  self.donate_btn:SetOnClick(BindCallback(self, self.OnDonateBtnClick))
  self.have_num = self:AddComponent(UITextMeshProUGUIEx, have_num_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self, self.OnCloseBtnClick))
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.costFrame = nil
  self.costIcon = nil
  self.donate_get = nil
  self.get_num_text = nil
  self.slider = nil
  self.dec_btn = nil
  self.add_btn = nil
  self.count_text = nil
  self.donate_btn = nil
  self.have_num = nil
  self.close_btn = nil
end

local function DataDefine(self)
  self.point = self:GetUserData()
  self.isNone = nil
  self.canSliderChange = true
end

local function DataDestroy(self)
  self.point = nil
  self.isNone = nil
  self.canSliderChange = nil
end

local function ReInit(self)
  local itemId = DataCenter.LWZoneMobilizationManager:GetDonateCostItemData()
  if itemId then
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if template then
      self.costFrame:LoadSprite(UIUtil.GetItemQualityBg(template.quality))
    end
    self.costIcon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(itemId))
    local getNum = LuaEntry.DataConfig:TryGetNum("zone_mobilization", "k16", 1)
    self.unitGetNum = getNum
    local have = DataCenter.ItemData:GetItemCount(itemId) or 0
    self.minItemCount = 1
    self.haveNum = have
    self.maxItemCount = 0 < have and have or 1
    self.have_num:SetText(have)
    self.isNone = have == 0
    self:UpdateGetNumText(self.maxItemCount)
    self:UpdateSliderValue()
  end
end

local function OnCloseBtnClick(self)
  self.ctrl:CloseSelf()
end

local function RealDonate(self)
  if self.point and self.point > 0 then
    local info = CS.SceneManager.World:GetPointInfo(self.point)
    if info then
      local uuid = info.uuid
      local extraObj = SFSObject.New()
      extraObj:PutInt("zMDonateNum", self.curItemCount)
      MarchUtil.LaunchScout(MarchTargetType.SCOUT_ZONE_MOBILIZATION_DONATE, self.point, uuid, extraObj)
      self:OnCloseBtnClick()
    else
      Logger.LogError("point info is nil, the point id is " .. self.point)
    end
  else
    Logger.LogError("the point is nil or 0")
  end
end

local function OnDonateBtnClick(self)
  if self.isNone then
    UIUtil.ShowTipsId("zone_mobilization_donated_nothing")
  elseif DataCenter.LWZoneMobilizationManager:IsDonateLimited() then
    local param = {
      contentText = Localization:GetString("zone_mobilization_donated_alliance_check", DataCenter.LWZoneMobilizationManager:GetDonateLimitHoursItemData()),
      btnNum = 2,
      confirmBtnParam = {
        action = function()
          RealDonate(self)
        end
      }
    }
    UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.ZoneMobilizationDonateLimitedConfirm, param)
  elseif not LuaEntry.Player:IsInAlliance() then
    local param = {
      contentText = Localization:GetString("zone_mobilization_donated_not_alliance"),
      btnNum = 2,
      confirmBtnParam = {
        action = function()
          RealDonate(self)
        end
      }
    }
    UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.ZoneMobilizationDonateNoneAlliance, param)
  else
    RealDonate(self)
  end
end

local function OnAddBtnClick(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_ChangeNum, false)
  self.canSliderChange = false
  if self.curItemCount < self.maxItemCount then
    self:UpdateGetNumText(self.curItemCount + 1)
    self:UpdateSliderValue()
  end
  self.canSliderChange = true
end

local function OnDecBtnClick(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_ChangeNum, false)
  self.canSliderChange = false
  if self.curItemCount > 1 then
    self:UpdateGetNumText(self.curItemCount - 1)
    self:UpdateSliderValue()
  end
  self.canSliderChange = true
end

local function SetInputText(self, value)
  self.curItemCount = value
  self.count_text:SetText(value)
  self.get_num_text:SetText(self.unitGetNum * value)
  self:UpdateAddAndDecBtnState()
end

local function UpdateAddAndDecBtnState(self)
  local can_dec = self.curItemCount > self.minItemCount
  local can_add = self.curItemCount < self.maxItemCount
  if can_dec then
    UIGray.SetGray(self.dec_btn.transform, false, true)
  else
    UIGray.SetGray(self.dec_btn.transform, true, false)
  end
  if can_add then
    UIGray.SetGray(self.add_btn.transform, false, true)
  else
    UIGray.SetGray(self.add_btn.transform, true, false)
  end
end

local function OnInputSliderChanged(self, value)
  if self.canSliderChange then
    local curNum = math.floor(value * self.maxItemCount)
    curNum = math.max(self.minItemCount, curNum)
    curNum = math.min(self.maxItemCount, curNum)
    self:UpdateGetNumText(curNum)
  end
end

local function UpdateGetNumText(self, count)
  if count then
    self:SetInputText(count)
  end
end

local function UpdateSliderValue(self)
  if self.curItemCount and self.maxItemCount then
    self.slider:SetValue(self.curItemCount / self.maxItemCount)
  end
end

LWUIMobilizationDonateView.OnCreate = OnCreate
LWUIMobilizationDonateView.OnDestroy = OnDestroy
LWUIMobilizationDonateView.OnEnable = OnEnable
LWUIMobilizationDonateView.OnDisable = OnDisable
LWUIMobilizationDonateView.ComponentDefine = ComponentDefine
LWUIMobilizationDonateView.ComponentDestroy = ComponentDestroy
LWUIMobilizationDonateView.DataDefine = DataDefine
LWUIMobilizationDonateView.DataDestroy = DataDestroy
LWUIMobilizationDonateView.OnAddListener = OnAddListener
LWUIMobilizationDonateView.OnRemoveListener = OnRemoveListener
LWUIMobilizationDonateView.ReInit = ReInit
LWUIMobilizationDonateView.OnCloseBtnClick = OnCloseBtnClick
LWUIMobilizationDonateView.OnDonateBtnClick = OnDonateBtnClick
LWUIMobilizationDonateView.OnAddBtnClick = OnAddBtnClick
LWUIMobilizationDonateView.OnDecBtnClick = OnDecBtnClick
LWUIMobilizationDonateView.SetInputText = SetInputText
LWUIMobilizationDonateView.UpdateAddAndDecBtnState = UpdateAddAndDecBtnState
LWUIMobilizationDonateView.OnInputSliderChanged = OnInputSliderChanged
LWUIMobilizationDonateView.UpdateGetNumText = UpdateGetNumText
LWUIMobilizationDonateView.UpdateSliderValue = UpdateSliderValue
return LWUIMobilizationDonateView
