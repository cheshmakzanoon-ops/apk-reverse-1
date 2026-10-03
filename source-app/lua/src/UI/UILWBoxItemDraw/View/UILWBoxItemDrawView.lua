local UILWBoxItemDrawView = BaseClass("UILWBoxItemDrawView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWBoxItemDrawItemComponent = require("UI/UILWBoxItemDraw/Component/UILWBoxItemDrawItemComponent")

function UILWBoxItemDrawView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWBoxItemDrawView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBoxItemDrawView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnBack = self:AddComponent(UIButton, "BtnBack")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnInfo = self:AddComponent(UIButton, "titleBg/Layout/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compBoxItem01 = self:AddComponent(UILWBoxItemDrawItemComponent, "Content/BoxContent/BoxItem01")
  self.compBoxItem02 = self:AddComponent(UILWBoxItemDrawItemComponent, "Content/BoxContent/BoxItem02")
  self.compBoxItem03 = self:AddComponent(UILWBoxItemDrawItemComponent, "Content/BoxContent/BoxItem03")
  self.compBoxItem04 = self:AddComponent(UILWBoxItemDrawItemComponent, "Content/BoxContent/BoxItem04")
  self.compBoxItem05 = self:AddComponent(UILWBoxItemDrawItemComponent, "Content/BoxContent/BoxItem05")
  self.compBoxItem06 = self:AddComponent(UILWBoxItemDrawItemComponent, "Content/BoxContent/BoxItem06")
  self.compBoxItem07 = self:AddComponent(UILWBoxItemDrawItemComponent, "Content/BoxContent/BoxItem07")
  self.compBoxItem08 = self:AddComponent(UILWBoxItemDrawItemComponent, "Content/BoxContent/BoxItem08")
  self.compBoxes = {
    self.compBoxItem01,
    self.compBoxItem02,
    self.compBoxItem03,
    self.compBoxItem04,
    self.compBoxItem05,
    self.compBoxItem06,
    self.compBoxItem07,
    self.compBoxItem08
  }
  self.imgCenterBoxIcon = self:AddComponent(UIImage, "Content/BoxContent/CenterBox/CenterBoxIcon")
  self.textCenterBox = self:AddComponent(UIText, "Content/BoxContent/CenterBox/CenterBoxText")
  self.textDes = self:AddComponent(UIText, "Content/DesText")
  self.textDes:SetText(Localization:GetString("activity_torch_relay_desc_36"))
  self.btnOn = self:AddComponent(UIButton, "Content/OnBtn")
  self.btnOn:SetOnClick(function()
    self:OnBtnOnClick()
  end)
  self.textOnBtn = self:AddComponent(UIText, "Content/OnBtn/OnImage/OnBtnText")
  self.textOnBtn:SetText(Localization:GetString("activity_torch_relay_button_9", "1"))
  self.btnTen = self:AddComponent(UIButton, "Content/TenBtn")
  self.btnTen:SetOnClick(function()
    self:OnBtnTenClick()
  end)
  self.textTenBtn = self:AddComponent(UIText, "Content/TenBtn/TenImage/TenBtnText")
  self.textTenBtn:SetText(Localization:GetString("activity_torch_relay_button_9", "5"))
  self.btnSkip = self:AddComponent(UIButton, "Content/SkipBtn")
  self.btnSkip:SetOnClick(function()
    self:OnBtnSkipClick()
  end)
  self.compSkipBtnBase = self:AddComponent(UIBaseContainer, "Content/SkipBtn/skipBtnBase/skipBtnBeSelect")
  self.textSkipTip = self:AddComponent(UIText, "Content/SkipBtn/skipTip")
  self.residueCountDesc = self:AddComponent(UIText, "Content/residueCountDesc")
  self.imgOneBtn = self:AddComponent(UIImage, "Content/OnBtn/OnImage")
  self.imgTenBtn = self:AddComponent(UIImage, "Content/TenBtn/TenImage")
  self.imgGray = self:AddComponent(UIImage, "Content/Gray")
  self.grayMaterial = self.imgGray:GetMaterial()
  self.onCostItemNode = self:AddComponent(UIBaseContainer, "Content/OnBtn/OnImage/OnCostItemNode")
  self.onCostItemIcon = self:AddComponent(UIImage, "Content/OnBtn/OnImage/OnCostItemNode/OnCostItemIcon")
  self.onCostItemNum = self:AddComponent(UIText, "Content/OnBtn/OnImage/OnCostItemNode/OnCostItemNum")
  self.tenCostItemNode = self:AddComponent(UIBaseContainer, "Content/TenBtn/TenImage/TenCostItemNode")
  self.tenCostItemIcon = self:AddComponent(UIImage, "Content/TenBtn/TenImage/TenCostItemNode/TenCostItemIcon")
  self.tenCostItemNum = self:AddComponent(UIText, "Content/TenBtn/TenImage/TenCostItemNode/TenCostItemNum")
end

function UILWBoxItemDrawView:ComponentDestroy()
  self.btnPanel = nil
  self.btnBack = nil
  self.compBoxItem01 = nil
  self.compBoxItem02 = nil
  self.compBoxItem03 = nil
  self.compBoxItem04 = nil
  self.compBoxItem05 = nil
  self.compBoxItem06 = nil
  self.compBoxItem07 = nil
  self.compBoxItem08 = nil
  self.imgCenterBoxIcon = nil
  self.textCenterBox = nil
  self.textDes = nil
  self.btnOn = nil
  self.textOnBtn = nil
  self.btnTen = nil
  self.textTenBtn = nil
  self.btnSkip = nil
  self.compSkipBtnBase = nil
  self.textSkipTip = nil
  self.compBoxes = nil
  self.btnInfo = nil
  self.imgOneBtn = nil
  self.imgTenBtn = nil
  self.imgGray = nil
  self.grayMaterial = nil
end

function UILWBoxItemDrawView:DataDefine()
  self.isDrawAnimPlaying = false
end

function UILWBoxItemDrawView:DataDestroy()
  self:StopAnimTimer()
  self:StopShowResultTimer()
  if self.delayShowClearTimer then
    self.delayShowClearTimer:Stop()
    self.delayShowClearTimer = nil
  end
  if self.delayNextAnimTimer then
    self.delayNextAnimTimer:Stop()
    self.delayNextAnimTimer = nil
  end
  self.isDrawAnimPlaying = nil
end

function UILWBoxItemDrawView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BoxItemDrawShowDrawSuccess, self.OnDrawCallback)
  self:AddUIListener(EventId.BoxItemDrawShowRewardClose, self.OnRewardClose)
  self:AddUIListener(EventId.BoxItemDrawShowDrawFailure, self.OnFailure)
end

function UILWBoxItemDrawView:OnRemoveListener()
  self:RemoveUIListener(EventId.BoxItemDrawShowDrawSuccess, self.OnDrawCallback)
  self:RemoveUIListener(EventId.BoxItemDrawShowRewardClose, self.OnRewardClose)
  self:RemoveUIListener(EventId.BoxItemDrawShowDrawFailure, self.OnFailure)
  base.OnRemoveListener(self)
end

function UILWBoxItemDrawView:OnOpen()
  if not self:InitData() then
    self.ctrl:CloseSelf()
    return
  end
  self:SetDrawAnimPlaying(false)
  self:UpdateContent()
  self:UpdateSkip()
  self:RefreshResidueCounts()
  self:InitCostItem()
end

function UILWBoxItemDrawView:OnFailure()
  self:SetDrawAnimPlaying(false)
end

function UILWBoxItemDrawView:InitData()
  self.param = self:GetUserData()
  if self.param == nil then
    return false
  end
  self.itemId = self.param.itemId
  self.uuid = nil
  local itemData = DataCenter.ItemData:GetItemById(self.itemId)
  if itemData then
    self.uuid = itemData.uuid
  end
  if self.itemId == nil then
    return false
  end
  self.itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
  if self.itemTemplate == nil or self.itemTemplate.type ~= GOODS_TYPE.GOODS_TYPE_DRAW_BOX then
    return false
  end
  self.groupId = checknumber(self.itemTemplate.para1)
  self.data = DataCenter.BoxItemDrawManager:GetUserData(self.groupId)
  if self.data == nil then
    return false
  end
  return true
end

function UILWBoxItemDrawView:UpdateContent()
  self.template = self.data:GetTemplate(self.data:GetCurRound())
  if self.template == nil then
    self.ctrl:CloseSelf()
    return
  end
  local rewards = self.template:GetRewards()
  for i, v in pairs(self.compBoxes) do
    v:ReInit(self.groupId, rewards[i])
  end
  self.textCenterBox:SetLocalText("activity_torch_relay_desc_21", DataCenter.ItemData:GetItemCount(self.itemId))
  local path = DataCenter.ItemTemplateManager:GetIconPath(self.itemId)
  self.imgCenterBoxIcon:LoadSprite(path)
  local userCount = DataCenter.ItemData:GetItemCount(self.itemId)
  CS.UIGray.SetGray(self.btnOn.transform, userCount < 1, true)
  CS.UIGray.SetGray(self.btnTen.transform, userCount < 5, true)
end

function UILWBoxItemDrawView:UpdateSkip()
  local isSkip = DataCenter.BoxItemDrawManager:IsSkipAnim()
  self.compSkipBtnBase:SetActive(isSkip)
  self.textSkipTip:SetLocalText("decoration_recruit_btn_name3")
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.btnSkip.transform)
end

