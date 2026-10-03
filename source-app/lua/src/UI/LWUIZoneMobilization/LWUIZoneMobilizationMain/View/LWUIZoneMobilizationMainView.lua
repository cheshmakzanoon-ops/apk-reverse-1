local base = UIBaseView
local LWUIZoneMobilizationMainView = BaseClass("LWUIZoneMobilizationMainView", base)
local Localization = CS.GameEntry.Localization
local LWUIZoneMobilizationTabItemRender = require("UI.LWUIZoneMobilization.LWUIZoneMobilizationMain.Component.LWUIZoneMobilizationTabItemRender")
local LWUIZoneMobilizationDonatedSubView = require("UI.LWUIZoneMobilization.LWUIDonatedSubView.LWUIZoneMobilizationDonatedSubView")
local LWUIZoneMobilizationAttackSubView = require("UI.LWUIZoneMobilization.LWUIAttackSubView.LWUIZoneMobilizationAttackSubView")
local LWUIZoneMobilizationDefendSubView = require("UI.LWUIZoneMobilization.LWUIDefendSubView.LWUIZoneMobilizationDefendSubView")
local UIZoneMobilizationModelPanel = require("UI.LWUIZoneMobilization.LWUIZoneMobilizationMain.Component.UIZoneMobilizationModelPanel")
local TabTypeTableData = {}
TabTypeTableData[ZoneMobilizationTabType.Donated] = {
  assetPath = UIAssets.LWUIZoneMobilizationDonatedSubPanel,
  cls = LWUIZoneMobilizationDonatedSubView
}
TabTypeTableData[ZoneMobilizationTabType.Attack] = {
  assetPath = UIAssets.LWUIZoneMobilizationAttackSubPanel,
  cls = LWUIZoneMobilizationAttackSubView
}
TabTypeTableData[ZoneMobilizationTabType.Defend] = {
  assetPath = UIAssets.LWUIZoneMobilizationDefendSubPanel,
  cls = LWUIZoneMobilizationDefendSubView
}
local BgTableData = {}
BgTableData[ZoneMobilizationTabType.Donated] = {
  bgPathName = "ljq_zhanqudongyuan_bg_01"
}
BgTableData[ZoneMobilizationTabType.Attack] = {
  bgPathName = "ljq_zhanqudongyuan_bg_02"
}
BgTableData[ZoneMobilizationTabType.Defend] = {
  bgPathName = "ljq_zhanqudongyuan_bg_03"
}
local titleText_path = "Content/TopContent/TitleText"
local bgRawImage_path = "Content/BgMask/BgRawImage"
local tabScrollView_path = "Content/TabScrollView"
local subPanelContent_path = "Content/SubPanelContent"
local backBtn_path = "Content/BackBtn"
local ruleBtn_path = "Content/RuleBtn"
local u_i_zone_mobilization_model_panel_path = "Content/PlaceGroup/UIZoneMobilizationModelPanel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

local function OnDestroy(self)
  self:RemoveTabScroll()
  self:DestroyAllSubView()
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
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.bgRawImage = self:AddComponent(UIRawImage, bgRawImage_path)
  self.tabScrollView = self:AddComponent(UIScrollView, tabScrollView_path)
  self.subPanelContent = self:AddComponent(UIBaseContainer, subPanelContent_path)
  self.backBtn = self:AddComponent(UIButton, backBtn_path)
  self.ruleBtn = self:AddComponent(UIButton, ruleBtn_path)
  self.u_i_zone_mobilization_model_panel = self:AddComponent(UIZoneMobilizationModelPanel, u_i_zone_mobilization_model_panel_path)
  self.titleText:SetLocalText("activity_name_zone_mobilization")
  self.backBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ruleBtn:SetOnClick(function()
    self:RuleBtnClick()
  end)
  self.tabScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnTabItemMoveIn(itemObj, index)
  end)
  self.tabScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnTabItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.bgRawImage = nil
  self.tabScrollView = nil
  self.subPanelContent = nil
  self.backBtn = nil
  self.ruleBtn = nil
  self.u_i_zone_mobilization_model_panel = nil
end

local function DataDefine(self)
  self.isInit = false
  self.curTabType = ZoneMobilizationTabType.Donated
  self.tabViewDataList = {
    {
      tabType = ZoneMobilizationTabType.Donated,
      tabName = "zone_mobilization_title_1"
    },
    {
      tabType = ZoneMobilizationTabType.Attack,
      tabName = "zone_mobilization_title_2"
    },
    {
      tabType = ZoneMobilizationTabType.Defend,
      tabName = "zone_mobilization_title_3"
    }
  }
  self.subViewPrefabAsyncDict = {}
  self.subViewCompDict = {}
  self.tabViewItemRenderDict = {}
  self.howtoPlayArr = nil
