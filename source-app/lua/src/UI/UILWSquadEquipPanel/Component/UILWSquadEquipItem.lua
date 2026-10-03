local UILWSquadEquipItem = BaseClass("UILWSquadEquipItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local icon_path = "Icon"
local levelText_path = "LevelText"
local redPoint_path = "RedPoint"
local percentNode_path = "percentNode"
local percent_path = "percentNode/percent"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.levelText = self:AddComponent(UITextMeshProUGUIEx, levelText_path)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.redPoint = self:AddComponent(UIImage, redPoint_path)
  self.typeIcon = self:AddComponent(UIImage, "FrameBg/TypeIcon")
  self.percentNode = self:AddComponent(UIBaseContainer, percentNode_path)
  self.percent = self:AddComponent(UITextMeshProUGUIEx, percent_path)
end

local function DataDefine(self)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.icon = nil
  self.levelText = nil
  self.btn = nil
  self.redPoint = nil
end

local function DataDestroy(self)
  self.equipData = nil
end

local function OnClick(self)
  if self.ownerUuid and self.slotId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalEquipUpgrade, {anim = true}, self.ownerUuid, self.slotId)
  end
end

local BgQualityPath = {
  [1] = "Assets/Main/Sprites/UI/UILWSquadEquip/cfm_chekuzhuangbei_kuang_2",
  [2] = "Assets/Main/Sprites/UI/UILWSquadEquip/cfm_chekuzhuangbei_kuang_3",
  [3] = "Assets/Main/Sprites/UI/UILWSquadEquip/cfm_chekuzhuangbei_kuang_4",
  [4] = "Assets/Main/Sprites/UI/UILWSquadEquip/cfm_chekuzhuangbei_kuang_5",
  [5] = "Assets/Main/Sprites/UI/UILWSquadEquip/cfm_chekuzhuangbei_kuang_6",
  [6] = "Assets/Main/Sprites/UI/UILWSquadEquip/zyf_chekuzhuangbei_kuang_7"
}
local SlotPath = {
  [1] = "Assets/Main/Sprites/UI/UILWSquadEquip/zyf_zhanbao_icon1",
  [2] = "Assets/Main/Sprites/UI/UILWSquadEquip/zyf_zhanbao_icon2",
  [3] = "Assets/Main/Sprites/UI/UILWSquadEquip/zyf_zhanbao_icon3",
  [4] = "Assets/Main/Sprites/UI/UILWSquadEquip/zyf_zhanbao_icon4",
  [5] = "Assets/Main/Sprites/UI/UILWSquadEquip/zyf_zhanbao_icon5"
}

local function RefreshState(self)
  self.percentNode:SetActive(false)
  if self.equipData then
    self.bg:SetActive(true)
    self.levelText:SetActive(true)
    self.levelText:SetLocalText(320439, self.equipData:GetConfigLevel())
    local iconPath = self.equipData:GetConfigIcon()
    self.icon:SetActive(true)
    self.icon:LoadSprite(iconPath)
    self.icon:SetSizeDelta(Vector2.New(120, 120))
    local quality = self.equipData:GetConfigQuality()
    self.bg:LoadSprite(BgQualityPath[quality])
  else
    self.bg:SetActive(false)
    self.levelText:SetActive(false)
    if self.showSlot then
      self.icon:SetActive(false)
      self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWSquadEquip/lrb_zhanshuwuqi_zhuangbei_bg.png")
    else
      self.icon:SetActive(false)
    end
    self.icon:SetSizeDelta(Vector2.New(72, 72))
  end
end

local function SetData(self, ownerUuid, slotId)
  if not ownerUuid or not slotId then
    return
  end
  self.ownerUuid = ownerUuid
  self.slotId = slotId
  self.equipData = DataCenter.CommonEquipDataManager:GetWearingEquipByOwnerIdAndSlot(CommonEquipType.SquadEquip, ownerUuid, slotId)
  self:RefreshState()
  self:RefreshRedPoint()
  local path = string.format("Assets/Main/Sprites/UI/UILWSquadEquip/sj_zhanshuwuqi_zhuangbei_icon%s.png", slotId)
  self.typeIcon:LoadSprite(path)
  self:RefreshPercent()
end

local function RefreshRedPoint(self)
  if self.ownerUuid and self.slotId then
    local hasRed = DataCenter.CommonEquipDataManager:IsHasBetterCommonEquipSlot(CommonEquipType.SquadEquip, self.ownerUuid, self.slotId)
    hasRed = hasRed or DataCenter.CommonEquipDataManager:IsCommonEquipCanUpgradeByOwnerSlot(CommonEquipType.SquadEquip, self.ownerUuid, self.slotId)
    hasRed = hasRed or DataCenter.CommonEquipDataManager:CanResearch(self.slotId)
    self.redPoint:SetActive(hasRed)
  else
    self.redPoint:SetActive(false)
  end
end

local function SetDataForMail(self, param)
  if type(param) == "number" then
    self.slotId = param
    self.showSlot = true
    self.equipData = nil
  else
    self.equipData = param
    self.showSlot = false
  end
  self:RefreshState()
  self:RefreshRedPoint()
  self:RefreshPercent()
end

local function SetLevelText(self, str)
  self.levelText:SetText(str)
end

function UILWSquadEquipItem:RefreshPercent()
  if self.equipData == nil then
    return
  end
  local config = self.equipData.config
  if config.upgrade_switch == 1 and config.target_id > 0 then
    local percentValue = math.floor(self.equipData.upgradePercent * 100)
    self.percent:SetText(string.format("%s%%", percentValue))
  end
  self.percentNode:SetActive(config.upgrade_switch == 1 and config.target_id > 0)
end

UILWSquadEquipItem.OnCreate = OnCreate
UILWSquadEquipItem.OnDestroy = OnDestroy
UILWSquadEquipItem.ComponentDefine = ComponentDefine
UILWSquadEquipItem.ComponentDestroy = ComponentDestroy
UILWSquadEquipItem.DataDefine = DataDefine
UILWSquadEquipItem.DataDestroy = DataDestroy
UILWSquadEquipItem.RefreshState = RefreshState
UILWSquadEquipItem.OnClick = OnClick
UILWSquadEquipItem.RefreshRedPoint = RefreshRedPoint
UILWSquadEquipItem.SetData = SetData
UILWSquadEquipItem.SetDataForMail = SetDataForMail
UILWSquadEquipItem.SetLevelText = SetLevelText
return UILWSquadEquipItem