function UILWBoxItemDrawView:GetRewardIndex(source)
  if source and self.template ~= nil then
    local rewardDatas = self.template:GetRewards()
    for i, v in ipairs(rewardDatas) do
      if v.rewardId == source then
        return i
      end
    end
  end
  return 0
end

function UILWBoxItemDrawView:OnDrawCallback(evt)
  local function ShowOneRewardHelper(curRound, maxRound, rewards)
    if maxRound < curRound then
      self:StopShowResultTimer()
      
      self.delayShowResultTimer = TimerManager:GetInstance():DelayInvoke(function()
        local logIndex = -1
        if self.curFinishBoxIndex then
          logIndex = self.curFinishBoxIndex
        end
        self:RefreshResidueCounts()
        self:ShowFinalRewardResult()
      end, 1)
      return
    else
      local rewardIndex = rewards[curRound] + 1
      if 1 <= rewardIndex and rewardIndex <= 8 then
        self:StartAnimTimer(rewardIndex, function()
          if self.delayNextAnimTimer then
            self.delayNextAnimTimer:Stop()
            self.delayNextAnimTimer = nil
          end
          self.delayNextAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
            ShowOneRewardHelper(curRound + 1, maxRound, rewards)
          end, 1)
        end)
      end
    end
  end
  
  if evt == nil or evt.reward == nil or evt.rewardIdList == nil then
    return
  end
  self.evtCache = evt
  local count = #evt.rewardIdList
  if DataCenter.BoxItemDrawManager:IsSkipAnim() then
    self:RefreshResidueCounts()
    self:ShowFinalRewardResult()
  else
    ShowOneRewardHelper(1, count, evt.rewardIdList)
  end
