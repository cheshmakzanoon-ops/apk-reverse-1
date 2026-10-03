local UIFlowerTrainArrivedView = BaseClass("UIFlowerTrainArrivedView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIFlowerTrainArrivedCheeringItemComponent = require("UI.FlowerTrain.UIFlowerTrainArrived.View.Component.UIFlowerTrainArrivedCheeringItemComponent")

function UIFlowerTrainArrivedView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local params = self:GetUserData()
  self.rewarDataList = params.reward
  self.trainData = params.trainData
  self.topPlayerArr = params.topPlayerArr
  self:RefreshView()
end

function UIFlowerTrainArrivedView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFlowerTrainArrivedView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.rawImgTrainIcon = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.imgLvIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textDescTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgExpIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textExpNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textLikeNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.loopGridViewRewardScrollView = self.viewSkin:AddComponent(self, UILoopGridView, 9)
  self.compCheerInfoArea = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.loopListView2CheerScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 11)
  self.compCheerContent = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.btnClaim = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.compItemRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 14)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.rawImgTop = self.viewSkin:AddComponent(self, UIRawImage, 16)
  self.imgMid = self.viewSkin:AddComponent(self, UIImage, 17)
  self.rawImgBottom = self.viewSkin:AddComponent(self, UIRawImage, 18)
  self.imgBG = self.viewSkin:AddComponent(self, UIImage, 19)
  self.compItemRoot:SetActive(false)
  self.loopGridViewRewardScrollView:InitGridView(0, function(loopView, index)
    return self:OnGetRewardItemByIndex(loopView, index)
  end)
  self.loopListView2CheerScrollView:InitListView(0, function(loopView, index)
    return self:OnGetCheerItemByIndex(loopView, index)
  end)
end

function UIFlowerTrainArrivedView:ComponentDestroy()
  self.compRewardContent:RemoveComponents(UICommonResItem)
  self.loopGridViewRewardScrollView:ClearAllItems()
  self.compRewardContent = nil
  self.viewSkin = nil
  self.btnClose = nil
  self.rawImgTrainIcon = nil
  self.imgLvIcon = nil
  self.textDescTxt = nil
  self.imgExpIcon = nil
  self.textExpNum = nil
  self.textLikeNum = nil
  self.compRewardContent = nil
  self.loopGridViewRewardScrollView = nil
  self.compCheerInfoArea = nil
  self.loopListView2CheerScrollView = nil
  self.compCheerContent = nil
  self.btnClaim = nil
  self.compItemRoot = nil
  self.btnPanel = nil
  self.rawImgTop = nil
  self.imgMid = nil
  self.rawImgBottom = nil
  self.imgBG = nil
end

function UIFlowerTrainArrivedView:DataDefine()
end

function UIFlowerTrainArrivedView:DataDestroy()
end

function UIFlowerTrainArrivedView:OnAddListener()
  base.OnAddListener(self)
end

function UIFlowerTrainArrivedView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFlowerTrainArrivedView:RefreshView()
  self:RefreshSkin()
  self:RefreshBaseInfo()
  self:RefreshRewardInfo()
  self:RefreshCheerInfo()
  self:GenerateDecoEff()
end

function UIFlowerTrainArrivedView:RefreshSkin()
  if not self.trainData then
    Logger.LogError("UIFlowerTrainArrivedView:RefreshBaseInfo trainData is nil")
    return
  end
  local bgConfig = self.trainData:GetArrivedPanelBGConfig()
  if not bgConfig or #bgConfig < 4 then
    return
  end
  self.rawImgTop:LoadSpriteAsync(bgConfig[1])
  self.imgMid:LoadSpriteAsync(bgConfig[2])
  self.rawImgBottom:LoadSpriteAsync(bgConfig[3])
  self.imgBG:LoadSpriteAsync(bgConfig[4])
end

function UIFlowerTrainArrivedView:RefreshBaseInfo()
  if not self.trainData then
    Logger.LogError("UIFlowerTrainArrivedView:RefreshBaseInfo trainData is nil")
    return
  end
  local iconPath = self.trainData:GetFinishRewardPicPath()
  if iconPath then
    self.rawImgTrainIcon:LoadSpriteAsync(iconPath)
  end
  local lvImgPath = self.trainData:GetLvImgPath()
  if lvImgPath then
    self.imgLvIcon:LoadSpriteAsync(lvImgPath)
  end
  local likeCount = self.trainData:GetLikeCount()
  self.textLikeNum:SetText(likeCount)
  local exp = self.trainData:GetCurTotalExp()
  self.textExpNum:SetText(exp)
  local expImgPath = self.trainData:GetExpFireImgPath()
  if expImgPath then
    self.imgExpIcon:LoadSpriteAsync(expImgPath)
  end
  local duration = self.trainData:GetDuration() / 1000
  local min = math.floor(duration / 60)
  local sec = duration % 60
  local lv = self.trainData:GetFlowerTrainLv()
  self.textDescTxt:SetLocalText(self.trainData:GetArrivedDesc(), min, sec, lv, exp)
