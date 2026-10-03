local SeasonFactionWarAliList = BaseClass("SeasonFactionWarAliList", UIGridLayoutGroup)
local base = UIGridLayoutGroup
local UnityLayoutElement = typeof(CS.UnityEngine.UI.LayoutElement)
local SeasonFactionWarAliInfo = require("UI.LWSeason2.Activity.Component.SeasonFactionWar.SeasonFactionWarAliInfo")

function SeasonFactionWarAliList:OnCreate()
  base.OnCreate(self)
  self.enableAutoSize = false
  self.unity_LayoutElement = self.gameObject:GetComponent(UnityLayoutElement)
  self.vs = self:AddComponent(UIImage, "vs")
  self.group1 = self:AddComponent(UIBaseContainer, "Group1")
  self.group2 = self:AddComponent(UIBaseContainer, "Group2")
  self.ali_info11 = self:AddComponent(SeasonFactionWarAliInfo, "Group1/AliInfo11")
  self.ali_info12 = self:AddComponent(SeasonFactionWarAliInfo, "Group1/AliInfo12")
  self.ali_info13 = self:AddComponent(SeasonFactionWarAliInfo, "Group1/AliInfo13")
  self.ali_info21 = self:AddComponent(SeasonFactionWarAliInfo, "Group2/AliInfo21")
  self.ali_info22 = self:AddComponent(SeasonFactionWarAliInfo, "Group2/AliInfo22")
  self.ali_info23 = self:AddComponent(SeasonFactionWarAliInfo, "Group2/AliInfo23")
end

function SeasonFactionWarAliList:OnDestroy()
  self.unity_LayoutElement = nil
  self.vs = nil
  self.ali_info11 = nil
  self.ali_info12 = nil
  self.ali_info13 = nil
  self.ali_info21 = nil
  self.ali_info22 = nil
  self.ali_info23 = nil
  base.OnDestroy(self)
end

function SeasonFactionWarAliList:SetAutoSizeEnable(enable)
  if enable ~= self.enableAutoSize then
    self.enableAutoSize = enable
    self:RefreshHeight()
  end
end

function SeasonFactionWarAliList:CanShowInviteWhenEmpty(canShowInvite)
  self.canShowInvite = canShowInvite
  self.ali_info11:CanShowInviteWhenEmpty(canShowInvite)
  self.ali_info12:CanShowInviteWhenEmpty(canShowInvite)
  self.ali_info13:CanShowInviteWhenEmpty(canShowInvite)
  self.ali_info21:CanShowInviteWhenEmpty(canShowInvite)
  self.ali_info22:CanShowInviteWhenEmpty(canShowInvite)
  self.ali_info23:CanShowInviteWhenEmpty(canShowInvite)
end

function SeasonFactionWarAliList:ReInit(dataDefence, dataAttack, warServerId, warAllianceId)
  self.ali_info11:ReInit(dataDefence and dataDefence[1] or nil, true, warServerId, warAllianceId)
  self.ali_info12:ReInit(dataDefence and dataDefence[2] or nil, true, warServerId, warAllianceId)
  self.ali_info13:ReInit(dataDefence and dataDefence[3] or nil, true, warServerId, warAllianceId)
  self.ali_info21:ReInit(dataAttack and dataAttack[1] or nil, false, warServerId, warAllianceId)
  self.ali_info22:ReInit(dataAttack and dataAttack[2] or nil, false, warServerId, warAllianceId)
  self.ali_info23:ReInit(dataAttack and dataAttack[3] or nil, false, warServerId, warAllianceId)
  self:RefreshHeight()
end

function SeasonFactionWarAliList:HideEmpty()
  self.ali_info22:SetActive(not self.ali_info22:IsEmpty())
  self.ali_info23:SetActive(not self.ali_info23:IsEmpty())
  self.ali_info12:SetActive(not self.ali_info12:IsEmpty())
  self.ali_info13:SetActive(not self.ali_info13:IsEmpty())
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.group1.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.group2.transform)
end

function SeasonFactionWarAliList:RefreshHeight()
  if self.unity_LayoutElement then
    if self.enableAutoSize then
      if self.ali_info12:IsEmpty() and self.ali_info22:IsEmpty() then
        self.unity_LayoutElement.minHeight = 180
        self.unity_LayoutElement.preferredHeight = 180
        self.ali_info12:SetActive(false)
        self.ali_info13:SetActive(false)
        self.ali_info22:SetActive(false)
        self.ali_info23:SetActive(false)
      elseif self.ali_info13:IsEmpty() and self.ali_info23:IsEmpty() then
        self.unity_LayoutElement.minHeight = 240
        self.unity_LayoutElement.preferredHeight = 240
        self.ali_info12:SetActive(true)
        self.ali_info13:SetActive(false)
        self.ali_info22:SetActive(true)
        self.ali_info23:SetActive(false)
      else
        self.unity_LayoutElement.minHeight = 360
        self.unity_LayoutElement.preferredHeight = 360
        self.ali_info12:SetActive(true)
        self.ali_info13:SetActive(true)
        self.ali_info22:SetActive(true)
        self.ali_info23:SetActive(true)
      end
      local sizeDelta = self:GetSizeDelta()
      self:SetSizeDeltaXY(sizeDelta.x, self.unity_LayoutElement.minHeight)
    else
      self.unity_LayoutElement.minHeight = 360
      self.unity_LayoutElement.preferredHeight = 360
      self.ali_info12:SetActive(true)
      self.ali_info13:SetActive(true)
      self.ali_info22:SetActive(true)
      self.ali_info23:SetActive(true)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.group1.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.group2.transform)
end

function SeasonFactionWarAliList:GetPreferredHeight()
  if self.unity_LayoutElement then
    return self.unity_LayoutElement.preferredHeight
  end
  return 360
end

function SeasonFactionWarAliList:ShowEmptyIcon(showIt)
  self.showEmptyIcon = showIt
  self.ali_info11:ShowEmptyIcon(showIt)
  self.ali_info12:ShowEmptyIcon(showIt)
  self.ali_info13:ShowEmptyIcon(showIt)
  self.ali_info21:ShowEmptyIcon(showIt)
  self.ali_info22:ShowEmptyIcon(showIt)
  self.ali_info23:ShowEmptyIcon(showIt)
end

function SeasonFactionWarAliList:UpdateResChangeInfo(alResChangeInfo)
  self.ali_info11:UpdateResChangeInfo(alResChangeInfo)
  self.ali_info12:UpdateResChangeInfo(alResChangeInfo)
  self.ali_info13:UpdateResChangeInfo(alResChangeInfo)
  self.ali_info21:UpdateResChangeInfo(alResChangeInfo)
  self.ali_info22:UpdateResChangeInfo(alResChangeInfo)
  self.ali_info23:UpdateResChangeInfo(alResChangeInfo)
end

return SeasonFactionWarAliList
