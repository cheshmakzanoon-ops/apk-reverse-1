local base = require("DataCenter.AllianceCityTip.AllianceCityTipBaseClass")
local ActivityCityStrongholdLogic = BaseClass("ActivityCityStrongholdLogic", base)
local StrongholdOccupy = require("DataCenter.AllianceCityTip.Season.ActivityCityStrongholdOccupy")
local TouchObjectEventTrigger = CS.TouchObjectEventTrigger
local BoxCollider = CS.UnityEngine.BoxCollider

function ActivityCityStrongholdLogic:__init(gameObject)
  base.__init(self, gameObject)
  self.occupyRoot = nil
  self.stronghold_occupy_player = nil
  self.stronghold_occupy_btn = self.transform:Find("StrongholdOccupyBtn"):GetComponent(typeof(TouchObjectEventTrigger))
  if IsNotNull(self.stronghold_occupy_btn) then
    self.stronghold_occupy_rect = self.transform:Find("StrongholdOccupyBtn"):GetComponent(typeof(BoxCollider))
    self.stronghold_occupy_btn.gameObject:SetActive(false)
    
    function self.stronghold_occupy_btn.onPointerClick()
      if self.stronghold_occupy_player ~= nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOccupyRankDetail, self.cityId)
      end
    end
    
    self.stronghold_occupy_btn.previewType = CS.WorldPreviewType.GUI
  end
  self:OnAddListener()
end

function ActivityCityStrongholdLogic:__delete()
  if self.occupyRoot then
    self.occupyRoot:Delete()
    self.occupyRoot = nil
  end
  if self.bankRobRoot then
    self.bankRobRoot:Delete()
    self.bankRobRoot = nil
  end
  if self.bankDepositRoot then
    self.bankDepositRoot:Delete()
    self.bankDepositRoot = nil
  end
  if self.fishingRoot then
    self.fishingRoot:Delete()
    self.fishingRoot = nil
  end
  if IsNotNull(self.stronghold_occupy_btn) then
    self.stronghold_occupy_btn.gameObject:SetActive(false)
    self.stronghold_occupy_btn.onPointerClick = nil
  end
  self.stronghold_occupy_player = nil
  self:OnRemoveListener()
  base.__delete(self)
end

function ActivityCityStrongholdLogic:OnAddListener()
  if not self.PushStrongholdBankPointInfo then
    function self.PushStrongholdBankPointInfo(data)
      self:OnStrongholdBankPointInfo(data)
    end
    
    EventManager:GetInstance():AddListener(EventId.PushStrongholdBankPointInfo, self.PushStrongholdBankPointInfo)
  end
  if not self.BankDepositChange then
    function self.BankDepositChange()
      self:OnPointDateUpdate()
    end
    
    EventManager:GetInstance():AddListener(EventId.BankDepositChange, self.BankDepositChange)
  end
end

function ActivityCityStrongholdLogic:OnRemoveListener()
  if self.PushStrongholdBankPointInfo then
    EventManager:GetInstance():RemoveListener(EventId.PushStrongholdBankPointInfo, self.PushStrongholdBankPointInfo)
    self.PushStrongholdBankPointInfo = nil
  end
  if self.BankDepositChange then
    EventManager:GetInstance():RemoveListener(EventId.BankDepositChange, self.BankDepositChange)
    self.BankDepositChange = nil
  end
end

function ActivityCityStrongholdLogic:OnPointDateUpdate()
  if self.cityType == 4 then
    base.UpdateCityInfo(self)
    self:DoRefresh()
  end
end

function ActivityCityStrongholdLogic:OnKingOccupyProgressRefresh()
end

function ActivityCityStrongholdLogic:OnStrongholdBankPointInfo(data)
  if self.cityType == 4 then
    base.UpdateCityInfo(self)
    if data and self.theExtraInfo then
      self.theExtraInfo.bankRobInfo = data
    end
    self:DoRefresh()
  end
end

function ActivityCityStrongholdLogic:OnWorldAllianceCityDetail()
  if self.cityType == 4 then
    base.UpdateCityInfo(self)
    self:DoRefresh()
  end
end

function ActivityCityStrongholdLogic:SetLod(lod)
  base.SetLod(self, lod)
  if self.cityType == 4 then
    if IsNotNull(self.stronghold_occupy_btn) then
      self.stronghold_occupy_btn.gameObject:SetActive(self.lodCache < 3 and self.stronghold_occupy_player ~= nil)
    end
    if self.occupyRoot then
      self.occupyRoot:SetLod(lod)
    end
    if self.bankRobRoot then
      self.bankRobRoot:SetLod(lod)
    end
    if self.bankDepositRoot then
      self.bankDepositRoot:SetLod(lod)
    end
    if self.fishingRoot then
      self.fishingRoot:SetLod(lod)
    end
  end
end