end

function UIFlowerTrainArrivedView:RefreshRewardInfo()
  if not self.rewarDataList then
    return
  end
  self.loopGridViewRewardScrollView:SetListItemCount(#self.rewarDataList, false, false)
  self.loopGridViewRewardScrollView:RefreshAllShownItem()
end

function UIFlowerTrainArrivedView:OnGetRewardItemByIndex(loopView, index)
  index = index + 1
  if index < 1 or index > #self.rewarDataList then
    return nil
  end
  local item = loopView:NewListViewItem("UICommonResItem")
  local script = self.compRewardContent:GetComponent(item.gameObject.name, UICommonResItem)
  if script == nil then
    local objectName = tostring(NameCount)
    NameCount = NameCount + 1
    item.gameObject.name = objectName
    script = self.compRewardContent:AddComponent(UICommonResItem, objectName)
  end
  script:SetActive(true)
  item.transform.localScale = Vector3.New(0.8, 0.8, 0.8)
  local rewardData = self.rewarDataList[index]
  if rewardData then
    script:ReInit(rewardData)
  end
  return item
end

function UIFlowerTrainArrivedView:OnGetCheerItemByIndex(loopView, index)
  index = index + 1
  if index < 1 or index > #self.topPlayerArr then
    return nil
  end
  local item = loopView:NewListViewItem("UIFlowerTrainArrivedCheeringItem")
  local script = self.compCheerContent:GetComponent(item.gameObject.name, UIFlowerTrainArrivedCheeringItemComponent)
  if script == nil then
    local objectName = tostring(NameCount)
    NameCount = NameCount + 1
    item.gameObject.name = objectName
    script = self.compCheerContent:AddComponent(UIFlowerTrainArrivedCheeringItemComponent, objectName)
  end
  script:SetActive(true)
  item.transform.localScale = Vector3.New(1, 1, 1)
  local playerData = self.topPlayerArr[index]
  if playerData then
    script:ReInit(playerData)
  end
  return item
end

function UIFlowerTrainArrivedView:RefreshCheerInfo()
  if not self.topPlayerArr or #self.topPlayerArr == 0 then
    self.compCheerInfoArea:SetActive(false)
    return
  end
  self.compCheerInfoArea:SetActive(true)
  self.loopListView2CheerScrollView:SetListItemCount(#self.topPlayerArr, false, false)
  self.loopListView2CheerScrollView:RefreshAllShownItem()
end

function UIFlowerTrainArrivedView:OnBtnCloseClick()
  self:CloseView()
end

function UIFlowerTrainArrivedView:OnBtnClaimClick()
  self:CloseView()
end

function UIFlowerTrainArrivedView:OnBtnPanelClick()
  self:CloseView()
end

function UIFlowerTrainArrivedView:CloseView()
  self.ctrl:CloseSelf()
  if self.rewarDataList ~= nil and table.count(self.rewarDataList) > 0 then
    for i = 1, #self.rewarDataList do
      local child = self.compRewardContent.transform:GetChild(i - 1)
      local img = child.gameObject.transform:Find("clickBtn/ItemIcon")
      local pic = DataCenter.RewardManager:GetPicByType(self.rewarDataList[i].rewardType, self.rewarDataList[i].itemId)
      local flyPos = Vector3.New(0, 0, 0)
      UIUtil.DoFly(self.rewarDataList[i].rewardType, 2, pic, img.gameObject.transform.position, flyPos, 100, 100)
    end
  end
  self:ShowShareView()
end

function UIFlowerTrainArrivedView:ShowShareView()
  if self.trainData and self.trainData.paraMeta and self.trainData:GetCurTotalExp() > self.trainData.paraMeta.share_condition then
    UIUtil.OpenLWUIChatCommonShare(self.trainData.paraMeta.share_config, {
      trainData = self.trainData
    })
  end
end

function UIFlowerTrainArrivedView:GenerateDecoEff()
  if not (self.trainData and self.trainData.paraMeta) or not self.trainData.paraMeta.arrived_panel_deco_cfg then
    return
  end
  FlowerTrainUtils.GeneratePanelDeco(self, self.trainData.paraMeta.arrived_panel_deco_cfg)
end

return UIFlowerTrainArrivedView
