local base = UIAsyncContainer
local BankPoint = BaseClass("BankPoint", base)
local Localization = CS.GameEntry.Localization
local PlayerHeadContainer = require("UI.PlayerHeadContainer.PlayerHeadContainer")
local btnInfo_path = "BtnInfo"
local slider_path = "SliderGroup/Slider"
local sliderIcon_path = "SliderGroup/Slider/sliderIcon"
local sliderBtn_path = "SliderGroup/Slider/sliderIcon"
local sliderText_path = "SliderGroup/Slider/progressText"
local rootDefault_path = "rootDefault"
local rootBattle_path = "rootBattle"
local rootWork_path = "rootWork"
local btnDefault_path = "rootDefault/iconDefault"
local btnBattle_path = "rootBattle/iconBattle"
local leftTime_path = "rootBattle/leftTime"
local playerHeadContainer_path = "rootWork/PlayerHeadContainer"
local save_path = "rootWork/saveLayout/save"
local workName_path = "rootWork/owner/workName"
local emptyText_path = "rootWork/emptyText"
local btnSetting_path = "rootWork/owner/btnSetting"
local btnHistory_path = "SliderGroup/btnHistory"
local group_path = "SliderGroup"
local fx_path = "fx"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnInfo = self:AddComponent(UIButton, btnInfo_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.sliderIcon = self:AddComponent(UIImage, sliderIcon_path)
  self.sliderBtn = self:AddComponent(UIButton, sliderBtn_path)
  self.sliderText = self:AddComponent(UIText, sliderText_path)
  self.rootDefault = self:AddComponent(UIBaseContainer, rootDefault_path)
  self.rootBattle = self:AddComponent(UIBaseContainer, rootBattle_path)
  self.rootWork = self:AddComponent(UIBaseContainer, rootWork_path)
  self.btnDefault = self:AddComponent(UIButton, btnDefault_path)
  self.btnBattle = self:AddComponent(UIButton, btnBattle_path)
  self.leftTime = self:AddComponent(UIText, leftTime_path)
  self.playerHeadContainer = self:AddComponent(UIBaseContainer, playerHeadContainer_path)
  self.save = self:AddComponent(UIText, save_path)
  self.workName = self:AddComponent(UIText, workName_path)
  self.emptyText = self:AddComponent(UIText, emptyText_path)
  self.btnSetting = self:AddComponent(UIButton, btnSetting_path)
  self.btnHistory = self:AddComponent(UIButton, btnHistory_path)
  self.group = self:AddComponent(UIBaseContainer, group_path)
  self.fx = self:AddComponent(UIBaseContainer, fx_path)
  self.btnInfo:SetOnClick(function()
    if self.data then
      UIManager:GetInstance():OpenWindow(UIWindowNames.BankHelp, {anim = true}, self.data)
    end
  end)
  self.btnSetting:SetOnClick(function()
    if self.data then
      UIManager:GetInstance():OpenWindow(UIWindowNames.BankSetting, {anim = true}, self.data.cityId, self.data.serverId)
    end
  end)
  self.btnHistory:SetOnClick(function()
    if self.data then
      UIManager:GetInstance():OpenWindow(UIWindowNames.BankCityHistory, {anim = true}, self.data, self.detail and self.detail.bankDetail)
    end
  end)
  self.btnDefault:SetOnClick(function()
    UIUtil.ShowBubbleTips(Localization:GetString("s5_bank_tips01"), self.btnDefault.transform.position, 0, -30, 0)
  end)
  self.btnBattle:SetOnClick(function()
    UIUtil.ShowBubbleTips(Localization:GetString("s5_bank_tips02"), self.btnBattle.transform.position, 0, -30, 0)
  end)
  self.sliderBtn:SetOnClick(function()
    DataCenter.SeasonBankManager:ShowItemTips(self.sliderIcon, self.data and self.data.meta)
  end)
  self.playerHeadContainer = self:AddComponent(PlayerHeadContainer, playerHeadContainer_path)
  self.bidirectionalLayout = self.group.gameObject:GetComponent(typeof(CS.BidirectionalHorizontalLayoutGroup))
end

local function ComponentDestroy(self)
  self.btnInfo = nil
  self.slider = nil
  self.sliderIcon = nil
  self.sliderBtn = nil
  self.sliderText = nil
  self.rootDefault = nil
  self.rootBattle = nil
  self.rootWork = nil
  self.btnDefault = nil
  self.btnBattle = nil
  self.leftTime = nil
  self.playerHeadContainer = nil
  self.save = nil
  self.workName = nil
  self.emptyText = nil
  self.btnSetting = nil
  self.btnHistory = nil
  self.group = nil
  self.fx = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function BankPoint:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorldAllianceCityDetail, self.UpdateData)
  self:AddUIListener(EventId.PushStrongholdBankPointInfo, self.PushStrongholdBankPointInfo)
