local UILWTrainRewardView = BaseClass("UILWTrainRewardView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local close_btn_path = "UICommonRewardPopUp/Panel"
local title_text_path = "Content/TitleTxt"
local reminds_text_path_1 = "Content/RemindsTxt1"

function UILWTrainRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UILWTrainRewardView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTrainRewardView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleTxt = self:AddComponent(UIText, title_text_path)
  self.titleTxt:SetLocalText("457505")
  self.remindsTxt1 = self:AddComponent(UIText, reminds_text_path_1)
  self.remindsTxt1:SetLocalText("457506")
  self.rewardContent = self:AddComponent(UIBaseContainer, "Content/ScrollView/Viewport/Content")
end

function UILWTrainRewardView:ComponentDestroy()
  self:ClearReward()
  self.closeBtn = nil
  self.titleTxt = nil
  self.remindsTxt1 = nil
  self.rewardContent = nil
end

function UILWTrainRewardView:DataDefine()
  self.rewardData = self:GetUserData()
end

function UILWTrainRewardView:DataDestroy()
end

function UILWTrainRewardView:OnEnable()
  base.OnEnable(self)
end

function UILWTrainRewardView:OnDisable()
  base.OnDisable(self)
end

function UILWTrainRewardView:OnAddListener()
  base.OnAddListener(self)
end

function UILWTrainRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWTrainRewardView:RefreshView()
  self:RefreshReward()
end

function UILWTrainRewardView:OnClickGo()
end

function UILWTrainRewardView:ClearReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardItems = {}
  self.rewardReqs = {}
end

function UILWTrainRewardView:RefreshReward()
  self:ClearReward()
  local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(self.rewardData)
  for i, data in ipairs(rewardList) do
    self.rewardReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local index = i
      local nameStr = "UICommonResItem" .. index
      go.name = nameStr
      go:SetActive(true)
      go.transform:SetParent(self.rewardContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local item = self.rewardContent:AddComponent(UICommonResItem, nameStr)
      local param = UICommonResItem.Param.New()
      param.rewardType = data.rewardType
      param.itemId = data.itemId
      param.count = data.count
      param.heroUuid = data.heroUuid
      param.isHeroBox = data.isHeroBox
      item:ReInit(param)
      self.rewardItems[index] = item
    end)
  end
end

return UILWTrainRewardView
