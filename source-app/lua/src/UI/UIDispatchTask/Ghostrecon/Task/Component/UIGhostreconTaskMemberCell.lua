local base = UIBaseContainer
local UIGhostreconTaskMemberCell = BaseClass("UIGhostreconTaskMemberCell", base)
local playerHead_path = "Head/UIPlayerHead"

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
  self.playerHead = self:AddComponent(UICommonHead, playerHead_path)
  self.playerHead:SetEnableClickShowInfo(true, true)
end

local function ComponentDestroy(self)
  self.playerHead = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, headInfo)
  if headInfo then
    self.playerHead:SetActive(true)
    self.playerHead:ParseHeadInfo(headInfo)
  else
    self.playerHead:SetActive(false)
  end
end

UIGhostreconTaskMemberCell.OnCreate = OnCreate
UIGhostreconTaskMemberCell.OnDestroy = OnDestroy
UIGhostreconTaskMemberCell.OnEnable = OnEnable
UIGhostreconTaskMemberCell.OnDisable = OnDisable
UIGhostreconTaskMemberCell.ComponentDefine = ComponentDefine
UIGhostreconTaskMemberCell.ComponentDestroy = ComponentDestroy
UIGhostreconTaskMemberCell.DataDefine = DataDefine
UIGhostreconTaskMemberCell.DataDestroy = DataDestroy
UIGhostreconTaskMemberCell.SetData = SetData
return UIGhostreconTaskMemberCell
