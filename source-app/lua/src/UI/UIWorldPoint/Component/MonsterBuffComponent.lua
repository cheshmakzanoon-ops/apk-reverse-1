local MonsterBuffComponent = BaseClass("MonsterBuffComponent", UIBaseContainer)
local base = UIBaseContainer
local MonsterBuffIconComponent = require("UI.UIWorldPoint.Component.MonsterBuffIconComponent")
local monster_buff_btn_path = "monsterBuffBtn"

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
  self.compBuffContent = self:AddComponent(UIBaseContainer, "BuffContent")
  self.monster_buff_btn = self:AddComponent(UIButton, monster_buff_btn_path)
  self.monster_buff_btn:SetOnClick(function()
    local desc = CS.GameEntry.Localization:GetString("season_s4_monster_tips1")
    UIUtil.ShowBubbleTips(desc, self.monster_buff_btn.transform.position, 0, -30, -60)
  end)
end

local function ComponentDestroy(self)
  self.compBuffContent = nil
  self.monster_buff_btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self:ClearAll()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ClearAll(self)
  self.compBuffContent:RemoveComponents(MonsterBuffIconComponent)
  if self.itemReqs then
    for i, v in pairs(self.itemReqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.itemReqs = {}
end

local function SetData(self, statusIds)
  self:ClearAll()
  for i, v in ipairs(statusIds) do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.MonsterBuffIcon, function(req)
      local go = req.gameObject
      go.name = tostring(i)
      go:SetActive(true)
      go.transform:SetParent(self.compBuffContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local item = self.compBuffContent:AddComponent(MonsterBuffIconComponent, go.name)
      item:SetData(v)
    end)
  end
end

MonsterBuffComponent.OnCreate = OnCreate
MonsterBuffComponent.OnDestroy = OnDestroy
MonsterBuffComponent.OnEnable = OnEnable
MonsterBuffComponent.OnDisable = OnDisable
MonsterBuffComponent.ComponentDefine = ComponentDefine
MonsterBuffComponent.ComponentDestroy = ComponentDestroy
MonsterBuffComponent.DataDefine = DataDefine
MonsterBuffComponent.DataDestroy = DataDestroy
MonsterBuffComponent.OnAddListener = OnAddListener
MonsterBuffComponent.OnRemoveListener = OnRemoveListener
MonsterBuffComponent.SetData = SetData
MonsterBuffComponent.ClearAll = ClearAll
return MonsterBuffComponent
