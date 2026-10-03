local MultiRewardCellComponent = BaseClass("MultiRewardCellComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local text_path = "Root/Text"
local l_w_btn_common_path = "Root/LW_Btn_Common"
local icon_img_path = "Root/IconImg"
local b_g_path = "Root/BG"
local detect_num_info_path = "Root/DetectNumInfo"
local before_change_num_text_path = "Root/DetectNumInfo/BeforeChangeNumText"
local before_change_max_num_text_path = "Root/DetectNumInfo/BeforeChangeMaxNumText"
local after_change_max_num_text_path = "Root/DetectNumInfo/AfterChangeMaxNumText"
local root_path = "Root"
local SHOW_ANI_INTERVAL = 0.2

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self:RestorePivotWhenDestroy()
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, text_path)
  self.gotoBtn = self:AddComponent(UIButton, l_w_btn_common_path)
  self.iconImg = self:AddComponent(UIImage, icon_img_path)
  self.bgImg = self:AddComponent(UIRawImage, b_g_path)
  self.gotoBtn:SetOnClick(function()
    self:OnGotoBtnClick()
  end)
  self.detectObj = self:AddComponent(UIBaseContainer, detect_num_info_path)
  self.curNumText = self:AddComponent(UIText, before_change_num_text_path)
  self.curMaxNumText = self:AddComponent(UIText, before_change_max_num_text_path)
  self.afterChangeMaxNumText = self:AddComponent(UIText, after_change_max_num_text_path)
  self.rootObj = self:AddComponent(UIBaseContainer, root_path)
  self.ani = self:AddComponent(UISimpleAnimation, root_path)
  self.bgAni = self:AddComponent(UISimpleAnimation, b_g_path)
  self:ChangePivotForArabicMirror()
end

local function ComponentDestroy(self)
  self:RestorePivotWhenDestroy()
end

local function DataDefine(self)
end

local function DataDestroy(self)
  if self.aniTimer then
    self.aniTimer:Stop()
    self.aniTimer = nil
  end
  self.bgLocalPos = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function MultiRewardCellComponent:SetData(multiRewardData, index)
  if not multiRewardData then
    return
  end
  self.template = multiRewardData:GetMultiRewardTemplate()
  if not self.template then
    return
  end
  if not string.IsNullOrEmpty(self.template.buff_title) then
    self.titleText:SetLocalText(self.template.buff_title)
  end
  if not string.IsNullOrEmpty(self.template.text_color) then
    local tab = string.split(self.template.text_color, ",")
    if #tab == 4 then
      self.titleText:SetColorRGBA255(tonumber(tab[1]), tonumber(tab[2]), tonumber(tab[3]), tonumber(tab[4]))
    end
  end
  if not string.IsNullOrEmpty(self.template.icon) then
    self.iconImg:LoadSprite(self.template.icon)
    self.iconImg:SetNativeSize()
  end
  if not string.IsNullOrEmpty(self.template.buff_bg) then
    self.bgImg:LoadSprite(self.template.buff_bg)
  end
  local isExistGoto = not string.IsNullOrEmpty(self.template.goto_type)
  self.gotoBtn:SetActive(isExistGoto)
  self:RefreshNumberNumInfo()
  if self.aniTimer then
    self.aniTimer:Stop()
    self.aniTimer = nil
  end
  if self.ani then
    self.ani:Play("Idle")
  end
  if self.bgAni then
    self.bgAni:Play("Idle")
  end
  self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.ani then
      self.ani:Play("Play")
    end
    if self.bgAni then
      self.bgAni:Play("Play")
    end
  end, SHOW_ANI_INTERVAL * index)
end

function MultiRewardCellComponent:RefreshNumberNumInfo()
  if not self.template or string.IsNullOrEmpty(self.template.baseValue) then
    self.detectObj:SetActive(false)
    return
  end
  local baseVal = toInt(self.template.baseValue)
  if baseVal <= 0 then
    self.detectObj:SetActive(false)
    return
  end
  self.detectObj:SetActive(true)
  local afterChangeNum = baseVal * toInt(self.template.param_num)
  self.curNumText:SetText(baseVal)
  self.curMaxNumText:SetText(baseVal)
  self.afterChangeMaxNumText:SetText(afterChangeNum)
end

function MultiRewardCellComponent:OnGotoBtnClick()
  if not self.template then
    return
  end
  local isExistGoto = not string.IsNullOrEmpty(self.template.goto_type)
  if not isExistGoto then
    return
  end
  GoToUtil.GoToByTypeAndParam(toInt(self.template.goto_type), {
    self.template.goto_para
  })
end

function MultiRewardCellComponent:ResetParent()
  if not self.holder or not self.holder.bgRoot then
    return
  end
  if not self.bgLocalPos then
    self.bgLocalPos = self.bgImg.rectTransform.localPosition
  end
  self.bgImg.transform:SetParent(self.holder.bgRoot.transform)
end

function MultiRewardCellComponent:ResetCellBGOrder()
  if not self.bgImg then
    return
  end
  self.bgImg.transform:SetAsLastSibling()
end

function MultiRewardCellComponent:ResetCellOnDestroy()
  self.bgImg.transform:SetParent(self.rootObj.transform)
  self.bgImg.transform:SetAsLastSibling()
  if self.bgLocalPos then
    self.bgImg.transform.localPosition = self.bgLocalPos
  end
end

function MultiRewardCellComponent:ChangePivotForArabicMirror()
  if not CommonUtil.IsArabicAutoMirrorOpen() then
    return
  end
  if self.bgImg then
    self.bgPivot = self.bgImg.rectTransform.pivot
    self.bgImg.rectTransform.pivot = Vector2(1 - self.bgPivot.x, self.bgPivot.y)
  end
  if self.rootObj.rectTransform then
    self.rootPivot = self.rootObj.rectTransform.pivot
    self.rootObj.rectTransform.pivot = Vector2(1 - self.rootPivot.x, self.rootPivot.y)
  end
end

function MultiRewardCellComponent:RestorePivotWhenDestroy()
  if not CommonUtil.IsArabicAutoMirrorOpen() then
    return
  end
  if self.bgPivot and not IsNull(self.bgImg.rectTransform) then
    self.bgImg.rectTransform.pivot = self.bgPivot
  end
  if self.rootPivot and not IsNull(self.rootObj.rectTransform) then
    self.rootObj.rectTransform.pivot = self.rootPivot
  end
end

function MultiRewardCellComponent:GetOrder()
  if self.template == nil then
    return 0
  end
  return self.template.order or 0
end

MultiRewardCellComponent.OnCreate = OnCreate
MultiRewardCellComponent.OnDestroy = OnDestroy
MultiRewardCellComponent.OnEnable = OnEnable
MultiRewardCellComponent.OnDisable = OnDisable
MultiRewardCellComponent.ComponentDefine = ComponentDefine
MultiRewardCellComponent.ComponentDestroy = ComponentDestroy
MultiRewardCellComponent.DataDefine = DataDefine
MultiRewardCellComponent.DataDestroy = DataDestroy
MultiRewardCellComponent.OnAddListener = OnAddListener
MultiRewardCellComponent.OnRemoveListener = OnRemoveListener
return MultiRewardCellComponent
