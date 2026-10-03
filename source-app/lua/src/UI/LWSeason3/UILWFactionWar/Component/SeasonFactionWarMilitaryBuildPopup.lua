local SeasonFactionWarMilitaryBuildPopup = BaseClass("SeasonFactionWarMilitaryBuildPopup", UIBaseContainer)
local base = UIBaseContainer
local reward_icon_path = "RewardLine/Reward"
local reward_value_path = "RewardLine/RewardCount"
local hide_btn_path = "HideBtn"
local title_path = "title"
local desc_path = "desc"
local content_path = "content"
local arrow_path = "arrow"
local attack1_path = "content/attack1"
local name1_path = "content/attack1/name1"
local slider1_path = "content/attack1/Slider1"
local txt_num1_path = "content/attack1/Txt_Num1"
local reward_count1_path = "content/attack1/Reward/RewardCount1"
local attack2_path = "content/attack2"
local name2_path = "content/attack2/name2"
local slider2_path = "content/attack2/Slider2"
local txt_num2_path = "content/attack2/Txt_Num2"
local reward_count2_path = "content/attack2/Reward/RewardCount2"
local attack3_path = "content/attack3"
local name3_path = "content/attack3/name3"
local slider3_path = "content/attack3/Slider3"
local txt_num3_path = "content/attack3/Txt_Num3"
local reward_count3_path = "content/attack3/Reward/RewardCount3"

function SeasonFactionWarMilitaryBuildPopup:OnCreate()
  base.OnCreate(self)
  self.reward_icon = self:AddComponent(UIButton, reward_icon_path)
  self.reward_value = self:AddComponent(UITextMeshProUGUIEx, reward_value_path)
  self.reward_icon:SetOnClick(function()
    if ComponentIsValid(self.reward_icon) then
      UIUtil.ShowLootRewardList(self.reward_icon:GetPosition())
    end
  end)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.hide_btn = self:AddComponent(UIButton, hide_btn_path)
  self.hide_btn:SetOnClick(function()
    self:SetActive(false)
  end)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.content = self:AddComponent(UIImage, content_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.attack1 = self:AddComponent(UIBaseContainer, attack1_path)
  self.name1 = self:AddComponent(UITextMeshProUGUIEx, name1_path)
  self.slider1 = self:AddComponent(UISlider, slider1_path)
  self.txt_num1 = self:AddComponent(UITextMeshProUGUIEx, txt_num1_path)
  self.reward_count1 = self:AddComponent(UITextMeshProUGUIEx, reward_count1_path)
  self.attack2 = self:AddComponent(UIBaseContainer, attack2_path)
  self.name2 = self:AddComponent(UITextMeshProUGUIEx, name2_path)
  self.slider2 = self:AddComponent(UISlider, slider2_path)
  self.txt_num2 = self:AddComponent(UITextMeshProUGUIEx, txt_num2_path)
  self.reward_count2 = self:AddComponent(UITextMeshProUGUIEx, reward_count2_path)
  self.attack3 = self:AddComponent(UIBaseContainer, attack3_path)
  self.name3 = self:AddComponent(UITextMeshProUGUIEx, name3_path)
  self.slider3 = self:AddComponent(UISlider, slider3_path)
  self.txt_num3 = self:AddComponent(UITextMeshProUGUIEx, txt_num3_path)
  self.reward_count3 = self:AddComponent(UITextMeshProUGUIEx, reward_count3_path)
end

function SeasonFactionWarMilitaryBuildPopup:OnDestroy()
  self.hide_btn = nil
  self.title = nil
  self.content = nil
  self.desc = nil
  self.attack1 = nil
  self.name1 = nil
  self.slider1 = nil
  self.txt_num1 = nil
  self.reward_count1 = nil
  self.attack2 = nil
  self.name2 = nil
  self.slider2 = nil
  self.txt_num2 = nil
  self.reward_count2 = nil
  self.attack3 = nil
  self.name3 = nil
  self.slider3 = nil
  self.txt_num3 = nil
  self.reward_count3 = nil
  base.OnDestroy(self)
end

function SeasonFactionWarMilitaryBuildPopup:ShowIt(x, y, theLootNumChangeList, theScoreList, theBuildData)
  self:SetActive(true)
  self:SetLocalScaleXYZ(1, 1, 1)
  self:SetLocalPositionXYZ(x, y + 50, 0)
  local ax, ay, az = self.arrow:GetLocalPositionXYZ()
  if 50 < x then
    self.arrow:SetLocalPositionXYZ(120, ay, az)
  elseif x < -50 then
    self.arrow:SetLocalPositionXYZ(-120, ay, az)
  else
    self.arrow:SetLocalPositionXYZ(0, ay, az)
  end
  local s2_faction_war_k8 = LuaEntry.DataConfig:TryGetNum("s3_faction_war", "k8", 2000)
  if s2_faction_war_k8 <= 0 then
    s2_faction_war_k8 = 2000
  end
  self.desc:SetLocalText("season_s3_loot_rewards_tip", s2_faction_war_k8)
  local maxHp = theBuildData.maxdurability or 0
  self.theBuildData = theBuildData
  self.theScoreList = theScoreList
  self.theLootNumChangeList = theLootNumChangeList or {}
  self.totalReward = 0
  self.uuid = theBuildData.uuid
  self:SetAttackValue(theScoreList[1], self.attack1, self.name1, self.slider1, self.txt_num1, self.reward_count1, maxHp)
  self:SetAttackValue(theScoreList[2], self.attack2, self.name2, self.slider2, self.txt_num2, self.reward_count2, maxHp)
  self:SetAttackValue(theScoreList[3], self.attack3, self.name3, self.slider3, self.txt_num3, self.reward_count3, maxHp)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  self.reward_value:SetText("\195\151 " .. self.totalReward)
end

function SeasonFactionWarMilitaryBuildPopup:SetAttackValue(data, rootNode, name, slider, txt_num, reward_count, maxHp)
  if data == nil then
    rootNode:SetActive(false)
  else
    local score = toInt(data.score)
    rootNode:SetActive(true)
    reward_count:SetText("0")
    name:SetText("[" .. (data.abbr or data.name or "???") .. "]")
    for k, v in pairs(self.theLootNumChangeList) do
      if v and v.allianceId == data.allianceId then
        score = v.hp
        reward_count:SetText(v.lootNum or 0)
        self.totalReward = self.totalReward + toInt(v.lootNum or 0)
        break
      end
    end
    if maxHp ~= 0 then
      slider:SetValue(score / maxHp)
    else
      slider:SetValue(0)
    end
    txt_num:SetText(string.GetFormattedSeparatorNum(score))
  end
end

return SeasonFactionWarMilitaryBuildPopup
