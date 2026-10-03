local UILWBagItem = BaseClass("UILWBagItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIHeroCellTiny = require("UI.UIHero2.Common.UIHeroCellTiny")
local LWEquipRankStar = require("UI.UILWHero.UIHeroEquipListPanel.Component.LWEquipRankStar")
local btn_path = "clickBtn"
local item_quality_path = "clickBtn/ImgQuality"
local item_icon_path = "clickBtn/ImgIcon"
local item_num_path = "clickBtn/NumText"
local red_img_path = "clickBtn/RedPoint"
local flag_go_path = "clickBtn/FlagGo"
local flag_text_path = "clickBtn/FlagGo/FlagText"
local redDot_path = "clickBtn/RedDot"
local equip_level_txt_path = "clickBtn/EquipLevelTxt"
local equip_type_icon_path = "clickBtn/EquipHeroTypeIcon"
local equiped_icon_path = "clickBtn/EquipedIcon"
local owner_path = "clickBtn/OwnerBg"
local owner_text_path = "clickBtn/OwnerBg/OwnerText"
local ownerHero_icon_path = "clickBtn/UIHeroCellTiny"
local equip_rankStar_path = "clickBtn/EquipRankStar"
local expired_icon_path = "clickBtn/expiredIcon"
local expired_path = "clickBtn/Expired"
local will_expire_path = "clickBtn/WillExpire"
local showFormatNumStrMoreThan = 10000

function UILWBagItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWBagItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBagItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btn = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_SelectGoods, false)
    self:OnBtnClick()
  end)
  self.item_quality = self.viewSkin:AddComponent(self, UIImage, 2)
  self.item_icon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.item_num = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.red_img = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.flag_go = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.flag_text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.redDot = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.equipLevelTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.equipTypeIcon = self.viewSkin:AddComponent(self, UIImage, 10)
  self.equipedIcon = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.ownerHeroIcon = self.viewSkin:AddComponent(self, UIHeroCellTiny, 12)
  self.equipRankStar = self.viewSkin:AddComponent(self, LWEquipRankStar, 13)
  self.owner = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.ownerText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.expiredRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.willExpireRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 17)
  self.btn.Mute = true
end

function UILWBagItem:ComponentDestroy()
  self.viewSkin = nil
  self.btn = nil
  self.item_quality = nil
  self.item_icon = nil
  self.item_num = nil
  self.red_img = nil
  self.flag_go = nil
  self.flag_text = nil
  self.redDot = nil
  self.equipLevelTxt = nil
  self.equipTypeIcon = nil
  self.equipedIcon = nil
  self.ownerHeroIcon = nil
  self.equipRankStar = nil
  self.owner = nil
  self.ownerText = nil
  self.expiredRoot = nil
  self.willExpireRoot = nil
end

function UILWBagItem:DataDefine()
  self.param = {}
  self.type = nil
  self.index = nil
  self.callBack = nil
end

function UILWBagItem:DataDestroy()
  self.param = nil
  self.type = nil
  self.index = nil
  self.callBack = nil
end

function UILWBagItem:OnEnable()
  base.OnEnable(self)
end

function UILWBagItem:OnDisable()
  base.OnDisable(self)
end

function UILWBagItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWBagItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWBagItem:SetData(params)
  self.param = params.data
  self.type = params.type
  self.index = params.index
  self.callBack = params.callBack
  self.showRedPoint = params.showRedPoint
  self.equipLevelTxt:SetActive(false)
  self.equipTypeIcon:SetActive(false)
  self.flag_go:SetActive(false)
  self.redDot:SetActive(false)
  self.equipRankStar:SetActive(false)
  self.owner:SetActive(false)
  self.ownerHeroIcon:SetActive(false)
  self.item_num:SetAnchoredPositionXY(-80.85, 32.5)
  if self.expiredRoot then
    self.expiredRoot:SetActive(false)
  end
  if self.willExpireRoot then
    self.willExpireRoot:SetActive(false)
  end
  if self.type == BagItemType.Item or self.type == BagItemType.ResourceItem then
    self.flag_go:SetActive(true)
    self:RefreshNormalItem()
  elseif self.type == BagItemType.HeroEquip then
    self.equipTypeIcon:SetActive(true)
    self:RefreshEquipItem()
  elseif self.type == BagItemType.CommonEquip then
    self:RefreshCommonEquipItem()
  end
end

