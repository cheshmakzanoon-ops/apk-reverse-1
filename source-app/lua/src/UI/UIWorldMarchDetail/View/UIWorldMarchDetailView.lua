local UISubWayItem = require("UI.UISubWay.UIWorldMarchDetail.Component.UISubWayItem")
local UIWorldMarchDetailView = BaseClass("UIWorldMarchDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Data = CS.GameEntry.Data

function UIWorldMarchDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWorldMarchDetailView:ComponentDefine()
  self._close_btn = self:AddComponent(UIButton, "ImgBg/UICommonPopUpTitle/CloseBtn")
  self._close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._return_btn = self:AddComponent(UIButton, "ImgBg/UICommonPopUpTitle/panel")
  self._return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._title_txt = self:AddComponent(UIText, "ImgBg/UICommonPopUpTitle/Common_img_title/titleText")
  self._title_txt:SetLocalText(142507, "")
  self.itemCell = self:AddComponent(UIBaseContainer, "ImgBg/layoutContent/mainContent")
end

function UIWorldMarchDetailView:DataDefine()
end

function UIWorldMarchDetailView:OnDestroy()
  base.OnDestroy(self)
end

function UIWorldMarchDetailView:OnEnable()
  base.OnEnable(self)
  self:ReInit()
end

function UIWorldMarchDetailView:OnDisable()
  base.OnDisable(self)
end

function UIWorldMarchDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MarchItemUpdateSelf, self.RefreshCenterList)
end

function UIWorldMarchDetailView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MarchItemUpdateSelf, self.RefreshCenterList)
end

function UIWorldMarchDetailView:ReInit()
  self:RefreshCenterList()
end

function UIWorldMarchDetailView:RefreshCenterList()
  self:ClearItemCell()
  local list = self.ctrl:GetInWormHoleMarch()
  for i = 1, #list do
    self.itemTab[i] = self:GameObjectInstantiateAsync(UIAssets.UISubWayItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.itemCell.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      go.gameObject:SetActive(true)
      local cell = self.itemCell:AddComponent(UISubWayItem, go.name)
      cell:RefreshData(list[i], i)
      self.itemCellList[i] = cell
    end)
  end
end

function UIWorldMarchDetailView:ClearItemCell()
  self.itemCell:RemoveComponents(UISubWayItem)
  if self.itemTab and next(self.itemTab) then
    for k, v in pairs(self.itemTab) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.itemTab = {}
  self.itemCellList = {}
end

return UIWorldMarchDetailView