end

function UILWBoxItemDrawView:StartAnimTimer(rewardIndex, finishCallback)
  self.curAnimIndex = 1
  self.passRewardRoundCount = 0
  if self.timerFunc == nil then
    function self.timerFunc(temp)
      self:OnTimerTriggered(temp)
    end
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.1, self.timerFunc, {rewardIndex = rewardIndex, finishCallback = finishCallback}, false, false, false)
  end
  self.timer:Start()
  if self.compBoxes then
    for i, v in pairs(self.compBoxes) do
      v:HideHighlight()
    end
  end
end

function UILWBoxItemDrawView:StopAnimTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UILWBoxItemDrawView:StopShowResultTimer()
  if self.delayShowResultTimer ~= nil then
    self.delayShowResultTimer:Stop()
    self.delayShowResultTimer = nil
  end
end

function UILWBoxItemDrawView:OnTimerTriggered(data)
  if data and data.rewardIndex and self.curAnimIndex then
    if self.passRewardRoundCount == 2 and self.curAnimIndex == data.rewardIndex then
      self.curFinishBoxIndex = self.curAnimIndex
      if self.compBoxes[self.curAnimIndex] then
        self.compBoxes[self.curAnimIndex]:ShowHighlight(0)
        self.compBoxes[self.curAnimIndex]:AddGetCounts()
        self.compBoxes[self.curAnimIndex]:ShowGetVfx()
      end
      self:StopAnimTimer()
      if data.finishCallback then
        data.finishCallback()
      end
    elseif self.compBoxes[self.curAnimIndex] then
      self.compBoxes[self.curAnimIndex]:ShowHighlight(0.1)
    end
    if self.curAnimIndex == data.rewardIndex then
      self.passRewardRoundCount = self.passRewardRoundCount + 1
    end
    self.curAnimIndex = self.curAnimIndex + 1
    if self.curAnimIndex == 9 then
      self.curAnimIndex = 1
    end
  end
end

function UILWBoxItemDrawView:ShowFinalRewardResult()
  if self.evtCache then
    DataCenter.RewardManager:ShowCommonReward(self.evtCache, nil, nil, nil, nil, nil, function()
      if not table.IsNullOrEmpty(self.evtCache.bigClearAllRewards) then
        self.delayShowClearTimer = TimerManager:GetInstance():DelayInvoke(function()
          local data = {
            reward = self.evtCache.bigClearAllRewards
          }
          DataCenter.RewardManager:ShowCommonReward(data, nil, nil, nil, nil, nil, function()
            self.evtCache = nil
            EventManager:GetInstance():Broadcast(EventId.BoxItemDrawShowRewardClose)
          end)
        end, 0.5)
      else
        self.evtCache = nil
        EventManager:GetInstance():Broadcast(EventId.BoxItemDrawShowRewardClose)
      end
    end)
    local num = self.evtCache.num
    local costNum = self.evtCache.costNum
    if num and costNum and num > costNum then
      UIUtil.ShowTips(Localization:GetString("dominator_box_desc_1", costNum))
    end
  end
