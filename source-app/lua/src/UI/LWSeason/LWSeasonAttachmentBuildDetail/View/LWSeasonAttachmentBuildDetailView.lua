local LWSeasonAttachmentBuildDetailView = BaseClass("LWSeasonAttachmentBuildDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWSeasonAttachmentBuildDetailItem = require("UI.LWSeason.LWSeasonAttachmentBuildDetail.Component.LWSeasonAttachmentBuildDetailItem")
local common_bg_orange_path = "PopUpTitle/Common_bg_orange"
local attachment_build_pop_up_path = "PopUpTitle/Common_bg_orange/AttachmentBuildPopUp"
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_path = "PopUpTitle/Common_bg_orange/AttachmentBuildPopUp/title"
local res_num_path = "PopUpTitle/Common_bg_orange/AttachmentBuildPopUp/GameObject/ResNum"
local res_value_path = "PopUpTitle/Common_bg_orange/AttachmentBuildPopUp/GameObject/ResValue"
local mem_num_path = "PopUpTitle/Common_bg_orange/AttachmentBuildPopUp/GameObject/MemNum"
local mem_value_path = "PopUpTitle/Common_bg_orange/AttachmentBuildPopUp/GameObject/MemValue"
local has_reward_path = "PopUpTitle/Common_bg_orange/AttachmentBuildPopUp/HasReward"
local reward_tip_path = "PopUpTitle/Common_bg_orange/AttachmentBuildPopUp/HasReward/RewardTip"
local reward_icon_path = "PopUpTitle/Common_bg_orange/AttachmentBuildPopUp/HasReward/RewardIcon"
local reward_value_path = "PopUpTitle/Common_bg_orange/AttachmentBuildPopUp/HasReward/RewardValue"
local effect_text_path = "PopUpTitle/Common_bg_orange/AttachmentBuildPopUp/effectText"
local no_reward_path = "PopUpTitle/Common_bg_orange/AttachmentBuildPopUp/NoReward"
local no_reward_tip_path = "PopUpTitle/Common_bg_orange/AttachmentBuildPopUp/NoReward/NoRewardTip"

function LWSeasonAttachmentBuildDetailView:OnCreate()
  base.OnCreate(self)
  self.slotIndex, self.buildCfg, self.cfg, self.slotHasFirst = self:GetUserData()
  self:ComponentDefine()
  self:ShowDetail(self.slotIndex, self.buildCfg, self.cfg, self.slotHasFirst)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.attachment_build_pop_up.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.common_bg_orange.transform)
end

function LWSeasonAttachmentBuildDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonAttachmentBuildDetailView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, "panel")
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.common_bg_orange = self:AddComponent(UIBaseContainer, common_bg_orange_path)
  self.attachment_build_pop_up = self:AddComponent(UIBaseContainer, attachment_build_pop_up_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
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
  self.content = self.attachment_build_pop_up
  self.reward_icon:SetOnClick(function()
    if ComponentIsValid(self.reward_icon) then
      UIUtil.ShowLootRewardList(self.reward_icon:GetPosition())
    end
  end)
  self.theEffectItem = self.transform:Find(effect_text_path).gameObject
  self.theEffectItem:GameObjectCreatePool()
end

function LWSeasonAttachmentBuildDetailView:ComponentDestroy()
  self.content:RemoveComponents(UITextMeshProUGUIEx)
  self.theEffectItem:GameObjectRecycleAll()
  self.common_bg_orange = nil
  self.attachment_build_pop_up = nil
  self.title_text = nil
  self.close_btn = nil
end

function LWSeasonAttachmentBuildDetailView:ShowDetail(slotIndex, buildCfg, cityCfg, slotHasFirst)
  local cfg = buildCfg
  self.has_reward_root:SetActive(slotHasFirst)
  self.no_reward_root:SetActive(slotHasFirst ~= true)
  self.no_reward_tip:SetText(Localization:GetString("season_builders_alliance_UI_84") .. ": " .. Localization:GetString("season_builders_alliance_UI_85"))
  self.title:SetLocalText(cfg.name)
  self.title_text:SetLocalText(cfg.name)
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

return LWSeasonAttachmentBuildDetailView
