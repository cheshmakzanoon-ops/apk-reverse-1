local TreasureTenRewardPanelView = BaseClass("TreasureTenRewardPanelView", UIBaseView)
local UIRewardItem = require("UI.UIDispatchTask.RewardTen.Component.OneRewardComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function TreasureTenRewardPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:UpdateRewards()
end

function TreasureTenRewardPanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TreasureTenRewardPanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compRewardLay1 = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compRewardLay2 = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compRewardLay3 = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compRewardLay4 = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.rewardPosList = {}
  for i = 1, 10 do
    local j = 1
    if 3 <= i and i <= 5 then
      j = 2
    elseif 6 <= i and i <= 8 then
      j = 3
    elseif 9 <= i then
      j = 4
    end
    local cardPosItemName = string.format("Root/Panel/rewardLay%d/cardPos%d", j, i)
    local cardPosItem = self:AddComponent(UIBaseContainer, cardPosItemName)
    cardPosItem.cardItem = cardPosItem:AddComponent(UIRewardItem, "effect")
    table.insert(self.rewardPosList, cardPosItem)
  end
end

function TreasureTenRewardPanelView:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.textTitle = nil
  self.compRewardLay1 = nil
  self.compRewardLay2 = nil
  self.compRewardLay3 = nil
  self.compRewardLay4 = nil
  self.textTips = nil
  self.rewardPosList = nil
end

function TreasureTenRewardPanelView:DataDefine()
  self.message, self.closeCallback = self:GetUserData()
  self.timer = nil
  local msg = self.message
  
  function self.timer_action(temp)
    self.ctrl:ShowReward(msg, self.closeCallback)
  end
  
  self.ctrl:SetView(self)
end

function TreasureTenRewardPanelView:DataDestroy()
  self:DeleteTimer()
  self.message = nil
  self.closeCallback = nil
end

function TreasureTenRewardPanelView:OnAddListener()
  base.OnAddListener(self)
end

function TreasureTenRewardPanelView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TreasureTenRewardPanelView:OnBtnCloseClick()
  self.ctrl:ShowReward(self.message, self.closeCallback)
end

function TreasureTenRewardPanelView:UpdateRewards()
  local rewardList = self.message.boxArray
  if not table.IsNullOrEmpty(rewardList) then
    local count = #rewardList
    if count == 2 then
      self.compRewardLay1.gameObject:SetActive(true)
      self.compRewardLay2.gameObject:SetActive(false)
      self.compRewardLay3.gameObject:SetActive(false)
      self.compRewardLay4.gameObject:SetActive(false)
      self:InitRewardBox(1, rewardList)
    elseif count == 3 then
      self.compRewardLay1.gameObject:SetActive(false)
      self.compRewardLay2.gameObject:SetActive(true)
      self.compRewardLay3.gameObject:SetActive(false)
      self.compRewardLay4.gameObject:SetActive(false)
      self:InitRewardBox(3, rewardList)
    elseif count == 4 or count == 5 then
      self.compRewardLay1.gameObject:SetActive(true)
      self.compRewardLay2.gameObject:SetActive(true)
      self.compRewardLay3.gameObject:SetActive(false)
      self.compRewardLay4.gameObject:SetActive(false)
      self:InitRewardBox(1, rewardList)
    elseif count == 6 then
      self.compRewardLay1.gameObject:SetActive(false)
      self.compRewardLay2.gameObject:SetActive(true)
      self.compRewardLay3.gameObject:SetActive(true)
      self.compRewardLay4.gameObject:SetActive(false)
      self:InitRewardBox(3, rewardList)
    else
      self.compRewardLay1.gameObject:SetActive(true)
      self.compRewardLay2.gameObject:SetActive(true)
      self.compRewardLay3.gameObject:SetActive(true)
      self.compRewardLay4.gameObject:SetActive(true)
      self:InitRewardBox(1, rewardList)
    end
  end
end

function TreasureTenRewardPanelView:InitRewardBox(start, rewardList)
  local startNum = start
  if self.rewardPosList and #self.rewardPosList > 0 then
    for i = 1, #self.rewardPosList do
      self.rewardPosList[i].gameObject:SetActive(false)
    end
    for i = 1, #rewardList do
      self.rewardPosList[startNum].gameObject:SetActive(true)
      self.rewardPosList[startNum].cardItem:UpdateData(rewardList[i])
      startNum = startNum + 1
    end
  end
  self:AddTimer(1.5)
end

function TreasureTenRewardPanelView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function TreasureTenRewardPanelView:AddTimer(time)
  self:DeleteTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(time, self.timer_action, self, true, false, false)
  end
  self.timer:Start()
end

return TreasureTenRewardPanelView
