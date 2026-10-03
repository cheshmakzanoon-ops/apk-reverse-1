local CityManage = BaseClass("CityManage", UIBaseContainer)
local base = UIBaseContainer
local UICityManageCell = require("UI.UICityManage.Component.UICityManageCell")
local WarFeverContent = require("UI.UICityManage.Component.WarFeverContent")
local WarGuardContent = require("UI.UICityManage.Component.WarGuardContent")
local Localization = CS.GameEntry.Localization
local returnUp_btn_path = "ReturnUpBtn"
local scroll_view_path = "ScrollView"
local svContent_path = "ScrollView/Viewport/Content"
local warFever_content_path = "WarFeverContent"
local warGuard_content_path = "WarGuardContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.returnUp_btn = self:AddComponent(UIButton, returnUp_btn_path)
  self.warFever_content = self:AddComponent(WarFeverContent, warFever_content_path)
  self.warGuard_content = self:AddComponent(WarGuardContent, warGuard_content_path)
  self.returnUp_btn:SetOnClick(function()
    self:CloseContentClick()
  end)
  self.scroll_view = self:AddComponent(UIBaseContainer, scroll_view_path)
  self.svContentN = self:AddComponent(UIBaseContainer, svContent_path)
  self.itemList = {}
  self.cells = {}
end

local function ComponentDestroy(self)
  self.itemList = nil
  self.cells = nil
  self.scroll_view = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ScrollViewContentChange, self.ForceRepositionSv)
  self:AddUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ScrollViewContentChange, self.ForceRepositionSv)
  self:RemoveUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self:CloseContentClick()
  self.itemList = self.view.ctrl:GetAllCityManageData()
  self:RefreshCityManageCell()
end

local function RefreshCityManageCell(self)
  self:SetAllCellDestroy()
  local list = self.itemList
  self.model = {}
  if list ~= nil then
    for i = 1, table.length(list) do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICityManageCell, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.svContentN.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "item" .. i
        local cell = self.svContentN:AddComponent(UICityManageCell, go.name)
        cell:ReInit(list[i])
      end)
    end
  end
end

local function SetAllCellDestroy(self)
  self.svContentN:RemoveComponents(UICityManageCell)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function SwitchContent(self, param)
  self.returnUp_btn.gameObject:SetActive(true)
  self.warFever_content.gameObject:SetActive(false)
  self.warGuard_content.gameObject:SetActive(false)
  self.scroll_view.gameObject:SetActive(false)
  self.curParam = param
  if param.id == CityManageBuffType.CityFever then
    self.warFever_content.gameObject:SetActive(true)
    self.warFever_content:ReInit()
  else
    self.warGuard_content.gameObject:SetActive(true)
    self.warGuard_content:ReInit(param)
  end
end

local function ForceRepositionSv(self)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.svContentN.rectTransform)
end

local function CloseContentClick(self)
  self.returnUp_btn.gameObject:SetActive(false)
  self.warFever_content.gameObject:SetActive(false)
  self.warGuard_content.gameObject:SetActive(false)
  self.scroll_view.gameObject:SetActive(true)
end

local function UseItemSuccessHandle(self)
  if self.curParam and self.curParam.id == CityManageBuffType.WarGuard then
    self.warGuard_content:ItemUseRefresh(self.curParam)
  end
end

CityManage.OnCreate = OnCreate
CityManage.OnDestroy = OnDestroy
CityManage.OnEnable = OnEnable
CityManage.OnDisable = OnDisable
CityManage.ComponentDefine = ComponentDefine
CityManage.ComponentDestroy = ComponentDestroy
CityManage.DataDefine = DataDefine
CityManage.DataDestroy = DataDestroy
CityManage.OnAddListener = OnAddListener
CityManage.OnRemoveListener = OnRemoveListener
CityManage.ReInit = ReInit
CityManage.SwitchContent = SwitchContent
CityManage.CloseContentClick = CloseContentClick
CityManage.ForceRepositionSv = ForceRepositionSv
CityManage.RefreshCityManageCell = RefreshCityManageCell
CityManage.SetAllCellDestroy = SetAllCellDestroy
CityManage.UseItemSuccessHandle = UseItemSuccessHandle
return CityManage
