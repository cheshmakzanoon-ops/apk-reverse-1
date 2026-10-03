local SeasonFactionWarStoveCenter = BaseClass("SeasonFactionWarStoveCenter", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LWSeasonAllianceTipsItem = require("UI.LWSeason.LWSeasonAllianceRank.Component.LWSeasonAllianceTipsItem")
local icon_path = "icon"
local hp_bar_path = "icon/HPBar"
local xy_path = "icon/xy"
local reward_path = "icon/Reward"
local reward_count_path = "icon/Reward/RewardCount"
local reward_info_btn_path = "icon/RewardInfoBtn"
local res_full_path = "res_full"
local res_war_path = "res_war"
local name_path = "name"
local res_full_title_path = "res_full_title"
local res_war_title_path = "res_war_title"
local level_bg_path = "icon/levelBg"
local level_path = "icon/levelBg/level"
local key1_path = "InfoList/bg1/key1"
local value1_path = "InfoList/bg1/value1"
local key2_path = "InfoList/bg2/key2"
local value2_path = "InfoList/bg2/value2"
local key3_path = "InfoList/bg3/key3"
local value3_path = "InfoList/bg3/value3"
local info_btn_path = "InfoList/bg3/InfoBtn"
local attack_info_path = "AttackInfo"
local attack1_path = "AttackInfo/content/attack1"
local name1_path = "AttackInfo/content/attack1/name1"
local slider1_path = "AttackInfo/content/attack1/Slider1"
local txt_num1_path = "AttackInfo/content/attack1/Txt_Num1"
local attack2_path = "AttackInfo/content/attack2"
local name2_path = "AttackInfo/content/attack2/name2"
local slider2_path = "AttackInfo/content/attack2/Slider2"
local txt_num2_path = "AttackInfo/content/attack2/Txt_Num2"
local attack3_path = "AttackInfo/content/attack3"
local name3_path = "AttackInfo/content/attack3/name3"
local slider3_path = "AttackInfo/content/attack3/Slider3"
local txt_num3_path = "AttackInfo/content/attack3/Txt_Num3"
local content_path = "AttackInfo/content"
local attack_info_btn_path = "AttackInfo/AttackInfoBtn"
local tip_root_path = "icon/Reward/TipRoot"
local btn_close_tip_path = "icon/Reward/TipRoot/BtnCloseTip"
local tip_box_title_path = "icon/Reward/TipRoot/TipBox/Title/TipBoxTitle"
local tip_box_icon_path = "icon/Reward/TipRoot/TipBox/Title/TipBoxIcon"
local tip_box_content_path = "icon/Reward/TipRoot/TipBox/ScrollView/Viewport/TipBoxContent"
local tip_box_item_path = "icon/Reward/TipRoot/TipBox/ScrollView/Viewport/TipBoxContent/TipBoxItem"
local tip_title_path = "icon/Reward/TipRoot/TipBox/Title"
local reward_info_tips_path = "icon/RewardInfoBtn/RewardInfoTips"
local reward_desc_path = "icon/RewardInfoBtn/RewardInfoTips/RewardDesc"
local btn_close_tip2_path = "icon/RewardInfoBtn/RewardInfoTips/BtnCloseTip2"

function SeasonFactionWarStoveCenter:OnCreate()
  base.OnCreate(self)
  self.reward_info_tips = self:AddComponent(UIImage, reward_info_tips_path)
  self.reward_desc = self:AddComponent(UITextMeshProUGUIEx, reward_desc_path)
  self.btn_close_tip2 = self:AddComponent(UIButton, btn_close_tip2_path)
  self.btn_close_tip2:SetOnClick(function()
    self.reward_info_tips:SetActive(false)
  end)
  self.tip_root = self:AddComponent(UICanvasGroup, tip_root_path)
  self.btn_close_tip = self:AddComponent(UIButton, btn_close_tip_path)
  self.tip_root:SetActive(false)
  self.btn_close_tip:SetOnClick(function()
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(self.tip_root:FadeOut(0.2))
    sequence:Join(self.tip_root.transform:DOScale(Vector3.New(1, 0, 1), 0.2))
    sequence:AppendCallback(function()
      if self.tip_root then
        self.tip_root:SetActive(false)
      end
    end)
  end)
  self.TipBoxTitle = self:AddComponent(UIBaseContainer, tip_title_path)
  self.tip_box_title = self:AddComponent(UIText, tip_box_title_path)
  self.tip_box_icon = self:AddComponent(UIImage, tip_box_icon_path)
  self.tip_box_content = self:AddComponent(UIBaseContainer, tip_box_content_path)
  self.tipBoxTemplate = self.transform:Find(tip_box_item_path).gameObject
  self.tipBoxTemplate:GameObjectCreatePool()
  self.rewardBtn = self:AddComponent(UIButton, reward_path)
  self.rewardCount = self:AddComponent(UITextMeshProUGUIEx, reward_count_path)
  self.rewardInfoBtn = self:AddComponent(UIButton, reward_info_btn_path)
  self.rewardBtn:SetOnClick(function()
    if self.tip_root:GetActive() and self.tip_root:GetAlpha() ~= 0 then
      return
    end
    self.tip_root:SetAlpha(0)
    self.tip_root:SetActive(true)
    self:InitRewardTips()
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(self.tip_root:FadeIn(0.2))
    sequence:Join(self.tip_root.transform:DOScale(Vector3.New(1, 1, 1), 0.2))
  end)
  self.rewardInfoBtn:SetOnClick(function()
    self.reward_desc:SetLocalText("season_s2_battletips002")
    self.reward_info_tips:SetActive(true)
  end)
  self.rewardBtn:SetActive(false)
  self.rewardInfoBtn:SetActive(false)
  self.level_bg = self:AddComponent(UIImage, level_bg_path)
  self.level = self:AddComponent(UITextMeshProUGUIEx, level_path)
  self.key1 = self:AddComponent(UITextMeshProUGUIEx, key1_path)
  self.value1 = self:AddComponent(UITextMeshProUGUIEx, value1_path)
  self.key2 = self:AddComponent(UITextMeshProUGUIEx, key2_path)
  self.value2 = self:AddComponent(UITextMeshProUGUIEx, value2_path)
  self.key3 = self:AddComponent(UITextMeshProUGUIEx, key3_path)
  self.value3 = self:AddComponent(UITextMeshProUGUIEx, value3_path)
  self.icon = self:AddComponent(UIButton, icon_path)
  self.hp_bar = self:AddComponent(UISlider, hp_bar_path)
  self.xy = self:AddComponent(UITextMeshProUGUIEx, xy_path)
  self.res_full = self:AddComponent(UITextMeshProUGUIEx, res_full_path)
  self.res_war = self:AddComponent(UITextMeshProUGUIEx, res_war_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.res_full_title = self:AddComponent(UITextMeshProUGUIEx, res_full_title_path)
  self.res_war_title = self:AddComponent(UITextMeshProUGUIEx, res_war_title_path)
  self.xy:OnPointerClick(function(eventData)
    self:GotoStoveCenter()
  end)
  self.icon:SetOnClick(function()
    self:GotoStoveCenter()
  end)
  self.content = self:AddComponent(UIImage, content_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.attack_info = self:AddComponent(UIButton, attack_info_path)
  self.attack1 = self:AddComponent(UIBaseContainer, attack1_path)
  self.name1 = self:AddComponent(UITextMeshProUGUIEx, name1_path)
  self.slider1 = self:AddComponent(UISlider, slider1_path)
  self.txt_num1 = self:AddComponent(UITextMeshProUGUIEx, txt_num1_path)
  self.attack2 = self:AddComponent(UIBaseContainer, attack2_path)
  self.name2 = self:AddComponent(UITextMeshProUGUIEx, name2_path)
  self.slider2 = self:AddComponent(UISlider, slider2_path)
  self.txt_num2 = self:AddComponent(UITextMeshProUGUIEx, txt_num2_path)
  self.attack3 = self:AddComponent(UIBaseContainer, attack3_path)
  self.name3 = self:AddComponent(UITextMeshProUGUIEx, name3_path)
  self.slider3 = self:AddComponent(UISlider, slider3_path)
  self.txt_num3 = self:AddComponent(UITextMeshProUGUIEx, txt_num3_path)
  self.info_btn:SetOnClick(function()
    if self.data and table.count(self.data.scoreList) > 0 then
      local scoreList = self.data.scoreList
      local maxHp = self.data.maxdurability or 0
      self.attack_info:SetActive(true)
      self:SetAttackValue(scoreList[1], self.attack1, self.name1, self.slider1, self.txt_num1, maxHp)
      self:SetAttackValue(scoreList[2], self.attack2, self.name2, self.slider2, self.txt_num2, maxHp)
      self:SetAttackValue(scoreList[3], self.attack3, self.name3, self.slider3, self.txt_num3, maxHp)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.attack_info.transform)
    else
      local param = {}
      param.type = "desc"
      param.title = ""
      param.desc = "season_s2_faction_war_tips_04"
      param.alignObject = self.info_btn
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end)
  self.attack_info_btn = self:AddComponent(UIButton, attack_info_btn_path)
  self.attack_info_btn:SetOnClick(function()
    self.attack_info:SetActive(false)
  end)
  self.attack_info:SetOnClick(function()
    self.attack_info:SetActive(false)
  end)
  self.attack_info:SetActive(false)
end

function SeasonFactionWarStoveCenter:GotoStoveCenter()
  if self.linkInfo then
    GoToUtil.TryJumpToWorld(self.linkInfo)
  end
end

function SeasonFactionWarStoveCenter:InitRewardTips()
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
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.TipBoxTitle.transform)
end

function SeasonFactionWarStoveCenter:SetAttackValue(data, rootNode, name, slider, txt_num, maxHp)
  if data == nil then
    rootNode:SetActive(false)
  else
    rootNode:SetActive(true)
    name:SetText(UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name))
    if maxHp ~= 0 then
      slider:SetValue(toInt(data.score) / maxHp)
    else
      slider:SetValue(0)
    end
    txt_num:SetText(string.GetFormattedSeparatorNum(data.score or 0))
  end
