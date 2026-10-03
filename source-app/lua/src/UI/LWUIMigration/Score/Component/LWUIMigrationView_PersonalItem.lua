local LWUIMigrationView_PersonalItem = BaseClass("LWUIMigrationView_PersonalItem", UIBaseContainer)
local base = UIBaseContainer
local PItemContent = require("UI.LWUIMigration.Score.Component.LWUIMigrationView_PersonalItemContent")
local item_content_path = "ItemContent"
local power_source_type_content_path = "PowerSourceTypeContent"
local button_path = "Title/Content/buttonContent/button"
local icon_path = "Title/Content/iconContent/icon"
local empty_content_path = "Title/Content/emptyContent"
local button_content_path = "Title/Content/buttonContent"
local button_img_path = "Title/Content/buttonContent/button/buttonImg"
local name_path = "Title/Content/name"
local value_path = "Title/Content/value"

function LWUIMigrationView_PersonalItem:OnCreate()
  base.OnCreate(self)
  self.bShowDetail = false
  self.goItem = self.transform:Find(item_content_path).gameObject
  self.goItem:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, power_source_type_content_path)
  self.button = self:AddComponent(UIButton, button_path)
  self.button:SetOnClick(BindCallback(self, self.OnClick))
  self.name = self:AddComponent(UIText, name_path)
  self.value = self:AddComponent(UIText, value_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.empty_content = self:AddComponent(UIBaseContainer, empty_content_path)
  self.button_content = self:AddComponent(UIBaseContainer, button_content_path)
  self.button_img = self:AddComponent(UIImage, button_img_path)
end

function LWUIMigrationView_PersonalItem:OnDestroy()
  self:ClearItems()
  base.OnDestroy(self)
end

function LWUIMigrationView_PersonalItem:OnClick()
  if self.idx == 1 or self.idx == 4 then
    if self.view and self.view.OnClickDetail then
      self.view:OnClickDetail(self.button_img, self.idx)
    end
  else
    self.bShowDetail = not self.bShowDetail
  end
  self:RefreshShowTypeView()
end

function LWUIMigrationView_PersonalItem:ClearItems()
  self.goItem:GameObjectRecycleAll()
  self.content:RemoveComponents(PItemContent)
end

function LWUIMigrationView_PersonalItem:SetData(idx)
  self.idx = idx
  self:ClearItems()
  local cnt = 0
  if idx == 2 then
    cnt = 3
  elseif idx == 3 then
    cnt = 2
  end
  if 0 < cnt then
    for i = 1, cnt do
      local goObj = self.goItem:GameObjectSpawn(self.content.transform)
      goObj.name = "item_" .. i
      goObj:SetActive(true)
      local itemRender = self.content:AddComponent(PItemContent, goObj.name)
      itemRender:SetData(idx, i)
    end
  end
  self:RefreshShowTypeView()
end

function LWUIMigrationView_PersonalItem:RefreshShowTypeView()
  if self.idx == 1 or self.idx == 4 or self.idx == 5 then
    self.content:SetActive(false)
  else
    self.content:SetActive(self.bShowDetail)
  end
  self:RefreshTitle()
end

function LWUIMigrationView_PersonalItem:RefreshTitle()
  local info = DataCenter.ActMigrationManager:GetScoreInfo()
  local flag = self.icon:LoadSpriteAsyncWithCallback(info:GetIconPath(self.idx), function()
    if self.icon then
      self.icon:SetNativeSize()
    end
  end)
  if not flag then
    self.icon:SetNativeSize()
  end
  self.name:SetLocalText(info:GetNameKey(self.idx))
  self.value:SetText(string.GetFormattedSeparatorNum(math.floor(info:GetPower(self.idx, 0))))
  if self.idx == 2 or self.idx == 3 then
    self.empty_content:SetActive(false)
    self.button_content:SetActive(true)
    if self.bShowDetail then
      self.button_img:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_2.png")
    else
      self.button_img:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png")
    end
  elseif self.idx == 1 or self.idx == 4 then
    self.empty_content:SetActive(false)
    self.button_content:SetActive(true)
    self.button_img:LoadSpriteAuto("Assets/Main/Sprites/UI/LWUIMigration/ljq_youling_tanhao.png")
  else
    self.empty_content:SetActive(true)
    self.button_content:SetActive(false)
  end
end

return LWUIMigrationView_PersonalItem
