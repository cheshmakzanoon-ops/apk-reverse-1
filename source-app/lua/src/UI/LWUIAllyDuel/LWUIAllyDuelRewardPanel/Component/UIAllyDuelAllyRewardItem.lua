local UIAllyDuelAllyRewardItem = BaseClass("UIAllyDuelAllyRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_path = "BG2/TitleText"
local infoBtn_path = "BG2/InfoBtn"
local content_path = "ScrollRect/ViewPort/Content"
local bg_path = "BG2"

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
  self.bgN = self:AddComponent(UIImage, bg_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
  self:RemoveReward()
  self.titleN = nil
  self.infoBtnN = nil
  self.bgN = nil
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
  self:RemoveReward()
  local rewardsList = DataCenter.RewardManager:ReturnRewardParamForMessage(rewardInfo) or {}
  local rewardCount = 0
  rewardCount = #rewardsList
  for i, v in ipairs(rewardsList) do
    if v.rewardType == RewardType.GOLD then
      local tempR = v
      table.remove(rewardsList, i)
      table.insert(rewardsList, 1, tempR)
      break
    end
  end
  for i = 1, rewardCount do
    local reward = rewardsList[i]
    self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local transform = go.transform
      go:SetActive(true)
      transform:SetParent(self.content.transform)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.content:AddComponent(UICommonResItem, nameStr)
      cell:SetLocalScale(ResetScale)
      cell:SetSizeDelta(ResetCommonResSize)
      cell:ReInit(reward)
    end)
  end
end

local function OnClickInfoBtn(self)
  UIUtil.ShowBubbleTips(self.strTip, self.infoBtnN.transform.position, 0, -20, -20)
end

local function SetBgImg(self, spritePath)
  self.bgN:LoadSprite(spritePath)
end

function UIAllyDuelAllyRewardItem:RemoveReward()
  self.content:RemoveComponents(UICommonResItem)
  if self.itemReqs then
    for _, v in pairs(self.itemReqs) do
      v:Destroy()
    end
  end
  self.itemReqs = {}
end

UIAllyDuelAllyRewardItem.OnCreate = OnCreate
UIAllyDuelAllyRewardItem.OnDestroy = OnDestroy
UIAllyDuelAllyRewardItem.ComponentDefine = ComponentDefine
UIAllyDuelAllyRewardItem.ComponentDestroy = ComponentDestroy
UIAllyDuelAllyRewardItem.DataDefine = DataDefine
UIAllyDuelAllyRewardItem.DataDestroy = DataDestroy
UIAllyDuelAllyRewardItem.OnAddListener = OnAddListener
UIAllyDuelAllyRewardItem.OnRemoveListener = OnRemoveListener
UIAllyDuelAllyRewardItem.SetItem = SetItem
UIAllyDuelAllyRewardItem.OnClickInfoBtn = OnClickInfoBtn
UIAllyDuelAllyRewardItem.SetBgImg = SetBgImg
return UIAllyDuelAllyRewardItem
