local UITroopSkillList = BaseClass("UITroopSkillList", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UITroopSkillItem = require("UI.UIMain.Component.UIMainBottom.TroopList.UITroopSkillItem")
local this_path = ""

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
  self.this_go = self:AddComponent(UIBaseContainer, this_path)
end

local function ComponentDestroy(self)
  self.this_go = nil
end

local function DataDefine(self)
  self.itemDict = {}
  self.reqDict = {}
  self.active = false
end

local function DataDestroy(self)
  self.itemDict = nil
  self.reqDict = nil
  self.active = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CareerSkillUpdate, self.OnCareerSkillUpdate)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.CareerSkillUpdate, self.OnCareerSkillUpdate)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  if self.active then
    return
  end
  local careerSkillList = DataCenter.PlayerCareerManager:GetTroopSkillList()
  if table.IsNullOrEmpty(careerSkillList) then
    self:Hide()
    return
  end
  self:Show()
  for _, skill in ipairs(careerSkillList) do
    local req = Resource:InstantiateAsync(UIAssets.UITroopSkillItem)
    req:completed("+", function()
      if req.isError then
        return
      end
      if not self.active then
        req:Destroy()
        return
      end
      CommonUtil.CallAutoArabicMirrorManually(req)
      local go = req.gameObject
      go.name = tostring(skill.id)
      go:SetActive(true)
      go.transform:SetParent(self.this_go.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local item = self.this_go:AddComponent(UITroopSkillItem, go)
      item:SetData(skill)
      self.itemDict[skill.id] = item
      self.reqDict[skill.id] = req
    end)
  end
end

local function ClearItems(self)
  if not table.IsNullOrEmpty(self.reqDict) then
    self.this_go:RemoveComponents(UITroopSkillItem)
    for _, req in pairs(self.reqDict) do
      req:Destroy()
    end
    self.itemDict = {}
    self.reqDict = {}
  end
end

local function Show(self)
  self:SetActive(true)
  self.active = true
end

local function Hide(self)
  self:ClearItems()
  self:SetActive(false)
  self.active = false
end

local function OnCareerSkillUpdate(self, id)
  if not self.active then
    return
  end
  local item = self.itemDict[id]
  if item == nil then
    return
  end
  local skill = DataCenter.PlayerCareerManager:GetCareerSkill(id)
  item:SetData(skill)
end

UITroopSkillList.OnCreate = OnCreate
UITroopSkillList.OnDestroy = OnDestroy
UITroopSkillList.ComponentDefine = ComponentDefine
UITroopSkillList.ComponentDestroy = ComponentDestroy
UITroopSkillList.DataDefine = DataDefine
UITroopSkillList.DataDestroy = DataDestroy
UITroopSkillList.OnAddListener = OnAddListener
UITroopSkillList.OnRemoveListener = OnRemoveListener
UITroopSkillList.OnEnable = OnEnable
UITroopSkillList.OnDisable = OnDisable
UITroopSkillList.ReInit = ReInit
UITroopSkillList.ClearItems = ClearItems
UITroopSkillList.Show = Show
UITroopSkillList.Hide = Hide
UITroopSkillList.OnCareerSkillUpdate = OnCareerSkillUpdate
return UITroopSkillList
