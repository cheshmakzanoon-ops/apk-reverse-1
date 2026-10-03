local UIValentineNpcRewardCardView = BaseClass("UIValentineNpcRewardCardView", UIBaseView)
local RewardUtil = require("Util.RewardUtil")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIValentineNpcRewardCardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIValentineNpcRewardCardView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIValentineNpcRewardCardView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.compSpineNode = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compRewardItem = self.viewSkin:AddComponent(self, UICommonResItem, 5)
  self.textRewardNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.rewardGetFlag = self:AddComponent(UIBaseContainer, "PanelRoot/layout/rewardNode/rewardGetFlag")
  self.spineMaskNode = self:AddComponent(UIBaseContainer, "PanelRoot/spineNode/spineMask")
end

function UIValentineNpcRewardCardView:ComponentDestroy()
  self.viewSkin = nil
  self.btnMask = nil
  self.compSpineNode = nil
  self.textTitle = nil
  self.textDesc = nil
  self.compRewardItem = nil
  self.textRewardNum = nil
end

function UIValentineNpcRewardCardView:ReInit()
  self.data, self.type, self.rewards, self.isFirstOpen = self:GetUserData()
  if self.data == nil or self.type == nil then
    return
  end
  if self.rewards == nil then
    self:RefreshPreviewReward()
  else
    self:RefreshReward()
  end
  if self.isFirstOpen == nil then
    self.isFirstOpen = true
  end
  self.rewardGetFlag:SetActive(not self.isFirstOpen)
  self:CreateSpine()
  self:RefreshContent()
end

function UIValentineNpcRewardCardView:RefreshContent()
  local cardData = self.data:GetCardDisplayData(self.type)
  self.textTitle:SetLocalText(cardData.title)
  self.textDesc:SetLocalText(cardData.desc)
end

function UIValentineNpcRewardCardView:RefreshPreviewReward()
  local cardData = self.data:GetCardDisplayData(self.type)
  local rewardId = cardData.reward
  local rewardList = RewardUtil.GetRewardItem(rewardId)
  if rewardList and 0 < #rewardList then
    self.compRewardItem:ReInit(rewardList[1])
  end
end

function UIValentineNpcRewardCardView:RefreshReward()
  local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(self.rewards)
  if rewardList and 0 < #rewardList then
    self.compRewardItem:ReInit(rewardList[1])
  end
end

function UIValentineNpcRewardCardView:CreateSpine()
  if self.spineReq then
    return
  end
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(self.data.appearance)
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  self.spineReq = self:GameObjectInstantiateAsync(spinePath, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    local obj = request.gameObject
    obj:SetActive(true)
    obj.transform:SetParent(self.spineMaskNode.transform)
    local spineConfig = self.data.spineConfig
    if spineConfig then
      obj.transform.localPosition = Vector3.New(spineConfig.posX, spineConfig.posY, 0)
      obj.transform.localRotation = Quaternion.identity
      if CommonUtil.IsArabicAutoMirrorOpen() then
        obj.transform.localScale = Vector3.New(-spineConfig.scale, spineConfig.scale, spineConfig.scale)
      else
        obj.transform.localScale = Vector3.New(spineConfig.scale, spineConfig.scale, spineConfig.scale)
      end
    end
  end)
end

function UIValentineNpcRewardCardView:DataDefine()
end

function UIValentineNpcRewardCardView:DataDestroy()
  if self.spineReq then
    self.spineReq:Destroy()
    self.spineReq = nil
  end
end

function UIValentineNpcRewardCardView:OnAddListener()
  base.OnAddListener(self)
end

function UIValentineNpcRewardCardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIValentineNpcRewardCardView:OnBtnMaskClick()
  self:OnClose()
end

function UIValentineNpcRewardCardView:OnClose()
  if self.isFirstOpen then
    EventManager:GetInstance():Broadcast(EventId.ValentineNpcRewardGetUIClose, self.data.npcId)
  end
  self.ctrl:CloseSelf()
end

return UIValentineNpcRewardCardView
