local UILWActDetectEventTreasureClaimInfoPlayerItemRender = BaseClass("UILWActDetectEventTreasureClaimInfoPlayerItemRender", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local player_head_path = "PlayerHead"
local player_level_text_path = "HorLayout/PlayerLevelText"
local player_gender_icon_path = "HorLayout/PlayerLevelText/PlayerGenderIcon"
local player_name_text_path = "PlayerNameText"
local speed_text_path = "SpeedText"
local double_mark_path = "DoubleMark"
local speed_tips_text_path = "SpeedTipsText"
local reward_content_path = "RewardScroll/Content"

function UILWActDetectEventTreasureClaimInfoPlayerItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWActDetectEventTreasureClaimInfoPlayerItemRender:OnDestroy()
  self:ClearContent()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWActDetectEventTreasureClaimInfoPlayerItemRender:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.player_level_text = self:AddComponent(UITextMeshProUGUIEx, player_level_text_path)
  self.player_gender_icon = self:AddComponent(UIImage, player_gender_icon_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.speed_text = self:AddComponent(UITextMeshProUGUIEx, speed_text_path)
  self.double_mark = self:AddComponent(UIImage, double_mark_path)
  self.speed_tips_text = self:AddComponent(UITextMeshProUGUIEx, speed_tips_text_path)
  self.speed_tips_text:SetLocalText("radar_title_3")
  self.itemReqs = {}
  self.itemList = {}
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
end

function UILWActDetectEventTreasureClaimInfoPlayerItemRender:ComponentDestroy()
  self.bg = nil
  self.player_head = nil
  self.player_level_text = nil
  self.player_gender_icon = nil
  self.player_name_text = nil
  self.speed_text = nil
  self.double_mark = nil
  self.speed_tips_text = nil
end

function UILWActDetectEventTreasureClaimInfoPlayerItemRender:ClearContent()
  if table.count(self.itemList) > 0 then
    self.rewardContent:RemoveComponents(UICommonResItem)
    self.itemList = {}
  end
  if table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      req:Destroy()
    end
    self.itemReqs = {}
  end
end

function UILWActDetectEventTreasureClaimInfoPlayerItemRender:ReInit(data)
  self.data = data
  if self.data.uid == LuaEntry.Player.uid then
    self.bg:SetColorRGBA(0.6862, 1, 0.3725, 0.5019)
  else
    self.bg:SetColorRGBA(1, 1, 1, 0.5)
  end
  self.player_head:SetHeadAndFrame(self.data.uid, self.data.headPic, self.data.headPicVer, nil, self.data.headSkinId, self.data.headSkinET)
  self.player_level_text:SetText("Lv." .. self.data.level)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.uid, self.data.name)
  self.player_name_text:SetText(showName)
  self.double_mark:SetActive(self.data.isBigReward)
  if self.data.gender == 0 or self.data.gender == 3 then
    self.player_gender_icon:SetActive(false)
  else
    self.player_gender_icon:SetActive(true)
    local gender_img_path = "Assets/Main/Sprites/UI/UILWAlliance/"
    self.player_gender_icon:LoadSprite(gender_img_path .. (self.data.gender == 2 and "cfm_lianmeng_tubiao_nv" or "cfm_lianmeng_tubiao_nan"))
  end
  local seconds = self.data.costTime / 1000
  if 60 <= seconds then
    self.speed_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(self.data.costTime))
  else
    local str = string.format("%.2f", seconds)
    self.speed_text:SetText(Localization:GetString("130076", str))
  end
  local rewardStr = self.data.reward
  local rewardList = {}
  if not string.IsNullOrEmpty(rewardStr) then
    rewardList = string.string2array_i(rewardStr, ";", "|")
  end
  local showList = {}
  for k, v in ipairs(rewardList) do
    if #v == 3 and v[1] == RewardType.GOODS then
      local item = {
        rewardType = v[1],
        itemId = v[2],
        count = v[3]
      }
      table.insert(showList, item)
    end
  end
  self:RefreshReward(showList)
end

function UILWActDetectEventTreasureClaimInfoPlayerItemRender:RefreshReward(rewardList)
  self:ClearContent()
  if not table.IsNullOrEmpty(rewardList) then
    for i, data in pairs(rewardList) do
      local req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "reward_item" .. i
        item:SetActive(true)
        item.transform:SetParent(self.rewardContent.transform)
        item.transform:Set_localScale(0.8, 0.8, 1)
        item.transform:Set_sizeDelta(118, 118)
        item.transform:Set_pivot(0.5, 0.5)
        local cell = self.rewardContent:AddComponent(UICommonResItem, item.name)
        cell:ReInit(data)
        table.insert(self.itemList, cell)
      end)
      table.insert(self.itemReqs, req)
    end
  end
end

return UILWActDetectEventTreasureClaimInfoPlayerItemRender
