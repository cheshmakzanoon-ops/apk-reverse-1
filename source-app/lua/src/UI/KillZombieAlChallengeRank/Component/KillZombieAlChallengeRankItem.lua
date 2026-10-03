local base = require("UI.KillZombieAlChallengeRank.Component.KillZombieAlChallengeRankItemBase")
local KillZombieAlChallengeRankItem = BaseClass("KillZombieAlChallengeRankItem", base)
local UICommonHorseLampTMP = require("UI.UICommonTMPHorseRaceLamp.Component.UICommonHorseLampTMP")
local bg_path = "bg"
local power_path = "powerTxt"
local num_path = "numTxt"
local num_txt2_path = "numTxt2"
local first_flag_path = "firstImg"
local second_flag_path = "secondImg"
local third_flag_path = "thirdImg"
local player_flag_path = "UIPlayerHead"
local name_path = "Name"
local guarantee_root_path = "GuaranteeRoot"
local icon_path = "GuaranteeRoot/Icon"
local tag_text_path = "GuaranteeRoot/TagText"
local click_path = "Click"
local REACHED_COLOR = "#FFD66B"
local NOT_REACHED_COLOR = "#CCC8C6"
local QUALITY_ICON_PATH = {
  "Assets/Main/Sprites/UI/UIDispatchTask/FX_YMJDD_tanxiaanbaoxiang_baoxiang01.png",
  "Assets/Main/Sprites/UI/UIDispatchTask/FX_YMJDD_tanxiaanbaoxiang_baoxiang02.png",
  "Assets/Main/Sprites/UI/UIDispatchTask/FX_YMJDD_tanxiaanbaoxiang_baoxiang03.png",
  "Assets/Main/Sprites/UI/UIDispatchTask/FX_YMJDD_tanxiaanbaoxiang_baoxiang06.png",
  "Assets/Main/Sprites/UI/UIDispatchTask/FX_YMJDD_tanxiaanbaoxiang_baoxiang04.png",
  "Assets/Main/Sprites/UI/UIDispatchTask/FX_YMJDD_tanxiaanbaoxiang_baoxiang05.png"
}

function KillZombieAlChallengeRankItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
end

function KillZombieAlChallengeRankItem:OnDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function KillZombieAlChallengeRankItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.power_txt = self:AddComponent(UITextMeshProUGUIEx, power_path)
  self.num_txt = self:AddComponent(UITextMeshProUGUIEx, num_path)
  self.num_txt2 = self:AddComponent(UITextMeshProUGUIEx, num_txt2_path)
  self.first_flag = self:AddComponent(UIBaseContainer, first_flag_path)
  self.second_flag = self:AddComponent(UIBaseContainer, second_flag_path)
  self.third_flag = self:AddComponent(UIBaseContainer, third_flag_path)
  self.player_flag = self:AddComponent(UICommonHead, player_flag_path)
  self.name = self:AddComponent(UICommonHorseLampTMP, name_path)
  self.guarantee_root = self:AddComponent(UIButton, guarantee_root_path)
  self.guarantee_root:SetOnClick(function()
    self:OnGuaranteeBtnClick()
  end)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.tag_text = self:AddComponent(UITextMeshProUGUIEx, tag_text_path)
  self.click = self:AddComponent(UIButton, click_path)
  self.click:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  end)
end

function KillZombieAlChallengeRankItem:ComponentDestroy()
  base.ComponentDestroy(self)
  self.name = nil
  self.guarantee_root = nil
  self.icon = nil
  self.tag_text = nil
  self.click = nil
end

function KillZombieAlChallengeRankItem:DataDefine()
  self.complete = nil
  self.bossId = nil
  self.quality = nil
  self.sizeY = nil
  self.rewardTitle = nil
end

function KillZombieAlChallengeRankItem:DataDestroy()
  self.complete = nil
  self.bossId = nil
  self.quality = nil
  self.sizeY = nil
  self.rewardTitle = nil
