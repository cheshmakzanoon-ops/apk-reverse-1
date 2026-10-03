local AllianceCityRankRewardCell = BaseClass("AllianceCityRankRewardCell", UIBaseContainer)
local base = UIBaseContainer

function AllianceCityRankRewardCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllianceCityRankRewardCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function AllianceCityRankRewardCell:OnEnable()
  base.OnEnable(self)
end

function AllianceCityRankRewardCell:OnDisable()
  base.OnDisable(self)
end

function AllianceCityRankRewardCell:ComponentDefine()
  self.leaderHeadIconN = self:AddComponent(UICommonHead, "leaderHead1")
  self.nameText = self:AddComponent(UIText, "Name")
  self.dmgText = self:AddComponent(UIText, "Dmg")
  self.selfBg = self:AddComponent(UIBaseContainer, "SelfBg")
  self.selfBg:SetActive(false)
  local root_path_pattern = "content_reward/p_item_reward_%s"
  local icon_path_pattern = "content_reward/p_item_reward_%s/p_img_reward_icon_%s"
  local count_path_pattern = "content_reward/p_item_reward_%s/p_text_reward_count_%s"
  self.content_reward = self:AddComponent(UIBaseContainer, "content_reward")
  self.p_comp_reward = {}
  for i = 1, 2 do
    self.p_comp_reward[i] = {}
    self.p_comp_reward[i].Root = self:AddComponent(UIBaseContainer, string.format(root_path_pattern, i))
    self.p_comp_reward[i].Icon = self:AddComponent(UIImage, string.format(icon_path_pattern, i, i))
    self.p_comp_reward[i].Count = self:AddComponent(UITextMeshProUGUIEx, string.format(count_path_pattern, i, i))
  end
end

function AllianceCityRankRewardCell:ComponentDestroy()
  self.content_reward = nil
  self.p_comp_reward = nil
end

function AllianceCityRankRewardCell:DataDefine()
end

function AllianceCityRankRewardCell:DataDestroy()
end

function AllianceCityRankRewardCell:RefreshData(leaderInfo, dmg, rewardList)
  self.leaderHeadIconN:SetData(leaderInfo.uid, leaderInfo.pic, leaderInfo.picVer)
  self.nameText:SetText(leaderInfo.name)
  self.dmgText:SetText(string.GetFormattedGoldNum(dmg))
  self.selfBg:SetActive(leaderInfo.uid == LuaEntry.Player.uid)
  for i = 1, 2 do
    if i <= table.count(rewardList) then
      self.p_comp_reward[i].Root:SetActive(true)
      local reward = rewardList[i]
      if reward.type ~= nil and reward.type.value ~= nil then
        local rewardType = checknumber(reward.type.value)
        local id = reward.id ~= nil and checknumber(reward.id.value) or 0
        local img = DataCenter.RewardManager:GetPicByType(rewardType, id)
        if not string.IsNullOrEmpty(img) then
          self.p_comp_reward[i].Icon:LoadSpriteAsync(img)
        end
      end
      if reward.num ~= nil and reward.num.value ~= nil then
        self.p_comp_reward[i].Count:SetText(string.GetFormattedSeparatorNum(reward.num.value))
      end
    else
      self.p_comp_reward[i].Root:SetActive(false)
    end
  end
end

return AllianceCityRankRewardCell
