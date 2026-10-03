local UILWAllianceApplicationView = BaseClass("UILWAllianceApplicationView", UIBaseView)
local base = UIBaseView
local LWAllianceApplyItem = require("UI.UILWAlliance.UILWAllianceApplication.Component.LWAllianceApplyItem")
local title_txt_path = "UICommonPopUpTitle/Common_img_title/titleText"
local return_path2 = "UICommonPopUpTitle/panel"
local scroll_view_path = "ImgBg/ScrollView"
local return_btn_path = "UICommonPopUpTitle/CloseBtn"

function UILWAllianceApplicationView:OnCreate()
  base.OnCreate(self)
  SFSNetwork.SendMessage(MsgDefines.AlApplyList, 1)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAllianceApplicationView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAllianceApplicationView:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, title_txt_path)
  self.txt_title:SetLocalText(393084)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return2_btn = self:AddComponent(UIButton, return_path2)
  self.return2_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UILWAllianceApplicationView:ComponentDestroy()
  self.txt_title = nil
  self.scroll_view = nil
end

function UILWAllianceApplicationView:DataDefine()
  self.apply_list = {}
end

function UILWAllianceApplicationView:DataDestroy()
  self.apply_list = nil
end

function UILWAllianceApplicationView:OnEnable()
  base.OnEnable(self)
  self:RefreshApplyList()
end

function UILWAllianceApplicationView:OnDisable()
  base.OnDisable(self)
end

function UILWAllianceApplicationView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnGetNewAlJoinReq, self.RefreshApplyList)
end

function UILWAllianceApplicationView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnGetNewAlJoinReq, self.RefreshApplyList)
  base.OnRemoveListener(self)
end

function UILWAllianceApplicationView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWAllianceApplyItem)
end

function UILWAllianceApplicationView:ShowCells()
end

function UILWAllianceApplicationView:OnCellMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWAllianceApplyItem, itemObj)
  cellItem:SetItemShow(self.apply_list[index])
end

function UILWAllianceApplicationView:OnCellMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWAllianceApplyItem)
end

function UILWAllianceApplicationView:RefreshApplyList()
  self:ClearScroll()
  self.apply_list = self.ctrl:GetAllianceApplyList()
  if #self.apply_list > 0 then
    self.ScrollView:SetTotalCount(#self.apply_list)
    self.ScrollView:RefillCells()
  end
end

return UILWAllianceApplicationView
