local UISurvivorPackPopupView = BaseClass("UISurvivorPackPopupView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local GiftPackInfoDefault = require("DataCenter.GiftPackageData.GiftPackInfoDefault")
local WorkerUtil = require("DataCenter.WorkerData.WorkerUtil")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")

function UISurvivorPackPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UISurvivorPackPopupView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISurvivorPackPopupView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textAddBuffDes1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textAddBuffNum1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textAddBuffDes2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textAddBuffNum2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.scrollRectFreeScroll = self.viewSkin:AddComponent(self, UIScrollRect, 8)
  self.textFreeTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.scrollRectPayScroll = self.viewSkin:AddComponent(self, UIScrollRect, 10)
  self.textPayTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textPrice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.rawImgBg = self.viewSkin:AddComponent(self, UIRawImage, 13)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.compPayContent = self.viewSkin:AddComponent(self, UIBaseContainer, 15)
  self.rawImgPoseImage = self.viewSkin:AddComponent(self, UIRawImage, 16)
  self.btnGet = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnGet:SetOnClick(function()
    self:OnBtnGetClick()
  end)
  self.imgClaim = self.viewSkin:AddComponent(self, UIImage, 18)
  self.textMultiplier = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textGetBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.loopListView2FreeScroll = self.viewSkin:AddComponent(self, UILoopListView2, 22)
  self.loopListView2PayScroll = self.viewSkin:AddComponent(self, UILoopListView2, 23)
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 24)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.buyBtn = self.viewSkin:AddComponent(self, LWBtnBuyRefundRemind, 25)
end

function UISurvivorPackPopupView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textName = nil
  self.btnClose = nil
  self.textAddBuffDes1 = nil
  self.textAddBuffNum1 = nil
  self.textAddBuffDes2 = nil
  self.textAddBuffNum2 = nil
  self.scrollRectFreeScroll = nil
  self.textFreeTitle = nil
  self.scrollRectPayScroll = nil
  self.textPayTitle = nil
  self.textPrice = nil
  self.rawImgBg = nil
  self.compContent = nil
  self.compPayContent = nil
  self.rawImgPoseImage = nil
  self.btnGet = nil
  self.imgClaim = nil
  self.textMultiplier = nil
  self.btnInfo = nil
  self.textGetBtn = nil
  self.loopListView2FreeScroll = nil
  self.loopListView2PayScroll = nil
  self.btnUICommonBlackMask = nil
  self.buyBtn = nil
end

function UISurvivorPackPopupView:DataDefine()
  self.fakeUid = nil
  self.survivorListId = nil
  self.workerId = nil
  self.exchangeId = nil
  self.freeId = nil
  self.freeRewards = {}
  self.payRewards = {}
  self.rewardItemNameSeq = 0
  self.freeRewardScale = 0.7
  self.payRewardScale = 1
  self.exchangePack = nil
  if self.buyBtn ~= nil then
    self.buyBtn:SetSafeClickMode(true)
    self.buyBtn:SetBuyClickAction(function()
      self:OnBtnBuyClick()
    end)
  end
end

function UISurvivorPackPopupView:DataDestroy()
  self:ClearLoopRewardList(self.loopListView2FreeScroll, self.compContent)
  self:ClearLoopRewardList(self.loopListView2PayScroll, self.compPayContent)
  if self.exchangePack ~= nil then
    self.exchangePack:dispose()
    self.exchangePack = nil
  end
  self.freeRewards = nil
  self.payRewards = nil
  self.rewardItemNameSeq = nil
end

function UISurvivorPackPopupView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SurvivorPackInfoMsg, self.RefreshView)
  self:AddUIListener(EventId.PaySuccess, self.OnPaySuccess)
end

function UISurvivorPackPopupView:OnRemoveListener()
  self:RemoveUIListener(EventId.SurvivorPackInfoMsg, self.RefreshView)
  self:RemoveUIListener(EventId.PaySuccess, self.OnPaySuccess)
  base.OnRemoveListener(self)
end

