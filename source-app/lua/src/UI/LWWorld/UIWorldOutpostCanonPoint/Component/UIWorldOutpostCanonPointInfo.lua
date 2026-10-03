local UIWorldOutpostCanonPointInfo = BaseClass("UIWorldOutpostCanonPointInfo", UIBaseContainer)
local base = UIBaseContainer
local UIWorldOutpostCanonPointNormal = require("UI.LWWorld.UIWorldOutpostCanonPoint.Component.UIWorldOutpostCanonPointNormal")
local build_info_path = "BuildInfo"
local build_details_path = "BuildDetails"
local cross_outpost_canon_path = "BuildInfo/CrossOutpostCanon"

function UIWorldOutpostCanonPointInfo:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIWorldOutpostCanonPointInfo:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldOutpostCanonPointInfo:ComponentDefine()
  self.build_info = self:AddComponent(UICanvasGroup, build_info_path)
  self.build_details = self:AddComponent(UIImage, build_details_path)
  self.normalRoot = self:AddComponent(UIWorldOutpostCanonPointNormal, cross_outpost_canon_path)
end

function UIWorldOutpostCanonPointInfo:ComponentDestroy()
  if self.dCompAssistance then
    self.dCompAssistance:Delete()
    self.dCompAssistance = nil
  end
  self.build_info = nil
  self.build_details = nil
  self.normalRoot = nil
end

function UIWorldOutpostCanonPointInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:AddUIListener(EventId.FocusPointChanged, self.OnAssistanceDetailInfo)
end

function UIWorldOutpostCanonPointInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:RemoveUIListener(EventId.FocusPointChanged, self.OnAssistanceDetailInfo)
  base.OnRemoveListener(self)
end

function UIWorldOutpostCanonPointInfo:InitData(param)
  self.param = param
  self.build_details:SetActive(false)
  self.normalRoot:InitData(param)
  self.canAssistance = param.canAssistance
  if self.dCompAssistance == nil and not param.inProtectMode and WorldBattleUtil.EnableShowWorldAssistanceInfo() and not BattleFieldUtil.InBattleField() then
    local lua_path_assistance = "UI.UIWorldPoint.Component.UIWorldPointNewOtherPlayerInfoAssistanceComp"
    self.dCompAssistance = UIAsyncLoaderBridge.New(self, "dCompAssistance", self.build_info.transform, UIAssets.UIWorldPointComp_PlayerAssistanceComp, lua_path_assistance, false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

function UIWorldOutpostCanonPointInfo:RefreshData(serverData)
  self.serverData = serverData
  self.normalRoot:RefreshData(serverData)
  self:RefreshAssistance(serverData)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

function UIWorldOutpostCanonPointInfo:OnInfoClick()
  self.build_details:SetActive(true)
end

function UIWorldOutpostCanonPointInfo:OnReturnClick()
  self.build_details:SetActive(false)
end

function UIWorldOutpostCanonPointInfo:RefreshAssistance(info)
  if not self.dCompAssistance then
    return
  end
  if not (info and info.assistanceList) or #info.assistanceList < 0 then
    self.dCompAssistance:SetActive(false)
  else
    self.dCompAssistance:SetActive(true)
    self.dCompAssistance:Setup({
      isCity = true,
      pointId = self.param.pointId,
      cityId = info.cityId,
      assistanceList = info.assistanceList,
      maxMember = info.maxAssistance,
      memberCount = info.currAssistance,
      totalPower = info.assistanceTotalPower,
      limit = 10
    })
  end
end

function UIWorldOutpostCanonPointInfo:OnAssistanceDetailInfo(pointId)
  if not self.param then
    return
  end
  pointId = pointId and tonumber(pointId)
  if pointId and pointId == self.param.pointId then
    WorldBattleUtil.TryRequestCityInfo(self.param.cityId)
  end
end

return UIWorldOutpostCanonPointInfo
