local UIMainBLBtnBase = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnBase")
local UIMainDispatchTask = BaseClass("UIMainDispatchTask", UIMainBLBtnBase)
local Localization = CS.GameEntry.Localization
local base = UIMainBLBtnBase
local EnterTip_path = "Assets/Main/Prefabs/UI/Ghostrecon/UIGhostreconEnterTip.prefab"
local UIGhostreconEnterTip = require("UI.LWMainUI.Component.UIMainBottom.UIGhostreconEnterTip")

function UIMainDispatchTask:ComponentDefine()
  base.ComponentDefine(self)
end

function UIMainDispatchTask:ComponentDestroy()
  self:DestoryGhostreconEnterTip()
  base.ComponentDestroy(self)
end

function UIMainDispatchTask:OnAddMainBtnListener()
  self:AddUIListener(EventId.OnEnterCity, self.Refresh)
  self:AddUIListener(EventId.OnEnterWorld, self.Refresh)
  self:AddUIListener(EventId.DispatchTaskUpdateSingle, self.Refresh)
  self:AddUIListener(EventId.DispatchTaskCompleteRefresh, self.Refresh)
  self:AddUIListener(EventId.DispatchTaskTodayNumUpdate, self.Refresh)
  self:AddUIListener(EventId.DispatchTreasureRefreshTabRedPoint, self.Refresh)
  self:AddUIListener(EventId.GhostreconRefreshRedPoint, self.Refresh)
  self:AddUIListener(EventId.OnEnterCrossServer, self.Refresh)
  self:AddUIListener(EventId.OnQuitCrossServer, self.Refresh)
  self:AddUIListener(EventId.GhostreconRefreshOneTask, self.RefreshGhostreconEnterTip)
  self:AddUIListener(EventId.OnGetExplorerTreasureSuccess, self.Refresh)
  self:AddUIListener(EventId.RefreshItems, self.Refresh)
  base.OnAddMainBtnListener(self)
end

function UIMainDispatchTask:OnRemoveMainBtnListener()
  self:RemoveUIListener(EventId.OnEnterCity, self.Refresh)
  self:RemoveUIListener(EventId.OnEnterWorld, self.Refresh)
  self:RemoveUIListener(EventId.DispatchTaskUpdateSingle, self.Refresh)
  self:RemoveUIListener(EventId.DispatchTaskCompleteRefresh, self.Refresh)
  self:RemoveUIListener(EventId.DispatchTaskTodayNumUpdate, self.Refresh)
  self:RemoveUIListener(EventId.DispatchTreasureRefreshTabRedPoint, self.Refresh)
  self:RemoveUIListener(EventId.GhostreconRefreshRedPoint, self.Refresh)
  self:RemoveUIListener(EventId.OnEnterCrossServer, self.Refresh)
  self:RemoveUIListener(EventId.OnQuitCrossServer, self.Refresh)
  self:RemoveUIListener(EventId.GhostreconRefreshOneTask, self.RefreshGhostreconEnterTip)
  self:RemoveUIListener(EventId.OnGetExplorerTreasureSuccess, self.Refresh)
  self:RemoveUIListener(EventId.RefreshItems, self.Refresh)
  base.OnRemoveMainBtnListener(self)
end

function UIMainDispatchTask:OnClick()
  if self.commonRedPoint:GetActive() then
    DataCenter.ActDispatchTaskDataManager:HideMainUIRedPoint()
    DataCenter.ActDispatchTreasureManager:SetDayFirstIsShow()
    self:Refresh()
  end
  local groupList = DataCenter.ActivityListDataManager:GetDispatchGroupList()
  if groupList and 0 < #groupList then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  else
    EventManager:GetInstance():Broadcast(EventId.ShowCrossServerBubbleTips, 500021)
  end
  self.commonRedPoint:SetViewed()
end

function UIMainDispatchTask:CheckEnable()
  local actDispatchMgr = DataCenter.ActDispatchTaskDataManager
  local isShow = actDispatchMgr:CheckUnlock()
  if not isShow then
    return false
  end
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_DISPATCH_TASK)
  if not buildData or buildData.level < 1 then
    return false
  end
  return isShow
end

function UIMainDispatchTask:Refresh()
  base.Refresh(self)
  self:RefreshGhostreconEnterTip()
end

function UIMainDispatchTask:RefreshGhostreconEnterTip()
  if self.ghostreconTip then
    self.ghostreconTip:Refresh()
  elseif self.ghostreconTipReq == nil then
    local state = DataCenter.ActGhostreconManager:GetTipShowState()
    if state ~= GhostreconEnterTipState.None then
      self.ghostreconTipReq = self:GameObjectInstantiateAsync(EnterTip_path, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.transform)
        self.ghostreconTip = self:AddComponent(UIGhostreconEnterTip, go.name)
        self.ghostreconTip:SetLocalScaleXYZ(1, 1, 1)
        self.ghostreconTip:SetAnchoredPositionXY(0, 0)
        self.ghostreconTip:Refresh()
      end)
    end
  end
end

function UIMainDispatchTask:DestoryGhostreconEnterTip()
  if self.ghostreconTipReq ~= nil then
    self:GameObjectDestroy(self.ghostreconTipReq)
    self.ghostreconTipReq = nil
    self.ghostreconTip = nil
  end
end

return UIMainDispatchTask