function UISurvivorPackPopupView:InitView()
  local fakeUid, survivorListId = self:GetUserData()
  self.fakeUid = fakeUid
  self.survivorListId = survivorListId
  self.workerId = nil
  self.textGetBtn:SetText(Localization:GetString("151084"))
  self:InitRewardLoopList()
  self:RefreshView()
  local groupKey = DataCenter and DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager.list_group or ""
  local survivorTpl = DataCenter and DataCenter.ActivitySurvivorListTemplateManager and DataCenter.ActivitySurvivorListTemplateManager:GetTemplate(survivorListId, groupKey)
  if survivorTpl ~= nil then
    self.freeId = tonumber(survivorTpl.free) or survivorTpl.free
    self.exchangeId = tonumber(survivorTpl.exchange) or survivorTpl.exchange
    if not string.IsNullOrEmpty(survivorTpl.subtitle) then
      self.textTitle:SetText(Localization:GetString(survivorTpl.subtitle))
    end
    if not string.IsNullOrEmpty(survivorTpl.title_free) then
      self.textFreeTitle:SetText(Localization:GetString(survivorTpl.title_free))
    end
    if not string.IsNullOrEmpty(survivorTpl.title_pay) then
      self.textPayTitle:SetText(Localization:GetString(survivorTpl.title_pay))
    end
    local nameWorkerId = tonumber(survivorTpl.title)
    if nameWorkerId ~= nil and 0 < nameWorkerId then
      local nameWorkerLine = LocalController:instance():getLine(TableName.LW_Worker, nameWorkerId)
      if nameWorkerLine ~= nil and not string.IsNullOrEmpty(nameWorkerLine.last_name) then
        self.textName:SetText(Localization:GetString(nameWorkerLine.last_name))
      end
    end
    local poseWorkerId = tonumber(survivorTpl.worker_id)
    if poseWorkerId ~= nil and 0 < poseWorkerId then
      self.workerId = poseWorkerId
    else
      self.workerId = nil
    end
  end
  self:RefreshPayBuyBtnState()
  self:RefreshSurvivorPose()
  self:RefreshWorkerEffects()
  self:RefreshRewardView()
end

function UISurvivorPackPopupView:InitRewardLoopList()
  if self.loopListView2FreeScroll ~= nil then
    self.loopListView2FreeScroll:InitListView(0, function(loopView, index)
      return self:OnGetFreeRewardItemByIndex(loopView, index)
    end)
  end
  if self.loopListView2PayScroll ~= nil then
    self.loopListView2PayScroll:InitListView(0, function(loopView, index)
      return self:OnGetPayRewardItemByIndex(loopView, index)
    end)
  end
end

function UISurvivorPackPopupView:GetRewardItemName()
  self.rewardItemNameSeq = (self.rewardItemNameSeq or 0) + 1
  return "UICommonResItem_" .. tostring(self.rewardItemNameSeq)
end

function UISurvivorPackPopupView:BindRewardItem(loopView, contentScript, index, rewardData, scale)
  if contentScript == nil or rewardData == nil then
    return nil
  end
  local item = loopView:NewListViewItem("UICommonResItem")
  if item == nil then
    return nil
  end
  local s = tonumber(scale)
  if s == nil or s <= 0 then
    s = 1
  end
  item.transform:Set_localScale(s, s, s)
  local script = contentScript:GetComponent(item.gameObject.name, UICommonResItem)
  if script == nil then
    item.gameObject.name = self:GetRewardItemName()
    script = contentScript:AddComponent(UICommonResItem, item.gameObject.name)
  end
  if script ~= nil then
    script:SetActive(true)
    script:ReInit(rewardData)
  end
  return item
end

function UISurvivorPackPopupView:OnGetFreeRewardItemByIndex(loopView, index)
  index = index + 1
  if self.freeRewards == nil or index < 1 or index > #self.freeRewards then
    return nil
  end
  return self:BindRewardItem(loopView, self.compContent, index, self.freeRewards[index], self.freeRewardScale)
end

function UISurvivorPackPopupView:OnGetPayRewardItemByIndex(loopView, index)
  index = index + 1
  if self.payRewards == nil or index < 1 or index > #self.payRewards then
    return nil
  end
  return self:BindRewardItem(loopView, self.compPayContent, index, self.payRewards[index], self.payRewardScale)
end

function UISurvivorPackPopupView:RefreshView()
  self.btnGet:SetActive(not DataCenter.SurvivorPackManager:IsFreeRewardReceivedById(self.survivorListId))
  self.imgClaim:SetActive(DataCenter.SurvivorPackManager:IsFreeRewardReceivedById(self.survivorListId))
  self:RefreshPayBuyBtnState()
end

function UISurvivorPackPopupView:RefreshPayBuyBtnState()
  if self.buyBtn == nil then
    return
  end
  local isPayReceived = false
  if self.survivorListId ~= nil and DataCenter and DataCenter.SurvivorPackManager then
    isPayReceived = DataCenter.SurvivorPackManager:IsPayRewardReceivedById(self.survivorListId)
  end
  self.buyBtn:SetBuyButtonInteractable(true)
  self.buyBtn:SetGray(isPayReceived, true)
  if isPayReceived then
    self.buyBtn:SetPriceText(Localization:GetString("2000092"))
  else
    self:RefreshBuyBtnText()
  end
