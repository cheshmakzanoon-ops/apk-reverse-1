local UITrainInfoView = BaseClass("UITrainInfoView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local DriverPage = require("UI.UILWRailway.UITrainPrepare.Component.DriverPage")
local PassengerPage = require("UI.UILWRailway.UITrainPrepare.Component.PassengerPage")
local RightsItem = require("UI.UILWRailway.UITrainPrepareScene.Component.UITrainRightsItemComponent")
local X1 = -338
local step = 96.6
local ImagePath = {
  [1] = "Assets/Main/TextureEx/UILWRailway/train/lrb_tongmenghuoche_huoche_chetou.png",
  [2] = "Assets/Main/TextureEx/UILWRailway/train/lrb_tongmenghuoche_huoche_baise.png",
  [3] = "Assets/Main/TextureEx/UILWRailway/train/lrb_tongmenghuoche_huoche_chewei.png"
}
local ImagePathUR = {
  [1] = "Assets/Main/TextureEx/UILWRailway/new_train_1/chetou_v001_tmp.png",
  [2] = "Assets/Main/TextureEx/UILWRailway/new_train_1/chexiang_v001_tmp.png",
  [3] = "Assets/Main/TextureEx/UILWRailway/new_train_1/daochetou_v001_tmp.png"
}
local coach_path = "Root/Middle/railway/Coach"

function UITrainInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UITrainInfoView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITrainInfoView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.recordBtn = self:AddComponent(UIButton, "Root/BottomBar/recordBtn")
  self.recordBtn:SetOnClick(function()
    self:OnClickRecord()
  end)
  self.shareBtn = self:AddComponent(UIButton, "Root/BottomBar/shareBtn")
  self.shareBtn:SetOnClick(function()
    self:OnClickShare()
  end)
  self.attackBtn = self:AddComponent(UIButton, "Root/BottomBar/attackBtn")
  self.attackBtn:SetOnClick(function()
    self:OnClickAttack()
  end)
  self.allyTitle = self:AddComponent(UIBaseComponent, "Root/Top/allyTitle")
  self.rightsItemList = self:AddComponent(UIBaseContainer, "Root/Top/RightsItemList")
  self.infoBtn = self:AddComponent(UIButton, "Root/Top/allyTitle/infoBtn")
  self.infoBtn:SetOnClick(function()
    self:OnClickInfo()
  end)
  self.enemyTitle = self:AddComponent(UIBaseComponent, "Root/Top/enemyTitle")
  self.robTimes = self:AddComponent(UIText, "Root/Top/enemyTitle/robTimes")
  self.time = self:AddComponent(UIText, "Root/Top/txtTime")
  self.bubble = self:AddComponent(UIBaseComponent, "Root/BottomBar/recordBtn/Bubble")
  self.bubbleTxt = self:AddComponent(UIText, "Root/BottomBar/recordBtn/Bubble/BubbleTxt")
  self.bubble:SetActive(false)
  self.driverPage = self:AddComponent(DriverPage, "Root/Middle/DriverPage")
  self.passengerPage = self:AddComponent(PassengerPage, "Root/Middle/PassengerPage")
  self.RightsItemBubbleContent = self:AddComponent(UIBaseContainer, "Root/RightsItemBubbleContent")
  self.RightsItemBubbleBtn = self:AddComponent(UIButton, "Root/RightsItemBubbleContent/RightsItemBubbleBtn")
  self.RightsItemBubbleBtn:SetOnClick(function()
    self.RightsItemBubbleContent:SetActive(false)
  end)
  self.RightsItemArrow = self:AddComponent(UIBaseContainer, "Root/RightsItemBubbleContent/arrow")
  self.RightsItemArrowRect = self.RightsItemArrow.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
  self.RightsItemTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/RightsItemBubbleContent/RightsItemKuang/RightsItemTitle")
  self.RightsItemDesc = self:AddComponent(UITextMeshProUGUIEx, "Root/RightsItemBubbleContent/RightsItemKuang/RightsItemDesc")
  self.coaches = {}
  for i = 1, 6 do
    local coach = self:AddComponent(UIRawImage, coach_path .. i)
    table.insert(self.coaches, coach)
  end
end

function UITrainInfoView:ComponentDestroy()
  self:RemoveItems()
  self.rightsItemList = nil
  self.coaches = nil
end

function UITrainInfoView:DataDefine()
  self.trainData = self:GetUserData()
  RailwayUtil.GetAllianceTrainBattleRecord(self.trainData)
end

function UITrainInfoView:DataDestroy()
end

function UITrainInfoView:Update1000MS()
  if not self.arriveTime then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < self.arriveTime then
    local str = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.arriveTime - now)
    self.time:SetText(str)
  else
    self.arriveTime = nil
    self.time:SetActive(false)
  end
end

