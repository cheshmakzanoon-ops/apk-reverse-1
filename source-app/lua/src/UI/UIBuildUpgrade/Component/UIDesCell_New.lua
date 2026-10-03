local UIDesCell_New = BaseClass("UIDesCell_New", UIBaseContainer)
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

function UIDesCell_New:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDesCell_New:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDesCell_New:OnEnable()
  base.OnEnable(self)
end

function UIDesCell_New:OnDisable()
  base.OnDisable(self)
end

function UIDesCell_New:ComponentDefine()
  self.des_name = self:AddComponent(UIText, des_name_path)
  self.des_add = self:AddComponent(UIText, des_add_path)
  self.des_cur = self:AddComponent(UIText, des_cur_path)
  self.des_add_dur = self:AddComponent(UIBaseContainer, des_add_dur_path)
  self.des_bg = self:AddComponent(UIImage, "Image")
  self.btn = self:AddComponent(UIButton, "LayoutContent/Content/Btn")
  self.btn:SetOnClick(function()
    self:OnClickBtn()
  end)
  self.propertyIconImg = self:AddComponent(UIImage, property_icon_path)
  self.newImgObj = self:AddComponent(UIBaseContainer, new_img_path)
  self.normalUpgradeEffObj = self:AddComponent(UIBaseContainer, eff_ui_domintor_saoguang_long_new_path)
  self.newUnlockEffObj = self:AddComponent(UIBaseContainer, eff_ui_decoration_new_path)
end

function UIDesCell_New:ComponentDestroy()
  self.des_name = nil
  self.des_add = nil
  self.des_cur = nil
  self.line = nil
  self.des_add_dur = nil
  self.des_bg = nil
  if self.showEffTimer then
    self.showEffTimer:Stop()
    self.showEffTimer = nil
  end
end

function UIDesCell_New:DataDefine()
  self.param = {}
end

function UIDesCell_New:DataDestroy()
  self.param = nil
end

function UIDesCell_New:ReInit(param, refreshFromUpgrade)
  self.param = param
  self.isShowAddDes = param.isShowAddDes
  self.des_name:SetText(param.name)
  local isSameVal = param.addValue == param.curValue
  local isShowAddDesc = self.isShowAddDes and not isSameVal
  if param.addValue == nil or not isShowAddDesc then
    self.des_add:SetActive(false)
  else
    self.des_add:SetActive(true)
    self.des_add:SetText(param.addValue)
  end
  if param.addValue == nil or param.curValue == nil or not isShowAddDesc then
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
  self.des_bg:SetActive(param.index % 2 ~= 0)
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

function UIDesCell_New:OnClickBtn()
  self.view:ShowTip(self.param.extra, self.btn.transform.position)
end

function UIDesCell_New:RefreshPropertyIcon()
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

return UIDesCell_New
