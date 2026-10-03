local UILLRuleView = BaseClass("UILLRuleView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local PREFAB_PATH = "Assets/Main/Prefabs/UI/Landlord/Rule/%s.prefab"
local CLS_PATH = "UI.Landlord.Rule.Component.%s"
local T_INFOS = {
  "LLRuleStage",
  "LLRuleCommon",
  "LLRuleBuild",
  "LLRuleBattle"
}

function UILLRuleView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILLRuleView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILLRuleView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.panel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.panel:SetOnClick(function()
    self:OnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compCenter = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.toggleTT1 = self.viewSkin:AddComponent(self, UIToggle, 4)
  self.toggleTT2 = self.viewSkin:AddComponent(self, UIToggle, 5)
  self.toggleTT3 = self.viewSkin:AddComponent(self, UIToggle, 6)
  self.toggleTT4 = self.viewSkin:AddComponent(self, UIToggle, 7)
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 8)
  self.toggleTTList = {
    self.toggleTT1,
    self.toggleTT2,
    self.toggleTT3,
    self.toggleTT4
  }
end

function UILLRuleView:ComponentDestroy()
  self.viewSkin = nil
  self.panel = nil
  self.btnClose = nil
  self.compCenter = nil
  self.toggleTT1 = nil
  self.toggleTT2 = nil
  self.toggleTT3 = nil
  self.toggleTT4 = nil
  self.scrollRect = nil
  self.toggleTTList = nil
end

function UILLRuleView:DataDefine()
  self.contents = {}
  self.tabIdx = 1
  self.subTabIdx = 1
  local userValue, extraId = self:GetUserData()
  self.extraId = extraId
  userValue = userValue or LLConst.RuleType.Stage
  if userValue <= LLConst.RuleType.Battle then
    self.tabIdx = userValue
  elseif userValue >= LLConst.RuleType.Build1 and userValue <= LLConst.RuleType.Build5 then
    self.tabIdx = LLConst.RuleType.Build
    self.subTabIdx = userValue - LLConst.RuleType.Build * 10
  elseif userValue >= LLConst.RuleType.BattleDef and userValue <= LLConst.RuleType.BattleOther then
    self.tabIdx = LLConst.RuleType.Battle
    self.subTabIdx = userValue - LLConst.RuleType.Battle * 10
  end
  self:SetToggleOn(self.tabIdx)
  for i, tog in ipairs(self.toggleTTList) do
    tog:SetOnValueChanged(function(value)
      if value then
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
        self:OnToggleClick(i)
      end
    end)
  end
  self:OnToggleClick(self.tabIdx, true)
end

function UILLRuleView:DataDestroy()
  self.contents = nil
  self.compSpeed = nil
end

function UILLRuleView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordRuleTabIndex, self.OnTabValue)
  self:AddUIListener(EventId.LandlordShowCityDetailSpeed, self.OnShowSpeedTips)
end

function UILLRuleView:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordRuleTabIndex, self.OnTabValue)
  self:RemoveUIListener(EventId.LandlordShowCityDetailSpeed, self.OnShowSpeedTips)
  base.OnRemoveListener(self)
end

function UILLRuleView:OnPanelClick()
  self.ctrl:CloseSelf()
end

function UILLRuleView:OnBtnCloseClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.ctrl:CloseSelf()
end

function UILLRuleView:OnTabValue(param)
  if param == nil then
    return
  end
  local tab = param.tab
  if tab == nil then
    return
  end
  self.subTabIdx = param.subTab or nil
  if self.tabIdx == tab then
    local content = self.contents[self.tabIdx]
    content:SetInfo(self.tabIdx, self.subTabIdx)
    self.subTabIdx = nil
    return
  end
  self:SetToggleOn(tab)
  self:OnToggleClick(tab)
end

function UILLRuleView:OnShowSpeedTips(info)
  if self.compSpeed == nil then
    self.compSpeed = self:LoadComponentAsync(LLConst.CLS_DETAIL_SPEED, LLConst.PREFAB_DETAIL_SPEED, self)
  end
  local localP = self.transform:InverseTransformPoint(info.x, info.y, info.z)
  self.compSpeed:SetTargetPos(localP, false, info.isThroneCity)
end

function UILLRuleView:SetToggleOn(tab)
  self.toggleTTList[tab]:SetIsOn(true)
  local p, w = 0, 0
  for i, tog in ipairs(self.toggleTTList) do
    local x = tog:GetSizeDeltaXY()
    w = w + x
    if i < tab then
      p = w
    end
  end
  self.scrollRect:SetHorizontalNormalizedPosition(p / w)
end

function UILLRuleView:OnToggleClick(idx, bForce)
  if not bForce and self.tabIdx == idx then
    return
  end
  local lastContent = self.contents[self.tabIdx]
  if lastContent ~= nil then
    lastContent:SetActive(false)
  end
  self.tabIdx = idx
  local content = self.contents[self.tabIdx]
  if content == nil then
    local name = T_INFOS[idx]
    local cls = string.format(CLS_PATH, name)
    local prefab = string.format(PREFAB_PATH, name)
    content = self:LoadComponentAsync(cls, prefab, self.compCenter, function(_, go)
      go.name = name
      content = self.contents[idx]
      content:SetOffsetMinXY(0, 0)
      content:SetOffsetMaxXY(0, 0)
      if self.tabIdx == idx then
        content:SetActive(true)
      else
        content:SetActive(false)
      end
    end)
    self.contents[idx] = content
  end
  content:SetActive(true)
  content:SetInfo(self.tabIdx, self.subTabIdx, self.extraId)
  self.subTabIdx = nil
  self.extraId = nil
end

return UILLRuleView
