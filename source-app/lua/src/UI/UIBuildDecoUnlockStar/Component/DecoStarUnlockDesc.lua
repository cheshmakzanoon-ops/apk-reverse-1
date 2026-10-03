local DecoStarUnlockDesc = BaseClass("DecoStarUnlockDesc", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local des_name_path = "Root/LayoutContent/AccelerateText"
local des_add_path = "Root/LayoutContent/Content/AddValue"
local des_add_dur_path = "Root/LayoutContent/Content/AddDur"
local des_cur_path = "Root/LayoutContent/Content/CurValue"
local root_path = "Root"
local new_img_path = "Root/LayoutContent/NewImgRoot/VFX_new/NewImg"

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
end

local function ComponentDefine(self)
  self.des_name = self:AddComponent(UIText, des_name_path)
  self.des_add = self:AddComponent(UIText, des_add_path)
  self.des_cur = self:AddComponent(UIText, des_cur_path)
  self.des_add_dur = self:AddComponent(UIBaseContainer, des_add_dur_path)
  self.des_bg = self:AddComponent(UIImage, "Root/BG")
  self.rootObj = self:AddComponent(UIBaseContainer, root_path)
  self.simpleAni = self:AddComponent(UISimpleAnimation, "")
  self.newImgObj = self:AddComponent(UIBaseContainer, new_img_path)
end

local function ComponentDestroy(self)
  if self.aniDelayTimer then
    self.aniDelayTimer:Stop()
    self.aniDelayTimer = nil
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function DecoStarUnlockDesc:ReInit(index, param)
  self.param = param
  self.des_name:SetText(param.name)
  if param.addValue == nil then
    self.des_add:SetActive(false)
  else
    self.des_add:SetActive(true)
    self.des_add:SetText(param.addValue)
  end
  if param.addValue == nil or param.curValue == nil then
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
  self.rootObj:SetActive(false)
  self.aniDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.rootObj:SetActive(true)
    self.simpleAni:Play("FadeIn")
  end, 2 + index * 0.05)
  self.newImgObj:SetActive(self.param.isNew)
end

DecoStarUnlockDesc.OnCreate = OnCreate
DecoStarUnlockDesc.OnDestroy = OnDestroy
DecoStarUnlockDesc.OnEnable = OnEnable
DecoStarUnlockDesc.OnDisable = OnDisable
DecoStarUnlockDesc.ComponentDefine = ComponentDefine
DecoStarUnlockDesc.ComponentDestroy = ComponentDestroy
DecoStarUnlockDesc.DataDefine = DataDefine
DecoStarUnlockDesc.DataDestroy = DataDestroy
DecoStarUnlockDesc.OnAddListener = OnAddListener
DecoStarUnlockDesc.OnRemoveListener = OnRemoveListener
return DecoStarUnlockDesc
