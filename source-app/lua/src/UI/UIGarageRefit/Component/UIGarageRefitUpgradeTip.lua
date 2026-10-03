local UIGarageRefitUpgradeTip = BaseClass("UIGarageRefitUpgradeTip", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGarageRefitItem = require("UI.UIGarageRefit.Component.UIGarageRefitItem")
local UIGarageRefitUpgradeLine = require("UI.UIGarageRefit.Component.UIGarageRefitUpgradeLine")
local this_path = ""
local root_path = "Root"
local item_path = "Root/Bg/UIGarageRefitItem"
local level_path = "Root/Bg/Level"
local PART_COUNT = 4
local MOVE_Y_LOW = 150
local MOVE_Y_MIDDLE = 180
local MOVE_Y_HIGH = 210

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
  self.anim = self:AddComponent(UIAnimator, this_path)
  self.root_go = self:AddComponent(UIBaseContainer, root_path)
  self.item = self:AddComponent(UIGarageRefitItem, item_path)
  self.level_text = self:AddComponent(UIText, level_path)
end

local function ComponentDestroy(self)
  self.anim = nil
  self.root_go = nil
  self.item = nil
  self.item_anim = nil
  self.level_text = nil
end

local function DataDefine(self)
  self.reqs = {}
  self.active = false
  self.levels = nil
  self.typeList = {}
  self.onClose = nil
  self.timer = nil
end

local function DataDestroy(self)
  self.reqs = nil
  self.active = nil
  self.levels = nil
  self.typeList = nil
  self.onClose = nil
  if self.timer ~= nil then
    self.timer:Stop()
  end
  self.timer = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  self.active = false
  base.OnDisable(self)
end

local function SetData(self, refitData, typeList)
  self.levels = {}
  for type = 1, PART_COUNT do
    self.levels[type] = refitData.parts[type] and refitData.parts[type].level or 0
  end
  self.typeList = typeList
  self:Show()
end

local function Show(self)
  if not self.levels or table.IsNullOrEmpty(self.typeList) then
    self:SetActive(false)
    return
  end
  self:ClearItems()
  self:SetActive(true)
  self.anim:Play("CommonPopup_movein", 0, 0)
  local type = table.remove(self.typeList, 1)
  local rightLevel = self.levels[type]
  local leftLevel = rightLevel - 1
  self.levels[type] = rightLevel
  local leftPartTemplate = DataCenter.GarageRefitManager:GetPartTemplate(type, leftLevel)
  local rightPartTemplate = DataCenter.GarageRefitManager:GetPartTemplate(type, rightLevel)
  self.item:SetTemplate(rightPartTemplate)
  self.level_text:SetText("Lv." .. rightLevel)
  self.reqs = {}
  local count = #rightPartTemplate.effects
  for i = 1, count do
    local line = LocalController:instance():getLine(TableName.EffectNumDesc, tostring(rightPartTemplate.effects[i]))
    local desc = Localization:GetString(line.des)
    local descType = tonumber(line.type)
    local leftVal = "+" .. string.GetFormattedSeperatorNum(leftPartTemplate and leftPartTemplate.effectVals[i] or 0)
    local rightVal = "+" .. string.GetFormattedSeperatorNum(rightPartTemplate.effectVals[i])
    if descType == 1 then
      leftVal = leftVal .. "%"
      rightVal = rightVal .. "%"
    elseif descType == 2 then
      leftVal = leftVal .. "\226\128\176"
      rightVal = rightVal .. "\226\128\176"
    end
    if leftVal ~= rightVal then
      self.reqs[i] = self:GameObjectInstantiateAsync(UIAssets.UIGarageRefitUpgradeLine2, function(req)
        if req.isError then
          return
        end
        if not self.gameObject or not self.active then
          req:Destroy()
          return
        end
        local go = req.gameObject
        go:SetActive(true)
        go.name = "Line_" .. tostring(i)
        local tf = go.transform
        tf:SetParent(self.root_go.transform)
        tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.root_go.rectTransform:Set_anchoredPosition(0, MOVE_Y_LOW)
        self.root_go.rectTransform:DOAnchorPosY(MOVE_Y_MIDDLE, 0.3)
        local item = self.root_go:AddComponent(UIGarageRefitUpgradeLine, go)
        item:SetData(desc, leftVal, rightVal)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root_go.transform)
        self.reqs[i] = req
      end)
    end
  end
  if self.timer ~= nil then
    self.timer:Stop()
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.root_go.rectTransform:DOAnchorPosY(MOVE_Y_HIGH, 0.3)
    self:Next()
  end, 3)
end

local function Next(self)
  if not table.IsNullOrEmpty(self.typeList) then
    self:Show()
  else
    if self.onClose then
      self.onClose()
    end
    self.anim:Play("CommonPopup_moveout", 0, 0)
  end
end

local function ClearItems(self)
  self.root_go:RemoveComponents(UIGarageRefitUpgradeLine)
  for _, req in pairs(self.reqs) do
    req:Destroy()
  end
end

local function SetOnClose(self, onClose)
  self.onClose = onClose
end

UIGarageRefitUpgradeTip.OnCreate = OnCreate
UIGarageRefitUpgradeTip.OnDestroy = OnDestroy
UIGarageRefitUpgradeTip.ComponentDefine = ComponentDefine
UIGarageRefitUpgradeTip.ComponentDestroy = ComponentDestroy
UIGarageRefitUpgradeTip.DataDefine = DataDefine
UIGarageRefitUpgradeTip.DataDestroy = DataDestroy
UIGarageRefitUpgradeTip.OnEnable = OnEnable
UIGarageRefitUpgradeTip.OnDisable = OnDisable
UIGarageRefitUpgradeTip.SetData = SetData
UIGarageRefitUpgradeTip.ClearItems = ClearItems
UIGarageRefitUpgradeTip.Show = Show
UIGarageRefitUpgradeTip.Next = Next
UIGarageRefitUpgradeTip.SetOnClose = SetOnClose
return UIGarageRefitUpgradeTip
