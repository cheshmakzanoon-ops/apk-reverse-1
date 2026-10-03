local StageItem = BaseClass("StageItem", UIAsyncDataContainer)
local base = UIAsyncDataContainer
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
StageItem.DataSchema = {
  "goodsId",
  "count",
  "needCnt",
  "claimedState"
}
StageItem.PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/CardBoxTip/StageItem.prefab"

function StageItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function StageItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function StageItem:ComponentDefine()
  self.rewardItem = self:AddComponent(UICommonResItem, "rewardItem")
  self.stageNeed_txt = self:AddComponent(UIText, "stageNeed_txt")
  self.claimedState = self:AddComponent(UIImage, "claimedState")
end

function StageItem:ComponentDestroy()
end

function StageItem:UpdateData()
  local data = self:GetData()
  if not data then
    return
  end
  self.stageNeed_txt:SetText(tostring(data.needCnt))
  if data.goodsId and data.count then
    local param = UICommonResItem.Param.New()
    param.rewardType = RewardType.GOODS
    param.itemId = data.goodsId
    param.count = data.count
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
    if itemTemplate and itemTemplate.tipsType == GOODS_TIPS_TYPE.BoxTacticalCard then
      function param.clickCallBack()
        local tipsParam = {}
        
        tipsParam.itemId = param.itemId
        tipsParam.alignObject = self
        tipsParam.showArrow = true
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardChoiceBoxTips, {anim = true}, tipsParam)
      end
    end
    self.rewardItem:ReInit(param)
  end
  self:UpdateState()
end

function StageItem:UpdateState()
  local scoreInfo = DataCenter.TacticalCardDataManager:GetScoreInfo()
  local currentScore = scoreInfo or 0
  local data = self:GetData()
  local isAchieved = currentScore >= data.needCnt
  if self.claimedState then
    self.claimedState:SetActive(isAchieved)
  end
end

return StageItem
