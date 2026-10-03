local UIPVESelectAdventureSubView = BaseClass("UIPVESelectAdventureSubView", UIBaseView)
local base = UIBaseView
local UIPVESelectAdventureSubCell = require("UI.UIPVE.UIPVESelectAdventureSub.Component.UIPVESelectAdventureSubCell")
local back_path = "SafeArea/Back"
local sub_list_go_path = "SafeArea/SubListGo"

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
  self.back_btn = self:AddComponent(UIButton, back_path)
  self.back_btn:SetOnClick(function()
    self:OnBackClick()
  end)
  self.sub_list_go = self:AddComponent(UIBaseContainer, sub_list_go_path)
end

local function ComponentDestroy(self)
  self.back_btn = nil
  self.sub_list_go = nil
end

local function DataDefine(self)
  self.itemList = {}
  self.canSelectCell = false
end

local function DataDestroy(self)
  self.itemList = nil
  self.canSelectCell = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  local trigger = self:GetUserData()
  if trigger == nil then
    return
  end
  trigger:SetMonsterLevelVisible(false)
  self.canSelectCell = true
  local mainLv = DataCenter.BuildManager.MainLv
  local caseId = 1
  for _, info in ipairs(trigger.config.caseList) do
    caseId = info.caseId
    if mainLv <= info.mainLv then
      break
    end
  end
  local line = LocalController:instance():getLine(TableName.AdventureCase, caseId)
  local contentSpls = string.split(line:getValue("content") or "", ";")
  for i, spl in ipairs(contentSpls) do
    local type = tonumber(spl)
    self:GameObjectInstantiateAsync(UIAssets.UIPVESelectAdventureSubCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.sub_list_go.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(i)
      go.name = nameStr
      local item = self.sub_list_go:AddComponent(UIPVESelectAdventureSubCell, nameStr)
      local param = {}
      param.trigger = trigger
      param.triggerId = trigger:GetTriggerId()
      param.caseId = caseId
      param.type = type
      param.line = line
      param.indexCache = {}
      item.view = self
      item:ReInit(param)
      self.itemList[i] = item
    end)
  end
end

local function OnBackClick(self)
  local trigger = self:GetUserData()
  if trigger == nil then
    return
  end
  trigger:SetMonsterLevelVisible(true)
  local pos = DeepCopy(DataCenter.BattleLevel:GetPosition())
  pos.z = pos.z - 3
  DataCenter.BattleLevel:SetPosition(pos)
  self.ctrl:CloseSelf()
end

UIPVESelectAdventureSubView.OnCreate = OnCreate
UIPVESelectAdventureSubView.OnDestroy = OnDestroy
UIPVESelectAdventureSubView.ComponentDefine = ComponentDefine
UIPVESelectAdventureSubView.ComponentDestroy = ComponentDestroy
UIPVESelectAdventureSubView.DataDefine = DataDefine
UIPVESelectAdventureSubView.DataDestroy = DataDestroy
UIPVESelectAdventureSubView.OnEnable = OnEnable
UIPVESelectAdventureSubView.OnDisable = OnDisable
UIPVESelectAdventureSubView.OnAddListener = OnAddListener
UIPVESelectAdventureSubView.OnRemoveListener = OnRemoveListener
UIPVESelectAdventureSubView.ReInit = ReInit
UIPVESelectAdventureSubView.OnBackClick = OnBackClick
return UIPVESelectAdventureSubView
