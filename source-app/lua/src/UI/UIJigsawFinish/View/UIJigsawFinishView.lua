local base = UIBaseView
local UIJigsawFinishView = BaseClass("UIJigsawFinishView", base)
local Localization = CS.GameEntry.Localization
local title_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local subTitle_path = "container/subTitle"
local costTimeTxt_path = "container/costTimeTxt"
local costTime_path = "container/costTimeTxt/costTime"
local serverBestTxt_path = "container/serverBestTxt"
local serverBest_path = "container/serverBestTxt/serverBest"
local selfBestTxt_path = "container/selfBestTxt"
local selfBest_path = "container/selfBestTxt/selfBest"
local selfRankTxt_path = "container/selfRankTxt"
local selfRank_path = "container/selfRankTxt/selfRank"
local closeBtn_path = "UICommonRewardPopUp/Panel"
local stars_path = "container/stars/star/starFill"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshAll()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetText(Localization:GetString("104201"))
  self.subTitleN = self:AddComponent(UIText, subTitle_path)
  self.subTitleN:SetActive(false)
  self.costTimeTxtN = self:AddComponent(UIText, costTimeTxt_path)
  self.costTimeTxtN:SetText(Localization:GetString("372356"))
  self.costTimeN = self:AddComponent(UIText, costTime_path)
  self.serverBestTxtN = self:AddComponent(UIText, serverBestTxt_path)
  self.serverBestTxtN:SetText(Localization:GetString("372357"))
  self.serverBestN = self:AddComponent(UIText, serverBest_path)
  self.selfBestTxtN = self:AddComponent(UIText, selfBestTxt_path)
  self.selfBestTxtN:SetText(Localization:GetString("372359"))
  self.selfBestN = self:AddComponent(UIText, selfBest_path)
  self.selfRankTxtN = self:AddComponent(UIText, selfRankTxt_path)
  self.selfRankTxtN:SetText(Localization:GetString("372358"))
  self.selfRankN = self:AddComponent(UIText, selfRank_path)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.starsTbN = {}
  for i = 1, 3 do
    local tempStar = self:AddComponent(UIBaseContainer, stars_path .. i)
    table.insert(self.starsTbN, tempStar)
  end
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.subTitleN = nil
  self.costTimeTxtN = nil
  self.costTimeN = nil
  self.serverBestTxtN = nil
  self.serverBestN = nil
  self.selfBestTxtN = nil
  self.selfBestN = nil
  self.selfRankTxtN = nil
  self.selfRankN = nil
  self.closeBtnN = nil
  self.starsTbN = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshAll(self)
  local finishInfo = DataCenter.JigsawPuzzleManager:GetJigsawFinishInfo()
  local selfStarNum = DataCenter.JigsawPuzzleManager:GetStarNumByTime(finishInfo.activityId, finishInfo.id, finishInfo.useTime)
  for i, v in ipairs(self.starsTbN) do
    v:SetActive(i <= selfStarNum)
  end
  self.costTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(finishInfo.useTime * 1000))
  self.serverBestN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(finishInfo.serverMinTime * 1000))
  if finishInfo.serverMinTime == finishInfo.useTime then
    self.serverBestN:SetColor(YellowColor)
  else
    self.serverBestN:SetColor(WhiteColor)
  end
  self.selfBestN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(finishInfo.minTime * 1000))
  if finishInfo.minTime == finishInfo.useTime then
    self.selfBestN:SetColor(YellowColor)
  else
    self.selfBestN:SetColor(WhiteColor)
  end
  self.selfRankN:SetText(finishInfo.rank)
end

local function OnClickCloseBtn(self)
  local finishInfo = DataCenter.JigsawPuzzleManager:GetJigsawFinishInfo()
  if finishInfo and finishInfo.reward then
    DataCenter.RewardManager:ShowCommonReward(finishInfo)
  end
  self.ctrl:CloseSelf()
end

UIJigsawFinishView.OnCreate = OnCreate
UIJigsawFinishView.OnDestroy = OnDestroy
UIJigsawFinishView.OnAddListener = OnAddListener
UIJigsawFinishView.OnRemoveListener = OnRemoveListener
UIJigsawFinishView.ComponentDefine = ComponentDefine
UIJigsawFinishView.ComponentDestroy = ComponentDestroy
UIJigsawFinishView.DataDefine = DataDefine
UIJigsawFinishView.DataDestroy = DataDestroy
UIJigsawFinishView.RefreshAll = RefreshAll
UIJigsawFinishView.OnClickCloseBtn = OnClickCloseBtn
return UIJigsawFinishView
