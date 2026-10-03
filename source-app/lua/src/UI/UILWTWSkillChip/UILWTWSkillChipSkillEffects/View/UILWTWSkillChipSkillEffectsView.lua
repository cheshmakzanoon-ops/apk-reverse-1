local base = UIBaseView
local UILWTWSkillChipSkillEffectsView = BaseClass("UILWTWSkillChipSkillEffectsView", base)
local SkillEffectLine = require("UI.UILWTWSkillChip.UILWTWSkillChipSkillEffects.Component.SkillEffectLine")
local closeMask_btn_path = "panel"
local scroll_path = "root/scroll"
local content_path = "root/scroll/content"
local unlock_path = "root/scroll/content/active"
local lock_path = "root/scroll/content/unactive"
local YELLOW_INDICES = {
  [2] = true,
  [5] = true,
  [8] = true
}

local function GetLineBgType(index, activeState)
  if activeState then
    if YELLOW_INDICES[index] then
      return 2
    else
      return 1
    end
  elseif YELLOW_INDICES[index] then
    return 4
  else
    return 3
  end
end

local function CreateLines(self)
  local skillChipTemplate = DataCenter.TWSkillChipTemplateManager:GetTemplate(self.skillChipId)
  if not skillChipTemplate then
    return
  end
  local skillInfo = skillChipTemplate:GetSkillInfoByStarLevel(self.skillChipStar)
  local effects = skillInfo:GetEffectsDescTWSkillChip()
  for i = 1, #effects do
    local effect = effects[i]
    local container = effect.isUnlock and self.unlock or self.lock
    local lineReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUITacticalWeapon/SkillChipSkillEffectLine.prefab", function(request)
      if IsNull(request.gameObject) then
        return
      end
      local go = request.gameObject
      local transform = go.transform
      go.gameObject:SetActive(true)
      transform:SetParent(container.transform)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = i
      local cell = container:AddComponent(SkillEffectLine, go)
      cell:SetData(effect.outDesc, i, GetLineBgType(i, effect.isUnlock))
    end)
    table.insert(effect.isUnlock and self.activeLines or self.unactiveLines, lineReq)
  end
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.skillChipId, self.skillChipStar = self:GetUserData()
  CreateLines(self)
end

local function ClearAllSkillLines(self)
  self.unlock:RemoveComponents(SkillEffectLine)
  self.lock:RemoveComponents(SkillEffectLine)
  if self.activeLines then
    for i, v in ipairs(self.activeLines) do
      self:GameObjectDestroy(v)
    end
  end
  self.activeLines = {}
  if self.unactiveLines then
    for i, v in ipairs(self.unactiveLines) do
      self:GameObjectDestroy(v)
    end
  end
  self.unactiveLines = {}
end

local function OnDestroy(self)
  ClearAllSkillLines(self)
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
  self.closeMask_btn = self:AddComponent(UIButton, closeMask_btn_path)
  self.scroll = self:AddComponent(UIScrollRect, scroll_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.unlock = self:AddComponent(UIBaseContainer, unlock_path)
  self.lock = self:AddComponent(UIBaseContainer, lock_path)
  self.closeMask_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.closeMask_btn = nil
  self.scroll = nil
  self.content = nil
  self.unlock = nil
  self.lock = nil
end

local function DataDefine(self)
  self.activeLines = {}
  self.unactiveLines = {}
end

local function DataDestroy(self)
end

UILWTWSkillChipSkillEffectsView.OnCreate = OnCreate
UILWTWSkillChipSkillEffectsView.OnDestroy = OnDestroy
UILWTWSkillChipSkillEffectsView.OnEnable = OnEnable
UILWTWSkillChipSkillEffectsView.OnDisable = OnDisable
UILWTWSkillChipSkillEffectsView.ComponentDefine = ComponentDefine
UILWTWSkillChipSkillEffectsView.ComponentDestroy = ComponentDestroy
UILWTWSkillChipSkillEffectsView.DataDefine = DataDefine
UILWTWSkillChipSkillEffectsView.DataDestroy = DataDestroy
return UILWTWSkillChipSkillEffectsView
