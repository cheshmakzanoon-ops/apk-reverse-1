local LeagueMatchAlRewardItem = BaseClass("LeagueMatchAlRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local title_path = "title"
local infoBtn_path = "title/infoBtn"
local rewards_path = "rewards/rewardItem_"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.rewardsTbN = {}
  for i = 1, 10 do
    local reward = self:AddComponent(UICommonResItem, rewards_path .. i)
    table.insert(self.rewardsTbN, reward)
  end
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.infoBtnN = nil
  self.rewardsTbN = nil
end

local function DataDefine(self)
  self.strTip = nil
end

local function DataDestroy(self)
  self.strTip = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, rewardInfo, strConf, numParam)
  self.strTip = Localization:GetString(strConf.Tips, numParam)
  self.titleN:SetLocalText(strConf.Name)
  local rewardsList = DataCenter.RewardManager:ReturnRewardParamForMessage(rewardInfo)
  for i, v in ipairs(rewardsList) do
    if v.rewardType == RewardType.GOLD then
      local tempR = v
      table.remove(rewardsList, i)
      table.insert(rewardsList, 1, tempR)
      break
    end
  end
  for i, v in ipairs(self.rewardsTbN) do
    if i <= #rewardsList then
      v:SetActive(true)
      v:ReInit(rewardsList[i])
    else
      v:SetActive(false)
    end
  end
end

local function OnClickInfoBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.infoBtnN.transform.position + Vector3.New(0, 10, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = self.strTip
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 400
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

LeagueMatchAlRewardItem.OnCreate = OnCreate
LeagueMatchAlRewardItem.OnDestroy = OnDestroy
LeagueMatchAlRewardItem.ComponentDefine = ComponentDefine
LeagueMatchAlRewardItem.ComponentDestroy = ComponentDestroy
LeagueMatchAlRewardItem.DataDefine = DataDefine
LeagueMatchAlRewardItem.DataDestroy = DataDestroy
LeagueMatchAlRewardItem.OnAddListener = OnAddListener
LeagueMatchAlRewardItem.OnRemoveListener = OnRemoveListener
LeagueMatchAlRewardItem.SetItem = SetItem
LeagueMatchAlRewardItem.OnClickInfoBtn = OnClickInfoBtn
return LeagueMatchAlRewardItem
