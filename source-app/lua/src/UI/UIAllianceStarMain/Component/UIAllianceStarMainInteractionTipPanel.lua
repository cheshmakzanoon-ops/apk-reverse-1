local UIAllianceStarMainInteractionTipPanel = BaseClass("UIAllianceStarMainInteractionTipPanel", UIBaseContainer)
local UIAllianceStarMainInteractionTip = require("UI.UIAllianceStarMain.Component.UIAllianceStarMainInteractionTip")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.tipIcon = self:AddComponent(UIAllianceStarMainInteractionTip, "InteractionTipIcon")
  self.tipIcon:SetActive(false)
  self.tipIconPool = self.tipIcon.gameObject
  self.tipIconPool:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self:RemoveComponents(UIAllianceStarMainInteractionTip)
  self.tipIconPool:GameObjectRecycleAll()
  self.tipIconPool = nil
  self.tipIcon = nil
end

local function DataDefine(self)
  self.tipIconIndex = 1
  self.tipIconShowTime = 1
  self.freeAllyTipIcon = {}
end

local function DataDestroy(self)
  self.tipIconIndex = nil
  self.tipIconShowTime = nil
  self.freeAllyTipIcon = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnAllianceStarCeremonyInteractionInfoPush(self, msg)
  if msg.interactionNumber > 0 then
    local scene = DataCenter.AllianceStarManager.ceremonyScene
    if scene then
      local ally, pos = scene:GetFreeAllyInteractionPos(self.rectTransform)
      if ally and pos then
        self:AddTipIcon(ally, pos)
      end
    end
  end
end

local function AddTipIcon(self, unit, pos)
  local comp
  if #self.freeAllyTipIcon > 0 then
    comp = table.remove(self.freeAllyTipIcon)
  end
  if comp == nil then
    local tipIconObj = self.tipIconPool:GameObjectSpawn(self.transform)
    tipIconObj.name = "tipIcon" .. self.tipIconIndex
    comp = self:AddComponent(UIAllianceStarMainInteractionTip, tipIconObj.name)
    self.tipIconIndex = self.tipIconIndex + 1
  end
  comp:SetActive(false)
  comp:SetActive(true)
  comp:Refresh(self.tipIconShowTime, unit, pos)
end

local function RemoveTipIcon(self, tipIcon, unit)
  if unit then
    unit:CloseInteractionIcon()
  end
  tipIcon:SetActive(false)
  tipIcon:Clear()
  table.insert(self.freeAllyTipIcon, tipIcon)
end

UIAllianceStarMainInteractionTipPanel.OnCreate = OnCreate
UIAllianceStarMainInteractionTipPanel.OnDestroy = OnDestroy
UIAllianceStarMainInteractionTipPanel.OnEnable = OnEnable
UIAllianceStarMainInteractionTipPanel.OnDisable = OnDisable
UIAllianceStarMainInteractionTipPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainInteractionTipPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainInteractionTipPanel.DataDefine = DataDefine
UIAllianceStarMainInteractionTipPanel.DataDestroy = DataDestroy
UIAllianceStarMainInteractionTipPanel.OnAddListener = OnAddListener
UIAllianceStarMainInteractionTipPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainInteractionTipPanel.OnAllianceStarCeremonyInteractionInfoPush = OnAllianceStarCeremonyInteractionInfoPush
UIAllianceStarMainInteractionTipPanel.AddTipIcon = AddTipIcon
UIAllianceStarMainInteractionTipPanel.RemoveTipIcon = RemoveTipIcon
return UIAllianceStarMainInteractionTipPanel
