local ULWUIActValentineRankRewardItem = BaseClass("ULWUIActValentineRankRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rank_icon_num2_path = "RankIconNum2"

function ULWUIActValentineRankRewardItem:OnCreate()
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
  self.rank_icon_num2 = self:AddComponent(UITextMeshProUGUIEx, rank_icon_num2_path)
end

function ULWUIActValentineRankRewardItem:OnBeginDrag(eventData)
  if self.parentBeginDragCallBack then
    self.parentBeginDragCallBack(eventData)
  end
end

function ULWUIActValentineRankRewardItem:OnEndDrag(eventData)
  if self.parentEndDragCallBack then
    self.parentEndDragCallBack(eventData)
  end
end

function ULWUIActValentineRankRewardItem:OnDrag(eventData)
  if self.parentDragCallBack then
    self.parentDragCallBack(eventData)
  end
end

function ULWUIActValentineRankRewardItem:OnDestroy()
  self:ClearScroll()
  base.OnDestroy(self)
end

function ULWUIActValentineRankRewardItem:OnEnable()
  base.OnEnable(self)
end

function ULWUIActValentineRankRewardItem:OnDisable()
  base.OnDisable(self)
end

function ULWUIActValentineRankRewardItem:SetData(data, onBeginDragFunc, onEndDragFunc, onDragFunc)
  self.parentBeginDragCallBack = onBeginDragFunc
  self.parentEndDragCallBack = onEndDragFunc
  self.parentDragCallBack = onDragFunc
  self.data = data
  self.noRewardTxt:SetActive(false)
  self.scroll_view_reward:SetActive(false)
  if data.minRank == -1 then
    self.numTxt:SetText("-")
    self.rankIcon:SetActive(false)
    self.noRewardTxt:SetActive(true)
    self.scroll_view_reward:SetActive(false)
    return
  end
  self.noRewardTxt:SetActive(false)
  self.scroll_view_reward:SetActive(true)
  if data.uid and data.uid == LuaEntry.Player.uid then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5.png")
  elseif data.minRank == 1 and data.maxRank == 1 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png")
  elseif data.minRank == 2 and data.maxRank == 2 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png")
  elseif data.minRank == 3 and data.maxRank == 3 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png")
  else
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png")
  end
  self:SetRankIcon(data.minRank)
  if data.minRank ~= data.maxRank then
    self.numTxt:SetText(data.minRank .. "-" .. data.maxRank)
    self.rank_icon_num2:SetText(data.minRank .. "-" .. data.maxRank)
  else
    self.numTxt:SetText(data.minRank)
    self.rank_icon_num2:SetText(data.minRank)
  end
  if data.minRank >= 1 and data.minRank <= 3 then
    self.numTxt:SetActive(true)
    self.rank_icon_num2:SetActive(false)
  else
    self.numTxt:SetActive(false)
    self.rank_icon_num2:SetActive(true)
  end
  self.rewardList = DataCenter.RewardManager:ReturnRewardParamForView(self.data.reward)
  if next(self.rewardList) then
    self:ClearScroll()
    self.scroll_view_reward:SetTotalCount(#self.rewardList)
    self.scroll_view_reward:RefillCells()
    self.scroll_view_reward:SetHorizontalNormalizedPosition(0)
  end
end

function ULWUIActValentineRankRewardItem:SetRankIcon(rank)
  self.rankIcon:SetActive(rank <= 3 and 1 <= rank)
  if rank <= 3 then
    if rank == 1 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang01.png")
    elseif rank == 2 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang02.png")
    elseif rank == 3 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang03.png")
    end
  end
  self.rankIcon:SetNativeSize()
end

function ULWUIActValentineRankRewardItem:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  itemObj.transform:Set_localScale(0.7, 0.7, 0.7)
  local cellItem = self.scroll_view_reward:AddComponent(UICommonResItem, itemObj)
  cellItem:ParseInfo(self.rewardList[index])
end

function ULWUIActValentineRankRewardItem:OnItemMoveOut(itemObj, index)
  self.scroll_view_reward:RemoveComponent(itemObj.name, UICommonResItem)
end

function ULWUIActValentineRankRewardItem:ClearScroll()
  self.scroll_view_reward:ClearCells()
  self.scroll_view_reward:RemoveComponents(UICommonResItem)
end

return ULWUIActValentineRankRewardItem