end

function BankPoint:OnRemoveListener()
  self:RemoveUIListener(EventId.WorldAllianceCityDetail, self.UpdateData)
  self:RemoveUIListener(EventId.PushStrongholdBankPointInfo, self.PushStrongholdBankPointInfo)
  base.OnRemoveListener(self)
end

function BankPoint:ReInit(data)
  self.data = data
  self.info = nil
  self.detail = nil
  self.robInfo = nil
  if not self.data then
    return
  end
  self.pointInfo = CS.SceneManager.World:GetPointInfo(self.data.pointId)
  if not self.pointInfo then
    return
  end
  self:UpdateData()
end

function BankPoint:Update1000MS()
  if IsNull(self.gameObject) then
    return
  end
  if self.EndTime then
    UIUtil.SetLeftTimeText(self.leftTime, nil, self.EndTime, "alliance_war_notice_UI_14")
  end
end

function BankPoint:UpdateData()
  if not self.data or IsNull(self.gameObject) or not self.data.meta then
    return
  end
  self.EndTime = nil
  self.info = SeasonUtil.TryParseAllianceCityPointInfo(self.pointInfo.PointType, self.pointInfo.extraInfo)
  if not self.info then
    return
  end
  self.detail = DataCenter.WorldPointDetailManager:GetAllianceCityData(self.data.cityId)
  local robInfo = self.robInfo or self.detail and self.detail.bankDetail or self.info.bankRobInfo
  local lastState = self.state
  if DataCenter.SeasonBankManager:CanRob(robInfo) then
    self:RefreshBattle(robInfo)
    self:Update1000MS()
  elseif self.data.ownerServerId and self.data.ownerServerId > 0 then
    self:RefreshWork()
  elseif not self:RefreshDefault() then
    if robInfo and robInfo.depositCount then
      self:RefreshWork()
    else
      self:SetActive(false)
      if lastState ~= nil and lastState ~= self.state then
        EventManager:GetInstance():Broadcast(EventId.WorldSiegePointBtnRefresh)
      end
      return
    end
  end
  DataCenter.SeasonBankManager:LoadItemIcon(self.sliderIcon, self.data.meta)
  self:SetActive(true)
  if lastState ~= nil and lastState ~= self.state then
    EventManager:GetInstance():Broadcast(EventId.WorldSiegePointBtnRefresh)
  end
end

function BankPoint:PushStrongholdBankPointInfo(data)
  if not self.data or data.strongholdId ~= self.data.cityId then
    return
  end
  self.robInfo = data
  self:UpdateData()
end

function BankPoint:RefreshDefault()
  local bankDetail = self.detail and self.detail.bankDetail
  if bankDetail and not bankDetail.isFirst then
    return false
  end
  self.state = 0
  self.rootDefault:SetActive(true)
  self.rootBattle:SetActive(false)
  self.rootWork:SetActive(false)
  self.btnHistory:SetActive(false)
  self:SetSizeDeltaY(230)
  self:RefreshProgress(self.data.meta and self.data.meta.default_asset or 0)
  self.bidirectionalLayout.padding.top = 0
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.holder.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.holder.transform.parent.transform)
  self:ShowFx(true)
  return true
