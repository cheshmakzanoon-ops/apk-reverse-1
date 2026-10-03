local UIActEpidemicHelpView = BaseClass("UIActEpidemicHelpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIActEpidemicHelpView:OnCreate()
  base.OnCreate(self)
  self.loadedRenderer = nil
  self.itemRequest = nil
  self.ruleConfig = nil
  self:ComponentDefine()
  self:DataDefine()
  self.ruleId = self:GetUserData()
  self:RefreshView()
end

function UIActEpidemicHelpView:OnDestroy()
  self:DestroyLoadedItemRenderer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.loadedRenderer = nil
  self.ruleConfig = nil
  self.itemRequest = nil
  self.ruleId = nil
end

function UIActEpidemicHelpView:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPanelNewPopUp/PanelRoot/TitleText")
  self.btnClose = self:AddComponent(UIButton, "UICommonPanelNewPopUp/PanelRoot/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnUICommonBlackMask = self:AddComponent(UIButton, "UICommonPanelNewPopUp/UICommonBlackMask")
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.compPanelRoot = self:AddComponent(UIBaseComponent, "UICommonPanelNewPopUp/PanelRoot")
  self.compContent = self:AddComponent(UIBaseComponent, "UICommonPanelNewPopUp/PanelRoot/Content/ViewRect/Viewport/Content")
  self.rootWidth = self.compPanelRoot.rectTransform.sizeDelta.x
end

function UIActEpidemicHelpView:ComponentDestroy()
  self.textTitle = nil
  self.btnClose = nil
  self.btnUICommonBlackMask = nil
  self.compPanelRoot = nil
  self.compContent = nil
end

function UIActEpidemicHelpView:DataDefine()
end

function UIActEpidemicHelpView:DataDestroy()
end

function UIActEpidemicHelpView:OnAddListener()
  base.OnAddListener(self)
end

function UIActEpidemicHelpView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActEpidemicHelpView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIActEpidemicHelpView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UIActEpidemicHelpView:RefreshView()
  if not self.ruleId then
    Logger.LogError("UIActEpidemicHelpView refresh view failed. Rule id is null.")
    return
  end
  local config = LocalController:instance():getLine(TableName.LW_BattleField_Rules, self.ruleId)
  if not config then
    Logger.LogError("UIActEpidemicHelpView refresh view failed. Config is null. id = " .. self.ruleId)
    return
  end
  if self.ruleConfig and self.ruleConfig.type ~= config.type then
    self:DestroyLoadedItemRenderer()
    self.ruleConfig = nil
  end
  self.ruleConfig = config
  self.rendererConfig = self:GetRendererConfig(self.ruleConfig)
  if not self.rendererConfig then
    return
  end
  if self:RefreshItemRenderer() then
    return
  end
  self:TryLoadItemRenderer()
end

function UIActEpidemicHelpView:GetRendererConfig(ruleConfig)
  if self.ruleConfig.type == 1 then
    return ruleConfig
  elseif self.ruleConfig.type == 2 then
    return DataCenter.EpidemicBuildTemplateMgr:GetTemplate(tonumber(self.ruleConfig.battle_building))
  elseif self.ruleConfig.type == 3 then
    return nil
  elseif self.ruleConfig.type == 4 then
    return ruleConfig
  elseif self.ruleConfig.type == 5 then
    return DataCenter.ActEpidemicZoneManager:GetTemplateSkillById(tonumber(self.ruleConfig.battle_skill))
  end
end

function UIActEpidemicHelpView:RefreshItemRenderer()
  if self.loadedRenderer then
    self.loadedRenderer:ReInit(self.rendererConfig, self.ruleConfig.battle_type)
    return true
  end
  return false
end

function UIActEpidemicHelpView:TryLoadItemRenderer()
  if self.itemRequest then
    return
  end
  if self.loadedRenderer then
    return
  end
  if not self.ruleConfig then
    return
  end
  local config = self.ctrl:GetItemRendererConfig(self.ruleConfig.type)
  if not config.asset then
    return
  end
  self.textTitle:SetLocalText(config.title)
  self.itemRequest = self:GameObjectInstantiateAsync(config.asset, function(request)
    if request.isError then
      return
    end
    if not config then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.compContent.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.name = "[async]loadedRenderer_id_" .. self.ruleConfig.id
    go:SetActive(true)
    self.loadedRenderer = self:AddComponent(config.lua, go)
    self.compPanelRoot.rectTransform.sizeDelta = Vector2.New(self.rootWidth, config.height)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
    self:RefreshItemRenderer()
  end)
end

function UIActEpidemicHelpView:DestroyLoadedItemRenderer()
  if self.itemRequest then
    self:GameObjectDestroy(self.itemRequest)
    self.itemRequest = nil
  end
  self.loadedRenderer = nil
end

return UIActEpidemicHelpView