end

function UISurvivorPackPopupView:RefreshBuyBtnText()
  if self.exchangePack ~= nil then
    self.exchangePack:dispose()
    self.exchangePack = nil
  end
  local idNum = tonumber(self.exchangeId)
  if idNum == nil or idNum <= 0 or LocalController:instance():getLine(TableName.Exchange, idNum) == nil then
    if self.buyBtn ~= nil then
      self.buyBtn:SetPriceText("")
    end
    self.textMultiplier:SetText("")
    return
  end
  local serverPack = GiftPackageData.get(tostring(idNum))
  if self.buyBtn ~= nil then
    if serverPack ~= nil then
      self.buyBtn:Init(serverPack)
      self.buyBtn:RefreshPoint()
      self.buyBtn:SetActive(true)
    else
      self.buyBtn:SetActive(false)
    end
  end
  local percent = serverPack and serverPack:getPercent()
  if percent ~= nil and tostring(percent) ~= "" then
    self.textMultiplier:SetLocalText("giftpackage_value", percent)
  else
    self.textMultiplier:SetText("")
  end
end

function UISurvivorPackPopupView:RefreshSurvivorPose()
  if DataCenter == nil or DataCenter.SurvivorPackManager == nil then
    return
  end
  if self.workerId == nil then
    return
  end
  local workerLine = LocalController:instance():getLine(TableName.LW_Worker, tonumber(self.workerId))
  if workerLine == nil then
    return
  end
  local appearanceId = workerLine.appearance
  if appearanceId == nil then
    return
  end
  local imgPath = HeroUtils.GetHeroIconPath(tonumber(appearanceId), HeroIconType.pose_icon_path)
  if string.IsNullOrEmpty(imgPath) then
    return
  end
  self.rawImgPoseImage:LoadSpriteAuto(imgPath, function(texture)
    if self and self.rawImgPoseImage then
      self.rawImgPoseImage:SetNativeSize()
    end
  end)
end

function UISurvivorPackPopupView:RefreshWorkerEffects()
  if self.workerId == nil then
    return
  end
  local workerLine = LocalController:instance():getLine(TableName.LW_Worker, tonumber(self.workerId))
  if workerLine == nil then
    return
  end
  local workerEffect = workerLine.effect
  if type(workerEffect) ~= "table" then
    workerEffect = nil
  end
  self.textAddBuffDes1:SetText("")
  self.textAddBuffNum1:SetText("")
  self.textAddBuffDes2:SetText("")
  self.textAddBuffNum2:SetText("")
  local effects = {}
  if workerEffect ~= nil then
    if type(workerEffect[1]) == "table" then
      for i = 1, 2 do
        local pair = workerEffect[i]
        if pair ~= nil and pair[1] ~= nil and pair[2] ~= nil then
          table.insert(effects, {
            tonumber(pair[1]),
            tonumber(pair[2])
          })
        end
      end
    else
      if workerEffect[1] ~= nil and workerEffect[2] ~= nil then
        table.insert(effects, {
          tonumber(workerEffect[1]),
          tonumber(workerEffect[2])
        })
      end
      if workerEffect[3] ~= nil and workerEffect[4] ~= nil then
        table.insert(effects, {
          tonumber(workerEffect[3]),
          tonumber(workerEffect[4])
        })
      end
    end
  end
  for idx = 1, 2 do
    local eff = effects[idx]
    if eff ~= nil and eff[1] ~= nil and eff[2] ~= nil and eff[1] > 0 then
      local describe, text = WorkerUtil.GetEffectText(eff[1], eff[2], true)
      if idx == 1 then
        self.textAddBuffDes1:SetText(describe)
        self.textAddBuffNum1:SetText(text)
      else
        self.textAddBuffDes2:SetText(describe)
        self.textAddBuffNum2:SetText(text)
      end
    end
  end
end

