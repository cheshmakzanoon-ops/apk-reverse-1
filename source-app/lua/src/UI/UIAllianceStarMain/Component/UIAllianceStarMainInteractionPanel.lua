local UIAllianceStarMainInteractionPanel = BaseClass("UIAllianceStarMainInteractionPanel", UIBaseContainer)
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
  self.tipPanel:SetActive(true)
  self.showTipDelay = nil
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIEventTrigger, "")
  self.btn:OnPointerClick(function(eventData)
    self:OnClickBtn(eventData.position)
  end)
  self.tipIcon = self:AddComponent(UIBaseContainer, "Effect")
  self.tipIcon:SetActive(false)
  self.tipIconPool = self.tipIcon.gameObject
  self.tipIconPool:GameObjectCreatePool()
  self.tipPanel = self:AddComponent(UIBaseContainer, "TipPanel")
  self.tipText = self:AddComponent(UIText, "TipPanel/TipText")
  self.tipText:SetLocalText("alliance_weeklyStar_ceremony_applaud_tips")
end

local function ComponentDestroy(self)
  self:RemoveComponents(UIAllianceStarMainInteractionTip)
  self.tipIconPool:GameObjectRecycleAll()
  self.tipIconPool = nil
  self.tipIcon = nil
  self.tipPanel = nil
  self.tipText = nil
end

local function DataDefine(self)
  self.clickCD = LuaEntry.DataConfig:TryGetNum("alliance_weeklyStar_config", "k7", 3)
  self.clickDelay = self.clickCD
  self.showTipCD = LuaEntry.DataConfig:TryGetNum("alliance_weeklyStar_config", "k5", 3)
  self.showTipDelay = nil
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

local function OnClickBtn(self, position)
  if self.interactionType then
    local uiPos = PosConverse.ScreenToUIPos(self.transform, position) * Vector3.New(CommonUtil.IsArabicAutoMirrorOpen() and -1 or 1, 1, 1)
    if self.tipPanel:GetActive() then
      self.tipPanel:SetActive(false)
    end
    if self.clickDelay >= self.clickCD then
      DataCenter.AllianceStarManager:PlaySfx(70006)
      DataCenter.AllianceStarManager:LogInfo("\231\156\159\233\188\147\230\142\140")
      self.clickDelay = 0
      SFSNetwork.SendMessage(MsgDefines.AllianceStarCeremonyInteraction, self.interactionType)
      self:AddTipIcon(uiPos, true)
    else
      DataCenter.AllianceStarManager:LogInfo("\229\129\135\233\188\147\230\142\140")
      self:AddTipIcon(uiPos, false)
    end
    self.showTipDelay = 0
  end
end

local function Refresh(self, param)
  if param and param.template then
    self.template = param.template
    self.interactionType = param.template:GetInteractionType()
    self.endDeltaTime = param.endDeltaTime
    self:RefreshInteractionNumMax()
  else
    self.interactionType = nil
  end
end

local function RefreshInteractionNumMax(self)
  self.interactionNumMax = false
  if self.interactionType then
    local num = 0
    local info = DataCenter.AllianceStarManager:GetCeremonyInteractionInfo(self.interactionType)
    if info then
      num = info.interactionNumber
    end
    local level, rewardInfo = self.template:GetLevelByInteractionNum(num)
    self.interactionNumMax = level >= #self.template.rewardInfoList
  end
end

local function Update(self)
  if self.clickDelay < self.clickCD then
    self.clickDelay = self.clickDelay + Time.deltaTime
  end
  if self.showTipDelay then
    self.showTipDelay = self.showTipDelay + Time.deltaTime
    if self.showTipDelay > self.showTipCD then
      self.tipPanel:SetActive(true)
      self.showTipDelay = nil
    end
  end
  if self.interactionNumMax then
    self.tipPanel:SetActive(false)
  end
end

local function AddTipIcon(self, position, isTrue)
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
  comp:Refresh(self.tipIconShowTime, nil, position, isTrue and 1 or 0.3)
end

local function RemoveTipIcon(self, tipIcon)
  tipIcon:SetActive(false)
  tipIcon:Clear()
  table.insert(self.freeAllyTipIcon, tipIcon)
end

UIAllianceStarMainInteractionPanel.OnCreate = OnCreate
UIAllianceStarMainInteractionPanel.OnDestroy = OnDestroy
UIAllianceStarMainInteractionPanel.OnEnable = OnEnable
UIAllianceStarMainInteractionPanel.OnDisable = OnDisable
UIAllianceStarMainInteractionPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainInteractionPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainInteractionPanel.DataDefine = DataDefine
UIAllianceStarMainInteractionPanel.DataDestroy = DataDestroy
UIAllianceStarMainInteractionPanel.OnAddListener = OnAddListener
UIAllianceStarMainInteractionPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainInteractionPanel.OnClickBtn = OnClickBtn
UIAllianceStarMainInteractionPanel.Refresh = Refresh
UIAllianceStarMainInteractionPanel.Update = Update
UIAllianceStarMainInteractionPanel.AddTipIcon = AddTipIcon
UIAllianceStarMainInteractionPanel.RemoveTipIcon = RemoveTipIcon
UIAllianceStarMainInteractionPanel.RefreshInteractionNumMax = RefreshInteractionNumMax
return UIAllianceStarMainInteractionPanel
