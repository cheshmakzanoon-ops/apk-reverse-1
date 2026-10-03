local UILWSeasonCityEffectTipsView = BaseClass("UILWSeasonCityEffectTipsView", UIBaseView)
local base = UIBaseView
local UILWSeasonCityEffectTipsItem = require("UI.LWSeasonShared.UILWSeasonCityEffectTips.Component.UILWSeasonCityEffectTipsItem")
local __cache_data
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local title_text_path = "PopUpTitle/ScrollView/Viewport/Content/TitleText"
local tab_path = "PopUpTitle/ScrollView/Viewport/Content/Tab"
local content_buff_path = "PopUpTitle/ScrollView/Viewport/Content/ContentBuff"
local eff_line_path = "PopUpTitle/ScrollView/Viewport/Content/ContentBuff/EffLine"
local empty_text_path = "PopUpTitle/ScrollView/Viewport/Content/ContentBuff/EmptyText"
local loading_path = "PopUpTitle/loading"
local toggle1_path = "PopUpTitle/ScrollView/Viewport/Content/Tab/toggle1"
local toggle2_path = "PopUpTitle/ScrollView/Viewport/Content/Tab/toggle2"

function UILWSeasonCityEffectTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  if SeasonUtil.IsInSeason(true) then
    self.title_text:SetLocalText("456509")
  else
    self.title_text:SetLocalText("season5_city_bonus_info01")
  end
  self.empty_text:SetLocalText("456514")
  SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceCityEffect)
  SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceCityStrongholdEffect)
  DataCenter.WorldAllianceCityDataManager:TrySendGetAltarEffect()
  SFSNetwork.SendMessage(MsgDefines.FetchCityEffectDetail)
  self.toggle1:SetIsOn(true)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControl(1)
    end
  end)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControl(2)
    end
  end)
  if self.activeTab == nil then
    self:ToggleControl(1)
  end
end

function UILWSeasonCityEffectTipsView:OnDestroy()
  self.activeTab = nil
  self.content_buff:RemoveComponents(UILWSeasonCityEffectTipsItem)
  self.theItemPool:GameObjectRecycleAll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityEffectTipsView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MyAlCityListChanged, self.UpdateData)
  self:AddUIListener(EventId.CityEffectDetailUpdate, self.OnCityEffectDetailUpdate)
end

function UILWSeasonCityEffectTipsView:OnRemoveListener()
  self:RemoveUIListener(EventId.MyAlCityListChanged, self.UpdateData)
  self:RemoveUIListener(EventId.CityEffectDetailUpdate, self.OnCityEffectDetailUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonCityEffectTipsView:ComponentDefine()
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.loading = self:AddComponent(UIImage, loading_path)
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.tab = self:AddComponent(UIImage, tab_path)
  self.content_buff = self:AddComponent(UIBaseContainer, content_buff_path)
  self.empty_text = self:AddComponent(UITextMeshProUGUIEx, empty_text_path)
  self.theItemPool = self.transform:Find(eff_line_path).gameObject
  self.theItemPool:GameObjectCreatePool()
end

function UILWSeasonCityEffectTipsView:ComponentDestroy()
  self.loading = nil
  self.close_btn = nil
  self.content = nil
  self.title_text = nil
  self.tab = nil
  self.content_buff = nil
  self.eff_line = nil
  self.empty_text = nil
  self.toggle1 = nil
  self.toggle2 = nil
end

function UILWSeasonCityEffectTipsView:ToggleControl(activeTab)
  self.activeTab = activeTab
  self:OnCityEffectDetailUpdate(__cache_data)
end

function UILWSeasonCityEffectTipsView:OnCityEffectDetailUpdate(data)
  if __cache_data ~= data then
    __cache_data = data
  end
  if data ~= nil and self.fullData ~= data then
    self.fullData = data
  end
  self:UpdateData()
end

function UILWSeasonCityEffectTipsView:UpdateData()
  if self.activeTab == nil then
    return
  end
  self.content_buff:RemoveComponents(UILWSeasonCityEffectTipsItem)
  self.theItemPool:GameObjectRecycleAll()
  local goItem, theItem
  local effectCount = 0
  if self.fullData then
    local effectDict
    if self.activeTab == 1 then
      effectDict = self.fullData.srcServer
    else
      effectDict = self.fullData.otherServer
    end
    if effectDict then
      for effectId, effectValue in pairs(effectDict) do
        local buffAddNum, effectName = UIUtil.GetEffectStr(nil, effectValue, effectId)
        if buffAddNum and effectName then
          effectCount = effectCount + 1
          goItem = self.theItemPool:GameObjectSpawn(self.content_buff.transform)
          goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
          goItem:SetActive(true)
          theItem = self.content_buff:AddComponent(UILWSeasonCityEffectTipsItem, goItem.name)
          theItem:ReInit(effectCount, buffAddNum, effectName)
        end
      end
    end
    self.tab:SetActive(true)
  else
    local effects = DataCenter.WorldAllianceCityDataManager:GetAllianceCityEffects()
    if effects then
      for effectId, effectValue in pairs(effects) do
        local buffAddNum, effectName = UIUtil.GetEffectStr(nil, effectValue, effectId)
        if buffAddNum and effectName then
          effectCount = effectCount + 1
          goItem = self.theItemPool:GameObjectSpawn(self.content_buff.transform)
          goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
          goItem:SetActive(true)
          theItem = self.content_buff:AddComponent(UILWSeasonCityEffectTipsItem, goItem.name)
          theItem:ReInit(effectCount, buffAddNum, effectName)
        end
      end
    end
    self.tab:SetActive(false)
  end
  self.loading:SetActive(false)
  self.empty_text:SetActive(effectCount == 0)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.title_text.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_buff.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

return UILWSeasonCityEffectTipsView
