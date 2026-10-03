local Localization = CS.GameEntry.Localization
local base = UIBaseContainer
local CityAttachmentBuildDetail = BaseClass("CityAttachmentBuildDetail", base)
local LWSeasonAllianceTipsItem = require("UI.LWSeason.LWSeasonAllianceRank.Component.LWSeasonAllianceTipsItem")
local pop_up_bg_path = "PopUpBg"
local img_arrow1_path = "imgArrow1"
local img_arrow2_path = "imgArrow2"
local img_arrow3_path = "imgArrow3"
local title_path = "title"
local res_num_path = "GameObject/ResNum"
local res_value_path = "GameObject/ResValue"
local mem_num_path = "GameObject/MemNum"
local mem_value_path = "GameObject/MemValue"
local has_reward_path = "HasReward"
local reward_tip_path = "HasReward/RewardTip"
local reward_icon_path = "HasReward/RewardIcon"
local reward_value_path = "HasReward/RewardValue"
local effect_text_path = "effectText"
local no_reward_path = "NoReward"
local no_reward_tip_path = "NoReward/NoRewardTip"
local tip_root_path = "HasReward/RewardIcon/TipRoot"
local btn_close_tip_path = "HasReward/RewardIcon/TipRoot/BtnCloseTip"
local tip_box_title_root_path = "HasReward/RewardIcon/TipRoot/TipBox/Title"
local tip_box_title_path = "HasReward/RewardIcon/TipRoot/TipBox/Title/TipBoxTitle"
local tip_box_icon_path = "HasReward/RewardIcon/TipRoot/TipBox/Title/TipBoxIcon"
local tip_box_content_path = "HasReward/RewardIcon/TipRoot/TipBox/ScrollView/Viewport/TipBoxContent"
local tip_box_item_path = "HasReward/RewardIcon/TipRoot/TipBox/ScrollView/Viewport/TipBoxContent/TipBoxItem"

