local UIServerBattleLastKingZoneReward = BaseClass("UIServerBattleLastKingZoneReward", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local reward_item_path = "ScrollView/Viewport/item"
local reward_content_path = "ScrollView/Viewport/RewardContent"
local reward_title_path = "tbg/title"
local reward_btn_path = "RewardBtn"
local reward_btn_text_path = "RewardBtn/Text"
local red_point_path = "RewardBtn/RedPoint"
local reward_radio_path = "RewardBtn/RewardRadio"
local reward_radio_num_path = "RewardBtn/RewardRadio/RewardRadioNum"

function UIServerBattleLastKingZoneReward:OnCreate()
  base.OnCreate(self)
  self.theItem = self.transform:Find(reward_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.title = self:AddComponent(UIText, reward_title_path)
  self.btn_text = self:AddComponent(UIText, reward_btn_text_path)
  self.reward_btn = self:AddComponent(UIButton, reward_btn_path)
  self.reward_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_point:SetActive(false)
  self.reward_radio = self:AddComponent(UIImage, reward_radio_path)
  self.reward_radio_num = self:AddComponent(UIText, reward_radio_num_path)
end

function UIServerBattleLastKingZoneReward:OnDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  base.OnDestroy(self)
end

function UIServerBattleLastKingZoneReward:ReInit(configSchedule, fightInfo, config, serverBattleType)
  local goItem, theItem
  local extraRewards = fightInfo.user.winServerRewardInfo
  self.config = config
  self.serverBattleType = serverBattleType
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
  if fightInfo.user.winServerReward == 1 then
    self.red_point:SetActive(false)
    self.btn_text:SetLocalText("170003")
    UIGray.SetGray(self.reward_btn.transform, true, false)
  else
    self.red_point:SetActive(DataCenter.ZoneWarManager:HasZoneWinRewardRedPoint())
    self.btn_text:SetLocalText("129054")
    local mySeverId, myInfo, targetInfo = DataCenter.ZoneWarManager:ParseVsRound(fightInfo.curVsRound)
    local isWin = myInfo ~= nil and myInfo.win == 1
    UIGray.SetGray(self.reward_btn.transform, not isWin, isWin)
  end
  self.fightInfo = fightInfo
  local rewardTitleKey = 801455
  if serverBattleType == ServerBattleType.VSCamp then
    rewardTitleKey = "zone_war_ui_desc06"
    self.reward_radio:SetActive(false)
  else
    self.reward_radio_num:SetText("x" .. (fightInfo.user.winServerRewardRadio or 1))
    self.reward_radio:SetActive(true)
  end
  self.title:SetLocalText(rewardTitleKey)
end

function UIServerBattleLastKingZoneReward:OnBtnClick()
  SFSNetwork.SendMessage(MsgDefines.CrossKingServerRewardWin)
end

return UIServerBattleLastKingZoneReward
