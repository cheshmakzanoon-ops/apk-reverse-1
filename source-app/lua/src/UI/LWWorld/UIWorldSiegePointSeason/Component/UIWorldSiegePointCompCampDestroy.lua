local base = UIAsyncContainer
local UIWorldSiegePointCompCampDestroy = BaseClass("UIWorldSiegePointCompCampDestroy", base)
local UIWorldSiegePointCompCampDestroyIR = require("UI.LWWorld.UIWorldSiegePointSeason.Component.UIWorldSiegePointCompCampDestroyIR")
local Localization = CS.GameEntry.Localization

function UIWorldSiegePointCompCampDestroy:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWorldSiegePointCompCampDestroy:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldSiegePointCompCampDestroy:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compBottom = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.textTmpBottomScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTmpBottom = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compRank2 = self.viewSkin:AddComponent(self, UIWorldSiegePointCompCampDestroyIR, 5)
  self.compRank1 = self.viewSkin:AddComponent(self, UIWorldSiegePointCompCampDestroyIR, 6)
  self.compRank0 = self.viewSkin:AddComponent(self, UIWorldSiegePointCompCampDestroyIR, 7)
  self.textTmpTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compFoldRect = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.btnFold = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnFold:SetOnClick(function()
    self:OnBtnFoldClick()
  end)
  self.imgFold = self.viewSkin:AddComponent(self, UIImage, 11)
  self.compFirstFuckNode = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.textAllianceName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textFuckTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.compFactionNode = self.viewSkin:AddComponent(self, UIBaseContainer, 15)
  self.textTmpTitle:SetLocalText("season_s6_activity_1200112_desc12")
  self.textTmpBottom:SetLocalText("season_s6_activity_1200116_desc14")
  self.isFold = false
  self:RefreshFoldState()
end

function UIWorldSiegePointCompCampDestroy:ComponentDestroy()
  self.viewSkin = nil
  self.textTmpDesc = nil
  self.compBottom = nil
  self.textTmpBottomScore = nil
  self.textTmpBottom = nil
  self.compRank2 = nil
  self.compRank1 = nil
  self.compRank0 = nil
  self.textTmpTitle = nil
  self.compFoldRect = nil
  self.btnFold = nil
  self.imgFold = nil
  self.compFirstFuckNode = nil
  self.textAllianceName = nil
  self.textFuckTime = nil
  self.compFactionNode = nil
end

function UIWorldSiegePointCompCampDestroy:DataDefine()
  self.isFold = false
end

function UIWorldSiegePointCompCampDestroy:DataDestroy()
end

function UIWorldSiegePointCompCampDestroy:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.OnAllianceDataCallBack)
end

function UIWorldSiegePointCompCampDestroy:OnRemoveListener()
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.OnAllianceDataCallBack)
  base.OnRemoveListener(self)
end

function UIWorldSiegePointCompCampDestroy:RefreshData(serverData, buildData)
  self.serverData = serverData
  self.isOutpost = serverData.isOutpost
  self:SetActive(true)
  self.textTmpTitle:SetLocalText("season_s6_camp_destroy_1")
  local destroy_force = toInt(buildData and buildData.destroy_force or 0)
  if 0 < destroy_force then
    self.compFactionNode:SetActive(true)
    self.textTmpBottomScore:SetText(string.format("+%s", string.GetFormattedSeparatorNum(destroy_force)))
  else
    self.compFactionNode:SetActive(false)
  end
  self:RefreshFoldState()
  local campType = serverData.ruinObj.currOwnerCampId or SeasonFactionType.None
  self:RefreshCampState(campType)
  local rankInfo = serverData and serverData.ruinObj and serverData.ruinObj.rankInfo
  local allianceInfo = serverData and serverData.ruinObj and serverData.ruinObj.allianceInfo
  self:RefreshRank(rankInfo, allianceInfo)
  self:RefreshDestroyAlliance(serverData and serverData.ruinObj)
end

function UIWorldSiegePointCompCampDestroy:OnBtnFoldClick()
  self.isFold = not self.isFold
  self:RefreshFoldState()
end

function UIWorldSiegePointCompCampDestroy:RefreshFoldState()
  local spriteName = self.isFold and "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png" or "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png"
  self.imgFold:LoadSpriteAsync(spriteName)
  self.compFoldRect:SetActive(not self.isFold)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  if self.view and self.view.AutoFitUI then
    self.view:AutoFitUI(1)
  end
end

function UIWorldSiegePointCompCampDestroy:RefreshCampState(camp)
  if self.isOutpost then
    if camp == SeasonFactionType.Rebels then
      self.textTmpDesc:SetLocalText("s6_outpost_destroy_limit_1")
      self.textTmpDesc:SetActive(true)
    elseif camp == SeasonFactionType.Gendarmerie then
      self.textTmpDesc:SetLocalText("s6_outpost_destroy_limit_2")
      self.textTmpDesc:SetActive(true)
    else
      self.textTmpDesc:SetActive(false)
    end
  elseif camp == SeasonFactionType.Rebels then
    self.textTmpDesc:SetLocalText("season_s6_activity_1200112_desc10")
    self.textTmpDesc:SetActive(true)
  elseif camp == SeasonFactionType.Gendarmerie then
    self.textTmpDesc:SetLocalText("season_s6_activity_1200112_desc11")
    self.textTmpDesc:SetActive(true)
  else
    self.textTmpDesc:SetActive(false)
  end
end

function UIWorldSiegePointCompCampDestroy:RefreshRank(rank, allianceInfo)
  if not rank or #rank <= 0 then
    self.compRank0:SetActive(false)
    self.compRank1:SetActive(false)
    self.compRank2:SetActive(false)
    self.btnFold:SetActive(false)
    return
  end
  self.btnFold:SetActive(true)
  self.compRank0:RefreshData(rank[1], allianceInfo, 1)
  self.compRank1:RefreshData(rank[2], allianceInfo, 2)
  self.compRank2:RefreshData(rank[3], allianceInfo, 3)
end

function UIWorldSiegePointCompCampDestroy:RefreshDestroyAlliance(data)
  if not data then
    return
  end
  local alliance = data.allianceInfo
  local second = math.floor((data.ruinBeginTime or 0) / 1000)
  self.allianceId = alliance.allianceId
  if alliance.abbr == nil or alliance.name == nil then
    local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(alliance.allianceId)
    if allianceInfo == nil then
      SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, alliance.allianceId)
    else
      self.textAllianceName:SetText(allianceInfo:GetFullName())
    end
  else
    local name = UIUtil.FormatServerAllianceName(alliance.serverId, alliance.abbr, alliance.name)
    self.textAllianceName:SetText(name)
  end
  if self.isOutpost then
    self.textFuckTime:SetLocalText("s6_outpost_destroy_limit_3", UITimeManager:GetInstance():GetTimeToMD(second))
  else
    self.textFuckTime:SetLocalText("season_s6_activity_1200112_desc14", UITimeManager:GetInstance():GetTimeToMD(second))
  end
end

function UIWorldSiegePointCompCampDestroy:OnAllianceDataCallBack()
  if self.serverData == nil or self.allianceId == nil then
    return
  end
  local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allianceId)
  if data ~= nil then
    self.textAllianceName:SetText(data:GetFullName())
  end
end

return UIWorldSiegePointCompCampDestroy
