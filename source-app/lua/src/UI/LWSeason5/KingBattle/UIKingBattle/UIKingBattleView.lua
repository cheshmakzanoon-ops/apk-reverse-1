local base = UIBaseView
local UIKingBattle = BaseClass("UIKingBattle", base)
local __assetsPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/KingBattle/Component/%s.prefab"
local __scriptPath = "UI.LWSeason5.KingBattle.Component.%s"
local __tabInfo = {
  {
    Name = "season_s5_activity_1200067_tab01",
    Asset = "KingPreBattle"
  },
  {
    Name = "season_s5_activity_1200067_tab02",
    Asset = "KingFinalBattle"
  }
}
local title_path = "safeArea/TopBar/TextTitle"
local btnBack_path = "safeArea/BottomBar/BtnBack"
local panelContainer_path = "safeArea/panelContainer"
local tog1_path = "safeArea/tabsSv/Toggle1"
local textTab1_path = "safeArea/tabsSv/Toggle1/TextTab1"
local textTabSel1_path = "safeArea/tabsSv/Toggle1/select/TextTabSel1"
local tog2_path = "safeArea/tabsSv/Toggle2"
local textTab2_path = "safeArea/tabsSv/Toggle2/TextTab2"
local textTabSel2_path = "safeArea/tabsSv/Toggle2/select/TextTabSel2"
local red2_path = "safeArea/tabsSv/Toggle2/RedDotWithoutNum2"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
  SFSNetwork.SendMessage(MsgDefines.ThroneConnectedInfo)
  SFSNetwork.SendMessage(MsgDefines.CenterThroneActivityInfo)
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
  self.title = self:AddComponent(UIText, title_path)
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.panelContainer = self:AddComponent(UIBaseContainer, panelContainer_path)
  self.tog1 = self:AddComponent(UIToggle, tog1_path)
  self.textTab1 = self:AddComponent(UIText, textTab1_path)
  self.textTabSel1 = self:AddComponent(UIText, textTabSel1_path)
  self.tog2 = self:AddComponent(UIToggle, tog2_path)
  self.textTab2 = self:AddComponent(UIText, textTab2_path)
  self.textTabSel2 = self:AddComponent(UIText, textTabSel2_path)
  self.red2 = self:AddComponent(UIBaseContainer, red2_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.title:SetLocalText("season_s5_activity_1200067_name")
  for i, v in ipairs(__tabInfo) do
    local tog = self[string.format("tog%d", i)]
    if tog then
      tog:SetOnValueChanged(function(isOn)
        if isOn then
          self:RefreshContent(i)
        end
      end)
    end
    local textTab = self[string.format("textTab%d", i)]
    local textTabSel = self[string.format("textTabSel%d", i)]
    local tabInfo = __tabInfo[i]
    if textTab and textTabSel and tabInfo then
      textTab:SetLocalText(tabInfo.Name)
      textTabSel:SetLocalText(tabInfo.Name)
    end
  end
end

local function ComponentDestroy(self)
  self.title = nil
  self.btnBack = nil
  self.panelContainer = nil
  self.tog1 = nil
  self.textTab1 = nil
  self.textTabSel1 = nil
  self.tog2 = nil
  self.textTab2 = nil
  self.textTabSel2 = nil
  self.red2 = nil
end

local function DataDefine(self)
  self.curIndex = -1
end

local function DataDestroy(self)
end

function UIKingBattle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonNineKingRewardRedPointChange, self.OnCheckRedPoint)
end

function UIKingBattle:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonNineKingRewardRedPointChange, self.OnCheckRedPoint)
  base.OnRemoveListener(self)
end

function UIKingBattle:RefreshView()
  self.activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.NineNationKingBattle.Type)
  self.mySourceServerId = LuaEntry.Player:GetSourceServerId()
  self.tog1:SetIsOn(true)
  self:RefreshContent(1)
  self:OnCheckRedPoint()
end

function UIKingBattle:RefreshContent(index)
  if self.curIndex == index then
    return
  end
  self.curIndex = index
  if self.contentPrefab then
    self.panelContainer:RemoveAllComponentes()
    self:GameObjectDestroy(self.contentPrefab)
    self.contentPrefab = nil
  end
  local tabInfo = __tabInfo[index]
  self.contentPrefab = self:GameObjectInstantiateAsync(string.format(__assetsPath, tabInfo.Asset), function(req)
    local obj = req.gameObject
    if IsNull(obj) then
      return
    end
    obj.transform:SetParent(self.panelContainer.transform)
    local script = require(string.format(__scriptPath, tabInfo.Asset))
    local comp = self.panelContainer:GetComponent(obj.name, script)
    comp = comp or self.panelContainer:AddComponent(script, obj.name)
    comp:SetSizeDeltaXY(0, 0)
    comp:SetAnchoredPositionXY(0, 0)
    comp:SetLocalScaleXYZ(1, 1, 1)
    comp:ReInit(self.activityData)
  end)
end

function UIKingBattle:OnCheckRedPoint()
  self.red2:SetActive(DataCenter.SeasonNineKingManager.redPointCount > 0)
end

function UIKingBattle:GetTestData(data)
  if not data then
    data = {}
    data.endTime = UITimeManager:GetInstance():GetServerTime() + math.random(10000, 100000000)
    data.para_1 = "400002|400003|400004"
  end
  return data
end

UIKingBattle.OnCreate = OnCreate
UIKingBattle.OnDestroy = OnDestroy
UIKingBattle.OnEnable = OnEnable
UIKingBattle.OnDisable = OnDisable
UIKingBattle.ComponentDefine = ComponentDefine
UIKingBattle.ComponentDestroy = ComponentDestroy
UIKingBattle.DataDefine = DataDefine
UIKingBattle.DataDestroy = DataDestroy
return UIKingBattle
