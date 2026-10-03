local UIRoleListShowCell = require("UI.UIAccount2.UIDeleteAllAccount.UIRoleListShow.Component.UIRoleListShowCell")
local UIRoleListShowView = BaseClass("UIRoleListShowView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local goback_btn_path = "UICommonPopUpTitle/Btn_GoBack"
local return_btn_path = "UICommonPopUpTitle/panel"
local layout_path = "layout"
local scroll_view_path = "layout/ScrollView"
local roles_prefab_path = "Roles"
local cell_content_path = "layout/ScrollView/Viewport/Content"

function UIRoleListShowView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIRoleListShowView:OnDestroy()
  self:SetAllCellsDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIRoleListShowView:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.goback_btn = self:AddComponent(UIButton, goback_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.content = self:AddComponent(UIBaseContainer, cell_content_path)
  self.role_cell = self:AddComponent(UIBaseContainer, roles_prefab_path)
  self.role_cell.gameObject:GameObjectCreatePool()
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

function UIRoleListShowView:ComponentDestroy()
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.scroll_view = nil
  self:ClearScroll()
end

function UIRoleListShowView:DataDefine()
  self.list = {}
  SFSNetwork.SendMessage(MsgDefines.AccountLoginNew, nil, 3)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
end

function UIRoleListShowView:DataDestroy()
  self.list = nil
end

function UIRoleListShowView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RolesRefresh, self.ShowCells)
end

function UIRoleListShowView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RolesRefresh, self.ShowCells)
end

function UIRoleListShowView:ReInit()
  self.txt_title:SetLocalText("delete_account_title_03")
end

function UIRoleListShowView:SetAllCellsDestroy()
  self:ClearScroll()
end

function UIRoleListShowView:ShowCells()
  self:ClearScroll()
  self.list = DataCenter.AccountManager:GetRolesList()
  for k, v in pairs(self.list) do
    local item = self.role_cell.gameObject:GameObjectSpawn(self.content.transform)
    item.name = "item" .. k
    local obj = self.content:AddComponent(UIRoleListShowCell, item.name)
    local tempType = v
    obj:ReInit(tempType)
    table.insert(self.cells, obj)
  end
end

function UIRoleListShowView:ClearScroll()
  self.cells = {}
  self.content:RemoveComponents(UIRoleListShowCell)
  self.role_cell.gameObject:GameObjectRecycleAll()
end

return UIRoleListShowView
