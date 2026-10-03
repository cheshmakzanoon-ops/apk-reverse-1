local MonsterBuffIconComponent = BaseClass("MonsterBuffIconComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.imgBuffIcon = self:AddComponent(UIImage, "mask/BuffIcon")
  self.btnMonsterBuffIcon = self:AddComponent(UIButton, "")
  self.btnMonsterBuffIcon:SetOnClick(function()
    self:OnBtnMonsterBuffIconClick()
  end)
end

local function ComponentDestroy(self)
  self.imgBuffIcon = nil
  self.btnMonsterBuffIcon = nil
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

local function OnBtnMonsterBuffIconClick(self)
  local statusLineData = DataCenter.StatusManager:GetTemplate(self.statusId)
  if statusLineData then
    local desc = Localization:GetString(statusLineData.description)
    UIUtil.ShowBubbleTips(desc, self.transform.position, 0, -30, 0)
  end
end

local function SetData(self, statusId)
  self.statusId = statusId
  local statusLineData = DataCenter.StatusManager:GetTemplate(statusId)
  if statusLineData then
    self.imgBuffIcon:LoadSprite(statusLineData.icon)
  end
end

MonsterBuffIconComponent.OnCreate = OnCreate
MonsterBuffIconComponent.OnDestroy = OnDestroy
MonsterBuffIconComponent.OnEnable = OnEnable
MonsterBuffIconComponent.OnDisable = OnDisable
MonsterBuffIconComponent.ComponentDefine = ComponentDefine
MonsterBuffIconComponent.ComponentDestroy = ComponentDestroy
MonsterBuffIconComponent.DataDefine = DataDefine
MonsterBuffIconComponent.DataDestroy = DataDestroy
MonsterBuffIconComponent.OnAddListener = OnAddListener
MonsterBuffIconComponent.OnRemoveListener = OnRemoveListener
MonsterBuffIconComponent.OnBtnMonsterBuffIconClick = OnBtnMonsterBuffIconClick
MonsterBuffIconComponent.SetData = SetData
return MonsterBuffIconComponent
