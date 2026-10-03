local UITacticalWeaponLevelDisplayView = BaseClass("UITacticalWeaponLevelDisplayView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "Root/title"
local content_path = "Root/Scroll View/Viewport/Content"
local level_title_path = "Root/Scroll View/Viewport/Content/levelTitle"
local level_progress_path = "Root/Scroll View/Viewport/Content/levelProgress"
local level_progress_img_path = "Root/Scroll View/Viewport/Content/levelProgress/levelProgressImg"
local close_btn_path = "closeBtn"
local TacticalLevelDisplayLevelItem = require("UI.UILWTacticalWeapon.UITacticalWeaponLevelDisplay.Component.TacticalLevelDisplayLevelItem")

function UITacticalWeaponLevelDisplayView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnReInit()
  DataCenter.LWSoundManager:PlaySound(62281, false)
end

function UITacticalWeaponLevelDisplayView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITacticalWeaponLevelDisplayView:ComponentDefine()
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.title:SetLocalText("new_uav_level_button1")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.level_title = self:AddComponent(UITextMeshProUGUIEx, level_title_path)
  self.level_title:SetLocalText("new_uav_level_desc5")
  self.level_progress = self:AddComponent(UIBaseContainer, level_progress_path)
  self.level_progress_img = self:AddComponent(UIBaseContainer, level_progress_img_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.viewport = self:AddComponent(UIBaseContainer, "Root/Scroll View/Viewport")
  self.levelHeightPixel = LuaEntry.DataConfig:TryGetNum("uav_level_preview_config", "k1")
end

function UITacticalWeaponLevelDisplayView:ComponentDestroy()
  self.title = nil
  self.content = nil
  self.level_title = nil
  self.level_progress = nil
  self.level_progress_img = nil
  self.close_btn = nil
end

function UITacticalWeaponLevelDisplayView:DataDefine()
  self.itemReqList = {}
  self.cells = {}
end

function UITacticalWeaponLevelDisplayView:DataDestroy()
  if self.itemReqList then
    self.level_progress:RemoveComponents(TacticalLevelDisplayLevelItem)
    for i, v in ipairs(self.itemReqList) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.itemReqList = nil
  self.cells = nil
end

function UITacticalWeaponLevelDisplayView:OnAddListener()
  base.OnAddListener(self)
end

function UITacticalWeaponLevelDisplayView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITacticalWeaponLevelDisplayView:OnReInit()
  local weapons = DataCenter.TacticalWeaponManager:GetTacticalWeaponInfos()
  if not table.IsNullOrEmpty(weapons) then
    for i, v in pairs(weapons) do
      self.weaponInfo = v
      break
    end
  end
  if not self.weaponInfo then
    Logger.LogError("[Tactical] \230\178\161\230\156\137\230\151\160\228\186\186\230\156\186\230\149\176\230\141\174\239\188\129")
    return
  end
  self:InitProgressLength()
  self:CreateLevelItemList()
end

function UITacticalWeaponLevelDisplayView:InitProgressLength()
  local templateList = DataCenter.TacticalWeaponDisplayManager:GetTemplateList()
  local lastTemplate = templateList[#templateList]
  local height = lastTemplate.location_level * self.levelHeightPixel
  local progressSizeDelta = self.level_progress.rectTransform.sizeDelta
  progressSizeDelta.y = height
  self.level_progress.rectTransform.sizeDelta = progressSizeDelta
  local contentSizeDelta = self.content.rectTransform.sizeDelta
  contentSizeDelta.y = -self.level_progress.rectTransform.anchoredPosition.y + height + 630
  self.content.rectTransform.sizeDelta = contentSizeDelta
  local weaponLv = math.min(self.weaponInfo.level, self.weaponInfo:GetBaseMaxLevel())
  local progressValueSizeDelta = self.level_progress_img.rectTransform.sizeDelta
  progressValueSizeDelta.y = weaponLv * self.levelHeightPixel
  self.level_progress_img.rectTransform.sizeDelta = progressValueSizeDelta
  local viewportSizeRect = self.viewport.rectTransform.rect
  if progressValueSizeDelta.y > viewportSizeRect.height * 0.5 then
    local moveY = progressValueSizeDelta.y - viewportSizeRect.height * 0.5
    local anchoredPos = self.content.rectTransform.anchoredPosition
    anchoredPos.y = moveY
    self.content.rectTransform.anchoredPosition = anchoredPos
  end
end

function UITacticalWeaponLevelDisplayView:CreateLevelItemList()
  local templateList = DataCenter.TacticalWeaponDisplayManager:GetTemplateList()
  for i, v in ipairs(templateList) do
    self.itemReqList[i] = self:CreateLevelItem(i, v)
  end
end

function UITacticalWeaponLevelDisplayView:CreateLevelItem(index, template)
  return self:GameObjectInstantiateAsync(UIAssets.TacticalLevelDisplayLevelItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.level_progress.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local height = template.location_level * 16
    go.transform:Set_localPosition(0, -height, 0)
    local nameStr = "levelItem" .. template.display_level
    go.name = nameStr
    self.cells[index] = self.level_progress:AddComponent(TacticalLevelDisplayLevelItem, nameStr)
    self.cells[index]:SetData(template, self.weaponInfo.level)
  end)
end

return UITacticalWeaponLevelDisplayView
