local UILWSeasonPutOutpostS6View = BaseClass("UILWSeasonPutOutpostS6View", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local PutOutpostS6Item = require("UI.LWSeason6.UILWSeasonPutOutpostS6.Component.UILWSeasonPutOutpostS6Item")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local tip_count_path = "PopUpTitle/tipCount"

function UILWSeasonPutOutpostS6View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ClearSelect()
  self.theIndex = self:GetUserData()
  self.dialog_title_text:SetLocalText("s6_outpost_limit_1", self.theIndex, 4)
  self.tip_count:SetLocalText("s6_outpost_limit_5", 5 - self.theIndex, 4)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local serverList = DataCenter.SeasonFactionWarDataManager:GetMyGroupingServer()
  if serverList then
    local activeIndex = 1
    local UnityTextMeshProEx = typeof(CS.TextMeshProUGUIEx)
    for index, serverId in ipairs(serverList) do
      if index < 5 then
        local name = self.transform:Find(string.format("PopUpTitle/TabLayout/Tab%d/name%d", index, index))
        if name then
          local unity_txt = name.gameObject:GetComponent(UnityTextMeshProEx)
          if unity_txt then
            unity_txt:Native_SetText("#" .. serverId)
          end
        end
        name = self.transform:Find(string.format("PopUpTitle/TabLayoutTop/Tab%d/name%d", index, index))
        if name then
          local unity_txt = name.gameObject:GetComponent(UnityTextMeshProEx)
          if unity_txt then
            unity_txt:Native_SetText("#" .. serverId)
          end
        end
        if serverId == mySourceServerId then
          activeIndex = index
        end
      end
    end
    self.select_server = mySourceServerId
    self.serverList = serverList
    self["tab" .. activeIndex]:SetIsOn(true)
    self.tab1:SetOnValueChanged(function(tf)
      if tf then
        self:OnServerChanged(1)
      end
    end)
    self.tab2:SetOnValueChanged(function(tf)
      if tf then
        self:OnServerChanged(2)
      end
    end)
    self.tab3:SetOnValueChanged(function(tf)
      if tf then
        self:OnServerChanged(3)
      end
    end)
    self.tab4:SetOnValueChanged(function(tf)
      if tf then
        self:OnServerChanged(4)
      end
    end)
    self:OnServerChanged(activeIndex)
  end
  self.area1:SetOnValueChanged(function(tf)
    self:OnSelectChanged()
  end)
  self.area3:SetOnValueChanged(function(tf)
    self:OnSelectChanged()
  end)
  self.area5:SetOnValueChanged(function(tf)
    self:OnSelectChanged()
  end)
  self.area7:SetOnValueChanged(function(tf)
    self:OnSelectChanged()
  end)
  self.area9:SetOnValueChanged(function(tf)
    self:OnSelectChanged()
  end)
  self.btn_put:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnConfirmBtnClick()
  end)
end

function UILWSeasonPutOutpostS6View:ClearSelect()
  self.select_index = nil
  self.area1:SetIsOn(false)
  self.area3:SetIsOn(false)
  self.area5:SetIsOn(false)
  self.area7:SetIsOn(false)
  self.area9:SetIsOn(false)
  self.area5:SetInteractable(false)
  CS.UIGray.SetGray(self.btn_put.transform, true, true)
end

function UILWSeasonPutOutpostS6View:OnServerChanged(index)
  if self.serverList and self.serverList[index] ~= nil then
    self:ClearSelect()
    self.select_server = self.serverList[index]
    local serverId = self.select_server
    local mapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(serverId)
    local cityList = SeasonUtil.GetOutpostList(SeasonMapType.NineNationRainforest, mapIndex)
    local kingCityId = SeasonUtil.GetKingCityId(serverId)
    local nodeList = {
      self.area1,
      self.area3,
      self.area7,
      self.area9
    }
    self.area5:ReInit(serverId, kingCityId, true)
    for _index, _cityId in ipairs(cityList) do
      local node = nodeList[_index]
      if node then
        node:ReInit(serverId, _cityId, false)
      end
    end
  end
end

function UILWSeasonPutOutpostS6View:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonPutOutpostS6View:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OutpostListUpdate, self.OnOutpostListUpdate)
end

