local base = UIBaseView
local StorageShopList = BaseClass("StorageShopList", base)
local Localization = CS.GameEntry.Localization
local StorageShopItem = require("UI.UIStorageShopList.Component.StorageShopItem")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UIGray = CS.UIGray
local shopsSv_path = "ScrollView"
local shopsContent_path = "ScrollView/Viewport/Content"
local refreshCD_path = "refreshCd"
local refresh_path = "refresh"
local refreshBtn_path = "refresh/refreshBtn"
local refreshTxt_path = "refresh/refreshTxt"
local emptyTip_path = "emptyTxt"
local extraRewardTip_path = "extraRewardTip"
local infoBtn_path = "extraRewardTip/infoBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DelRefreshCdTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.shopSvN = self:AddComponent(UIScrollView, shopsSv_path)
  self.shopSvN:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.shopSvN:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.shopContentN = self:AddComponent(UIBaseContainer, shopsContent_path)
  self.refreshCdN = self:AddComponent(UIText, refreshCD_path)
  self.refreshN = self:AddComponent(UIBaseContainer, refresh_path)
  self.refreshTimesN = self:AddComponent(UIText, refreshTxt_path)
  self.refreshBtnN = self:AddComponent(UIButton, refreshBtn_path)
  self.refreshBtnN:SetOnClick(function()
    self:OnClickRefreshWorldList()
  end)
  self.emptyTipN = self:AddComponent(UIText, emptyTip_path)
  self.emptyTipN:SetLocalText(372135)
  self.extraRewardTipN = self:AddComponent(UIText, extraRewardTip_path)
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
end

local function ComponentDestroy(self)
  self.shopSvN = nil
  self.shopContentN = nil
  self.refreshCdN = nil
  self.refreshBtnN = nil
  self.emptyTipN = nil
end

local function DataDefine(self)
  self.curShowType = nil
  self.refreshCdTimer = nil
  self.refreshCdEndT = 0
end

local function DataDestroy(self)
  self.curShowType = nil
  self.refreshCdTimer = nil
  self.refreshCdEndT = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.StorageShopGetShopList, self.RefreshAll)
  self:AddUIListener(EventId.UpdateTraderExtraRewardTimes, self.RefreshExtraTimes)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.StorageShopGetShopList, self.RefreshAll)
  self:RemoveUIListener(EventId.UpdateTraderExtraRewardTimes, self.RefreshExtraTimes)
  base.OnRemoveListener(self)
end

local function ShowPanel(self, showType)
  self.curShowType = showType
  self:RefreshAll(true)
end

local function RefreshAll(self, needUpdate)
  if self.curShowType == StorageShopListType.World then
    self.curShopsList = DataCenter.StorageShopManager:GetWorldShopList() or {}
    self:ResetWorldRefreshTime()
  elseif self.curShowType == StorageShopListType.Alliance then
    self.curShopsList = DataCenter.StorageShopManager:GetAlShopList(needUpdate) or {}
    self:DelRefreshCdTimer()
    self.refreshN:SetActive(false)
    self.refreshCdN:SetActive(false)
  end
  self:ShowShopsList(self.curShopsList)
end

local function ResetWorldRefreshTime(self)
  if self.curShowType == StorageShopListType.World then
    local remainTimes, nextRecoverTime = DataCenter.StorageShopManager:GetRemainRefreshTimes()
    if 0 < remainTimes then
      self.refreshCdN:SetActive(false)
      self.refreshN:SetActive(true)
      local maxTimes = LuaEntry.DataConfig:TryGetStr("tradingbank_para", "k18")
      self.refreshTimesN:SetLocalText(372234, remainTimes .. "/" .. maxTimes)
    else
      self.refreshN:SetActive(false)
      self.refreshCdN:SetActive(true)
    end
    self.refreshCdEndT = nextRecoverTime
    self:AddRefreshCdTimer()
    self:SetRefreshCd()
  end
end