end

function KillZombieAlChallengeRankItem:SetItemShow(data)
  local isSelf = data.isSelf
  local bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png"
  local rank = data.rank
  if isSelf then
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5.png"
  elseif rank == 1 then
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png"
  elseif rank == 2 then
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png"
  elseif rank == 3 then
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png"
  end
  self.data = data
  local complete = data.complete
  self:SetGuaranteeIcon(rank, complete)
  self.complete = complete
  self.rewardData = nil
  self.player_flag:SetActive(true)
  self.player_flag:ParseHeadInfo(data.roleInfo)
  if type(rank) == "number" and 0 < rank then
    if 3 < rank then
      self.num_txt:SetText("")
      self.num_txt2:SetText(rank)
    else
      self.num_txt:SetText(rank)
      self.num_txt2:SetText("")
    end
  else
    self.num_txt:SetText("")
    self.num_txt2:SetLocalText("challenge_zombie_no_rank")
  end
  self.bg:LoadSpriteAuto(bgPath)
  self.first_flag:SetActive(rank == 1)
  self.second_flag:SetActive(rank == 2)
  self.third_flag:SetActive(rank == 3)
  local score = string.GetFormattedGiga2(data.score)
  self.power_txt:SetText(score)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.roleInfo.uid, data.roleInfo.name)
  local name = showName
  self.name:SetTextWithLength(name, 150)
end

function KillZombieAlChallengeRankItem:SetGuaranteeIcon(rank, complete)
  if rank == nil or rank == 0 then
    self.guarantee_root:SetActive(false)
    return
  end
  self.guarantee_root:SetActive(true)
  local newAlData = DataCenter.ActivityKillZombieManager.newAlData
  local bossId = newAlData and newAlData.bossId
  self.bossId = bossId
  local data = bossId and DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(bossId)
  local quality = 0
  if data then
    local info = data:GetBoxRewardSure()
    if info then
      for _, v in ipairs(info) do
        if v and #v == 3 then
          local r = v[1]
          local q = v[3]
          quality = q
          if rank <= r then
            break
          end
        end
      end
      if 0 < quality and quality <= 6 then
        local path = QUALITY_ICON_PATH[quality]
        self.icon:LoadSpriteAuto(path)
      end
    end
  end
  if complete then
    self.tag_text:SetColorHex(REACHED_COLOR)
    self.tag_text:SetLocalText("challenge_zombie_quality_true")
  else
    self.tag_text:SetColorHex(NOT_REACHED_COLOR)
    self.tag_text:SetLocalText("challenge_zombie_quality_false")
  end
  self.quality = quality
end

function KillZombieAlChallengeRankItem:OnGuaranteeBtnClick()
  if self.complete then
    if self.rewardData == nil and self.bossId then
      local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(self.bossId)
      local boxReward = template and template:GetBoxReward()
      if boxReward and self.quality and self.quality <= #boxReward then
        local reward = boxReward[self.quality]
        local rewardId = reward and reward.rewardId
        local rewardData = rewardId and DataCenter.RewardTemplateManager:GetList(rewardId)
        self.rewardData = rewardData
      end
    end
    if self.rewardData and #self.rewardData > 0 then
      if self.sizeY == nil then
        local size = self.guarantee_root:GetSizeDelta()
        self.sizeY = size.y / 2 - 10
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardContentTip, {anim = true}, self.guarantee_root, self.rewardData, 0, self.sizeY or 0, nil, true)
    end
  else
    if self.rewardTitle == nil or self.rewardTitle == "" then
      self.rewardTitle = CS.GameEntry.Localization:GetString("challenge_zombie_quality_2")
    end
    if self.rewardTitle then
      UIUtil.ShowBubbleTips(self.rewardTitle, self.guarantee_root.transform.position, 0, -50, 0)
    end
  end
end

return KillZombieAlChallengeRankItem
