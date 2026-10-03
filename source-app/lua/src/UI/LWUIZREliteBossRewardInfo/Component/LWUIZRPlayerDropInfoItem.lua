local LWUIZRPlayerDropInfoItem = BaseClass("LWUIZRPlayerDropInfoItem", UIBaseContainer)
local base = UIBaseContainer
local GENDER_IMG_PATH = "Assets/Main/Sprites/UI/UILWAlliance/"
local bg_path = "Bg"
local player_head_path = "PlayerHead"
local player_level_text_path = "HorLayout/PlayerLevelText"
local player_gender_icon_path = "HorLayout/PlayerLevelText/PlayerGenderIcon"
local player_name_text_path = "PlayerNameText"
local content_path = "RewardScroll/Content"
local u_i_common_res_item_path = "UICommonResItem"

function LWUIZRPlayerDropInfoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUIZRPlayerDropInfoItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIZRPlayerDropInfoItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.player_level_text = self:AddComponent(UITextMeshProUGUIEx, player_level_text_path)
  self.player_gender_icon = self:AddComponent(UIImage, player_gender_icon_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.reward_item = self.transform:Find(u_i_common_res_item_path).gameObject
  self.reward_item:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function LWUIZRPlayerDropInfoItem:ComponentDestroy()
  self.bg = nil
  self.player_head = nil
  self.player_level_text = nil
  self.player_gender_icon = nil
  self.player_name_text = nil
  self.content:RemoveComponents(UICommonResItem)
  self.reward_item:GameObjectRecycleAll()
  self.reward_item = nil
end

function LWUIZRPlayerDropInfoItem:ReInit(data)
  self.data = data
  if data == nil then
    return
  end
  if data.uid == LuaEntry.Player.uid then
    self.bg:SetColorRGBA(0.6862, 1, 0.3725, 0.5019)
  else
    self.bg:SetColorRGBA(1, 1, 1, 0.5)
  end
  self.player_head:SetHeadAndFrame(data.uid, data.headPic, data.headPicVer, nil, data.headSkinId, data.headSkinET)
  self.player_level_text:SetLocalText(300665, data.level)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.uid, data.name)
  self.player_name_text:SetText(showName)
  if data.gender == 0 or data.gender == 3 then
    self.player_gender_icon:SetActive(false)
  else
    self.player_gender_icon:SetActive(true)
    self.player_gender_icon:LoadSprite(GENDER_IMG_PATH .. (data.gender == 2 and "cfm_lianmeng_tubiao_nv" or "cfm_lianmeng_tubiao_nan"))
  end
  local rewardList = data.reward
  local showList = {}
  for _, v in ipairs(rewardList) do
    if v and v.value then
      local item = {
        rewardType = v.type,
        itemId = v.value.id,
        count = v.value.num
      }
      table.insert(showList, item)
    end
  end
  self:RefreshReward(showList)
end

function LWUIZRPlayerDropInfoItem:RefreshReward(rewardList)
  if not table.IsNullOrEmpty(rewardList) then
    local goItem, theItem
    for i, data in pairs(rewardList) do
      goItem = self.reward_item:GameObjectSpawn(self.content.transform)
      goItem.name = "item_" .. i
      goItem:SetActive(true)
      theItem = self.content:AddComponent(UICommonResItem, goItem.name)
      theItem:ReInit(data)
    end
  end
end

return LWUIZRPlayerDropInfoItem
