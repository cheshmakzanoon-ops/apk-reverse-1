local SeasonFactionWarZoneReward = BaseClass("SeasonFactionWarZoneReward", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local reward_item_path = "ScrollView/Viewport/item"
local reward_content_path = "ScrollView/Viewport/RewardContent"
local reward_btn_path = "RewardBtn"
local reward_btn_text_path = "RewardBtn/Text"
local red_point_path = "RewardBtn/RedPoint"
local reward_radio_path = "RewardBtn/RewardRadio"
local reward_radio_num_path = "RewardBtn/RewardRadio/RewardRadioNum"
local info_btn_path = "tbg/title/InfoBtn"

function SeasonFactionWarZoneReward:OnCreate()
  base.OnCreate(self)
  self:AddUIListener(EventId.LWSeasonFactionBattleWinRewardFinish, self.OnWinRewardFinish)
  self.theItem = self.transform:Find(reward_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.btn_text = self:AddComponent(UIText, reward_btn_text_path)
  self.reward_btn = self:AddComponent(UIButton, reward_btn_path)
  self.reward_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.reward_btn:SetSafeClickMode(true)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_point:SetActive(false)
  self.reward_radio = self:AddComponent(UIImage, reward_radio_path)
  self.reward_radio_num = self:AddComponent(UIText, reward_radio_num_path)
  self.reward_radio:SetActive(false)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    UIUtil.ShowDetail(Localization:GetString("season_s2_faction_war_tips_03"))
  end)
end

function SeasonFactionWarZoneReward:OnDestroy()
  self:RemoveUIListener(EventId.LWSeasonFactionBattleWinRewardFinish, self.OnWinRewardFinish)
  self.content:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function SeasonFactionWarZoneReward:ReInit(fightInfo, fightResult)
  local goItem, theItem
  local extraRewards = fightInfo.winReward
  self.content:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  if extraRewards ~= nil then
    for i, item in ipairs(extraRewards) do
      local theName = "item_" .. i
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = theName
      goItem:SetActive(true)
      theItem = self.content:AddComponent(UICommonResItem, theName)
      theItem:ParseInfo(item)
    end
  end
  if fightInfo.userInfo and fightInfo.userInfo.winReward == 1 then
    self.red_point:SetActive(false)
    self.btn_text:SetLocalText("170003")
    UIGray.SetGray(self.reward_btn.transform, true, false)
  else
    local canGetReward = false
    local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
    local isAttacker = DataCenter.SeasonFactionWarDataManager:CampIsAttacker(myCampId)
    if fightResult == 1 and not isAttacker then
      canGetReward = true
    elseif fightResult == 2 and isAttacker then
      canGetReward = true
    end
    self.red_point:SetActive(false)
    self.btn_text:SetLocalText("129054")
    UIGray.SetGray(self.reward_btn.transform, not canGetReward, canGetReward)
  end
  local winRate = toInt(fightInfo.winRate)
  if 0 < winRate then
    self.reward_radio:SetActive(true)
    self.reward_radio_num:SetText("\195\151" .. winRate)
  else
    self.reward_radio:SetActive(false)
  end
  self.fightInfo = fightInfo
  local actInfo = DataCenter.SeasonFactionWarDataManager:GetDeclareWarActInfo()
  if actInfo and toInt(actInfo.currStep) < SeasonFactionDeclareWarStep.battle_before then
    self.reward_radio:SetActive(false)
  end
end

function SeasonFactionWarZoneReward:OnBtnClick()
  SFSNetwork.SendMessage(MsgDefines.GetSeasonFactionBattleWinReward)
end

function SeasonFactionWarZoneReward:OnWinRewardFinish()
  self.red_point:SetActive(false)
  self.btn_text:SetLocalText("170003")
  UIGray.SetGray(self.reward_btn.transform, true, false)
end

return SeasonFactionWarZoneReward