function CityAttachmentBuildDetail:OnCreate()
  base.OnCreate(self)
  self.pop_up_bg = self:AddComponent(UIButton, pop_up_bg_path)
  self.img_arrow1 = self:AddComponent(UIImage, img_arrow1_path)
  self.img_arrow2 = self:AddComponent(UIImage, img_arrow2_path)
  self.img_arrow3 = self:AddComponent(UIImage, img_arrow3_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.res_num = self:AddComponent(UITextMeshProUGUIEx, res_num_path)
  self.res_value = self:AddComponent(UITextMeshProUGUIEx, res_value_path)
  self.mem_num = self:AddComponent(UITextMeshProUGUIEx, mem_num_path)
  self.mem_value = self:AddComponent(UITextMeshProUGUIEx, mem_value_path)
  self.reward_tip = self:AddComponent(UITextMeshProUGUIEx, reward_tip_path)
  self.reward_icon = self:AddComponent(UIButton, reward_icon_path)
  self.reward_value = self:AddComponent(UITextMeshProUGUIEx, reward_value_path)
  self.has_reward_root = self:AddComponent(UIBaseContainer, has_reward_path)
  self.no_reward_root = self:AddComponent(UIBaseContainer, no_reward_path)
  self.no_reward_tip = self:AddComponent(UITextMeshProUGUIEx, no_reward_tip_path)
  self.content = self:AddComponent(UIBaseContainer, "")
  self.pop_up_bg:SetOnClick(function()
    self:SetActive(false)
  end)
  self.tip_root = self:AddComponent(UICanvasGroup, tip_root_path)
  self.btn_close_tip = self:AddComponent(UIButton, btn_close_tip_path)
  self.tip_root:SetActive(false)
  self.tip_box_title_root = self:AddComponent(UIBaseComponent, tip_box_title_root_path)
  self.tip_box_title = self:AddComponent(UIText, tip_box_title_path)
  self.tip_box_icon = self:AddComponent(UIImage, tip_box_icon_path)
  self.tip_box_content = self:AddComponent(UIBaseContainer, tip_box_content_path)
  self.tipBoxTemplate = self.transform:Find(tip_box_item_path).gameObject
  self.tipBoxTemplate:GameObjectCreatePool()
  self.btn_close_tip:SetOnClick(function()
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(self.tip_root:FadeOut(0.2))
    sequence:Join(self.tip_root.transform:DOScale(Vector3.New(0.9, 0, 0.9), 0.2))
    sequence:AppendCallback(function()
      if self.tip_root then
        self.tip_root:SetActive(false)
      end
    end)
  end)
  self.reward_icon:SetOnClick(function()
    if self.tip_root:GetActive() and self.tip_root:GetAlpha() ~= 0 then
      return
    end
    self.tip_root:SetAlpha(0)
    self.tip_root:SetActive(true)
    self:InitRewardTips()
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(self.tip_root:FadeIn(0.2))
    sequence:Join(self.tip_root.transform:DOScale(Vector3.New(0.9, 0.9, 0.9), 0.2))
  end)
  self.theEffectItem = self.transform:Find(effect_text_path).gameObject
  self.theEffectItem:GameObjectCreatePool()
end

function CityAttachmentBuildDetail:OnDestroy()
  self.tip_box_content:RemoveComponents(LWSeasonAllianceTipsItem)
  self.tipBoxTemplate:GameObjectRecycleAll()
  self.content:RemoveComponents(UITextMeshProUGUIEx)
  self.theEffectItem:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function CityAttachmentBuildDetail:ShowDetail(slotIndex, buildCfg, cityCfg, slotHasFirst)
  local cfg = buildCfg
  self:SetActive(true)
  self.img_arrow1:SetActive(slotIndex == 1)
  self.img_arrow2:SetActive(slotIndex == 2)
  self.img_arrow3:SetActive(slotIndex == 3)
  self.has_reward_root:SetActive(slotHasFirst)
  self.no_reward_root:SetActive(slotHasFirst ~= true)
  self.no_reward_tip:SetText(Localization:GetString("season_builders_alliance_UI_84") .. ": " .. Localization:GetString("season_builders_alliance_UI_85"))
  self.title:SetLocalText(cfg.name)
  self.res_num:SetLocalText("season_builders_alliance_UI_63")
  self.res_value:SetText(string.GetFormattedSeparatorNum(cfg.cost))
  self.mem_num:SetLocalText("season_builders_alliance_UI_64")
  self.mem_value:SetText(string.GetFormattedSeparatorNum(cfg.persons_num))
  self.reward_value:SetText("\195\151" .. cityCfg:GetChestNumBySlot(slotIndex))
  self.content:RemoveComponents(UITextMeshProUGUIEx)
  self.theEffectItem:GameObjectRecycleAll()
  if cfg.desc_1 then
    local goItem, theItem
    local effectList = string.split(cfg.desc_1, "|")
    local paramList = string.split(cfg.desc_1_para or "", "|")
    for k, v in ipairs(effectList) do
      goItem = self.theEffectItem:GameObjectSpawn(self.content.transform)
      goItem.name = "item_" .. k
      goItem:SetActive(true)
      theItem = self.content:AddComponent(UITextMeshProUGUIEx, goItem.name)
      theItem:SetLocalText(v, paramList[k] or "")
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
end

function CityAttachmentBuildDetail:InitRewardTips()
  self.tip_box_content:RemoveComponents(LWSeasonAllianceTipsItem)
  self.tipBoxTemplate:GameObjectRecycleAll()
  local goItem, theItem
  local extraRewards = DataCenter.SeasonDataManager:GetLootRewardList()
  if extraRewards ~= nil then
    for i, item in ipairs(extraRewards) do
      goItem = self.tipBoxTemplate:GameObjectSpawn(self.tip_box_content.transform)
      goItem.name = "item_" .. i
      goItem:SetActive(true)
      theItem = self.tip_box_content:AddComponent(LWSeasonAllianceTipsItem, goItem.name)
      theItem:ReInit(item)
    end
  end
  extraRewards = DataCenter.SeasonDataManager:GetSeasonConfig()
  local value = extraRewards.loot_reward_value
  local text = Localization:GetString("2000155")
  self.tip_box_title:SetText(text .. value)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tip_box_title_root.rectTransform)
end

return CityAttachmentBuildDetail
