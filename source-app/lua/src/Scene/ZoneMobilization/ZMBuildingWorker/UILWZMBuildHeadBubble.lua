local UILWTeamHeadBubble = BaseClass("UILWTeamHeadBubble")
local spe_head_path = "root/SpeHead"

local function __init(self, param, transform)
  self.transform = transform
  self.gameObject = transform and transform.gameObject
  self:DataDefine()
  self:ComponentDefine()
  self:Refresh(param)
end

local function __delete(self)
  self:DataDestroy()
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.item = self:AddComponent(UICommonHead, spe_head_path)
end

local function ComponentDestroy(self)
  self.item = nil
  self.transform = nil
  self.gameObject = nil
end

local function DataDefine(self)
  self.active = true
  self.duration = LuaEntry.DataConfig:TryGetNum("lock_banner", "k4", 1)
end

local function DataDestroy(self)
  self.active = nil
  self.duration = nil
end

local function AddComponent(self, component_target, var_arg, ...)
  assert(component_target.__ctype == ClassType.class)
  local component_inst = component_target.New(self, var_arg)
  component_inst:OnCreate(...)
  if component_inst:GetActiveInHierarchy() then
    component_inst:OnEnable()
  end
  return component_inst
end

local function Refresh(self, param)
  if param then
    self.item:ParseHeadInfo(param)
    self.item:SetEnableClickShowInfo(false, false)
    if not self.active then
      self:SetActive(true)
    end
  else
    self:SetActive(false)
  end
end

local function SetActive(self, active)
  if self.gameObject then
    self.gameObject:SetActive(active)
    self.active = active
  end
end

UILWTeamHeadBubble.__init = __init
UILWTeamHeadBubble.__delete = __delete
UILWTeamHeadBubble.ComponentDefine = ComponentDefine
UILWTeamHeadBubble.ComponentDestroy = ComponentDestroy
UILWTeamHeadBubble.DataDefine = DataDefine
UILWTeamHeadBubble.DataDestroy = DataDestroy
UILWTeamHeadBubble.AddComponent = AddComponent
UILWTeamHeadBubble.Refresh = Refresh
UILWTeamHeadBubble.SetActive = SetActive
return UILWTeamHeadBubble
