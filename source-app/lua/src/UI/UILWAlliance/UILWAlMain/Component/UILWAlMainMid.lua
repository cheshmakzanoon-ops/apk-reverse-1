local UILWAlMainMid = BaseClass("UILWAlMainMid", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local MainMidItem = require("UI.UILWAlliance.UILWAlMain.Component.UILWAlMainMidItem")
local scroll_view_path = ""

function UILWAlMainMid:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMainMid:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMainMid:ComponentDefine()
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
end

function UILWAlMainMid:ShowArrow()
  local param = {}
  param.position = self:GetMidBtnPosByType(6)
  param.arrowType = ArrowType.Building
  param.positionType = PositionType.Screen
  param.isPanel = false
  if param.position ~= nil then
    DataCenter.ArrowManager:ShowArrow(param)
  end
end

function UILWAlMainMid:ComponentDestroy()
  self.scroll_view = nil
end

function UILWAlMainMid:DataDefine()
  self.btnCells = {}
  self.midShowBtns = {}
end

function UILWAlMainMid:DataDestroy()
  self.btnCells = nil
  self.midShowBtns = nil
end

function UILWAlMainMid:OnEnable()
  base.OnEnable(self)
end

function UILWAlMainMid:OnDisable()
  base.OnDisable(self)
end

function UILWAlMainMid:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceWarUpdate, self.OnRefreshAlWar)
  self:AddUIListener(EventId.UpdateAllianceAutoRallyInfo, self.OnRefreshAlWar)
  self:AddUIListener(EventId.ALLIANCE_WAR_DELETE, self.OnRefreshAlWar)
  self:AddUIListener(EventId.UpdateAlertRedPoint, self.OnRefreshAlWar)
  self:AddUIListener(EventId.CrossServerWar, self.OnRefreshAlWar)
  self:AddUIListener(EventId.UpdateAllianceHelpNum, self.OnRefreshAlHelp)
  self:AddUIListener(EventId.UpdateAllianceGiftNum, self.OnRefreshAlGift)
  self:AddUIListener(EventId.UpdateMainAllianceRedCount, self.OnRefreshAlScience)
  self:AddUIListener(EventId.OnAllianceTaskRedChange, self.OnRefreshAllianceTask)
  self:AddUIListener(EventId.CheckSeasonDevoteData, self.OnCheckSeasonDevoteData)
  self:AddUIListener(EventId.UpdateLongDistanceMemberNum, self.OnRefreshAlGather)
  self:AddUIListener(EventId.BuildMainZeroUpgradeSuccess, self.OnRefreshAlGather)
  self:AddUIListener(EventId.UpdateSelfAllianceRallyPoint, self.OnRefreshAlGather)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.OnRefreshAlActivity)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.OnRefreshAlActivity)
  self:AddUIListener(EventId.OnAllyDrillStageChange, self.OnRefreshAlActivity)
  self:AddUIListener(EventId.OnRecvNewActivityInfo, self.OnRefreshAlActivity)
end

function UILWAlMainMid:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceWarUpdate, self.OnRefreshAlWar)
  self:RemoveUIListener(EventId.UpdateAllianceAutoRallyInfo, self.OnRefreshAlWar)
  self:RemoveUIListener(EventId.ALLIANCE_WAR_DELETE, self.OnRefreshAlWar)
  self:RemoveUIListener(EventId.UpdateAlertRedPoint, self.OnRefreshAlWar)
  self:RemoveUIListener(EventId.CrossServerWar, self.OnRefreshAlWar)
  self:RemoveUIListener(EventId.UpdateAllianceHelpNum, self.OnRefreshAlHelp)
  self:RemoveUIListener(EventId.UpdateAllianceGiftNum, self.OnRefreshAlGift)
  self:RemoveUIListener(EventId.UpdateMainAllianceRedCount, self.OnRefreshAlScience)
  self:RemoveUIListener(EventId.OnAllianceTaskRedChange, self.OnRefreshAllianceTask)
  self:RemoveUIListener(EventId.CheckSeasonDevoteData, self.OnCheckSeasonDevoteData)
  self:RemoveUIListener(EventId.UpdateLongDistanceMemberNum, self.OnRefreshAlGather)
  self:RemoveUIListener(EventId.BuildMainZeroUpgradeSuccess, self.OnRefreshAlGather)
  self:RemoveUIListener(EventId.UpdateSelfAllianceRallyPoint, self.OnRefreshAlGather)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.OnRefreshAlActivity)
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.OnRefreshAlActivity)
  self:RemoveUIListener(EventId.OnAllyDrillStageChange, self.OnRefreshAlActivity)
  self:RemoveUIListener(EventId.OnRecvNewActivityInfo, self.OnRefreshAlActivity)