function ActivityCityStrongholdLogic:CheckLod(lod)
  base.CheckLod(self, lod)
  if self.cityType == 4 then
    if IsNotNull(self.stronghold_occupy_btn) then
      self.stronghold_occupy_btn.gameObject:SetActive(self.lodCache < 3 and self.stronghold_occupy_player ~= nil)
    end
    if self.occupyRoot then
      self.occupyRoot:SetLod(lod)
    end
    if self.bankRobRoot then
      self.bankRobRoot:SetLod(lod)
    end
    if self.bankDepositRoot then
      self.bankDepositRoot:SetLod(lod)
    end
    if self.fishingRoot then
      self.fishingRoot:SetLod(lod)
    end
  end
end

function ActivityCityStrongholdLogic:ReInit(data)
  base.ReInit(self, data)
  self.stronghold_occupy_player = nil
end

function ActivityCityStrongholdLogic:OnPointOutView()
  base.OnPointOutView(self)
end

function ActivityCityStrongholdLogic:OnBattleFinish()
  self.stronghold_occupy_player = nil
  if IsNotNull(self.stronghold_occupy_btn) then
    self.stronghold_occupy_btn.gameObject:SetActive(false)
  end
  if self.occupyRoot then
    self.occupyRoot:Delete()
    self.occupyRoot = nil
  end
end

function ActivityCityStrongholdLogic:DoRefresh()
  if self.cityType ~= WorldAllianceCityType.Stronghold then
    return
  end
  self:RefreshBattleState()
  if SeasonUtil.GetCurWorldSeasonType() == SeasonMapType.NineNation then
    local subdivisionType = SeasonUtil.GetSeasonSubdivisionType()
    if subdivisionType == SeasonMapType.NineNationRainforest then
    elseif subdivisionType == SeasonMapType.NineNation then
      self:RefreshBankRobState()
      self:RefreshBankState()
    end
  end
end

function ActivityCityStrongholdLogic:RefreshBattleState()
  if self.theExtraInfo == nil or self.theExtraInfo.buildPointInfo == nil or toInt(self.theExtraInfo.battleStartTime) == 0 then
    self:OnBattleFinish()
    return
  end
  local attackInfo = self.theExtraInfo.buildPointInfo
  if attackInfo == nil or string.IsNullOrEmpty(attackInfo.allianceId) then
    self:OnBattleFinish()
    return
  end
  self.stronghold_occupy_player = attackInfo
  if self.occupyRoot == nil then
    self.occupyRoot = StrongholdOccupy.New(self.transform, self.serverId)
  end
  self.occupyRoot:ReInit(self.data, attackInfo, self.theExtraInfo)
  if IsNotNull(self.stronghold_occupy_btn) then
    self.stronghold_occupy_btn.gameObject:SetActive(self.lodCache < 3 and self.stronghold_occupy_player ~= nil)
  end
end

function ActivityCityStrongholdLogic:RefreshBankRobState()
  if not self:HasBankBattle() then
    self:OnBanRobFinish()
    return
  end
  local BankRobTip = require("DataCenter.SeasonManager.Bank.Tip.BankRobTip")
  if self.bankRobRoot == nil then
    self.bankRobRoot = BankRobTip.New(self.transform, LuaEntry.Player:GetCurServerId())
  end
  self.bankRobRoot:ReInit(self.data, self.theExtraInfo and self.theExtraInfo.bankRobInfo, self.theExtraInfo)
end

function ActivityCityStrongholdLogic:OnBanRobFinish()
  if self.bankRobRoot then
    self.bankRobRoot:Delete()
    self.bankRobRoot = nil
  end
end

function ActivityCityStrongholdLogic:HasBankBattle()
  local bankRobInfo = self.theExtraInfo and self.theExtraInfo.bankRobInfo
  if not bankRobInfo or bankRobInfo.robStage ~= 1 or bankRobInfo.robEndTime < UITimeManager:GetInstance():GetServerTime() then
    return false
  end
  return true
end

function ActivityCityStrongholdLogic:RefreshBankState()
  local hasDeposit = DataCenter.SeasonBankManager.selfDepositData and DataCenter.SeasonBankManager.selfDepositData[self.cityId] ~= nil
  if not hasDeposit then
    if self.bankDepositRoot then
      self.bankDepositRoot:Delete()
      self.bankDepositRoot = nil
    end
    return
  end
  local BankDepositTip = require("DataCenter.SeasonManager.Bank.Tip.BankStateTip")
  if self.bankDepositRoot == nil then
    self.bankDepositRoot = BankDepositTip.New(self.transform)
  end
  self.bankDepositRoot:ReInit(self.cityId, self:HasBankBattle())
end

function ActivityCityStrongholdLogic:CheckCanFishing()
  local canFish = DataCenter.WorldAllianceCityDataManager:IsMyCamp(self.serverId, self.cityId)
  if not canFish then
    if self.fishingRoot then
      self.fishingRoot:Delete()
      self.fishingRoot = nil
    end
    return
  end
  local FishingTip = require("DataCenter.LWFishing.FishingStateTip")
  if self.fishingRoot == nil then
    self.fishingRoot = FishingTip.New(self.transform)
  end
  self.fishingRoot:Init(self.cityId, self.serverId)
end

return ActivityCityStrongholdLogic