end

function UILWBoxItemDrawView:RefreshResidueCounts()
  if self.data then
    local alreadyCount = self.data:GetAlreadySum() or 0
    local residueCount = self.data:GetTotalCount() - alreadyCount
    self.residueCountDesc:SetLocalText("helloween_run_desc3", alreadyCount, residueCount)
    self.textTenBtn:SetText(Localization:GetString("activity_torch_relay_button_9", self.data:GetDrawNum()))
    local cost = self:GetItemCost()
    self.tenCostItemNum:SetText(cost * self.data:GetDrawNum())
  end
end

function UILWBoxItemDrawView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILWBoxItemDrawView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UILWBoxItemDrawView:OnBtnOnClick()
  if self.isDrawAnimPlaying == true then
    return
  end
  if self.data == nil then
    return
  end
  if self.uuid == nil then
    LWResourceLackUtil:GotoGoodsItemLack(self.itemId, 1)
    return
  end
  if self.data:GetTemplate(self.data:GetCurRound()) == nil then
    return
  end
  if DataCenter.ItemData:GetItemCount(self.itemId) >= self:GetItemCost() * 1 then
    self.evtCache = nil
    self:SetDrawAnimPlaying(true)
    DataCenter.BoxItemDrawManager:SendDrawMsg(self.itemId, 1)
  else
    LWResourceLackUtil:GotoGoodsItemLack(self.itemId, self:GetItemCost() * 1)
  end
end

function UILWBoxItemDrawView:OnBtnTenClick()
  if self.isDrawAnimPlaying == true then
    return
  end
  if self.data == nil then
    return
  end
  if self.uuid == nil then
    LWResourceLackUtil:GotoGoodsItemLack(self.itemId, 1)
    return
  end
  if self.data:GetTemplate(self.data:GetCurRound()) == nil then
    return
  end
  local drawNum = self.data:GetDrawNum()
  if DataCenter.ItemData:GetItemCount(self.itemId) >= drawNum * self:GetItemCost() then
    self.evtCache = nil
    self:SetDrawAnimPlaying(true)
    DataCenter.BoxItemDrawManager:SendDrawMsg(self.itemId, drawNum)
  else
    LWResourceLackUtil:GotoGoodsItemLack(self.itemId, drawNum * self:GetItemCost() - DataCenter.ItemData:GetItemCount(self.itemId))
  end
end

function UILWBoxItemDrawView:OnBtnSkipClick()
  DataCenter.BoxItemDrawManager:SetIsSkipAnim(not DataCenter.BoxItemDrawManager:IsSkipAnim())
  self:UpdateSkip()
end

function UILWBoxItemDrawView:OnRewardClose()
  self:SetDrawAnimPlaying(false)
  self:UpdateContent()
end

function UILWBoxItemDrawView:OnBtnInfoClick()
  if self.itemId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBoxItemDrawProbability, {anim = true}, {
      itemId = self.itemId
    })
  end
end

function UILWBoxItemDrawView:SetDrawAnimPlaying(isPlaying)
  self.isDrawAnimPlaying = isPlaying
  if self.grayMaterial and self.imgOneBtn and self.imgTenBtn then
    if self.isDrawAnimPlaying then
      self.imgOneBtn:SetMaterial(self.grayMaterial)
      self.imgTenBtn:SetMaterial(self.grayMaterial)
    else
      self.imgOneBtn:SetMaterial(nil)
      self.imgTenBtn:SetMaterial(nil)
    end
  end
end

function UILWBoxItemDrawView:InitCostItem()
  self.onCostItemNode:SetActive(true)
  self.tenCostItemNode:SetActive(true)
  local path = DataCenter.ItemTemplateManager:GetIconPath(self.itemId)
  self.onCostItemIcon:LoadSprite(path)
  self.tenCostItemIcon:LoadSprite(path)
  local cost = self:GetItemCost()
  self.onCostItemNum:SetText(cost)
  self.tenCostItemNum:SetText(cost * 5)
end

function UILWBoxItemDrawView:GetItemCost()
  local itemInfo = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
  local cost
  if string.IsNullOrEmpty(itemInfo.para2) then
    cost = 1
  else
    cost = tonumber(itemInfo.para2)
  end
  return cost
end

return UILWBoxItemDrawView