end

function UILWAlMainMid:ClearScroll()
  self.btnCells = {}
  self.midShowBtns = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(MainMidItem)
end

function UILWAlMainMid:OnCheckSeasonDevoteData()
  local existDevoteData = DataCenter.SeasonDataManager.ExistDevoteData
  if existDevoteData then
    self:ClearScroll()
    self.hasCheckDevoteData = true
    self.midShowBtns = self.view.ctrl:GetMidShowBtnsList()
    local count = table.count(self.midShowBtns)
    if 0 < count then
      self.scroll_view:SetTotalCount(count)
      self.scroll_view:RefillCells()
    end
  end
end

function UILWAlMainMid:RefreshContent()
  self:ClearScroll()
  self.midShowBtns = self.view.ctrl:GetMidShowBtnsList()
  local count = table.count(self.midShowBtns)
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
  if SeasonUtil.IsInSeason() then
    local existDevoteData = DataCenter.SeasonDataManager.ExistDevoteData
    if not existDevoteData and not self.hasCheckDevoteData then
      self.hasCheckDevoteData = true
      SFSNetwork.SendMessage(MsgDefines.CheckSeasonDevoteData, LuaEntry.Player:GetAllianceUid())
    end
  end
  local param = self.view:GetUserData()
  if param and param.Guide then
    local target
    if param.Guide == "Gather" then
      target = self.btnCells[LWAlMainMidBtnType.Al_Gather]
      target = target and target.transform
    end
    if not IsNull(target) then
      TimerManager:GetInstance():DelayInvoke(function()
        local p = {
          position = target.position,
          arrowType = ArrowType.Capacity,
          positionType = PositionType.Screen
        }
        DataCenter.ArrowManager:ShowArrow(p)
      end, 0.1)
    end
  end
end

function UILWAlMainMid:OnCellMoveIn(itemObj, index)
  local param = {
    type = self.midShowBtns[index],
    clickCall = function(type)
      self:OnClick(type)
    end
  }
  itemObj.name = param.type
  local cellItem = self.scroll_view:AddComponent(MainMidItem, itemObj)
  cellItem:SetData(param)
  cellItem:OnRefreshRedPot()
  self.btnCells[self.midShowBtns[index]] = cellItem
end

function UILWAlMainMid:OnCellMoveOut(itemObj, index)
  self.btnCells[self.midShowBtns[index]] = nil
  self.scroll_view:RemoveComponent(itemObj.name, MainMidItem)
end

function UILWAlMainMid:OnClick(type)
  self.view.ctrl:OnMidBtnClick(type)
end

function UILWAlMainMid:GetMidBtnPosByType(type)
  if self.btnCells[type] then
    return self.btnCells[type].transform.position
  end
  return nil
end

function UILWAlMainMid:OnRefreshMidByType(type)
  if self.btnCells and self.btnCells[type] ~= nil then
    self.btnCells[type]:OnRefreshRedPot()
  end
end

function UILWAlMainMid:OnRefreshAlWar()
  self:OnRefreshMidByType(LWAlMainMidBtnType.Al_War)
end

function UILWAlMainMid:OnRefreshAlHelp()
  self:OnRefreshMidByType(LWAlMainMidBtnType.Al_Help)
end

function UILWAlMainMid:OnRefreshAlGift()
  self:OnRefreshMidByType(LWAlMainMidBtnType.Al_Gift)
end

function UILWAlMainMid:OnRefreshAlMember()
  self:OnRefreshMidByType(LWAlMainMidBtnType.Al_Member)
end

function UILWAlMainMid:OnRefreshAlScience()
  self:OnRefreshMidByType(LWAlMainMidBtnType.Al_Science)
  self:OnRefreshMidByType(LWAlMainMidBtnType.Al_Shop)
end

function UILWAlMainMid:OnRefreshAllianceTask()
  self:OnRefreshMidByType(LWAlMainMidBtnType.Al_Achieve)
end

function UILWAlMainMid:OnRefreshAlGather()
  self:OnRefreshMidByType(LWAlMainMidBtnType.Al_Gather)
end

function UILWAlMainMid:OnRefreshAlActivity()
  self:OnRefreshMidByType(LWAlMainMidBtnType.Al_Activity)
end

function UILWAlMainMid:SetScrollViewOffsetMinXY(x, y)
  self.scroll_view:SetOffsetMinXY(x, y)
end

return UILWAlMainMid
