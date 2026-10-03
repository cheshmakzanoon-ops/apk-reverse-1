local ScratchOffCommonRewardPanel = BaseClass("ScratchOffCommonRewardPanel", UIBaseContainer)
local base = UIBaseContainer
local commonRewardItem = require("UI.UIScratchOffRewardDetailPage.Comp.ScratchOffCommonRewardItem")
local commonRewardTitleTxt_path = "ScrollView/Viewport/Content/RectCommonReward/commonRewardTitle/commonRewardTxt"
local commonRewardItem_path = "ScrollView/Viewport/Content/RectCommonReward/RectCommonRewardContent/ScratchOffCommonRewardItem"
local extraRewardTitleTxt_path = "ScrollView/Viewport/Content/RectExtraReward/extraRewardTitle/extraRewardTxt"
local extraRewardItem_path = "ScrollView/Viewport/Content/RectExtraReward/RectExtraRewardContent/extraRewardItem/UICommonResItem"
local commonRewardItemMaxNum = 16

function ScratchOffCommonRewardPanel:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ScratchOffCommonRewardPanel:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ScratchOffCommonRewardPanel:DataDefine()
  self.commonRewardItemList = {}
  self.extraItem = nil
end

function ScratchOffCommonRewardPanel:DataDestroy()
  self.commonRewardItemList = nil
  self.extraItem = nil
end

function ScratchOffCommonRewardPanel:ComponentDefine()
  self.commonRewardTitleTxt = self:AddComponent(UIText, commonRewardTitleTxt_path)
  self.commonRewardTitleTxt:SetLocalText(2000696)
  for i = 1, commonRewardItemMaxNum do
    local item = self:AddComponent(commonRewardItem, commonRewardItem_path .. i)
    table.insert(self.commonRewardItemList, item)
  end
  self.extraRewardTitleTxt = self:AddComponent(UIText, extraRewardTitleTxt_path)
  self.extraRewardTitleTxt:SetLocalText(2000697)
  self.extraItem = self:AddComponent(UICommonResItem, extraRewardItem_path)
end

function ScratchOffCommonRewardPanel:ComponentDestroy()
end

function ScratchOffCommonRewardPanel:RefreshPanel(activityId)
  if self.activityId and self.activityId == activityId then
    return
  end
  self.activityId = activityId
  self.chooseIndex = DataCenter.ScratchOffGameManager:GetSelectedHeroIndexByActId(activityId)
  local commonRewardItemInfoList = self:GetCommonRewardItemInfoList(activityId)
  if commonRewardItemInfoList and 0 < #commonRewardItemInfoList then
    for i = 1, commonRewardItemMaxNum do
      if i <= #commonRewardItemInfoList then
        self.commonRewardItemList[i]:SetActive(true)
        self.commonRewardItemList[i]:SetData(commonRewardItemInfoList[i], self.chooseIndex)
      else
        self.commonRewardItemList[i]:SetActive(false)
      end
    end
  end
  local extraItemInfo = self:GetExtraItemInfo(activityId)
  self.extraItem:ReInit(extraItemInfo)
end

function ScratchOffCommonRewardPanel:GetCommonRewardItemInfoList(activityId)
  local list = DataCenter.ScratchOffGameManager:GetCommonRewardItemInfoListByActId(activityId)
  if list and 0 < #list then
    local itemInfoList = {}
    for i = 1, #list do
      local value = list[i]
      local itemInfo = {}
      itemInfo.rate = value.rate
      itemInfo.resItemInfo = value.resItemInfo[math.min(self.chooseIndex, #value.resItemInfo)]
      table.insert(itemInfoList, itemInfo)
    end
    return itemInfoList
  end
  return nil
end

function ScratchOffCommonRewardPanel:GetExtraItemInfo(activityId)
  local info = DataCenter.ScratchOffGameManager:GetExtraRewardItemInfoByActId(activityId)
  if info == nil then
    return nil
  end
  local itemInfo = {}
  itemInfo.rewardType = RewardType.GOODS
  itemInfo.itemId = info.id
  itemInfo.count = info.count
  return itemInfo
end

return ScratchOffCommonRewardPanel
