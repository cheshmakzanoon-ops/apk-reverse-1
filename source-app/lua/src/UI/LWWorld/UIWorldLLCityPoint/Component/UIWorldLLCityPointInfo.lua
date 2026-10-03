local base = UIAsyncContainer
local UIWorldLLCityPointInfo = BaseClass("UIWorldLLCityPointInfo", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local UIWorldLLCityPointFixOrPrepareBoom = require("UI.LWWorld.UIWorldLLCityPoint.Component.UIWorldLLCityPointFixOrPrepareBoom")
local UIWorldLLCityPointNormalBattle = require("UI.LWWorld.UIWorldLLCityPoint.Component.UIWorldLLCityPointNormalBattle")
local UIWorldLLCityPointThroneBattle = require("UI.LWWorld.UIWorldLLCityPoint.Component.UIWorldLLCityPointThroneBattle")
local UIWorldLLCityPointTime = require("UI.LWWorld.UIWorldLLCityPoint.Component.UIWorldLLCityPointTime")
local UIWorldLLCityPointReward = require("UI.LWWorld.UIWorldLLCityPoint.Component.UIWorldLLCityPointReward")
local lua_path_assistance = "UI.UIWorldPoint.Component.UIWorldPointNewOtherPlayerInfoAssistanceComp"

function UIWorldLLCityPointInfo:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWorldLLCityPointInfo:OnDestroy()
  self:DataDestroy()
  if self.dCompAssistance then
    self.dCompAssistance:Delete()
    self.dCompAssistance = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldLLCityPointInfo:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compFixingOrPreparingBoomProgressContent = self.viewSkin:AddComponent(self, UIWorldLLCityPointFixOrPrepareBoom, 1)
  self.compNormalBuildingProgressContent = self.viewSkin:AddComponent(self, UIWorldLLCityPointNormalBattle, 2)
  self.compThroneProgressContent = self.viewSkin:AddComponent(self, UIWorldLLCityPointThroneBattle, 3)
  self.compRewardContent = self.viewSkin:AddComponent(self, UIWorldLLCityPointReward, 4)
  self.compTimeTipContent = self.viewSkin:AddComponent(self, UIWorldLLCityPointTime, 5)
  self.compAssistanceRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
    self.dCompAssistance = UIAsyncLoaderBridge.New(self, "dCompAssistance", self.compAssistanceRoot.transform, UIAssets.UIWorldPointComp_PlayerAssistanceCompFat, lua_path_assistance)
  end
end

function UIWorldLLCityPointInfo:ComponentDestroy()
  self.viewSkin = nil
  self.compFixingOrPreparingBoomProgressContent = nil
  self.compNormalBuildingProgressContent = nil
  self.compThroneProgressContent = nil
  self.compRewardContent = nil
  self.compTimeTipContent = nil
  self.compAssistanceRoot = nil
end

function UIWorldLLCityPointInfo:DataDefine()
end

function UIWorldLLCityPointInfo:DataDestroy()
end

function UIWorldLLCityPointInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordCityPointInfoUpdate, self.OnLandlordCityPointInfoUpdate)
end

function UIWorldLLCityPointInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordCityPointInfoUpdate, self.OnLandlordCityPointInfoUpdate)
  base.OnRemoveListener(self)
end

function UIWorldLLCityPointInfo:Refresh(info)
  self.info = info
  if self.activeSelf then
    local clientState = self.info.clientState
    local worldCityType = self.info.worldCityType
    self.compFixingOrPreparingBoomProgressContent:SetActive(clientState == LLConst.LLBuildingState.Rebuilding or clientState == LLConst.LLBuildingState.WillExplode)
    self.compNormalBuildingProgressContent:SetActive((clientState == LLConst.LLBuildingState.Fighting or clientState == LLConst.LLBuildingState.OpenButShield or clientState == LLConst.LLBuildingState.NotOpen) and worldCityType == WorldAllianceCityType.LLNormalCity)
    self.compThroneProgressContent:SetActive((clientState == LLConst.LLBuildingState.Fighting or clientState == LLConst.LLBuildingState.OpenButShield or clientState == LLConst.LLBuildingState.NotOpen) and worldCityType == WorldAllianceCityType.LLThroneCity)
    self.compRewardContent:SetActive(not self.info.isOldCity and (clientState == LLConst.LLBuildingState.Fighting or clientState == LLConst.LLBuildingState.WillExplode or clientState == LLConst.LLBuildingState.NotOpen or clientState == LLConst.LLBuildingState.OpenButShield))
    self.compTimeTipContent:SetActive(clientState == LLConst.LLBuildingState.Fighting or clientState == LLConst.LLBuildingState.Rebuilding or clientState == LLConst.LLBuildingState.NotOpen or clientState == LLConst.LLBuildingState.OpenButShield or clientState == LLConst.LLBuildingState.WillExplode)
    self.compFixingOrPreparingBoomProgressContent:Refresh(self.info)
    self.compNormalBuildingProgressContent:Refresh(self.info)
    self.compThroneProgressContent:Refresh(self.info)
    self.compRewardContent:Refresh(self.info)
    self.compTimeTipContent:Refresh(self.info)
  end
end

function UIWorldLLCityPointInfo:OnLandlordCityPointInfoUpdate(uuid)
  if self.info and uuid == self.info.uuid then
    local info = self.view.ctrl:GetAllianceCityData()
    self:Refresh(info)
  end
end

function UIWorldLLCityPointInfo:RefreshAssistance(info)
  if not self.dCompAssistance then
    return
  end
  if not (info and info.assistanceList) or #info.assistanceList <= 0 then
    self.dCompAssistance:SetActive(false)
  else
    self.dCompAssistance:SetActive(true)
    self.dCompAssistance:Setup({
      isCity = true,
      pointId = self.info.pointId,
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

return UIWorldLLCityPointInfo