local function ShowShopsList(self)
  if #self.curShopsList == 0 then
    self.shopSvN:SetActive(false)
    self.emptyTipN:SetActive(true)
  else
    self.emptyTipN:SetActive(false)
    self.shopSvN:SetActive(true)
    self.shopSvN:SetTotalCount(#self.curShopsList)
    self.shopSvN:RefillCells()
  end
  self:RefreshExtraTimes()
end

local function RefreshExtraTimes(self)
  local extraTimes = DataCenter.PlayerCareerManager:GetRemainTraderExtraRewardTimes()
  if extraTimes then
    self.extraRewardTipN:SetActive(true)
    self.extraRewardTipN:SetText(Localization:GetString("395398", extraTimes))
  else
    self.extraRewardTipN:SetActive(false)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.shopContentN:AddComponent(StorageShopItem, itemObj)
  cellItem:SetItem(self.curShopsList[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.shopContentN:RemoveComponent(itemObj.name, StorageShopItem)
end

local function AddRefreshCdTimer(self)
  function self.RefreshCdTimerAction()
    self:SetRefreshCd()
  end
  
  if self.refreshCdTimer == nil then
    self.refreshCdTimer = TimerManager:GetInstance():GetTimer(1, self.RefreshCdTimerAction, self, false, false, false)
  end
  self.refreshCdTimer:Start()
end

local function SetRefreshCd(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.refreshCdEndT - curTime
  if 0 <= remainTime then
    self.refreshCdN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self:ResetWorldRefreshTime()
  end
end

local function DelRefreshCdTimer(self)
  if self.refreshCdTimer ~= nil then
    self.refreshCdTimer:Stop()
    self.refreshCdTimer = nil
  end
end

local function OnClickRefreshWorldList(self)
  local remainTimes = DataCenter.StorageShopManager:GetRemainRefreshTimes()
  if 0 < remainTimes then
    SFSNetwork.SendMessage(MsgDefines.StorageShopGetShopList, StorageShopListType.World)
  end
end

local function OnClickInfoBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.infoBtnN.transform.position + Vector3.New(0, 20, 0) * scaleFactor
  local careerTemplate = DataCenter.PlayerCareerManager:GetCareerTemplate(CareerType.Merchant, 2)
  local id = careerTemplate.levelEffect
  local name, desc = DataCenter.PlayerCareerManager:GetEffectTip(id)
  local param = UIHeroTipView.Param.New()
  param.content = name .. " (" .. Localization:GetString("395102") .. ")" .. [[


]] .. desc
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 280
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

StorageShopList.OnCreate = OnCreate
StorageShopList.OnDestroy = OnDestroy
StorageShopList.OnAddListener = OnAddListener
StorageShopList.OnRemoveListener = OnRemoveListener
StorageShopList.ComponentDefine = ComponentDefine
StorageShopList.ComponentDestroy = ComponentDestroy
StorageShopList.DataDefine = DataDefine
StorageShopList.DataDestroy = DataDestroy
StorageShopList.RefreshAll = RefreshAll
StorageShopList.ShowPanel = ShowPanel
StorageShopList.ShowShopsList = ShowShopsList
StorageShopList.OnItemMoveIn = OnItemMoveIn
StorageShopList.OnItemMoveOut = OnItemMoveOut
StorageShopList.TryShowRefreshCd = TryShowRefreshCd
StorageShopList.AddRefreshCdTimer = AddRefreshCdTimer
StorageShopList.SetRefreshCd = SetRefreshCd
StorageShopList.DelRefreshCdTimer = DelRefreshCdTimer
StorageShopList.OnEventShopEmpty = OnEventShopEmpty
StorageShopList.OnClickRefreshWorldList = OnClickRefreshWorldList
StorageShopList.RefreshExtraTimes = RefreshExtraTimes
StorageShopList.OnClickInfoBtn = OnClickInfoBtn
StorageShopList.ResetWorldRefreshTime = ResetWorldRefreshTime
return StorageShopList
