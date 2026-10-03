local UIWorldOutpostCityPointInfo = BaseClass("UIWorldOutpostCityPointInfo", UIBaseContainer)
local base = UIBaseContainer
local UIWorldOutpostCityFix = require("UI.LWWorld.UIWorldOutpostCityPoint.Component.UIWorldOutpostCityFix")
local UIWorldOutpostCityEmpty = require("UI.LWWorld.UIWorldOutpostCityPoint.Component.UIWorldOutpostCityEmpty")
local UIWorldOutpostCityNormal = require("UI.LWWorld.UIWorldOutpostCityPoint.Component.UIWorldOutpostCityNormal")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local build_info_path = "BuildInfo"
local build_details_path = "BuildDetails"
local normal_root_path = "BuildInfo/NormalRoot"
local fix_root_path = "BuildInfo/FixRoot"
local base_info_path = "BuildInfo/baseInfo"
local empty_root_path = "BuildInfo/EmptyRoot"
local the_desc_path = "BuildInfo/TheDesc"

function UIWorldOutpostCityPointInfo:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIWorldOutpostCityPointInfo:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldOutpostCityPointInfo:ComponentDefine()
  self.build_info = self:AddComponent(UICanvasGroup, build_info_path)
  self.build_details = self:AddComponent(UIImage, build_details_path)
  self.base_info = self:AddComponent(UIBaseContainer, base_info_path)
  self.fix_root = self:AddComponent(UIWorldOutpostCityFix, fix_root_path)
  self.normal_root = self:AddComponent(UIWorldOutpostCityNormal, normal_root_path)
  self.empty_root = self:AddComponent(UIWorldOutpostCityEmpty, empty_root_path)
  self.the_desc = self:AddComponent(UITextMeshProUGUIEx, the_desc_path)
end

function UIWorldOutpostCityPointInfo:ComponentDestroy()
  if self.dCompAssistance then
    self.dCompAssistance:Delete()
    self.dCompAssistance = nil
  end
  if self.dynamicCampDestroy then
    self.dynamicCampDestroy:Delete()
    self.dynamicCampDestroy = nil
  end
  self.build_info = nil
  self.build_details = nil
  self.base_info = nil
  self.fix_root = nil
  self.normal_root = nil
  self.empty_root = nil
  self.the_desc = nil
end

function UIWorldOutpostCityPointInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:AddUIListener(EventId.FocusPointChanged, self.OnAssistanceDetailInfo)
end

function UIWorldOutpostCityPointInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:RemoveUIListener(EventId.FocusPointChanged, self.OnAssistanceDetailInfo)
  base.OnRemoveListener(self)
end

function UIWorldOutpostCityPointInfo:InitData(param)
  local ownerServerId = 0
  if param ~= nil and param.extraInfo ~= nil then
    ownerServerId = toInt(param.extraInfo.ownerServerId)
  end
  self.param = param
  self.build_details:SetActive(false)
  self.base_info:SetActive(param.state == 0 and param.fixActData == nil)
  self.fix_root:InitData(param)
  self.normal_root:InitData(param)
  self.empty_root:InitData(param)
  self.canAssistance = param.canAssistance
  if self.dCompAssistance == nil and not param.inProtectMode and WorldBattleUtil.EnableShowWorldAssistanceInfo() and not BattleFieldUtil.InBattleField() then
    local lua_path_assistance = "UI.UIWorldPoint.Component.UIWorldPointNewOtherPlayerInfoAssistanceComp"
    self.dCompAssistance = UIAsyncLoaderBridge.New(self, "dCompAssistance", self.build_info.transform, UIAssets.UIWorldPointComp_PlayerAssistanceComp, lua_path_assistance, false)
  end
  if param.isDestroy and param.extraInfo then
    if self.dynamicCampDestroy == nil then
      local extraInfo = param.extraInfo
      local luaPath_campDestroy = "UI.LWWorld.UIWorldSiegePointSeason.Component.UIWorldSiegePointCompCampDestroy"
      local prefabPath_campDestroy = "Assets/Main/SeasonRes/S6/Prefabs/WorldUI/UIWorldSiegePointCompCampDestroy.prefab"
      self.dynamicCampDestroy = UIAsyncLoaderBridge.New(self, "dynamicCampDestroy", self.build_info.transform, prefabPath_campDestroy, luaPath_campDestroy, false, function()
        if self.the_desc then
          self.the_desc:SetAsLastSibling()
        end
      end)
      self.dynamicCampDestroy:RefreshData({
        state = 8,
        isOutpost = true,
        ruinObj = {
          ruinBeginTime = extraInfo.ruinTime,
          currOwnerCampId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(extraInfo.destroyServerId),
          allianceInfo = {
            allianceId = extraInfo.destroyAllianceId,
            serverId = extraInfo.destroyServerId
          }
        }
      }, self.param)
    end
    self.dynamicCampDestroy:SetActive(true)
    self.the_desc:SetActive(true)
    self.the_desc:SetLocalText("s6_outpost_destroy_limit_4")
    self.the_desc:SetAsLastSibling()
  else
    if self.dynamicCampDestroy then
      self.dynamicCampDestroy:SetActive(false)
    end
    self.the_desc:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function UIWorldOutpostCityPointInfo:RefreshData(serverData)
  self.serverData = serverData
  self.fix_root:RefreshData(serverData)
  self.normal_root:RefreshData(serverData)
  self.empty_root:RefreshData(serverData)
  self:RefreshAssistance(serverData)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function UIWorldOutpostCityPointInfo:OnInfoClick()
  self.build_details:SetActive(true)
end

function UIWorldOutpostCityPointInfo:OnReturnClick()
  self.build_details:SetActive(false)
end

function UIWorldOutpostCityPointInfo:RefreshAssistance(info)
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
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function UIWorldOutpostCityPointInfo:OnAssistanceDetailInfo(pointId)
  if not self.param then
    return
  end
  pointId = pointId and tonumber(pointId)
  if pointId and pointId == self.param.pointId then
    WorldBattleUtil.TryRequestCityInfo(self.param.cityId)
  end
end

return UIWorldOutpostCityPointInfo