end

local function DataDestroy(self)
  self.isInit = nil
  self.curTabType = nil
  self.tabViewDataList = nil
  self.subViewPrefabAsyncDict = nil
  self.subViewCompDict = nil
  self.tabViewItemRenderDict = nil
  self.howtoPlayArr = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReceivePushRequestZoneMobilizationData, self.OnReceivePushMsgRequestZoneMobilizationData)
  self:AddUIListener(EventId.UpdateDonatedProgressRewardData, self.RefreshModelPanel)
  self:AddUIListener(EventId.GetZoneMobilizationInfoData, self.OnGetZoneMobilizationInfoData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReceivePushRequestZoneMobilizationData, self.OnReceivePushMsgRequestZoneMobilizationData)
  self:RemoveUIListener(EventId.UpdateDonatedProgressRewardData, self.RefreshModelPanel)
  self:RemoveUIListener(EventId.GetZoneMobilizationInfoData, self.OnGetZoneMobilizationInfoData)
  base.OnRemoveListener(self)
end

local function OnReceivePushMsgRequestZoneMobilizationData(self, message)
  if message and message.tabType then
    DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(message.tabType)
  else
    DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(self.curTabType)
  end
end

local function OnGetZoneMobilizationInfoData(self)
  if not DataCenter.LWZoneMobilizationManager:IsActivityOpen() then
    self.ctrl:CloseSelf()
    return
  end
  if not self.isInit then
    self.isInit = true
    local curStageType = DataCenter.LWZoneMobilizationManager:GetCurStageType()
    if curStageType == ZoneMobilizationStageType.Donated or curStageType == ZoneMobilizationStageType.Sprint then
      self:OnTabItemClick(ZoneMobilizationTabType.Donated)
    elseif LuaEntry.Player:IsPresident() and not DataCenter.LWZoneMobilizationManager.isBossPlace and curStageType == ZoneMobilizationStageType.Battle_Place then
      self:OnTabItemClick(ZoneMobilizationTabType.Attack)
      local param = {}
      param.positionType = PositionType.Screen
      local targetRoot = self.u_i_zone_mobilization_model_panel:GetFingerArrowTargetRoot()
      param.position = targetRoot.transform.position + Vector3.New(50, -50, 0)
      param.isAutoClose = 2
      DataCenter.ArrowManager:ShowFingerArrow(param)
    else
      self:OnTabItemClick(ZoneMobilizationTabType.Defend)
    end
  end
  self:RefreshModelPanel()
end

local function InitData(self)
  local curStageType = DataCenter.LWZoneMobilizationManager:GetCurStageType()
  if curStageType ~= ZoneMobilizationStageType.None then
    if curStageType == ZoneMobilizationStageType.Donated or curStageType == ZoneMobilizationStageType.Sprint then
      self.curTabType = ZoneMobilizationTabType.Donated
    elseif LuaEntry.Player:IsPresident() and not DataCenter.LWZoneMobilizationManager.isBossPlace then
      self.curTabType = ZoneMobilizationTabType.Attack
    else
      self.curTabType = ZoneMobilizationTabType.Defend
    end
  end
  local tabCount = table.count(self.tabViewDataList)
  if 0 < tabCount then
    self.tabScrollView:SetTotalCount(tabCount)
    self.tabScrollView:RefillCells()
  end
  self:RefreshBgView()
  self:SwitchSubView(self.curTabType)
end

local function RefreshBgView(self)
  if BgTableData[self.curTabType] then
    local data = BgTableData[self.curTabType]
    local bgPath = string.format(LoadPath.LWUIZoneMobilizationTexturePath, data.bgPathName)
    self.bgRawImage:LoadSprite(bgPath)
  end
end

local function RefreshModelPanel(self)
  if self.u_i_zone_mobilization_model_panel then
    self.u_i_zone_mobilization_model_panel:RefreshPanel(self.curTabType, DataCenter.LWZoneMobilizationManager.stage)
  end
end

local function OnTabItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.tabScrollView:AddComponent(LWUIZoneMobilizationTabItemRender, itemObj)
  if itemRender ~= nil then
    local tableData = self.tabViewDataList[index]
    itemRender:InitData(tableData, self.curTabType)
    self.tabViewItemRenderDict[tableData.tabType] = itemRender
  end
end

local function OnTabItemMoveOut(self, itemObj, index)
  self.tabScrollView:RemoveComponent(itemObj.name, LWUIZoneMobilizationTabItemRender)
end

local function RemoveTabScroll(self)
  self.tabScrollView:ClearCells()
  self.tabScrollView:RemoveComponents(LWUIZoneMobilizationTabItemRender)
  self.tabViewItemRenderDict = {}
end