function UILWBagItem:RefreshNormalItem()
  self.item_quality:LoadSprite(self.param.quality_name)
  if string.IsNullOrEmpty(self.param.icon_full_path) then
    if not string.IsNullOrEmpty(self.param.icon_name) then
      if string.sub(self.param.icon_name, 1, 7) == "Assets/" then
        self.item_icon:LoadSprite(self.param.icon_name)
      else
        self.item_icon:LoadSprite(string.format(LoadPath.ItemPath, self.param.icon_name))
      end
    end
  else
    self.item_icon:LoadSprite(self.param.icon_full_path)
  end
  if self.param.num ~= nil then
    self.item_num:SetText(self.param.num)
  else
    self:RefreshNum()
  end
  if not string.IsNullOrEmpty(self.param.flagtxt) then
    self.flag_go:SetActive(true)
    self.flag_text:SetText(self.param.flagtxt)
  else
    self.flag_go:SetActive(false)
  end
  self:RedDotRefresh(self.param.redState)
  if self.expiredRoot then
    local isItemExpired = UIUtil.CheckItemIsExpired(self.param.itemId)
    local showExpired = isItemExpired
    self.expiredRoot:SetActive(showExpired)
  end
  if self.willExpireRoot then
    local showExpired = UIUtil.IsShowWillExpired(tonumber(self.param.itemId), true)
    self.willExpireRoot:SetActive(showExpired)
  end
end

function UILWBagItem:RefreshNum()
  local curNum = 0
  local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self.param.itemId)
  if itemData ~= nil then
    self.uuid = itemData.uuid
    curNum = itemData.number
  end
  if curNum >= showFormatNumStrMoreThan then
    self.item_num:SetText(string.GetFormattedStr(curNum))
  else
    self.item_num:SetText(string.GetFormattedSeperatorNum(curNum))
  end
end

function UILWBagItem:RedDotRefresh(state, isClick)
  if not self.param.template then
    return
  end
  if self.param.template.important == 1 and self.param.newCount and self.param.newCount > 0 then
    if isClick then
      local item = DataCenter.ItemData:GetItemById(self.param.itemId)
      if item then
        item:SetNewCount()
      end
      self.red_img:SetActive(false)
    else
      self.red_img:SetActive(true)
    end
    return
  end
  if self.param.template and self.param.template.important == 2 then
    self.red_img:SetActive(not state)
    if isClick then
      DataCenter.ItemData:SetItemRed(self.param.data.uuid)
    end
    return
  end
  self.red_img:SetActive(false)
end

function UILWBagItem:RefreshEquipItem()
  local equipData = self.param
  local config = equipData.config
  self.item_quality:LoadSprite(UIUtil.GetItemQualityBg(config.quality))
  self.item_icon:LoadSprite(string.format(LoadPath.ItemPath, config.icon))
  local equipTypeIconPath = HeroUtils.GetHeroTypeIcon(config.heroType)
  if not string.IsNullOrEmpty(equipTypeIconPath) then
    self.equipTypeIcon:SetActive(true)
    self.equipTypeIcon:LoadSprite(equipTypeIconPath)
  else
    self.equipTypeIcon:SetActive(false)
  end
  local un_equip = not equipData:IsBeingWeared()
  if not un_equip then
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(equipData.heroUuid)
    if heroData then
      self.ownerHeroIcon:SetActive(true)
      self.ownerHeroIcon:SetData(heroData.heroId, heroData.quality, nil, heroData.uniqueWeaponLv, nil, heroData:GetSkinId())
    end
  end
  self.item_num:SetText(equipData.num or "")
  self.red_img:SetActive(false)
  if equipData.promoteLevel > 0 and DataCenter.EquipDataManager:CheckRedEquipOpen() then
    self.equipRankStar:SetActive(true)
    self.equipRankStar:ShowRank(equipData.promoteLevel, equipData.maxPromoteLevel)
    self.item_num:SetAnchoredPositionXY(-8, 63.5)
  else
    self.equipRankStar:SetActive(false)
  end
  if config.quality > 2 then
    self.equipLevelTxt:SetActive(true)
    self.equipLevelTxt:SetText("Lv." .. tostring(equipData.level))
  else
    self.equipLevelTxt:SetActive(false)
  end
end

function UILWBagItem:RefreshCommonEquipItem()
  local equipData = self.param
  local quality = equipData:GetConfigQuality()
  self.item_quality:LoadSprite(UIUtil.GetItemQualityBg(quality))
  self.item_icon:LoadSprite(equipData:GetConfigIcon())
  self.item_num:SetText(equipData.num or "")
  self.red_img:SetActive(false)
  self.equipLevelTxt:SetActive(true)
  self.equipLevelTxt:SetText("Lv." .. tostring(equipData:GetConfigLevel()))
  local isBeingWeared = equipData:IsBeingWeared()
  if isBeingWeared then
    self.owner:SetActive(true)
  else
    self.owner:SetActive(false)
  end
end

function UILWBagItem:OnBtnClick()
  if self.callBack ~= nil then
    if self.showRedPoint then
      if not self.param.redState and self.type == 1 then
        self:RedDotRefresh(true, true)
        self.view:RedReference(self.index)
      end
      self:RedDotRefresh(true, true)
    end
    self.callBack(self.transform, self.index)
  end
end

return UILWBagItem
