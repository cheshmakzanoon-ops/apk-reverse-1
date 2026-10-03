local UIAlOfficialPos = BaseClass("UIAlOfficialPos", UIBaseContainer)
local base = UIBaseContainer
local root_path = "Root"
local name_path = "Root/Name"
local level_path = "Root/Level"

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
  self.root_image = self:AddComponent(UIImage, root_path)
  self.name_text = self:AddComponent(UIText, name_path)
end

local function ComponentDestroy(self)
  self.root_image = nil
  self.name_text = nil
end

local function DataDefine(self)
  self.active = true
end

local function DataDestroy(self)
  self.active = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, chatUserInfo)
  local officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(chatUserInfo.uid)
  if officialPos then
    self:SetActive(true)
    self.name_text:SetLocalText(AllianceOfficialPosConf[officialPos].name)
    self.active = true
  else
    self:SetActive(false)
    self.active = false
  end
end

local function IsActive(self)
  return self.active
end

UIAlOfficialPos.OnCreate = OnCreate
UIAlOfficialPos.OnDestroy = OnDestroy
UIAlOfficialPos.ComponentDefine = ComponentDefine
UIAlOfficialPos.ComponentDestroy = ComponentDestroy
UIAlOfficialPos.DataDefine = DataDefine
UIAlOfficialPos.DataDestroy = DataDestroy
UIAlOfficialPos.OnAddListener = OnAddListener
UIAlOfficialPos.OnRemoveListener = OnRemoveListener
UIAlOfficialPos.OnEnable = OnEnable
UIAlOfficialPos.OnDisable = OnDisable
UIAlOfficialPos.SetData = SetData
UIAlOfficialPos.IsActive = IsActive
return UIAlOfficialPos
