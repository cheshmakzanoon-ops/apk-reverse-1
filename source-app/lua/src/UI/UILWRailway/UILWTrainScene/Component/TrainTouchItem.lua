local TrainTouchItem = BaseClass("TrainTouchItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function TrainTouchItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TrainTouchItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TrainTouchItem:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnClickTrain()
  end)
  self.bg = self:AddComponent(UIBaseComponent, "bg")
  self.abbr = self:AddComponent(UIText, "bg/Abbr")
  self.name = self:AddComponent(UIText, "bg/Name")
  self.criminal = self:AddComponent(UIBaseComponent, "bg/Criminal")
  self.head = self:AddComponent(UICommonHead, "Head")
  self.bubble = self:AddComponent(UIButton, "Bubble")
  self.bubble:SetOnClick(function()
    self:OnClickTrain()
  end)
  self.myHead = self:TryAddComponent(UICommonHead, "MyHead")
  self.myHeadTitle = self:TryAddComponent(UITextMeshProUGUIEx, "MyHead/bg/MyTitle")
  if self.myHeadTitle then
    self.myHeadTitle:SetText(Localization:GetString("alliance_train_027"))
  end
end

function TrainTouchItem:ComponentDestroy()
  self.head = nil
end

function TrainTouchItem:DataDefine()
end

function TrainTouchItem:DataDestroy()
  self.trainData = nil
end

function TrainTouchItem:OnEnable()
  base.OnEnable(self)
end

function TrainTouchItem:OnDisable()
  base.OnDisable(self)
end

function TrainTouchItem:OnAddListener()
  base.OnAddListener(self)
end

function TrainTouchItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TrainTouchItem:update()
end

function TrainTouchItem:Refresh(train)
  self.train = train
  local trainData = train.trainData
  if IsNull(train.transform) then
    return
  end
  local screenPos = DataCenter.TrainSceneManager:GetTouchItemScreenPos(train.transform.position)
  local worldPos = CS.GameEntry.UICamera:ScreenToWorldPoint(Vector3(screenPos.x, screenPos.y, 1))
  self:SetPosition(worldPos)
  local myHeadShow = false
  if trainData:IsMyTrain() then
    if trainData.type == TrainType.Train then
      self.head:SetActive(true)
      self.head:SetHeadAndFrame(trainData.ownerId, trainData.pic, trainData.picVer, false, trainData.headSkinId, trainData.headSkinET)
      self.bg:SetActive(true)
      self.abbr:SetText("")
      self.name:SetText(trainData.name)
      self.criminal:SetActive(false)
      self.bubble:SetActive(false)
    else
      self.head:SetActive(false)
      self.bg:SetActive(false)
      local state = DataCenter.LWMyStationDataManager:GetTruckStationStateByTrainData(trainData)
      self.bubble:SetActive(state == TruckStationState.Reward)
    end
  else
    self.bubble:SetActive(false)
    local isUR = trainData.quality and trainData.quality >= 5
    local isCriminal = trainData.enemy
    self.head:SetActive(isUR)
    self.criminal:SetActive(isCriminal)
    if isUR or isCriminal then
      self.bg:SetActive(true)
      local abbrStr = string.IsNullOrEmpty(trainData.abbr) and "" or string.format("[%s]", trainData.abbr)
      self.abbr:SetText(abbrStr)
      local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(trainData.ownerId, trainData.name)
      self.name:SetText(showName)
      if isUR then
        self.head:SetHeadAndFrame(trainData.ownerId, trainData.pic, trainData.picVer, false, trainData.headSkinId, trainData.headSkinET)
        local myUid = LuaEntry.Player.uid
        if trainData:IAmVip() then
          myHeadShow = true
          local pic = LuaEntry.Player:GetPic()
          local picVer = LuaEntry.Player.picVer
          local headSkinPath = LuaEntry.Player:GetHeadBgImg()
          if self.myHead then
            self.myHead:SetData(myUid, pic, picVer, nil, headSkinPath)
            local offset = -5 * DataCenter.LWMyStationDataManager.CARRIAGE_LENGTH
            screenPos = DataCenter.TrainSceneManager:GetTouchItemScreenPos(train.transform.position + Vector3.New(0, 0, offset))
            worldPos = CS.GameEntry.UICamera:ScreenToWorldPoint(Vector3(screenPos.x, screenPos.y, 1))
            self.myHead:SetPosition(worldPos)
          end
        else
          local carriages = trainData.carriages
          if carriages then
            local carriagesCount = #carriages
            if 1 < carriagesCount then
              for i = 1, carriagesCount do
                local carriage = carriages[i]
                local passengerList = carriage.passengerList
                for _, v in ipairs(passengerList) do
                  if v.uid == myUid then
                    myHeadShow = true
                    local pic = LuaEntry.Player:GetPic()
                    local picVer = LuaEntry.Player.picVer
                    local headSkinPath = LuaEntry.Player:GetHeadBgImg()
                    if self.myHead then
                      self.myHead:SetData(myUid, pic, picVer, nil, headSkinPath)
                      local offset = (1 - i) * DataCenter.LWMyStationDataManager.CARRIAGE_LENGTH
                      screenPos = DataCenter.TrainSceneManager:GetTouchItemScreenPos(train.transform.position + Vector3.New(0, 0, offset))
                      worldPos = CS.GameEntry.UICamera:ScreenToWorldPoint(Vector3(screenPos.x, screenPos.y, 1))
                      self.myHead:SetPosition(worldPos)
                    end
                  end
                end
              end
            end
          end
        end
      end
    else
      self.bg:SetActive(false)
    end
  end
  if self.myHead then
    self.myHead:SetActive(myHeadShow)
  end
end

function TrainTouchItem:OnClickTrain()
  self.view:OnClickTrain(self.train)
end

return TrainTouchItem
