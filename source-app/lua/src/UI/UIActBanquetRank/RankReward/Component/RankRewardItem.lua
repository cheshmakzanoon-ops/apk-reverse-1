local RankRewardItem = BaseClass("RankRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function RankRewardItem:OnCreate()
  base.OnCreate(self)
  self.bgImgN = self:AddComponent(UIImage, "bg")
  self.rankIcon = self:AddComponent(UIImage, "RankIcon")
  self.numTxt = self:AddComponent(UIText, "RankIconNum")
  self.noRewardTxt = self:AddComponent(UIText, "NoRewardText")
  self.noRewardTxt:SetLocalText(2800059)
  self.scroll_view_reward = self:AddComponent(UIScrollView, "ScrollView")
  self.scroll_view_reward:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view_reward:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.scroll_view_reward:SetOnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.scroll_view_reward:SetOnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.scroll_view_reward:SetOnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
end

function RankRewardItem:OnBeginDrag(eventData)
  if self.parentBeginDragCallBack then
    self.parentBeginDragCallBack(eventData)
  end
end

function RankRewardItem:OnEndDrag(eventData)
  if self.parentEndDragCallBack then
    self.parentEndDragCallBack(eventData)
  end
end

function RankRewardItem:OnDrag(eventData)
  if self.parentDragCallBack then
    self.parentDragCallBack(eventData)
  end
end

function RankRewardItem:OnDestroy()
  self:ClearScroll()
  base.OnDestroy(self)
end

function RankRewardItem:OnEnable()
  base.OnEnable(self)
end

function RankRewardItem:OnDisable()
  base.OnDisable(self)
end

function RankRewardItem:RefreshData(data, reward, onBeginDragFunc, onEndDragFunc, onDragFunc)
  self.parentBeginDragCallBack = onBeginDragFunc
  self.parentEndDragCallBack = onEndDragFunc
  self.parentDragCallBack = onDragFunc
  self.data = data
  self.noRewardTxt:SetActive(false)
  self.scroll_view_reward:SetActive(false)
  if data.beginRank == -1 then
    self.numTxt:SetText("-")
    self.rankIcon:SetActive(false)
    self.noRewardTxt:SetActive(true)
    self.scroll_view_reward:SetActive(false)
    return
  end
  self.noRewardTxt:SetActive(false)
  self.scroll_view_reward:SetActive(true)
  local color = Color.New(0, 0, 0, 1)
  local scoreColor = Color.New(1, 1, 1, 1)
  if data.uid and data.uid == LuaEntry.Player.uid then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao.png")
    scoreColor = Color.New(0.37254901960784315, 0.9372549019607843, 0.5294117647058824, 1)
  elseif data.beginRank == 1 and data.endRank == 1 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao.png")
    color = Color.New(0.8156862745098039, 0.4823529411764706, 0.047058823529411764, 1)
  elseif data.beginRank == 2 and data.endRank == 2 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao.png")
    color = Color.New(0.4, 0.4549019607843137, 0.7294117647058823, 1)
  elseif data.beginRank == 3 and data.endRank == 3 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao.png")
    color = Color.New(0.7176470588235294, 0.4666666666666667, 0.34509803921568627, 1)
  else
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao.png")
  end
  self:SetRankIcon(data.beginRank)
  if data.beginRank ~= data.endRank then
    self.numTxt:SetText(data.beginRank .. "-" .. data.endRank)
  else
    self.numTxt:SetText(data.beginRank)
  end
  self.rewardList = reward
  if next(self.rewardList) then
    self:ClearScroll()
    self.scroll_view_reward:SetTotalCount(#self.rewardList)
    self.scroll_view_reward:RefillCells()
    self.scroll_view_reward:SetHorizontalNormalizedPosition(0)
  end
end

function RankRewardItem:SetRankIcon(rank)
  self.rankIcon:SetActive(rank <= 3 and 1 <= rank)
  if rank <= 3 then
    if rank == 1 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_1.png")
    elseif rank == 2 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_2.png")
    elseif rank == 3 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_3.png")
    end
  end
end

function RankRewardItem:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  itemObj.transform:Set_localScale(1, 1, 1)
  local cellItem = self.scroll_view_reward:AddComponent(UICommonResItem, itemObj)
  cellItem:ParseInfo(self.rewardList[index])
end

function RankRewardItem:OnItemMoveOut(itemObj, index)
  self.scroll_view_reward:RemoveComponent(itemObj.name, UICommonResItem)
end

function RankRewardItem:ClearScroll()
  self.scroll_view_reward:ClearCells()
  self.scroll_view_reward:RemoveComponents(UICommonResItem)
end

return RankRewardItem
