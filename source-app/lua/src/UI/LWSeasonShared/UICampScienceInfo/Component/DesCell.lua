local DesCell = BaseClass("DesCell", UIBaseContainer)
local base = UIBaseContainer
local des_name_path = "AccelerateText"
local des_add_path = "AddValue"
local des_cur_path = "CurValue"
local des_arrow_path = "AddDur"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
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
  self.des_arrow = self:AddComponent(UIImage, des_arrow_path)
end

local function ComponentDestroy(self)
  self.des_name = nil
  self.des_add = nil
  self.des_cur = nil
end

local function RefreshData(self, levelStatus, data, description_tip)
  self.des_name:SetText(description_tip)
  if #data == 2 then
    self.des_cur:SetActive(true)
    self.des_arrow:SetActive(true)
    self.des_add:SetActive(true)
    local cueEffect = data[1]
    local curEffect_vec = string.split_ss_array(cueEffect, ";")
    if 2 <= #curEffect_vec then
      self.des_cur:SetText(curEffect_vec[2])
    end
    local nextEffect = data[2]
    local nextEffect_vec = string.split_ss_array(nextEffect, ";")
    if 2 <= #nextEffect_vec then
      self.des_add:SetText(nextEffect_vec[2])
    end
  else
    local effect = data[1]
    local effect_vec = string.split_ss_array(effect, ";")
    if 2 <= #effect_vec then
      if levelStatus == -1 then
        self.des_cur:SetActive(false)
        self.des_arrow:SetActive(false)
        self.des_add:SetActive(true)
        self.des_add:SetText(effect_vec[2])
      elseif levelStatus == 1 then
        self.des_cur:SetActive(true)
        self.des_arrow:SetActive(false)
        self.des_add:SetActive(false)
        self.des_cur:SetText(effect_vec[2])
      end
    end
  end
end

DesCell.OnCreate = OnCreate
DesCell.OnDestroy = OnDestroy
DesCell.OnEnable = OnEnable
DesCell.OnDisable = OnDisable
DesCell.ComponentDefine = ComponentDefine
DesCell.ComponentDestroy = ComponentDestroy
DesCell.RefreshData = RefreshData
return DesCell
