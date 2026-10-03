local UIDesCell4DecoLevelUpPanel = BaseClass("UIDesCell4DecoLevelUpPanel", UIBaseContainer)
local base = UIBaseContainer
local des_name_path = "LayoutContent/TextLayout/AccelerateText"
local des_add_path = "LayoutContent/Content/AddValue"
local des_add_dur_path = "LayoutContent/Content/AddDur"
local des_cur_path = "LayoutContent/Content/CurValue"
local property_icon_path = "LayoutContent/PropertyIconRoot/PropertyIcon"
local PROPERTY_ICON_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/"
local new_img_path = "LayoutContent/TextLayout/AccelerateText/NewImg"
local eff_ui_domintor_saoguang_long_new_path = "Eff_ui_domintor_saoguang_long_new"
local eff_ui_decoration_new_path = "Eff_ui_decoration_new"

function UIDesCell4DecoLevelUpPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDesCell4DecoLevelUpPanel:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDesCell4DecoLevelUpPanel:OnEnable()
  base.OnEnable(self)
end

function UIDesCell4DecoLevelUpPanel:OnDisable()
  base.OnDisable(self)
end

function UIDesCell4DecoLevelUpPanel:ComponentDefine()
  self.des_name = self:AddComponent(UIText, des_name_path)
  self.des_add = self:AddComponent(UIText, des_add_path)
  self.des_cur = self:AddComponent(UIText, des_cur_path)
  self.des_add_dur = self:AddComponent(UIBaseContainer, des_add_dur_path)
  self.btn = self:AddComponent(UIButton, "LayoutContent/Content/Btn")
  self.btn:SetOnClick(function()
    self:OnClickBtn()
  end)
  self.propertyIconImg = self:AddComponent(UIImage, property_icon_path)
  self.newImgObj = self:AddComponent(UIBaseContainer, new_img_path)
  self.normalUpgradeEffObj = self:AddComponent(UIBaseContainer, eff_ui_domintor_saoguang_long_new_path)
  self.newUnlockEffObj = self:AddComponent(UIBaseContainer, eff_ui_decoration_new_path)
  self.anim = self:AddComponent(UIAnimator, "")
end

function UIDesCell4DecoLevelUpPanel:ComponentDestroy()
  self.des_name = nil
  self.des_add = nil
  self.des_cur = nil
  self.line = nil
  self.des_add_dur = nil
  self.anim = nil
  if self.showEffTimer then
    self.showEffTimer:Stop()
    self.showEffTimer = nil
  end
end

function UIDesCell4DecoLevelUpPanel:DataDefine()
  self:ClearDelayPlayShowAnimTimer()
  self.param = {}
end

function UIDesCell4DecoLevelUpPanel:DataDestroy()
  self.param = nil
end

function UIDesCell4DecoLevelUpPanel:ReInit(param, refreshFromUpgrade)
  self.param = param
  self.isMaxLv = param.isMaxLv
  self.des_name:SetText(param.name)
  if param.addValue == nil or self.isMaxLv then
    self.des_add:SetActive(false)
  else
    self.des_add:SetActive(true)
    self.des_add:SetText(param.addValue)
  end
  if param.addValue == nil or param.curValue == nil or self.isMaxLv then
    self.des_add_dur:SetActive(false)
  else
    self.des_add_dur:SetActive(true)
  end
  if param.curValue == nil then
    self.des_cur:SetActive(false)
  else
    self.des_cur:SetActive(true)
    self.des_cur:SetText(param.curValue)
  end
  self.btn:SetActive(param.extra)
  self.newImgObj:SetActive(param.isNew)
  self:RefreshPropertyIcon()
  if not self.showEffTimer then
    self.normalUpgradeEffObj:SetActive(false)
    self.newUnlockEffObj:SetActive(false)
  end
  if refreshFromUpgrade and not self.showEffTimer then
    local isNew = param.isNew
    if isNew then
      self.normalUpgradeEffObj:SetActive(false)
      self.newUnlockEffObj:SetActive(true)
    else
      self.normalUpgradeEffObj:SetActive(true)
    end
    self.showEffTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.showEffTimer = nil
    end, 2)
  end
end

function UIDesCell4DecoLevelUpPanel:DelayPlayShowAnim(delay)
  if not self.anim then
    self.anim = self:AddComponent(UIAnimator, self.gameObject)
    self.anim:Enable(true)
  end
  self:ClearDelayPlayShowAnimTimer()
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.anim then
      self.anim:Play("DesCell4DecoLevelUpPanel_movein", 0, 0)
    end
  end, delay)
end

function UIDesCell4DecoLevelUpPanel:ClearDelayPlayShowAnimTimer()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UIDesCell4DecoLevelUpPanel:OnClickBtn()
  self.view:ShowTip(self.param.extra, self.btn.transform.position)
end

function UIDesCell4DecoLevelUpPanel:RefreshPropertyIcon()
  local effectId = self.param.effectId
  if not effectId then
    return
  end
  local effectIcon = GetTableData(TableName.LW_Effect_Number, effectId, "small_icon")
  if string.IsNullOrEmpty(effectIcon) then
    self.propertyIconImg:SetActive(false)
    return
  end
  self.propertyIconImg:SetActive(true)
  local path = PROPERTY_ICON_PATH .. effectIcon
  self.propertyIconImg:LoadSprite(path)
end

return UIDesCell4DecoLevelUpPanel
