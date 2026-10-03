local UILLBattleDetailView = BaseClass("UILLBattleDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local PREFAB_PATH = "Assets/Main/Prefabs/UI/Landlord/World/LLWorldBattleDetail%sCity.prefab"
local CLS_PATH = "UI.LandlordBattle.BattleDetail.Component.LLWorldBattleDetail%sCity"
local T_INFOS = {
  "Small",
  "Small",
  "Normal",
  "Normal"
}

function UILLBattleDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILLBattleDetailView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILLBattleDetailView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 4)
  self.toggleTT1 = self.viewSkin:AddComponent(self, UIToggle, 5)
  self.toggleTT2 = self.viewSkin:AddComponent(self, UIToggle, 6)
  self.toggleTT3 = self.viewSkin:AddComponent(self, UIToggle, 7)
  self.toggleTT4 = self.viewSkin:AddComponent(self, UIToggle, 8)
  self.textAllianceRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textPersonalRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.toggleTTList = {
    self.toggleTT1,
    self.toggleTT2,
    self.toggleTT3,
    self.toggleTT4
  }
end

function UILLBattleDetailView:ComponentDestroy()
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.btnClose = nil
  self.compContent = nil
  self.scrollRect = nil
  self.toggleTT1 = nil
  self.toggleTT2 = nil
  self.toggleTT3 = nil
  self.toggleTT4 = nil
  self.textAllianceRank = nil
  self.textPersonalRank = nil
  self.btnRank = nil
  self.textTime = nil
  self.textEmpty = nil
  self.toggleTTList = nil
end

function UILLBattleDetailView:DataDefine()
  self.contents = {}
  local curWeek = ActMgr:GetCurWeek()
  if curWeek == 3 then
    self.tabList = {
      4,
      3,
      2,
      1
    }
  elseif curWeek == 2 then
    self.tabList = {
      3,
      2,
      1,
      4
    }
  else
    self.tabList = {
      3,
      1,
      2,
      4
    }
  end
  self.tabIdx = self.tabList[1]
  for i, tog in ipairs(self.toggleTTList) do
    local idx = self:TranSiblingIndex(i)
    tog:SetSiblingIndex(idx - 1)
  end
  self:SetToggleOn(self.tabIdx)
  self:OnToggleTTClick(self.tabIdx, true)
  for i, tog in ipairs(self.toggleTTList) do
    tog:SetOnValueChanged(function(value)
      if value then
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
        self:OnToggleTTClick(i)
      end
    end)
  end
  local info = ActMgr:GetActCurStageInfo()
  local stage = info ~= nil and info.stage or LLConst.LandlordStage.PREVIEW
  if stage == LLConst.LandlordStage.BATTLE then
    self.eTime = info ~= nil and info.eTime or 0
  else
    self.eTime = nil
  end
  self:RefreshTime()
end

function UILLBattleDetailView:DataDestroy()
  self.eTime = nil
  self.tabIdx = nil
  self.contents = nil
  self.compSpeed = nil
end

function UILLBattleDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordGetCityDetailList, self.OnListRefresh)
  self:AddUIListener(EventId.LandlordShowCityDetailSpeed, self.OnShowSpeedTips)
end

function UILLBattleDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordGetCityDetailList, self.OnListRefresh)
  self:RemoveUIListener(EventId.LandlordShowCityDetailSpeed, self.OnShowSpeedTips)
  base.OnRemoveListener(self)
end

function UILLBattleDetailView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UILLBattleDetailView:OnBtnCloseClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.ctrl:CloseSelf()
end

function UILLBattleDetailView:OnBtnRankClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLRank)
end

function UILLBattleDetailView:OnListRefresh(type)
  if self.tabIdx ~= type then
    return
  end
  self:RefreshRank()
  local content = self.contents[self.tabIdx]
  if content ~= nil then
    content:RefreshView()
  end
end

