local UILWTeamHeadBubble = BaseClass("UILWTeamHeadBubble")
local root_path = "root"
local head_group_path = "root/headGroup"
local spe_head_path = "root/headGroup/SpeHead"

local function __init(self, param, transform)
  self.sequence = sequence
  self.transform = transform
  self.gameObject = transform and transform.gameObject
  self:DataDefine()
  self:ComponentDefine()
  self:InitListView(param)
end

local function __delete(self)
  if not IsNull(self.sequence) then
    self.sequence:Pause()
    self.sequence:Kill()
    self.sequence = nil
  end
  self:DataDestroy()
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.canvasGroup = self.root.transform:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.content = self:AddComponent(UIBaseContainer, head_group_path)
  self.item = self:AddComponent(UICommonHead, spe_head_path)
  self.item.gameObject:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.root = nil
  self.canvasGroup = nil
  self.content:RemoveComponents(UICommonHead)
  self.content = nil
  self.item.gameObject:GameObjectRecycleAll()
  self.item = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.timer = nil
  self.headList = {}
  self.active = true
  self.duration = LuaEntry.DataConfig:TryGetNum("lock_banner", "k4", 1)
end

local function DataDestroy(self)
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  self.headList = nil
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

local function InitListView(self, param)
  if param then
    local name
    for i, v in ipairs(param) do
      local item = self.item.gameObject:GameObjectSpawn(self.content.transform)
      name = tostring(i)
      item.name = name
      local cell = self.content:AddComponent(UICommonHead, name)
      cell:ParseHeadInfo(v)
      cell:SetEnableClickShowInfo(false, false)
      table.insert(self.headList, cell)
    end
    self:AddTimer()
    if not self.active then
      self:SetActive(true)
    end
  else
    self:SetActive(false)
  end
end

local function Refresh(self, param)
  if param then
    if self.headList and #self.headList > 0 then
      local itemCount = #self.headList
      local index = 0
      for i, v in ipairs(param) do
        if i > itemCount then
          local item = self.item.gameObject:GameObjectSpawn(self.content.transform)
          local name = tostring(i)
          item.name = name
          local cell = self.content:AddComponent(UICommonHead, name)
          cell:ParseHeadInfo(v)
          cell:SetEnableClickShowInfo(false, false)
          cell:SetActive(true)
          table.insert(self.headList, cell)
        else
          local cell = self.headList[i]
          if cell then
            cell:ParseHeadInfo(v)
            cell:SetActive(true)
          end
        end
        index = i
      end
      self:AddTimer()
      if itemCount > index then
        for i = index + 1, itemCount do
          local cell = self.headList[i]
          if cell then
            cell:SetActive(false)
          end
        end
      end
      if not self.active then
        self:SetActive(true)
      end
    else
      self:InitListView(param)
    end
  else
    self:SetActive(false)
  end
end

local function AddTimer(self)
  if self.timer then
    self.timer:Stop()
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self:DoMoveOutTween()
    if self.timer then
      self.timer:Stop()
      self.timer = nil
    end
  end, self.duration)
end

local function SetActive(self, active)
  if self.gameObject then
    self.gameObject:SetActive(active)
    self.active = active
    if active then
      self.root:SetAnchoredPositionXY(0, 0)
      self.canvasGroup.alpha = 1
    end
  end
end

local function DoMoveOutTween(self)
  local sequence = DOTween.Sequence()
  sequence:Append(self.root.transform:DOLocalMoveY(60, 0.3):SetEase(CS.DG.Tweening.Ease.OutQuad))
  sequence:Insert(0, self.canvasGroup:DOFade(0, 0.3))
  sequence:OnComplete(function()
    self:SetActive(false)
  end)
  self.sequence = sequence
end

UILWTeamHeadBubble.__init = __init
UILWTeamHeadBubble.__delete = __delete
UILWTeamHeadBubble.ComponentDefine = ComponentDefine
UILWTeamHeadBubble.ComponentDestroy = ComponentDestroy
UILWTeamHeadBubble.DataDefine = DataDefine
UILWTeamHeadBubble.DataDestroy = DataDestroy
UILWTeamHeadBubble.AddComponent = AddComponent
UILWTeamHeadBubble.InitListView = InitListView
UILWTeamHeadBubble.Refresh = Refresh
UILWTeamHeadBubble.AddTimer = AddTimer
UILWTeamHeadBubble.SetActive = SetActive
UILWTeamHeadBubble.DoMoveOutTween = DoMoveOutTween
return UILWTeamHeadBubble
