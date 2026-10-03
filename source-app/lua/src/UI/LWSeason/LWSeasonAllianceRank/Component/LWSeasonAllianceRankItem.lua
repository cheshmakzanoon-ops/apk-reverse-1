local LWSeasonAllianceRankItem = BaseClass("LWSeasonAllianceRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local first_name_path = "Name/firstNameTxt"
local power_path = "powerTxt"
local num_path = "numTxt"
local first_flag_path = "firstImg"
local second_flag_path = "secondImg"
local third_flag_path = "thirdImg"
local player_flag_path = "player"
local bg_path = "bg"
local reward_path = "Reward"
local reward_num_path = "Reward/num"

function LWSeasonAllianceRankItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.first_txt = self:AddComponent(UIText, first_name_path)
  self.power_txt = self:AddComponent(UIText, power_path)
  self.rank_num_txt = self:AddComponent(UIText, num_path)
  self.first_flag = self:AddComponent(UIBaseContainer, first_flag_path)
  self.second_flag = self:AddComponent(UIBaseContainer, second_flag_path)
  self.third_flag = self:AddComponent(UIBaseContainer, third_flag_path)
  self.player_flag = self:AddComponent(UICommonHead, player_flag_path)
  self.player_flag:SetEnableClickShowInfo(true, true)
  self.rewardBtn = self:AddComponent(UIButton, reward_path)
  self.rewardBtn:SetOnClick(function()
    self:RewardBtnClick()
  end)
  self.rewardCount = self:AddComponent(UIText, reward_num_path)
end

function LWSeasonAllianceRankItem:SetItemShow(data, parentData, isSelf, subType)
  self.subType = subType
  self.isSelf = isSelf
  local power_color = "#2a2830"
  local first_color = "#2a2830"
  local second_color = "#6d82ad"
  self.parentData = parentData
  local bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao"
  if data.isAlliance and LuaEntry.Player.allianceId == data.uid or data.uid == LuaEntry.Player.uid then
    power_color = "#4a9327"
    first_color = "#4a9327"
    second_color = "#14a91b"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao"
  elseif data.rank == 1 then
    power_color = "#d07b0c"
    first_color = "#d07b0c"
    second_color = "#b78026"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao"
  elseif data.rank == 2 then
    power_color = "#6674ba"
    first_color = "#6674ba"
    second_color = "#5065cb"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao"
  elseif data.rank == 3 then
    power_color = "#b77758"
    first_color = "#b77758"
    second_color = "#ba6744"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao"
  end
  self.data = data
  local headFrame = self.data.headFrame
  headFrame = headFrame or self.data:GetHeadBgImg()
  self.player_flag:SetHead(self.data.uid, self.data.pic, self.data.picVer, nil, headFrame)
  if type(self.data.rank) == "number" and self.data.rank > 0 then
    self.rank_num_txt:SetText(self.data.rank)
  else
    self.rank_num_txt:SetText(CS.GameEntry.Localization:GetString("361054"))
  end
  if self.isSelf then
    CS.UIGray.SetGray(self.rewardBtn.transform, false, true)
  else
    local flag = DataCenter.AllianceBaseDataManager:IsR4orR5()
    CS.UIGray.SetGray(self.rewardBtn.transform, not flag, true)
  end
  self.bg:LoadSprite(bgPath)
  self.first_flag:SetActive(self.data.rank == 1)
  self.second_flag:SetActive(self.data.rank == 2)
  self.third_flag:SetActive(self.data.rank == 3)
  self.power_txt:SetText("<color=" .. power_color .. ">" .. string.GetFormattedSeparatorNum(self.data.score) .. "</color>")
  self.rewardCount:SetText(self.data.lootNum)
  local firstName = self.data:GetShowName()
  self.first_txt:SetText("<color=" .. first_color .. ">" .. firstName .. "</color>")
end

function LWSeasonAllianceRankItem:OnDestroy()
  self.first_txt = nil
  self.second_txt = nil
  self.power_txt = nil
  self.server_txt = nil
  self.rank_num_txt = nil
  self.first_flag = nil
  self.second_flag = nil
  self.third_flag = nil
  self.player_flag = nil
  base.OnDestroy(self)
end

function LWSeasonAllianceRankItem:RewardBtnClick()
  if self.isSelf and self.subType then
    local tip
    if self.subType == 1 then
      if self.data.lootNum > 0 then
        tip = Localization:GetString("season_tips132", self.data.lootNum)
      else
        tip = Localization:GetString("season_tips129")
      end
    elseif self.subType == 2 then
      if self.data.lootNum > 0 then
        tip = Localization:GetString("season_tips133", self.data.lootNum)
      else
        tip = Localization:GetString("season_tips130")
      end
    elseif self.subType == 3 then
      if self.data.lootNum > 0 then
        tip = Localization:GetString("season_tips134", self.data.lootNum)
      else
        tip = Localization:GetString("season_tips131")
      end
    end
    UIUtil.ShowTips(tip)
    return
  end
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    local str = Localization:GetString("season_tips140")
    UIUtil.ShowTips(str)
    return
  end
  local lootNum = DataCenter.SeasonAllianceRankDataManager:GetLootTotal()
  if lootNum == 0 then
    local str = Localization:GetString("season_tips139")
    UIUtil.ShowTips(str)
    return
  end
  if self:CheckMemberValidity(self.data.uid) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonDistributeReward, {anim = false}, {
      max = DataCenter.SeasonAllianceRankDataManager:GetLootTotal(),
      min = 1,
      defaultValue = 1,
      parentData = self
    })
  else
    local str = Localization:GetString("season_alliance_reward_tips002", self.data.name)
    UIUtil.ShowTips(str)
  end
end

function LWSeasonAllianceRankItem:CheckMemberValidity(uid)
  if not uid then
    return false
  end
  local member = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid)
  return member ~= nil
end

function LWSeasonAllianceRankItem:DistributeReward(count)
  local rankInfo = self.parentData:GetRankInfo()
  SFSNetwork.SendMessage(MsgDefines.LWSeasonAllianceDevotesAllocation, rankInfo.eventId, rankInfo.subType, self.data.uid, count)
end

return LWSeasonAllianceRankItem
