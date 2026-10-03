local JigsawRankItem = BaseClass("JigsawRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rankIndex_path = "numTxt"
local rankImg_path = "firstImg"
local headBtn_path = "UIPlayerHead"
local playerHead_path = "UIPlayerHead/HeadIcon"
local playerHeadFg_path = "UIPlayerHead/Foreground"
local playerName_path = "firstNameTxt"
local playerAlliance_path = "secondNameTxt"
local useTime_path = "scoreTxt"
local rewardsSv_path = "scrollView_Reward"
local rewardsContent_path = "scrollView_Reward/Viewport/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.rankIndexN = self:AddComponent(UIText, rankIndex_path)
  self.rankImgN = self:AddComponent(UIImage, rankImg_path)
  self.headBtnN = self:AddComponent(UIButton, headBtn_path)
  self.headBtnN:SetOnClick(function()
    self:OnClickPlayerHead()
  end)
  self.playerHeadN = self:AddComponent(UIPlayerHead, playerHead_path)
  self.playerHeadFgN = self:AddComponent(UIImage, playerHeadFg_path)
  self.playerNameN = self:AddComponent(UIText, playerName_path)
  self.playerAllianceN = self:AddComponent(UIText, playerAlliance_path)
  self.useTimeN = self:AddComponent(UIText, useTime_path)
  self.rewardSrN = self:AddComponent(UIScrollRect, rewardsSv_path)
  self.rewardsContentN = self:AddComponent(UIBaseContainer, rewardsContent_path)
end

local function ComponentDestroy(self)
  self.rankIndexN = nil
  self.rankImgN = nil
  self.playerHeadN = nil
  self.playerHeadFgN = nil
  self.playerNameN = nil
  self.playerAllianceN = nil
  self.useTimeN = nil
  self.rewardSvN = nil
end

local function DataDefine(self)
  self.rankDetail = nil
  self.rewardsList = {}
end

local function DataDestroy(self)
  self.rankDetail = nil
  self.rewardsList = nil
end

local function SetItem(self, detail)
  self.rankDetail = detail
  if detail.rank <= 3 and detail.rank > 0 then
    self.rankIndexN:SetActive(false)
    self.rankImgN:SetActive(true)
    self.rankImgN:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg0" .. detail.rank)
  else
    self.rankIndexN:SetActive(true)
    if detail.rank <= 0 then
      self.rankIndexN:SetText(Localization:GetString("361054"))
    else
      self.rankIndexN:SetText(detail.rank)
    end
    self.rankImgN:SetActive(false)
  end
  self.playerHeadN:SetData(detail.uid, detail.pic, detail.picVer)
  local headFgImg
  if isSelf then
    headFgImg = LuaEntry.Player:GetHeadBgImg()
  else
    headFgImg = detail:GetHeadBgImg()
  end
  if headFgImg then
    self.playerHeadFgN:SetActive(true)
  else
    self.playerHeadFgN:SetActive(false)
  end
  self.playerNameN:SetText(detail.name)
  local allianceName = string.IsNullOrEmpty(detail.abbr) and "" or "[" .. detail.abbr .. "]" .. detail.allianceName
  self.playerAllianceN:SetText(allianceName)
  self.useTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(detail.score * 1000))
  self:RefreshRewards()
end

local function RefreshRewards(self)
  self.rewardsList = self.view:GetRankRewards(self.rankDetail.rank)
  for i, v in ipairs(self.rewardsList) do
    if v.rewardType == RewardType.GOLD then
      self.rewardsList[i], self.rewardsList[1] = self.rewardsList[1], self.rewardsList[i]
      break
    end
  end
  self:SetAllCellDestroy()
  for i, v in ipairs(self.rewardsList) do
    if not string.IsNullOrEmpty(v) then
      self.models = {}
      self.models[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.rewardsContentN.transform)
        go.transform:Set_localScale(0.48, 0.48, 1)
        go.transform:SetAsLastSibling()
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local rewardItem = self.rewardsContentN:AddComponent(UICommonResItem, nameStr)
        rewardItem:ReInit(self.rewardsList[i])
      end)
    end
  end
end

local function SetAllCellDestroy(self)
  self.rewardsContentN:RemoveComponents(UICommonResItem)
  if self.models ~= nil then
    for k, v in pairs(self.models) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function OnClickPlayerHead(self)
  if not self.rankDetail then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = true}, self.rankDetail.uid)
end

JigsawRankItem.OnCreate = OnCreate
JigsawRankItem.OnDestroy = OnDestroy
JigsawRankItem.ComponentDefine = ComponentDefine
JigsawRankItem.ComponentDestroy = ComponentDestroy
JigsawRankItem.DataDefine = DataDefine
JigsawRankItem.DataDestroy = DataDestroy
JigsawRankItem.SetItem = SetItem
JigsawRankItem.RefreshRewards = RefreshRewards
JigsawRankItem.SetAllCellDestroy = SetAllCellDestroy
JigsawRankItem.OnClickPlayerHead = OnClickPlayerHead
return JigsawRankItem