end

function BankPoint:RefreshBattle(robInfo)
  self.state = 1
  self.EndTime = robInfo.robEndTime or 0
  self.rootDefault:SetActive(false)
  self.rootBattle:SetActive(true)
  self.rootWork:SetActive(false)
  self.btnHistory:SetActive(false)
  self:SetSizeDeltaY(250)
  self:RefreshProgress(robInfo.totalAmount, robInfo.totalAmount - robInfo.robAmount)
  self.bidirectionalLayout.padding.top = 0
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.holder.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.holder.transform.parent.transform)
  self:ShowFx(true)
end

function BankPoint:RefreshWork()
  self.state = 2
  local bankDetail = self.detail and self.detail.bankDetail
  local meta = self.data.meta or {}
  self.rootDefault:SetActive(false)
  self.rootBattle:SetActive(false)
  self.rootWork:SetActive(true)
  self.btnHistory:SetActive(true)
  self:SetSizeDeltaY(300)
  self:RefreshProgress(self.data.meta.max_asset, bankDetail and bankDetail.totalAmount or 0, true)
  if not self.data.ownerServerId or 0 >= self.data.ownerServerId then
    self.workName:SetLocalText("season5_bank_tips001")
  else
    self.workName:SetText(Localization:GetString("s5_bank_tips04", string.format("#%s[%s]%s", self.data.ownerServerId or self.data.serverId or "", self.data.alAbbr or "", self.data.alName or "")))
  end
  self.bidirectionalLayout.padding.top = 140
  self.btnSetting:SetActive(self.data.allianceId == LuaEntry.Player.allianceId)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.holder.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.holder.transform.parent.transform)
  self:ShowFx(false)
  if not bankDetail or 0 >= bankDetail.depositCount then
    self.emptyText:SetActive(true)
    self.playerHeadContainer:SetActive(false)
    self.save:SetLocalText(135225, 0, meta.max_player or 0)
    return
  end
  self.emptyText:SetActive(false)
  self.save:SetLocalText(135225, bankDetail.depositCount or 0, meta.max_player or 0)
  self.playerHeadContainer:Refresh(bankDetail.depositUsers, 1, 20)
  self.playerHeadContainer:SetActive(true)
end

function BankPoint:RefreshProgress(max, cur_, showMax)
  if not max or max <= 0 then
    self.slider:SetActive(false)
    return
  end
  cur_ = cur_ or max
  self.slider:SetValue(cur_ / max)
  if showMax then
    self.sliderText:SetLocalText("135225", string.GetFormattedSeperatorNum(cur_), string.GetFormattedSeperatorNum(max))
  else
    self.sliderText:SetText(string.GetFormattedSeperatorNum(cur_))
  end
  self.slider:SetActive(true)
end

function BankPoint:ShowFx(show)
  if IsNull(self.fx.gameObject) then
    return
  end
  if not show then
    if self.fxComp then
      self.fxComp:Stop()
    end
    return
  end
  if not self.fxComp then
    self.fxComp = self:AddComponent(UIVfx, fx_path, VfxAssets.DigTreasureReward, {
      lifeType = UIVfxLifeType.Stay
    })
  end
  if self.fxComp then
    self.fxComp:Replay()
  end
end

BankPoint.OnCreate = OnCreate
BankPoint.OnDestroy = OnDestroy
BankPoint.OnEnable = OnEnable
BankPoint.OnDisable = OnDisable
BankPoint.ComponentDefine = ComponentDefine
BankPoint.ComponentDestroy = ComponentDestroy
BankPoint.DataDefine = DataDefine
BankPoint.DataDestroy = DataDestroy
return BankPoint
