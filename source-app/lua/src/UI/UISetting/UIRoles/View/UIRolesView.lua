local UIRolesCell = require("UI.UISetting.UIRoles.Component.UIRolesCell")
local UIRolesView = BaseClass("UIRolesView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local goback_btn_path = "UICommonPopUpTitle/Btn_GoBack"
local return_btn_path = "UICommonPopUpTitle/panel"
local layout_path = "layout"
local scroll_view_path = "layout/ScrollView"
local des_txt_path = "layout/desText"
local roles_prefab_path = "Roles"
local cell_content_path = "layout/ScrollView/Viewport/Content"

function UIRolesView:OnCreate()
  base.OnCreate(self)
  local checkType = self:GetUserData()
  self.checkType = tonumber(checkType)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIRolesView:OnDestroy()
  self:SetAllCellsDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIRolesView:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.goback_btn = self:AddComponent(UIButton, goback_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.des_txt:SetLocalText(208238)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.content = self:AddComponent(UIBaseContainer, cell_content_path)
  self.role_cell = self:AddComponent(UIBaseContainer, roles_prefab_path)
  self.role_cell.gameObject:GameObjectCreatePool()
  self.role_cell:SetActive(false)
  self.cells = {}
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.goback_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UIRolesView:ComponentDestroy()
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.scroll_view = nil
  self:ClearScroll()
end

function UIRolesView:DataDefine()
  self.list = {}
  if self.checkType == 0 then
    self.des_txt:SetActive(false)
    SFSNetwork.SendMessage(MsgDefines.AccountLoginNew)
  else
    self.des_txt:SetActive(true)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
end

function UIRolesView:DataDestroy()
  self.list = nil
end

function UIRolesView:OnEnable()
  base.OnEnable(self)
  if self.checkType == 1 then
    self:ShowCells()
  end
end

function UIRolesView:OnDisable()
  base.OnDisable(self)
end

function UIRolesView:ReInit()
  self.txt_title:SetLocalText(208225)
end

function UIRolesView:SetAllCellsDestroy()
  self:ClearScroll()
end

function UIRolesView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RolesRefresh, self.ShowCells)
end

function UIRolesView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RolesRefresh, self.ShowCells)
end

function UIRolesView:ShowCells()
  self:ClearScroll()
  self.list = DataCenter.AccountManager:GetRolesList()
  if self.checkType == 0 then
    local empty = {}
    empty.isEmpty = true
    table.insert(self.list, 1, empty)
  end
  for k, v in pairs(self.list) do
    local item = self.role_cell.gameObject:GameObjectSpawn(self.content.transform)
    item.name = "item" .. k
    local obj = self.content:AddComponent(UIRolesCell, item.name)
    local tempType = v
    obj:SetActive(true)
    obj:ReInit(tempType)
    table.insert(self.cells, obj)
  end
end

function UIRolesView:ClearScroll()
  self.cells = {}
  self.content:RemoveComponents(UIRolesCell)
  self.role_cell.gameObject:GameObjectRecycleAll()
end

return UIRolesView