local function OnTabItemClick(self, newTabType)
  if self.curTabType == newTabType then
    return
  end
  if self.subViewCompDict[self.curTabType] ~= nil then
    self.subViewCompDict[self.curTabType]:SetActive(false)
  end
  if self.tabViewItemRenderDict[self.curTabType] ~= nil then
    self.tabViewItemRenderDict[self.curTabType]:SetSelectState(false)
  end
  self.curTabType = newTabType
  if self.tabViewItemRenderDict[newTabType] ~= nil then
    self.tabViewItemRenderDict[newTabType]:SetSelectState(true)
  end
  self:RefreshBgView()
  self:SwitchSubView(newTabType)
end

local function SwitchSubView(self, newTabType)
  local handlerData = TabTypeTableData[newTabType]
  if handlerData and handlerData.assetPath and handlerData.cls and not self.subViewPrefabAsyncDict[newTabType] and not self.subViewCompDict[self.curTabType] then
    self.subViewPrefabAsyncDict[newTabType] = self:GameObjectInstantiateAsync(handlerData.assetPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.subPanelContent.transform)
      go.transform:Set_localScale(1, 1, 1)
      local subViewComp = self.subPanelContent:AddComponent(handlerData.cls, go.name)
      subViewComp:SetOffsetMinXY(0, 0)
      subViewComp:SetOffsetMaxXY(0, 0)
      self.subViewCompDict[newTabType] = subViewComp
      subViewComp:ReInitData()
      subViewComp:SetActive(self.curTabType == newTabType)
    end)
  elseif self.subViewCompDict[self.curTabType] then
    local subViewComp = self.subViewCompDict[self.curTabType]
    subViewComp:SetActive(true)
    subViewComp:ReInitData()
  end
end

local function DestroyAllSubView(self)
  if self.subPanelContent then
    self.subPanelContent:RemoveAllComponentes()
  end
  if self.subViewPrefabAsyncDict then
    for k, v in pairs(self.subViewPrefabAsyncDict) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.subViewPrefabAsyncDict = {}
  self.subViewCompDict = {}
end

local function RuleBtnClick(self)
  if DataCenter.LWZoneMobilizationManager:GetIsNewFunc() then
    if self.howtoPlayArr and #self.howtoPlayArr >= 2 then
      local param = {}
      param.howToPlayList = {
        self.howtoPlayArr[1]
      }
      param.story = self.howtoPlayArr[2]
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
    end
  else
    local param = {}
    param.activityRulesStr = Localization:GetString("zone_mobilization_rule")
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

local function GetHowtoPlayId(self)
  local str = LuaEntry.DataConfig:TryGetStr("zone_mobilization_donate", "k12")
  local arr
  if not string.IsNullOrEmpty(str) then
    arr = string.split(str, "|")
  end
  self.howtoPlayArr = arr
  return self.howtoPlayArr
end

LWUIZoneMobilizationMainView.OnCreate = OnCreate
LWUIZoneMobilizationMainView.OnDestroy = OnDestroy
LWUIZoneMobilizationMainView.OnEnable = OnEnable
LWUIZoneMobilizationMainView.OnDisable = OnDisable
LWUIZoneMobilizationMainView.ComponentDefine = ComponentDefine
LWUIZoneMobilizationMainView.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationMainView.DataDefine = DataDefine
LWUIZoneMobilizationMainView.DataDestroy = DataDestroy
LWUIZoneMobilizationMainView.OnAddListener = OnAddListener
LWUIZoneMobilizationMainView.OnRemoveListener = OnRemoveListener
LWUIZoneMobilizationMainView.OnReceivePushMsgRequestZoneMobilizationData = OnReceivePushMsgRequestZoneMobilizationData
LWUIZoneMobilizationMainView.OnGetZoneMobilizationInfoData = OnGetZoneMobilizationInfoData
LWUIZoneMobilizationMainView.InitData = InitData
LWUIZoneMobilizationMainView.RefreshBgView = RefreshBgView
LWUIZoneMobilizationMainView.OnTabItemMoveIn = OnTabItemMoveIn
LWUIZoneMobilizationMainView.OnTabItemMoveOut = OnTabItemMoveOut
LWUIZoneMobilizationMainView.RemoveTabScroll = RemoveTabScroll
LWUIZoneMobilizationMainView.OnTabItemClick = OnTabItemClick
LWUIZoneMobilizationMainView.SwitchSubView = SwitchSubView
LWUIZoneMobilizationMainView.DestroyAllSubView = DestroyAllSubView
LWUIZoneMobilizationMainView.RuleBtnClick = RuleBtnClick
LWUIZoneMobilizationMainView.RefreshModelPanel = RefreshModelPanel
LWUIZoneMobilizationMainView.getters.howtoPlayArr = GetHowtoPlayId
return LWUIZoneMobilizationMainView
