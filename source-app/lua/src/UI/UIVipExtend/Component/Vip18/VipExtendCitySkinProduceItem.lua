local VipExtendCitySkinProduceItem = BaseClass("VipExtendCitySkinProduceItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_player_head_path = "content/iconGameObject/UIPlayerHead"
local bubble_root_path = "content/bubbleRoot"
local making_root_path = "content/makingRoot"
local complete_root_path = "content/completeRoot"
local city_name_path = "content/cityName"
local city_icon_path = "content/completeRoot/cityIcon"
local city_btn_path = "content/cityBtn"

function VipExtendCitySkinProduceItem:OnCreate()
  base.OnCreate(self)
  self.city_name = self:AddComponent(UITextMeshProUGUIEx, city_name_path)
  self.making_root = self:AddComponent(UIBaseContainer, making_root_path)
  self.complete_root = self:AddComponent(UIBaseContainer, complete_root_path)
  self.bubble_root = self:AddComponent(UIBaseContainer, bubble_root_path)
  self.compUIPlayerHead = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.city_icon = self:AddComponent(UIImage, city_icon_path)
  self.city_btn = self:AddComponent(UIButton, city_btn_path)
  self.city_btn:SetOnClick(function()
    self:OnCityBtnClick()
  end)
end

function VipExtendCitySkinProduceItem:OnDestroy()
  self.compUIPlayerHead = nil
  self.city_name = nil
  self.making_root = nil
  self.complete_root = nil
  self.bubble_root = nil
  self.bubble_btn = nil
  self.city_icon = nil
  self.city_btn = nil
  base.OnDestroy(self)
end

function VipExtendCitySkinProduceItem:OnEnable()
  base.OnEnable(self)
end

function VipExtendCitySkinProduceItem:OnDisable()
  base.OnDisable(self)
end

function VipExtendCitySkinProduceItem:ReInit(param)
  self.skinInfo = param.data
  self.index = param.index
  self:Refresh()
end

function VipExtendCitySkinProduceItem:OnGetReward()
  self:Refresh()
end

function VipExtendCitySkinProduceItem:Refresh()
  if not self.skinInfo then
    return
  end
  local playerId = self.skinInfo.playerInfo.uid == "" and self.skinInfo.playerId or self.skinInfo.playerInfo.uid
  local isMyself = playerId == LuaEntry.Player.uid
  if isMyself then
    self.skinInfo = DataCenter.VipExtendManager:GetMyselfSkinInfo()
  end
  self.compUIPlayerHead:SetData("", "player_head_3", 0)
  if self.skinInfo.anonymity == 0 then
    if isMyself then
      self.compUIPlayerHead:SetAsMyself()
    else
      self.compUIPlayerHead:SetData(playerId, self.skinInfo.playerInfo.pic, self.skinInfo.playerInfo.picver)
    end
  end
  self.making_root.gameObject:SetActive(self.skinInfo.displayType == 1)
  self.complete_root.gameObject:SetActive(self.skinInfo.displayType == 2 or self.skinInfo.displayType == 3)
  local skinId = tonumber(self.skinInfo.displayPara2)
  local skinData = DataCenter.DecorationDataManager:GetSkinDataById(skinId)
  local skinTemplate = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  self.bubble_root.gameObject:SetActive(false)
  if skinTemplate ~= nil and skinTemplate.icon ~= nil and (self.skinInfo.displayType == 2 or self.skinInfo.displayType == 3) then
    self.city_icon:LoadSpriteAuto(skinTemplate.icon)
  end
  if skinTemplate ~= nil and skinTemplate.name ~= nil then
    self.city_name:SetLocalText(skinTemplate.name)
  else
    self.city_name:SetLocalText("decoration_name16003")
  end
  self.skinData = skinData
end

function VipExtendCitySkinProduceItem:OnCityBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIVipExtendCitySkinDetailShow, {anim = true}, self.skinInfo)
end

return VipExtendCitySkinProduceItem