function UISurvivorPackPopupView:RefreshRewardView()
  self.freeRewards = self:BuildRewardListByRewardConfigId(self.freeId)
  self.payRewards = self:BuildPayRewardListByExchangeId(self.exchangeId)
  if self.loopListView2FreeScroll ~= nil then
    self.loopListView2FreeScroll:SetListItemCount(self.freeRewards and #self.freeRewards or 0, false, false)
    self.loopListView2FreeScroll:RefreshAllShownItem()
  end
  if self.loopListView2PayScroll ~= nil then
    self.loopListView2PayScroll:SetListItemCount(self.payRewards and #self.payRewards or 0, false, false)
    self.loopListView2PayScroll:RefreshAllShownItem()
  end
end

function UISurvivorPackPopupView:BuildRewardListByRewardConfigId(rewardConfigId)
  local rewardList = {}
  local idNum = tonumber(rewardConfigId)
  if idNum == nil or idNum <= 0 then
    return rewardList
  end
  local rewards = RewardUtil.GetRewardsById(idNum) or {}
  if DataCenter and DataCenter.RewardManager and DataCenter.RewardManager.RewardItemList then
    rewardList = DataCenter.RewardManager:RewardItemList(rewards) or {}
  else
    rewardList = rewards
  end
  return rewardList
end

function UISurvivorPackPopupView:BuildPayRewardListByExchangeId(exchangeId)
  local idNum = tonumber(exchangeId)
  if idNum == nil or idNum <= 0 then
    return {}
  end
  if LocalController:instance():getLine(TableName.Exchange, idNum) == nil then
    return {}
  end
  local pack = GiftPackInfoDefault.New()
  pack:update({id = idNum, simple = true})
  local rewardList = pack:getItems(false)
  local resStr = pack:getResourceStr()
  pack:dispose()
  if not string.IsNullOrEmpty(resStr) then
    self:AppendExchangeResourceStrToRewardList(rewardList, resStr)
  end
  return rewardList
end

function UISurvivorPackPopupView:AppendExchangeResourceStrToRewardList(rewardList, resourceStr)
  if string.IsNullOrEmpty(resourceStr) then
    return
  end
  local resStrs = string.split(resourceStr, "|")
  for _, resSeg in ipairs(resStrs) do
    if not string.IsNullOrEmpty(resSeg) then
      local spls = string.split(resSeg, ";")
      if #spls == 2 then
        rewardList[#rewardList + 1] = {
          rewardType = ResTypeToReward[tonumber(spls[1])],
          count = tonumber(spls[2])
        }
      end
    end
  end
end

function UISurvivorPackPopupView:ClearLoopRewardList(loopListView, contentScript)
  if contentScript ~= nil then
    contentScript:RemoveComponents(UICommonResItem)
  end
  if loopListView ~= nil then
    loopListView:ClearAllItems()
  end
end

function UISurvivorPackPopupView:OnBtnCloseClick()
  self.ctrl:CloseSelf(self.fakeUid)
end

function UISurvivorPackPopupView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf(self.fakeUid)
end

function UISurvivorPackPopupView:OnBtnBuyClick()
  if self.exchangeId == nil then
    return
  end
  local exchangeIdNum = tonumber(self.exchangeId)
  if exchangeIdNum == nil or exchangeIdNum <= 0 then
    return
  end
  if self.survivorListId ~= nil and DataCenter and DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager:IsPayRewardReceivedById(self.survivorListId) then
    return
  end
  local pack = GiftPackageData.get(tostring(exchangeIdNum))
  if pack == nil then
    return
  end
  local actData = DataCenter and DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager.actData
  local actId = actData and actData.activityId
  if actId == nil then
    return
  end
  DataCenter.PayManager:CallPayment(pack, UIWindowNames.UISurvivorPackPopup, "", actId)
end

function UISurvivorPackPopupView:OnPaySuccess(itemId)
  if tonumber(itemId) ~= tonumber(self.exchangeId) then
    return
  end
  local actData = DataCenter and DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager.actData
  local actId = actData and actData.activityId
  if actId == nil then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SurvivorVisitorInfo, actId)
  local freeReceived = DataCenter and DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager:IsFreeRewardReceivedById(self.survivorListId)
  if freeReceived then
    self.ctrl:CloseSelf(self.fakeUid)
  end
end

function UISurvivorPackPopupView:OnBtnGetClick()
  local actData = DataCenter and DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager.actData
  local actId = actData and actData.activityId
  if actId == nil then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SurvivorVisitorReceiveFree, actId, self.survivorListId)
end

function UISurvivorPackPopupView:OnBtnInfoClick()
  if self.btnInfo == nil then
    return
  end
  local actData = DataCenter and DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager.actData
  local survivorCfgId = actData and (actData.tableInfoType or actData.subType)
  if survivorCfgId == nil then
    return
  end
  local survivorCfg = DataCenter.ActivitySurvivorTemplateManager and DataCenter.ActivitySurvivorTemplateManager:GetTemplate(survivorCfgId)
  local rulesKey = survivorCfg and survivorCfg.rules or ""
  if string.IsNullOrEmpty(rulesKey) then
    return
  end
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.title = nil
  param.content = Localization:GetString(rulesKey)
  param.alignObject = self.btnInfo.transform
  param.width = 400
  param.yPosFix = 11
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

return UISurvivorPackPopupView