function UILWSeasonPutOutpostS6View:OnRemoveListener()
  self:RemoveUIListener(EventId.OutpostListUpdate, self.OnOutpostListUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonPutOutpostS6View:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("s6_outpost_title_7")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_put = self:AddComponent(UIButton, "PopUpTitle/BtnPut")
  self.area5 = self:AddComponent(PutOutpostS6Item, "PopUpTitle/MapRoot/Area5")
  self.area1 = self:AddComponent(PutOutpostS6Item, "PopUpTitle/MapRoot/Area1")
  self.area3 = self:AddComponent(PutOutpostS6Item, "PopUpTitle/MapRoot/Area3")
  self.area7 = self:AddComponent(PutOutpostS6Item, "PopUpTitle/MapRoot/Area7")
  self.area9 = self:AddComponent(PutOutpostS6Item, "PopUpTitle/MapRoot/Area9")
  self.tip_count = self:AddComponent(UITextMeshProUGUIEx, tip_count_path)
  self.tab1 = self:AddComponent(UIToggle, "PopUpTitle/TabLayout/Tab1")
  self.tab2 = self:AddComponent(UIToggle, "PopUpTitle/TabLayout/Tab2")
  self.tab3 = self:AddComponent(UIToggle, "PopUpTitle/TabLayout/Tab3")
  self.tab4 = self:AddComponent(UIToggle, "PopUpTitle/TabLayout/Tab4")
end

function UILWSeasonPutOutpostS6View:ComponentDestroy()
  self.btn_put = nil
  self.btn_back = nil
  self.tip_count = nil
  self.area5 = nil
  self.area1 = nil
  self.area3 = nil
  self.area7 = nil
  self.area9 = nil
  self.tab1 = nil
  self.tab2 = nil
  self.tab3 = nil
  self.tab4 = nil
end

function UILWSeasonPutOutpostS6View:OnOutpostListUpdate()
  if self.theIndex and self.waitPutResult then
    local data = DataCenter.SeasonOutpostManager:GetOutpostPos(self.theIndex)
    if data ~= nil and data.cityId == self.waitPutResult and data.serverId and data.meta then
      UIUtil.ShowTipsId("120175")
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonPutOutpostS6)
    end
  end
end

function UILWSeasonPutOutpostS6View:OnConfirmBtnClick()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local isManager = LuaEntry.Player:IsPresident(mySourceServerId)
  if isManager and self.theIndex ~= nil then
    if self.select_index == nil or self.select_server == nil then
      UIUtil.ShowTipsId("s6_outpost_limit_4")
    else
      local mapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(self.select_server)
      local cityList = SeasonUtil.GetOutpostList(SeasonMapType.NineNationRainforest, mapIndex)
      local cityId = cityList[self.select_index]
      local cityIndex = self.theIndex
      local putByServerId = DataCenter.SeasonOutpostManager:GetPutInfoByCityId(cityId)
      if putByServerId ~= nil then
        UIUtil.ShowTipsId("s6_outpost_limit_4")
        return
      end
      local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId, self.select_server)
      if cityData ~= nil then
        UIUtil.ShowTipsId("s6_outpost_limit_4")
        return
      end
      UIUtil.ShowSecondMessageByParam({
        tipText = Localization:GetString("s6_outpost_limit_15", cityIndex, 4),
        btnNum = 2,
        showToggle = false,
        delayConfirm = {delayTime = 10},
        sureAction = function()
          SFSNetwork.SendMessage(MsgDefines.PutOutpostAtCity, cityId, cityIndex)
          self.waitPutResult = cityId
        end
      })
    end
  else
    UIUtil.ShowTipsId(393018)
  end
end

function UILWSeasonPutOutpostS6View:OnSelectChanged()
  if self.area1:GetIsOn() then
    self.select_index = 1
  elseif self.area3:GetIsOn() then
    self.select_index = 2
  elseif self.area7:GetIsOn() then
    self.select_index = 3
  elseif self.area9:GetIsOn() then
    self.select_index = 4
  else
    self.select_index = nil
  end
  local mapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(self.select_server)
  local cityList = SeasonUtil.GetOutpostList(SeasonMapType.NineNationRainforest, mapIndex)
  local cityId = cityList[self.select_index]
  local putByServerId = DataCenter.SeasonOutpostManager:GetPutInfoByCityId(cityId)
  if putByServerId == nil then
    CS.UIGray.SetGray(self.btn_put.transform, self.select_index == nil, true)
  else
    local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId, self.select_server)
    if cityData == nil or toInt(cityData.destroyServerId) > 0 then
    else
    end
    goto lbl_78
    ::lbl_78::
    CS.UIGray.SetGray(self.btn_put.transform, true, true)
  end
end

return UILWSeasonPutOutpostS6View
