local UIBuildUpgradeSuccessLine = BaseClass("UIBuildUpgradeSuccessLine", UIBaseContainer)
local base = UIBaseContainer
local desc_path = "Content/Desc"
local desc1_path = "Content1/Desc1"
local left_val_path = "Content/RightGo/LeftVal"
local right_val_path = "Content/RightGo/RightVal"
local right_val1_path = "Content1/RightVal1"
local arrow_path = "Content/RightGo/ArrowContent"
local normal_icon_path = "BG/NormalIcon"
local power_icon_path = "BG/PowerIcon"
local powerKey = "135172"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.desc1_text = self:AddComponent(UIText, desc1_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.left_val_text = self:AddComponent(UIText, left_val_path)
  self.right_val_text = self:AddComponent(UIText, right_val_path)
  self.right_val1_text = self:AddComponent(UIText, right_val1_path)
  self.normalIcon = self:TryAddComponent(UIImage, normal_icon_path)
  self.powerIcon = self:TryAddComponent(UIImage, power_icon_path)
  self.anim = self:AddComponent(UIAnimator, self.gameObject)
end

local function ComponentDestroy(self)
  self.desc_text = nil
  self.left_val_text = nil
  self.right_val_text = nil
  self.normalIcon = nil
  self.powerIcon = nil
  self.anim = nil
end

local function DataDefine(self)
  self.stopAnim = nil
end

local function DataDestroy(self)
  self.stopAnim = nil
  self:ClearDelayPlayShowAnimTimer()
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, desc, leftVal, rightVal, key)
  self.stopAnim = false
  self:ClearDelayPlayShowAnimTimer()
  if self.anim then
    self.anim:Rebind()
  end
  self.desc_text:SetActive(false)
  self.desc1_text:SetActive(false)
  self.arrow:SetActive(false)
  self.left_val_text:SetActive(false)
  self.right_val_text:SetActive(false)
  self.right_val1_text:SetActive(false)
  if leftVal == nil then
    self.desc1_text:SetText(desc)
    self.right_val1_text:SetText(rightVal)
    self.desc1_text:SetActive(true)
    self.right_val1_text:SetActive(true)
  else
    self.desc_text:SetActive(true)
    self.arrow:SetActive(true)
    self.left_val_text:SetActive(true)
    self.right_val_text:SetActive(true)
    self.desc_text:SetText(desc)
    self.left_val_text:SetText(leftVal)
    self.right_val_text:SetText(rightVal)
    self.right_val_text:SetColor(leftVal == rightVal and WhiteColor or NewAttributeGreen)
  end
  if key and self.normalIcon and self.powerIcon then
    self.normalIcon.gameObject:SetActive(key ~= powerKey)
    self.powerIcon.gameObject:SetActive(key == powerKey)
  end
end

function UIBuildUpgradeSuccessLine:StopAnim(value)
  self.stopAnim = value
  self:ClearDelayPlayShowAnimTimer()
  self.anim:Play("UIBuildUpgradeSuccessCell_idle", 0, 0)
end

local function DelayPlayShowAnim(self, animName, delay)
  if not self.anim then
    self.anim = self:AddComponent(UIAnimator, self.gameObject)
    self.anim:Enable(true)
  end
  self.gameObject:SetActive(false)
  self:ClearDelayPlayShowAnimTimer()
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.anim then
      self.gameObject:SetActive(true)
      if self.stopAnim then
        self.anim:Play("UIBuildUpgradeSuccessCell_idle", 0, 0)
      else
        self.anim:Play(animName, 0, 0)
      end
    end
  end, delay)
end

local function ClearDelayPlayShowAnimTimer(self)
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UIBuildUpgradeSuccessLine:OnRecycle()
  self:ClearDelayPlayShowAnimTimer()
  self.stopAnim = false
end

UIBuildUpgradeSuccessLine.OnCreate = OnCreate
UIBuildUpgradeSuccessLine.OnDestroy = OnDestroy
UIBuildUpgradeSuccessLine.ComponentDefine = ComponentDefine
UIBuildUpgradeSuccessLine.ComponentDestroy = ComponentDestroy
UIBuildUpgradeSuccessLine.DataDefine = DataDefine
UIBuildUpgradeSuccessLine.DataDestroy = DataDestroy
UIBuildUpgradeSuccessLine.OnEnable = OnEnable
UIBuildUpgradeSuccessLine.OnDisable = OnDisable
UIBuildUpgradeSuccessLine.SetData = SetData
UIBuildUpgradeSuccessLine.DelayPlayShowAnim = DelayPlayShowAnim
UIBuildUpgradeSuccessLine.ClearDelayPlayShowAnimTimer = ClearDelayPlayShowAnimTimer
return UIBuildUpgradeSuccessLine
