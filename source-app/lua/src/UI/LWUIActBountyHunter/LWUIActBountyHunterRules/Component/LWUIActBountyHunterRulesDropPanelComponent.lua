local base = UIBaseContainer
local LWUIActBountyHunterRulesDropPanelComponent = BaseClass("LWUIActBountyHunterRulesDropPanelComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRules/LWUIActBountyHunterRulesConstant")
local LWUIActBountyHunterRulesDropItem01Component = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRules/Component/LWUIActBountyHunterRulesDropItem01Component")
local LWUIActBountyHunterRulesDropItem02Component = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRules/Component/LWUIActBountyHunterRulesDropItem02Component")

function LWUIActBountyHunterRulesDropPanelComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActBountyHunterRulesDropPanelComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActBountyHunterRulesDropPanelComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
end

function LWUIActBountyHunterRulesDropPanelComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compContent = nil
end

function LWUIActBountyHunterRulesDropPanelComponent:DataDefine()
end

function LWUIActBountyHunterRulesDropPanelComponent:DataDestroy()
end

function LWUIActBountyHunterRulesDropPanelComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActBountyHunterRulesDropPanelComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActBountyHunterRulesDropPanelComponent:ReInit(activityId)
  if not activityId then
    return
  end
  local bountyHunterData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
  if not bountyHunterData then
    return
  end
  self.templates = bountyHunterData:GetAllDropShowTemplates()
  self:AddMonsterRefreshItem()
  self:AddEventRefreshItem()
  self:AddMonsterRewardItem()
  self:AddBoxRewardItem()
end

function LWUIActBountyHunterRulesDropPanelComponent:AddMonsterRefreshItem()
  local templates = self.view.ctrl:GetTemplateByTypes(self.templates, {
    Const.Type.Monster_Refresh
  })
  if table.IsNullOrEmpty(templates) then
    return
  end
  self.monsterRefreshItemReq = self:GameObjectInstantiateAsync(Const.Item01AssetPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local nameStr = "Monster_Refresh"
    go.name = nameStr
    self.monsterRefreshItem = self.compContent:AddComponent(LWUIActBountyHunterRulesDropItem01Component, nameStr)
    self.monsterRefreshItem:ReInit(templates, Const.Type.Monster_Refresh)
  end)
end

function LWUIActBountyHunterRulesDropPanelComponent:AddEventRefreshItem()
  local templates = self.view.ctrl:GetTemplateByTypes(self.templates, {
    Const.Type.Event_Refresh
  })
  if table.IsNullOrEmpty(templates) then
    return
  end
  self.eventRefreshItemReq = self:GameObjectInstantiateAsync(Const.Item01AssetPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local nameStr = "Event_Refresh"
    go.name = nameStr
    self.eventRefreshItem = self.compContent:AddComponent(LWUIActBountyHunterRulesDropItem01Component, nameStr)
    self.eventRefreshItem:ReInit(templates, Const.Type.Event_Refresh)
  end)
end

function LWUIActBountyHunterRulesDropPanelComponent:AddMonsterRewardItem()
  local templates = self.view.ctrl:GetTemplateByTypes(self.templates, Const.MonsterRewardTypes)
  if table.IsNullOrEmpty(templates) then
    return
  end
  self.monsterRewardItemReq = self:GameObjectInstantiateAsync(Const.Item02AssetPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local nameStr = "Monster_Reward"
    go.name = nameStr
    self.monsterRewardItem = self.compContent:AddComponent(LWUIActBountyHunterRulesDropItem02Component, nameStr)
    self.monsterRewardItem:ReInit(templates)
  end)
end

function LWUIActBountyHunterRulesDropPanelComponent:AddBoxRewardItem()
  local templates = self.view.ctrl:GetTemplateByTypes(self.templates, {
    Const.Type.Box_Reward
  })
  if table.IsNullOrEmpty(templates) then
    return
  end
  self.boxRewardItemReq = self:GameObjectInstantiateAsync(Const.Item02AssetPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local nameStr = "Box_Reward"
    go.name = nameStr
    self.boxRewardItem = self.compContent:AddComponent(LWUIActBountyHunterRulesDropItem02Component, nameStr)
    self.boxRewardItem:ReInit(templates)
  end)
end

return LWUIActBountyHunterRulesDropPanelComponent
