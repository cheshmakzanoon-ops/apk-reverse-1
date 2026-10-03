local UIWorldLLCanonPointInfo = BaseClass("UIWorldLLCanonPointInfo", UIBaseContainer)
local base = UIBaseContainer
local UIWorldLLCanonPointNormal = require("UI.LWWorld.UIWorldLLCanonPoint.Component.UIWorldLLCanonPointNormal")
local build_info_path = "BuildInfo"
local build_details_path = "BuildDetails"
local ll_world_canon_info_path = "BuildInfo/LLWorldCanonInfo"

function UIWorldLLCanonPointInfo:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIWorldLLCanonPointInfo:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldLLCanonPointInfo:ComponentDefine()
  self.build_info = self:AddComponent(UICanvasGroup, build_info_path)
  self.build_details = self:AddComponent(UIImage, build_details_path)
  self.normalRoot = self:AddComponent(UIWorldLLCanonPointNormal, ll_world_canon_info_path)
end

function UIWorldLLCanonPointInfo:ComponentDestroy()
  if self.dCompAssistance then
    self.dCompAssistance:Delete()
    self.dCompAssistance = nil
  end
  self.build_info = nil
  self.build_details = nil
  self.normalRoot = nil
end

function UIWorldLLCanonPointInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:AddUIListener(EventId.FocusPointChanged, self.OnAssistanceDetailInfo)
end

function UIWorldLLCanonPointInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:RemoveUIListener(EventId.FocusPointChanged, self.OnAssistanceDetailInfo)
  base.OnRemoveListener(self)
end

function UIWorldLLCanonPointInfo:InitData(param)
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

function UIWorldLLCanonPointInfo:RefreshData(serverData)
  self.serverData = serverData
  self.normalRoot:RefreshData(serverData)
  self:RefreshAssistance(serverData)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

function UIWorldLLCanonPointInfo:OnInfoClick()
  self.build_details:SetActive(true)
end

function UIWorldLLCanonPointInfo:OnReturnClick()
  self.build_details:SetActive(false)
end

function UIWorldLLCanonPointInfo:RefreshAssistance(info)
  if not self.dCompAssistance then
    return
  end
  if not (info and info.assistanceList) or #info.assistanceList <= 0 then
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

function UIWorldLLCanonPointInfo:OnAssistanceDetailInfo(pointId)
  if not self.param then
    return
  end
  pointId = pointId and tonumber(pointId)
  if pointId and pointId == self.param.pointId then
    WorldBattleUtil.TryRequestCityInfo(self.param.cityId)
  end
end

return UIWorldLLCanonPointInfo