end

function SeasonFactionWarStoveCenter:OnDestroy()
  self.level_bg = nil
  self.level = nil
  self.key1 = nil
  self.value1 = nil
  self.key2 = nil
  self.value2 = nil
  self.key3 = nil
  self.value3 = nil
  self.icon = nil
  self.hp_bar = nil
  self.xy = nil
  self.res_full = nil
  self.res_war = nil
  self.name = nil
  self.res_full_title = nil
  self.res_war_title = nil
  self.reward = nil
  self.reward_count = nil
  self.reward_info_btn = nil
  self.reward_info_tips = nil
  self.reward_desc = nil
  self.btn_close_tip2 = nil
  base.OnDestroy(self)
end

function SeasonFactionWarStoveCenter:ReInit(data, furnaceChangeInfo, fightResult)
  self.data = data
  self.fightResult = fightResult
  if data.lootNum == nil then
    self.rewardBtn:SetActive(false)
    self.rewardInfoBtn:SetActive(false)
  else
    self.rewardCount:SetText("\195\151" .. data.lootNum)
    self.rewardBtn:SetActive(true)
    self.rewardInfoBtn:SetActive(true)
  end
  local myAllianceId = LuaEntry.Player.allianceId
  local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(BuildingTypes.SEASON_STOVE_CENTER + (data.level or 1))
  if meta then
    self.icon:LoadSprite(meta:GetIconPath())
    self.key1:SetText(meta:GetName())
  end
  local s2_faction_war_k8 = LuaEntry.DataConfig:TryGetNum("s2_faction_war", "k8", 2000)
  if s2_faction_war_k8 <= 0 then
    s2_faction_war_k8 = 2000
  end
  local ratio = DataCenter.SeasonFactionWarDataManager:GetPlunderRatio()
  local resourceNum = toInt(data.resourceNum)
  local canRobNum = toInt(data.canRobNum)
  local hp = toInt(data.durability)
  local hpMax = toInt(data.maxdurability)
  local v2 = SceneUtils.IndexToTilePos(data.pointId or 1, ForceChangeScene.World)
  if 0 < hp and 0 < hpMax then
    local value = hp / hpMax
    if value < 2.0E-4 then
      value = 1.0E-4
    end
    self.hp_bar:SetValue(math.max(0.1, value))
    self.value3:SetText(string.format("%.2f%%", value * 100))
  else
    self.hp_bar:SetValue(0)
    self.value3:SetText("0%")
  end
  self.xy:SetText(string.format("<u>#%s (X:%s Y:%s)</u>", data.buildServerId or data.allianceServer, v2.x, v2.y))
  self.res_full:SetText(string.GetFormattedStr(resourceNum))
  if canRobNum <= 0 then
    self.res_war:SetText(string.GetFormattedStr(resourceNum * ratio))
  else
    self.res_war:SetText(string.GetFormattedStr(canRobNum))
  end
  self.name:SetText(UIUtil.FormatServerAllianceName(data.buildServerId, data.abbr, data.allianceName))
  self.value1:SetLocalText(300665, data.level or 0)
  self.level:SetText(data.level or 0)
  if data.allianceId == myAllianceId then
    self.level_bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_dengji_bg2.png")
  else
    self.level_bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_dengji_bg1.png")
  end
  self.key2:SetLocalText("801140", "")
  self.value2:SetText(data.rank or "100+")
  self.key3:SetLocalText("100380")
  if data.pointId then
    local link = {
      action = "Jump",
      pointId = data.pointId,
      server = data.buildServerId or data.allianceServer,
      worldId = 0
    }
    self.linkInfo = link
  else
    self.xy:SetText("")
    return
  end
  if furnaceChangeInfo then
    if furnaceChangeInfo.newLevel and furnaceChangeInfo.newLevel < data.level then
      local strLevel = string.format("Lv.%s<color=#FF7373>(%s-%s)</color>", furnaceChangeInfo.newLevel, data.level, data.level - furnaceChangeInfo.newLevel)
      self.value1:SetText(strLevel)
    end
    if furnaceChangeInfo.newRank and furnaceChangeInfo.newRank < data.rank then
      local strRank = string.format("%s<color=#FF7373>(%s-%s)</color>", furnaceChangeInfo.newRank, data.rank, data.rank - furnaceChangeInfo.newRank)
      self.value2:SetText(strRank)
    end
    local newResourceNum = toInt(furnaceChangeInfo.newResourceNum)
    local oldResourceNum = toInt(data.resourceNum)
    if newResourceNum < oldResourceNum then
      local strRes = string.format("%s<color=#FF7373>(%s-%s)</color>", string.GetFormattedStr(newResourceNum), string.GetFormattedStr(oldResourceNum), string.GetFormattedStr(oldResourceNum - newResourceNum))
      self.res_full:SetText(strRes)
      self.res_war:SetText("<color=#FF7373>-" .. string.GetFormattedStr(oldResourceNum * ratio) .. "</color>")
    end
    if data.durability and data.maxdurability then
      self.hp_bar:SetValue(data.durability / data.maxdurability)
      self.value3:SetText("<color=#FF7373>" .. math.max(0, math.min(100, math.floor(data.durability * 100 / data.maxdurability))) .. "%</color>")
    else
      self.hp_bar:SetValue(1)
      self.value3:SetText("<color=#FF7373>100%</color>")
    end
    if self.fightResult == 1 then
      self.res_war:SetLocalText("season_s2_faction_war_74")
    end
  end
end

return SeasonFactionWarStoveCenter
