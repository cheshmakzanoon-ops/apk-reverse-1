local UILWSeasonVirusLayerItem = BaseClass("UILWSeasonVirusLayerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWSeasonVirusLayerItem:OnCreate()
  base.OnCreate(self)
  self.virus_layer_node = self:AddComponent(UIImage, "")
  self.txt = self:AddComponent(UITextMeshProUGUIEx, "txt")
  self.bgAct = self:AddComponent(UIImage, "bg")
  self.icon = self:AddComponent(UIButton, "icon")
  self.lock = self:AddComponent(UIButton, "lock")
  self.icon:SetOnClick(function()
    self:OnClickVirusIcon()
  end)
  self.lock:SetOnClick(function()
    self:OnClickVirusIcon()
  end)
  if CommonUtil.IsArabic() then
    self.txt:SetLocalScaleXYZ(-1, 1, 1)
  else
    self.txt:SetLocalScaleXYZ(1, 1, 1)
  end
end

function UILWSeasonVirusLayerItem:OnDestroy()
  self.virus_layer_node = nil
  self.txt = nil
  self.bgAct = nil
  self.icon = nil
  self.lock = nil
  base.OnDestroy(self)
end

function UILWSeasonVirusLayerItem:ShowUnlockTips()
  UIUtil.ShowTipsId("season_tips244")
end

function UILWSeasonVirusLayerItem:OnClickVirusIcon()
  if self.effectId and self.level and self.icon and self.meta then
    local theLayer = math.max(LuaEntry.Player.VirusLayer, toInt(self.level))
    local param = {}
    param.title = Localization:GetString(self.meta.name, theLayer)
    param.alignObject = self.icon
    param.type = "nameDesc"
    param.isLocal = true
    local StatusEffect = LocalController:instance():getLine(TableName.StatusEffect, self.effectId)
    if StatusEffect then
      local value = StatusEffect["level_" .. theLayer]
      if value ~= nil and value ~= "" then
        local theId, theValue, theDesc = string.match(value, "([^|]+)|([^|]+)|([^|]+)")
        if theId and theValue and theDesc then
          param.desc = Localization:GetString(self.meta.description, theDesc)
        end
      elseif self.isMax or not string.IsNullOrEmpty(StatusEffect.level_max) then
        param.desc = Localization:GetString(self.meta.description)
      end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

function UILWSeasonVirusLayerItem:ReInit(nowLayer, level, maxLayer, effectId, meta, isMax)
  self.level = level
  self.effectId = effectId
  self.meta = meta
  self.isMax = isMax
  self.maxLayer = math.max(nowLayer, level, maxLayer)
  self.virus_layer_node:SetEnable(0 < level)
  if self.level == 0 then
    self.icon:SetActive(false)
    self.lock:SetActive(false)
    self.bgAct:SetActive(0 < nowLayer)
  else
    if self.maxLayer >= self.level then
      self.icon:SetActive(true)
      self.lock:SetActive(false)
      if self.meta and self.meta.icon then
        self.icon:LoadSprite(self.meta.icon)
      end
    else
      self.icon:SetActive(false)
      self.lock:SetActive(true)
    end
    self.bgAct:SetActive(nowLayer >= self.level)
  end
  if self.isMax then
    self.strText = "<size=32>" .. Localization:GetString("110000") .. [[
</size>
<size=22>]] .. self.level .. "</size>"
    self.icon:SetSizeDeltaXY(130, 130)
  else
    self.strText = Localization:GetString("season_virus_layer") .. "\n" .. self.level
    self.icon:SetSizeDeltaXY(90, 90)
  end
  self:UpdateLayer(nowLayer)
end

function UILWSeasonVirusLayerItem:UpdateLayer(nowLayer)
  local redText = true
  if self.level == 0 then
    self.bgAct:SetActive(0 < nowLayer)
    redText = 0 < nowLayer
  else
    if nowLayer > self.maxLayer then
      self.maxLayer = nowLayer
      if self.maxLayer >= self.level then
        self.icon:SetActive(true)
        self.lock:SetActive(false)
        if self.meta and self.meta.icon then
          self.icon:LoadSprite(self.meta.icon)
        end
      else
        self.icon:SetActive(false)
        self.lock:SetActive(true)
      end
    end
    if nowLayer >= self.level then
      self.bgAct:SetActive(true)
      if self.maxLayer >= self.level then
        CS.UIGray.SetGray(self.icon.transform, false, true)
      end
      redText = true
    else
      self.bgAct:SetActive(false)
      if self.maxLayer >= self.level then
        CS.UIGray.SetGray(self.icon.transform, true, true)
      elseif self.isMax then
        self.icon:LoadSprite("Assets/Main/Sprites/SkillIcons/zxl_bingdu_max_hui.png")
      end
      redText = false
    end
  end
  if redText then
    self.txt:SetText(self.strText)
  else
    self.txt:SetText("<color=#FFFFFF>" .. self.strText .. "</color>")
  end
end

return UILWSeasonVirusLayerItem
