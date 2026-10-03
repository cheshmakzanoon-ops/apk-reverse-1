local LWUIMonsterInvasionLevelRewardItemRenderComponent = BaseClass("LWUIMonsterInvasionLevelRewardItemRenderComponent", UIBaseContainer)
local effectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/Lianhuanduobao/Eff_ui_duobao_jiangli_faguang.prefab"
local ResourceManager = CS.GameEntry.Resource
local RectTransformCSType = typeof(CS.UnityEngine.RectTransform)
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
  self.ui_common_res_item = self:AddComponent(UICommonResItem, "UICommonResItem")
end

local function ComponentDestroy(self)
  self.ui_common_res_item = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self:ClearEffect()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, reward)
  self.effectReqs = {}
  self.ui_common_res_item:SetActive(reward)
  if reward then
    self.ui_common_res_item:ReInit(reward)
    self.ui_common_res_item:SetItemCountActive(false)
  end
end

local function AddHighLight(self)
  local req = ResourceManager:InstantiateAsync(effectPath)
  table.insert(self.effectReqs, req)
  req:completed("+", function(request)
    if self.effectReqs == nil then
      request:Destroy()
      return
    end
    local go = request.gameObject
    local transform = go.transform
    go:SetActive(true)
    local rectTransform = go:GetComponent(RectTransformCSType)
    transform:SetParent(self.ui_common_res_item.gameObject.transform)
    rectTransform:Set_anchoredPosition(ResetPosition.x, ResetPosition.y)
    transform:Set_localScale(1.43, 1.43, 1.43)
  end)
end

local function ClearEffect(self)
  if self.effectReqs then
    for _, req in pairs(self.effectReqs) do
      req:Destroy()
    end
  end
  self.effectReqs = nil
end

LWUIMonsterInvasionLevelRewardItemRenderComponent.OnCreate = OnCreate
LWUIMonsterInvasionLevelRewardItemRenderComponent.OnDestroy = OnDestroy
LWUIMonsterInvasionLevelRewardItemRenderComponent.OnEnable = OnEnable
LWUIMonsterInvasionLevelRewardItemRenderComponent.OnDisable = OnDisable
LWUIMonsterInvasionLevelRewardItemRenderComponent.ComponentDefine = ComponentDefine
LWUIMonsterInvasionLevelRewardItemRenderComponent.ComponentDestroy = ComponentDestroy
LWUIMonsterInvasionLevelRewardItemRenderComponent.DataDefine = DataDefine
LWUIMonsterInvasionLevelRewardItemRenderComponent.DataDestroy = DataDestroy
LWUIMonsterInvasionLevelRewardItemRenderComponent.OnAddListener = OnAddListener
LWUIMonsterInvasionLevelRewardItemRenderComponent.OnRemoveListener = OnRemoveListener
LWUIMonsterInvasionLevelRewardItemRenderComponent.ReInit = ReInit
LWUIMonsterInvasionLevelRewardItemRenderComponent.AddHighLight = AddHighLight
LWUIMonsterInvasionLevelRewardItemRenderComponent.ClearEffect = ClearEffect
return LWUIMonsterInvasionLevelRewardItemRenderComponent
