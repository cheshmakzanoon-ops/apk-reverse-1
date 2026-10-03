local UILookForCareerItem = BaseClass("UILookForCareerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_path = "Toggle"
local check_path = "Check"
local cross_path = "Cross"
local desc_path = "Desc"
local State = {
  Idle = 1,
  Checked = 2,
  Crossed = 3
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.check_go = self:AddComponent(UIBaseContainer, check_path)
  self.cross_go = self:AddComponent(UIBaseContainer, cross_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.check_go = nil
  self.cross_go = nil
  self.desc_text = nil
end

local function DataDefine(self)
  self.data = nil
  self.onClick = nil
end

local function DataDestroy(self)
  self.data = nil
  self.onClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data)
  self.data = data
  if data.careerType ~= CareerType.None then
    local careerTemplate = DataCenter.PlayerCareerManager:GetCareerTemplate(data.careerType, 1)
    local careerName = Localization:GetString(careerTemplate.name)
    self.desc_text:SetText(string.format("%s (%s/%s)", careerName, data.cur, data.max))
  else
    self.desc_text:SetLocalText(395409)
  end
  self.check_go:SetActive(data.state == State.Checked)
  self.cross_go:SetActive(data.state == State.Crossed)
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

local function OnClick(self)
  if self.onClick then
    self.onClick()
  end
end

UILookForCareerItem.OnCreate = OnCreate
UILookForCareerItem.OnDestroy = OnDestroy
UILookForCareerItem.OnEnable = OnEnable
UILookForCareerItem.OnDisable = OnDisable
UILookForCareerItem.ComponentDefine = ComponentDefine
UILookForCareerItem.ComponentDestroy = ComponentDestroy
UILookForCareerItem.DataDefine = DataDefine
UILookForCareerItem.DataDestroy = DataDestroy
UILookForCareerItem.OnAddListener = OnAddListener
UILookForCareerItem.OnRemoveListener = OnRemoveListener
UILookForCareerItem.State = State
UILookForCareerItem.SetData = SetData
UILookForCareerItem.SetOnClick = SetOnClick
UILookForCareerItem.OnClick = OnClick
return UILookForCareerItem
