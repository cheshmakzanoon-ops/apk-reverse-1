local base = UIBaseView
local UISandWormFishingRewardView = BaseClass("UISandWormFishingRewardView", base)
local Localization = CS.GameEntry.Localization
local SandWormFishingRewardItem = require("UI.UISandWormFishing.UISandWormFishingReward.Component.SandWormFishingRewardItem")
local TabType = {LevelReward = 1, DamageReward = 2}
local TabName = {
  [TabType.LevelReward] = "season_s3_activity_1000074_desc03",
  [TabType.DamageReward] = "season_s3_activity_1000074_desc04"
}
local TitleName = {
  [TabType.LevelReward] = "season_s3_activity_1000074_desc05",
  [TabType.DamageReward] = "season_s3_activity_1000074_desc07"
}
local title_path = "safeArea/TopBar/TextTitle"
local closeBtn_path = "safeArea/BottomBar/BtnBackWhite"
local tab_path = "safeArea/tabSv/Viewport/Content/AllyDuelTab"
local content_path = "safeArea/ScrollView/Viewport/Content"

function UISandWormFishingRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

function UISandWormFishingRewardView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISandWormFishingRewardView:ComponentDefine()
  self.titleN = self:AddComponent(UIText, title_path)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.tabTbN = {}
  for i = 1, 2 do
    local tab = self:AddComponent(UIBaseContainer, tab_path .. i)
    local tabBtn = tab:AddComponent(UIButton, "TypeButton")
    tabBtn:SetOnClick(function()
      self:OnClickTab(i)
    end)
    local select = tab:AddComponent(UIBaseContainer, "select")
    local selectTxt = tab:AddComponent(UIText, "select/selectText")
    selectTxt:SetLocalText(TabName[i])
    local unselectTxt = tab:AddComponent(UIText, "unselectText")
    unselectTxt:SetLocalText(TabName[i])
    local red = tab:AddComponent(UIBaseContainer, "RedPoint")
    local redNum = tab:AddComponent(UIText, "RedPoint/RedNum")
    local newTab = {
      rootN = tab,
      btnN = tabBtn,
      selectN = select,
      selectTxtN = selectTxt,
      unselectTxtN = unselectTxt,
      redN = red,
      redNumN = redNum
    }
    table.insert(self.tabTbN, newTab)
  end
end

function UISandWormFishingRewardView:ComponentDestroy()
  self:RemoveList()
  self.titleN = nil
  self.tabTbN = nil
  self.content = nil
  self.closeBtnN = nil
end

function UISandWormFishingRewardView:DataDefine()
end

function UISandWormFishingRewardView:DataDestroy()
  self.curTab = nil
end

function UISandWormFishingRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnSandWormFishingRewardRefresh, self.RefreshRewardList)
end

function UISandWormFishingRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnSandWormFishingRewardRefresh, self.RefreshRewardList)
end

function UISandWormFishingRewardView:InitUI()
  local targetTab = TabType.LevelReward
  self:SelectTab(targetTab)
  local duelInfo = DataCenter.LeagueMatchManager:GetMyCurDuelInfo()
  local myRankType = 0
  if duelInfo and duelInfo.rankType then
    myRankType = duelInfo.rankType
  end
end

function UISandWormFishingRewardView:SelectTab(tab)
  if self.curTab == tab then
    return
  end
  self.curTab = tab
  self.titleN:SetLocalText(TitleName[tab])
  for i, v in pairs(self.tabTbN) do
    if i == tab then
      v.selectN:SetActive(true)
    else
      v.selectN:SetActive(false)
    end
  end
  DataCenter.SandWormFishingDataManager:FetchRewardList(tab)
  self:RefreshRewardList()
end

function UISandWormFishingRewardView:OnClickCloseBtn()
  self.ctrl:CloseSelf()
end

function UISandWormFishingRewardView:OnClickTab(index)
  self:SelectTab(index, self.cacheSeg)
end

function UISandWormFishingRewardView:RemoveList()
  self.content:RemoveComponents(SandWormFishingRewardItem)
  if self.reqs then
    for _, v in pairs(self.reqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.reqs = {}
end

function UISandWormFishingRewardView:RefreshRewardList()
  self:RemoveList()
  local list = DataCenter.SandWormFishingDataManager:GetRewardList(self.curTab) or {}
  if #list == 0 then
    return
  end
  for i = 1, #list do
    self.reqs[i] = self:GameObjectInstantiateAsync(UIAssets.WormFishingRewardItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "SandWormFishingRewardItem" .. i
      item.transform:SetParent(self.content.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.content:AddComponent(SandWormFishingRewardItem, item.name)
      obj:SetData(list[i])
    end)
  end
end

return UISandWormFishingRewardView
