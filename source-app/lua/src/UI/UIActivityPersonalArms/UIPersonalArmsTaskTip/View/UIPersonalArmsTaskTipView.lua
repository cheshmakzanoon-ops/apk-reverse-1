local UIPersonalArmsTaskTipView = BaseClass("UIPersonalArmsTaskTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIPersonalArmsTaskTipItem = require("UI.UIActivityPersonalArms.UIPersonalArmsTaskTip.Component.UIPersonalArmsTaskTipItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.param = self:GetUserData()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.bg.transform.position = self.param.pos
  local offset
  if CommonUtil.IsArabicAutoMirrorOpen() then
    offset = Vector2.New(-170, -33)
  else
    offset = Vector2.New(170, -33)
  end
  local bgAnchorPos = self.bg.transform.anchoredPosition
  self.bg.transform.anchoredPosition = bgAnchorPos + offset
  self:RefreshView()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIBaseContainer, "bg")
  self.content = self:AddComponent(UIBaseContainer, "bg/ItemScroll/Viewport/Content")
  self.item = self:AddComponent(UIBaseContainer, "bg/ItemScroll/Item")
  self.item.gameObject:GameObjectCreatePool()
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(function()
    self.ctrl.CloseSelf(self.ctrl)
  end)
end

local function ComponentDestroy(self)
  self.content = nil
  self.item = nil
  self.btnPanel = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshView(self)
  local tScoreTask = self.param.scoreTaskList
  local tScoreList = {}
  for k, v in pairs(tScoreTask.cfgList) do
    table.insert(tScoreList, v)
  end
  table.sort(tScoreList, function(a, b)
    return a.id < b.id
  end)
  self.content:RemoveComponents(UIPersonalArmsTaskTipItem)
  self.item.gameObject:GameObjectRecycleAll()
  for k, v in pairs(tScoreList) do
    local item = self.item.gameObject:GameObjectSpawn(self.content.transform)
    item.name = k
    local sName = v.name
    local sPointNum = v.points
    local cell = self.content:AddComponent(UIPersonalArmsTaskTipItem, item.name)
    cell:SetData(sName, sPointNum)
  end
end

UIPersonalArmsTaskTipView.OnCreate = OnCreate
UIPersonalArmsTaskTipView.OnDestroy = OnDestroy
UIPersonalArmsTaskTipView.OnEnable = OnEnable
UIPersonalArmsTaskTipView.OnDisable = OnDisable
UIPersonalArmsTaskTipView.ComponentDefine = ComponentDefine
UIPersonalArmsTaskTipView.ComponentDestroy = ComponentDestroy
UIPersonalArmsTaskTipView.DataDefine = DataDefine
UIPersonalArmsTaskTipView.DataDestroy = DataDestroy
UIPersonalArmsTaskTipView.OnAddListener = OnAddListener
UIPersonalArmsTaskTipView.OnRemoveListener = OnRemoveListener
UIPersonalArmsTaskTipView.RefreshView = RefreshView
return UIPersonalArmsTaskTipView
