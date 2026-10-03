local base = UIBaseContainer
local LWUIMigration_AllyTagItem = BaseClass("LWUIMigration_AllyTagItem", base)
local Localization = CS.GameEntry.Localization
local icon_path = "Icon"
local nameTxt_path = "ItemNameInfo"
local toggle_path = "BG1"
local chooseBg_path = "BG2"
local iconBg_path = "IconBg"
local iconBtn_path = "Icon"

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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.nameTxt = self:AddComponent(UIText, nameTxt_path)
  self.toggle = self:AddComponent(UIToggle, toggle_path)
  self.chooseBg = self:AddComponent(UIBaseContainer, chooseBg_path)
  self.iconBg = self:AddComponent(UIImage, iconBg_path)
  self.iconBtn = self:AddComponent(UIButton, iconBtn_path)
  self.iconBtn:SetOnClick(BindCallback(self, self.OnClickIconBtn))
  self.chooseBg:SetActive(false)
  self.toggle:SetIsOn(false)
  self.toggle:SetOnValueChanged(function(tf)
    if self.data.afterClicked then
      self.data.afterClicked(self.toggle.rectTransform)
    end
    if tf then
      local searchTag = self.data.searchTag
      if table.count(searchTag) >= 3 then
        self.toggle:SetIsOnWithoutNotify(false)
        UIUtil.ShowTipsId("migration_activity_interface_10147")
        return
      end
    end
    self.chooseBg:SetActive(tf)
    if self.data.type == ActMigrationAllianceTagType.Favor then
      if self.data.callback then
        self.data.callback(tf)
      else
        EventManager:GetInstance():Broadcast(EventId.ActMigrationSetFavorTagToggle, tf)
      end
    elseif self.data.type == ActMigrationAllianceTagType.Language then
      if self.data.callback then
        self.data.callback(self.curLang, tf)
      else
        self:SendLangChangeEvent()
      end
    elseif self.data.callback then
      self.data.callback(self.data.id, tf)
    else
      local data = {
        id = self.data.id,
        isChoose = tf
      }
      EventManager:GetInstance():Broadcast(EventId.ActMigrationSetAllyTagToggle, data)
    end
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.nameTxt = nil
  self.toggle = nil
  self.chooseBg = nil
  self.iconBg = nil
  self.iconBtn = nil
end

local function DataDefine(self)
  self.curLang = nil
end

local function DataDestroy(self)
  self.curLang = nil
end

local function SetData(self, data)
  self.data = data
  if self.data.type == ActMigrationAllianceTagType.Normal then
    local icon = GetTableData(TableName.LW_Migration_Alliance_Tag, self.data.id, "icon") or ""
    if not string.IsNullOrEmpty(icon) then
      self.icon:LoadSpriteAuto(string.format(LoadPath.LWUIMigrationIconPath, icon))
    end
    local icon_bg = GetTableData(TableName.LW_Migration_Alliance_Tag, self.data.id, "icon_bg") or ""
    if not string.IsNullOrEmpty(icon_bg) then
      self.iconBg:LoadSpriteAuto(string.format(LoadPath.LWUIMigrationIconPath, icon_bg))
    end
    self.nameTxt:SetLocalText(GetTableData(TableName.LW_Migration_Alliance_Tag, self.data.id, "name") or "")
    if self.data.isOn then
      self.toggle:SetIsOnWithoutNotify(self.data.isOn)
      self.chooseBg:SetActive(self.data.isOn)
    end
    self.iconBg:SetActive(true)
  elseif self.data.type == ActMigrationAllianceTagType.Favor then
    self.nameTxt:SetLocalText("migration_activity_tag_1008")
    self.icon:LoadSpriteAuto("Assets/Main/Sprites/UI/LWUIMigrationIcon/zxl_yimin_fenlei_shoucang.png")
    self.iconBg:SetActive(false)
    if self.data.isOn then
      self.toggle:SetIsOnWithoutNotify(self.data.isOn)
      self.chooseBg:SetActive(self.data.isOn)
    end
  elseif self.data.type == ActMigrationAllianceTagType.Language then
    local curLanguage = self.data.lang or Localization:GetLanguage()
    self:RefreshLanguage(curLanguage)
    self.iconBg:SetActive(false)
    if self.data.isOn then
      self.toggle:SetIsOnWithoutNotify(self.data.isOn)
      self.chooseBg:SetActive(self.data.isOn)
    end
  end
end

local function RefreshLanguage(self, idLang)
  if idLang then
    self.curLang = idLang
    local nameLang = SuportedLanguagesName[idLang]
    self.nameTxt:SetText(nameLang or "")
  end
end

local function OnClickIconBtn(self)
  if self.data.type == ActMigrationAllianceTagType.Language then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if not self.langCb then
      self.langCb = BindCallback(self, self.OnLangChanged)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationSetAllyRecruitLanguage, {anim = true}, self.curLang, self.langCb)
  end
end

function LWUIMigration_AllyTagItem:SendLangChangeEvent()
  local data = {
    idLang = self.curLang,
    isChoose = self.toggle:GetIsOn()
  }
  EventManager:GetInstance():Broadcast(EventId.ActMigrationSetLanguage, data)
end

function LWUIMigration_AllyTagItem:OnLangChanged(idLang)
  if not idLang then
    return
  end
  self:RefreshLanguage(idLang)
  if self.data.callback then
    if not self.toggle:GetIsOn() then
      self.toggle:SetIsOn(true)
    else
      self.data.callback(self.curLang, true)
    end
  elseif not self.toggle:GetIsOn() then
    self.toggle:SetIsOn(true)
  else
    self:SendLangChangeEvent()
  end
end

function LWUIMigration_AllyTagItem:ResetSelection()
  self.toggle:SetIsOnWithoutNotify(false)
  self.chooseBg:SetActive(false)
end

LWUIMigration_AllyTagItem.OnCreate = OnCreate
LWUIMigration_AllyTagItem.OnDestroy = OnDestroy
LWUIMigration_AllyTagItem.OnEnable = OnEnable
LWUIMigration_AllyTagItem.OnDisable = OnDisable
LWUIMigration_AllyTagItem.ComponentDefine = ComponentDefine
LWUIMigration_AllyTagItem.ComponentDestroy = ComponentDestroy
LWUIMigration_AllyTagItem.DataDefine = DataDefine
LWUIMigration_AllyTagItem.DataDestroy = DataDestroy
LWUIMigration_AllyTagItem.SetData = SetData
LWUIMigration_AllyTagItem.OnClickIconBtn = OnClickIconBtn
LWUIMigration_AllyTagItem.RefreshLanguage = RefreshLanguage
return LWUIMigration_AllyTagItem