function UITrainInfoView:Refresh()
  local trainData = self.trainData
  local state = trainData:GetTrainState()
  if trainData:IsMyOrAllyTrain() then
    self.recordBtn:SetActive(true)
    self.attackBtn:SetActive(false)
    self.shareBtn:SetActive(false)
    self.allyTitle:SetActive(true)
    self.enemyTitle:SetActive(false)
  else
    self.shareBtn:SetActive(true)
    self.recordBtn:SetActive(false)
    self.attackBtn:SetActive(true)
    self.allyTitle:SetActive(false)
    self.enemyTitle:SetActive(true)
    local cur, max = DataCenter.LWMyStationDataManager:GetRobCount()
    self.robTimes:SetText(Localization:GetString(457510) .. ": " .. cur .. "/" .. max)
  end
  if state == TrainState.Travelling then
    self.arriveTime = trainData.arriveTs
    self.time:SetActive(true)
    self:Update1000MS()
  else
    self.shareBtn:SetActive(false)
    self.attackBtn:SetActive(false)
    self.time:SetActive(false)
    self.arriveTime = nil
  end
  self.driverPage:Refresh(self.trainData)
  self.passengerPage:Refresh(self.trainData)
  local cfgId = trainData.cfgId
  local ur = RailwayUtil.IsUR(cfgId)
  local path = ur and ImagePathUR or ImagePath
  for i = 1, 6 do
    local image = self.coaches[i]
    if image then
      local p
      if i == 1 then
        p = path[1]
      elseif i == 6 then
        p = path[3]
      else
        p = path[2]
      end
      image:LoadSprite(p)
    end
  end
  local rightsOpenState = LuaEntry.DataConfig:CheckSwitch("alliance_train_vip")
  if rightsOpenState then
    self:SetTrainRightsList()
  end
end

function UITrainInfoView:OnEnable()
  base.OnEnable(self)
end

function UITrainInfoView:OnDisable()
  base.OnDisable(self)
end

function UITrainInfoView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceTrainBattleRecordList, self.RefreshBubble)
  self:AddUIListener(EventId.AllianceTrainKOFBattleRecordList, self.RefreshBubble)
end

function UITrainInfoView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceTrainBattleRecordList, self.RefreshBubble)
  self:RemoveUIListener(EventId.AllianceTrainKOFBattleRecordList, self.RefreshBubble)
end

function UITrainInfoView:OnClickRecord()
  RailwayUtil.OpenUIBattleRecord(self.trainData)
end

function UITrainInfoView:OnClickAttack()
  RailwayUtil.ClickAttackTrain(self.trainData)
end

function UITrainInfoView:OnClickShare()
  RailwayUtil.ShareTrainByTrainData(self.trainData)
end

function UITrainInfoView:OnClickInfo()
  RailwayUtil.ShowTrainActivityConstruction()
end

function UITrainInfoView:RefreshBubble(msg)
  if self.trainData.uuid ~= msg.trainUuid then
    return
  end
  if msg == nil or msg.list == nil or msg.list[1] == nil then
    self.bubble:SetActive(false)
  else
    self.bubble:SetActive(true)
    local firstRecord = msg.list[1]
    local attackerName = UIUtil.FormatAllianceAndName(firstRecord.abbr, firstRecord.name)
    local langKey = firstRecord.isWin and 458540 or 458539
    self.bubbleTxt:SetLocalText(langKey, attackerName)
  end
end

function UITrainInfoView:SetTrainRightsList()
  self.rightsItem = self.rightsItem or {}
  local TemplatesIsTrainRightsDict = DataCenter.LWAllianceRightShowTemplateManager:GetTemplatesIsTrainRights(1)
  for i, value in ipairs(TemplatesIsTrainRightsDict) do
    if value then
      self.rightsItem[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UILWRailway/Scene/UITrainRightsItem.prefab", function(req)
        if IsNull(req.gameObject) then
          return
        end
        local go = req.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.rightsItemList.transform)
        go.transform:Set_localScale(1, 1, 1)
        local nameStr = tostring(i)
        go.name = nameStr
        local cell = self.rightsItemList:AddComponent(RightsItem, nameStr)
        cell:SetRightInfo(TemplatesIsTrainRightsDict[i], self.trainData.giftLv, i, self.trainData)
      end)
    end
  end
end

function UITrainInfoView:RemoveItems()
  self.rightsItemList:RemoveComponents(RightsItem)
  if self.rightsItem then
    for _, v in pairs(self.rightsItem) do
      v:Destroy()
    end
  end
  self.rightsItem = {}
end

function UITrainInfoView:SetBubbleInfo(rightInfo, IsBuy)
  if rightInfo then
    self.RightsItemBubbleContent:SetActive(true)
    self.RightsItemTitle:SetLocalText(rightInfo.title)
    local desc = Localization:GetString(rightInfo.desc)
    if rightInfo.satisfyCondition or IsBuy then
      self.RightsItemDesc:SetText(desc)
    else
      local lv = Localization:GetString("alliance_train_vip022", rightInfo.needLv)
      self.RightsItemDesc:SetText(desc .. [[

<color=#f85967>]] .. lv .. "</color>")
    end
    local posX = X1 + (rightInfo.index - 1) * step
    local currentPos = self.RightsItemArrowRect.anchoredPosition
    self.RightsItemArrowRect.anchoredPosition = Vector2(posX, currentPos.y)
  end
end

return UITrainInfoView
