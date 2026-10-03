local MultiItem = BaseClass("MultiItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function MultiItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MultiItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MultiItem:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.root = self:AddComponent(UIBaseComponent, "root")
  self.name = self:AddComponent(UIText, "root/name")
  self.icon = self:AddComponent(UIImage, "root/icon")
end

function MultiItem:ComponentDestroy()
end

function MultiItem:SetData(object, maxW)
  local nameStr = object.name
  local iconPath = object.icon
  self.previewType = object.type
  self.data = object
  if self.previewType == WorldPreviewType.SeasonDesert then
    self.pointId = tonumber(nameStr)
    local desertId = tonumber(iconPath)
    iconPath = "Assets/Main/Sprites/UI/UISeasonHint/Mjc_saijijiangli_icon_dikuai.png"
    nameStr = Localization:GetString(110245)
    local desertMeta = DataCenter.DesertTemplateManager:GetTemplate(desertId)
    if desertMeta then
      if desertMeta.level == 0 then
        nameStr = Localization:GetString(desertMeta.name)
      else
        nameStr = Localization:GetString("140002", desertMeta.level) .. " " .. Localization:GetString(desertMeta.name)
      end
      iconPath = string.format(LoadPath.SeasonDesert, desertMeta.icon)
    end
  elseif self.previewType == WorldPreviewType.MeteoriteRes then
    iconPath = DataCenter.ActMeteoriteBattleManager:GetEntityLocIconById(iconPath)
  end
  if string.IsNullOrEmpty(iconPath) then
    iconPath = "Assets/Main/Sprites/LodIcon/cfm_daditu_chengshi_01.png"
  end
  self.name:SetText(nameStr)
  self.icon:LoadSprite(iconPath)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.rectTransform)
  local sizeDelta = self:GetSizeDelta()
  if maxW then
    self:SetSizeDeltaXY(maxW, sizeDelta.y)
  else
    local sizeDeltaRoot = self.root:GetSizeDelta()
    self:SetSizeDeltaXY(sizeDeltaRoot.x, sizeDelta.y)
  end
end

function MultiItem:OnClick()
  if self.previewType == WorldPreviewType.SeasonDesert then
    UIUtil.OnClickWorld(self.pointId, ClickWorldType.Ground)
  elseif self.data ~= nil and not IsNull(self.data.obj) then
    pcall(function()
      CS.TouchObjectEvent.ExecuteClick(self.data.obj)
    end)
  end
  if self.view and self.view.ctrl then
    self.view.ctrl:CloseSelf()
  end
end

return MultiItem