function UILLBattleDetailView:OnShowSpeedTips(data)
  local effValue
  local cityData = data.data
  if cityData ~= nil then
    local campId = cityData.ownerCampId ~= LLConst.LandLordGroup.NONE and cityData.ownerCampId or ActMgr:GetMyGroup()
    local effectId = LLConst.OccupySpeedEffectId[campId]
    if effectId and cityData.effects then
      effValue = (cityData.effects[effectId] or 0) + 1
    end
  end
  if self.compSpeed == nil then
    self.compSpeed = self:LoadComponentAsync(LLConst.CLS_DETAIL_SPEED, LLConst.PREFAB_DETAIL_SPEED, self, function(view)
      self.compSpeed:SetExtraValue(effValue)
    end)
  elseif self.compSpeed:AsyncLoadDone() then
    self.compSpeed:SetExtraValue(effValue)
  end
  local localP = self.transform:InverseTransformPoint(data.x, data.y, data.z)
  self.compSpeed:SetTargetPos(localP, false, data.isThroneCity)
end

function UILLBattleDetailView:TranSiblingIndex(i)
  for j, idx in ipairs(self.tabList) do
    if idx == i then
      return j
    end
  end
  return i
end

function UILLBattleDetailView:SetToggleOn(tab)
  self.toggleTTList[tab]:SetIsOn(true)
  local p, w = 0, 0
  local idx = self:TranSiblingIndex(tab)
  for i, tog in ipairs(self.toggleTTList) do
    local x = tog:GetSizeDeltaXY()
    w = w + x
    if i < idx then
      p = w
    end
  end
  self.scrollRect:SetHorizontalNormalizedPosition(p / w)
end

function UILLBattleDetailView:OnToggleTTClick(index, bForce)
  if not bForce and self.tabIdx == index then
    return
  end
  local lastContent = self.contents[self.tabIdx]
  if lastContent ~= nil then
    lastContent:SetActive(false)
  end
  self.tabIdx = index
  self:RefreshRank()
  local content = self.contents[self.tabIdx]
  if content ~= nil then
    content:SetActive(true)
    content:RefreshView()
    return
  end
  local name = T_INFOS[index]
  local cls = string.format(CLS_PATH, name)
  local prefab = string.format(PREFAB_PATH, name)
  content = self:LoadComponentAsync(cls, prefab, self.compContent, function(_, go)
    go.name = "Type_" .. index
    content = self.contents[index]
    content:SetActive(self.tabIdx == index)
  end)
  content:SetInfo(self, self.tabIdx)
  self:SetEmpty(true)
  self.contents[index] = content
  ActMgr:TryReqDetailList(self.tabIdx)
end

function UILLBattleDetailView:SetEmpty(bEmpty, isLocked)
  self.textEmpty:SetActive(bEmpty)
  if bEmpty then
    local emptyKey = isLocked and "zonewar_landlord_tips_1008" or "zonewar_landlord_desc_1026"
    self.textEmpty:SetLocalText(emptyKey)
  end
end

function UILLBattleDetailView:SetRank(text, rank, bAl)
  local key = bAl and "zonewar_landlord_limit_1020" or "zonewar_landlord_limit_1019"
  text:SetLocalText(key, (rank == nil or rank <= 0) and Localization:GetString(361054) or rank)
end

function UILLBattleDetailView:RefreshRank()
  local dic = ActMgr:GetDetailList(self.tabIdx)
  if dic == nil or dic.alRank == nil or dic.selfRank == nil then
    return
  end
  self:SetRank(self.textAllianceRank, dic.alRank, true)
  self:SetRank(self.textPersonalRank, dic.selfRank)
end

function UILLBattleDetailView:Update1000MS()
  if self.tabIdx == nil then
    return
  end
  self:RefreshTime()
  ActMgr:TryReqDetailList(self.tabIdx)
end

function UILLBattleDetailView:RefreshTime()
  if self.eTime ~= nil then
    local tMgr = UITimeManager:GetInstance()
    local curSec = tMgr:GetServerSeconds()
    local remain = self.eTime - curSec
    if remain <= 0 then
      self.eTime = nil
      self.textTime:SetActive(false)
      return
    end
    self.textTime:SetActive(true)
    self.textTime:SetText(tMgr:SecondToFmtString(remain))
  else
    self.textTime:SetActive(false)
  end
end

return UILLBattleDetailView
