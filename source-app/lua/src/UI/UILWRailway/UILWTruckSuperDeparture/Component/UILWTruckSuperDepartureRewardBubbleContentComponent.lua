local base = UIBaseContainer
local UILWTruckSuperDepartureRewardBubbleContentComponent = BaseClass("UILWTruckSuperDepartureRewardBubbleContentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")

function UILWTruckSuperDepartureRewardBubbleContentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTruckSuperDepartureRewardBubbleContentComponent:OnDestroy()
  self:ClearReward()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTruckSuperDepartureRewardBubbleContentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRewardBubbleContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.btnCloseTuckRewardBubble = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnCloseTuckRewardBubble:SetOnClick(function()
    self:OnBtnCloseTuckRewardBubbleClick()
  end)
  self.compRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.itemObjPool = self.transform:Find("RewardBubbleContent/UICommonResItem").gameObject
  self.itemObjPool:GameObjectCreatePool()
end

function UILWTruckSuperDepartureRewardBubbleContentComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compRewardBubbleContent = nil
  self.btnCloseTuckRewardBubble = nil
  self.compRewardContent = nil
end

function UILWTruckSuperDepartureRewardBubbleContentComponent:DataDefine()
  self.rewardShowViewDataList = nil
  self.isDuringMultiReward = false
end

function UILWTruckSuperDepartureRewardBubbleContentComponent:DataDestroy()
  self.rewardShowViewDataList = nil
  self.isDuringMultiReward = nil
end

function UILWTruckSuperDepartureRewardBubbleContentComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWTruckSuperDepartureRewardBubbleContentComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWTruckSuperDepartureRewardBubbleContentComponent:RefreshShow(position, truckInfo)
  self:SetActive(true)
  self.truckInfo = truckInfo
  local posX = position.x + 1
  local posY = position.y + 1
  if self.truckInfo then
    self.isDuringMultiReward = 1 < MultiRewardDropUtils.GetTruckCurCanEnjoyMaxMultiValue()
  end
  self.compRewardBubbleContent:SetPositionXYZ(posX, posY, 0)
  self:ShowReward()
end

function UILWTruckSuperDepartureRewardBubbleContentComponent:ShowReward()
  self:ClearReward()
  self.rewardShowViewDataList = {}
  local fullRewardList = self.truckInfo:GetFullRewardData()
  for i, data in ipairs(fullRewardList) do
    local rewardParam = self:CreateOneRewardParamData(data)
    table.insert(self.rewardShowViewDataList, rewardParam)
  end
  local count = table.count(self.rewardShowViewDataList)
  if 0 < count then
    for i = 1, count do
      local go = self.itemObjPool:GameObjectSpawn(self.compRewardContent.transform)
      go.name = "item_" .. i
      go:SetActive(true)
      local itemRender = self.compRewardContent:AddComponent(UICommonResItem, go)
      itemRender:ReInit(self.rewardShowViewDataList[i])
      if self.truckInfo then
        local curMultiVal = self.truckInfo.multiple
        if curMultiVal and 1 < curMultiVal and self.isDuringMultiReward then
          itemRender:ShowMultiMark(curMultiVal)
        else
          itemRender:HideMultiMark()
        end
      end
    end
  end
end

function UILWTruckSuperDepartureRewardBubbleContentComponent:CreateOneRewardParamData(rewardData)
  local param = UICommonResItem.Param.New()
  param.rewardType = rewardData.type
  if type(rewardData.value) == "table" then
    param.itemId = rewardData.value.id
    param.count = rewardData.value.num
  else
    param.itemId = rewardData.type
    param.count = self.truckInfo:CorrectResourceRewardCount(rewardData.value)
    local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_BASIC_RESOURCE_PRODUCT_PROMOTION)
    param.isShowArrow = 0 < effectValue
  end
  param.rewardType = rewardData.type
  param.heroUuid = rewardData.heroUuid
  param.isHeroBox = rewardData.isHeroBox
  param.isDelete = false
  return param
end

function UILWTruckSuperDepartureRewardBubbleContentComponent:ClearReward()
  self.compRewardContent:RemoveComponents(UICommonResItem)
  if self.itemObjPool then
    self.itemObjPool:GameObjectRecycleAll()
  end
end

function UILWTruckSuperDepartureRewardBubbleContentComponent:OnBtnCloseTuckRewardBubbleClick()
  self:SetActive(false)
end

return UILWTruckSuperDepartureRewardBubbleContentComponent
