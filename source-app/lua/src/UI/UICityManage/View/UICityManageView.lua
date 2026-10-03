local UICityManageView = BaseClass("UICityManageView", UIBaseView)
local base = UIBaseView
local UICityManageCell = require("UI.UICityManage.Component.UICityManageCell")
local WarFeverContent = require("UI.UICityManage.Component.WarFeverContent")
local WarGuardContent = require("UI.UICityManage.Component.WarGuardContent")
local Localization = CS.GameEntry.Localization
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local goback_btn_path = "UICommonPopUpTitle/Btn_GoBack"
local return_btn_path = "UICommonPopUpTitle/panel"
local returnUp_btn_path = "panel/ReturnUpBtn"
local title_txt_Path = "UICommonPopUpTitle/Common_img_title/titleText"
local scroll_view_path = "panel/ScrollView"
local svContent_path = "panel/ScrollView/Viewport/Content"
local warFever_content_path = "panel/WarFeverContent"
local warGuard_content_path = "panel/WarGuardContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  self:DoDirectToTab()
end

local function DoDirectToTab(self)
  if self.directToTab ~= nil then
    for _, k in ipairs(self.itemList) do
      if k ~= nil then
        for _, v in ipairs(k) do
          if v.id == self.directToTab then
            self:SwitchContent(v)
          end
        end
      end
    end
  end
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.goback_btn = self:AddComponent(UIButton, goback_btn_path)
  self.returnUp_btn = self:AddComponent(UIButton, returnUp_btn_path)
  self.title_txt = self:AddComponent(UIText, title_txt_Path)
  self.warFever_content = self:AddComponent(WarFeverContent, warFever_content_path)
  self.warGuard_content = self:AddComponent(WarGuardContent, warGuard_content_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseAll()
    self:CloseContentClick()
  end)
  self.goback_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    self:CloseContentClick()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    self:CloseContentClick()
  end)
  self.returnUp_btn:SetOnClick(function()
    if self.directToTab ~= nil then
      self.ctrl:CloseSelf()
    else
      self:CloseContentClick()
    end
  end)
  self.scroll_view = self:AddComponent(UIBaseContainer, scroll_view_path)
  self.svContentN = self:AddComponent(UIBaseContainer, svContent_path)
  self.itemList = {}
  self.cells = {}
end

local function ComponentDestroy(self)
  self.close_btn = nil
  self.return_btn = nil
  self.title_txt = nil
  self.itemList = nil
  self.cells = nil
  self.scroll_view = nil
end

local function DataDefine(self)
  self.directToTab = self:GetUserData()
end

local function DataDestroy(self)
  self.directToTab = nil
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
  self.title_txt:SetLocalText(129024)
  self.itemList = self.ctrl:GetAllCityManageData()
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
  self.close_btn.gameObject:SetActive(false)
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
  self.close_btn.gameObject:SetActive(true)
end

local function DoWhenUseProtectItem(self)
  if self.directToTab ~= nil then
    self.ctrl:CloseSelf()
  end
end

local function UseItemSuccessHandle(self)
  if self.curParam and self.curParam.id == CityManageBuffType.WarGuard then
    self.warGuard_content:ItemUseRefresh(self.curParam)
  end
end

UICityManageView.OnCreate = OnCreate
UICityManageView.OnDestroy = OnDestroy
UICityManageView.OnEnable = OnEnable
UICityManageView.OnDisable = OnDisable
UICityManageView.ComponentDefine = ComponentDefine
UICityManageView.ComponentDestroy = ComponentDestroy
UICityManageView.DataDefine = DataDefine
UICityManageView.DataDestroy = DataDestroy
UICityManageView.OnAddListener = OnAddListener
UICityManageView.OnRemoveListener = OnRemoveListener
UICityManageView.ReInit = ReInit
UICityManageView.ClearScroll = ClearScroll
UICityManageView.OnItemMoveIn = OnItemMoveIn
UICityManageView.OnItemMoveOut = OnItemMoveOut
UICityManageView.SwitchContent = SwitchContent
UICityManageView.CloseContentClick = CloseContentClick
UICityManageView.DoDirectToTab = DoDirectToTab
UICityManageView.DoWhenUseProtectItem = DoWhenUseProtectItem
UICityManageView.ForceRepositionSv = ForceRepositionSv
UICityManageView.RefreshCityManageCell = RefreshCityManageCell
UICityManageView.SetAllCellDestroy = SetAllCellDestroy
UICityManageView.UseItemSuccessHandle = UseItemSuccessHandle
return UICityManageView
