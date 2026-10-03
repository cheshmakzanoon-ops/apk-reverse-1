local base = UIBaseContainer
local AllianceCongratulationCard = BaseClass("AllianceCongratulationCard", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

function AllianceCongratulationCard:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllianceCongratulationCard:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceCongratulationCard:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgContent = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 2)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgBubbleBg = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textBubbleContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textCountDown = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
end

function AllianceCongratulationCard:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgContent = nil
  self.compUIPlayerHead = nil
  self.textName = nil
  self.textDesc = nil
  self.imgBubbleBg = nil
  self.textBubbleContent = nil
  self.textCountDown = nil
end

function AllianceCongratulationCard:DataDefine()
end

function AllianceCongratulationCard:DataDestroy()
  self.endTime = nil
  self.targetUid = nil
  self.configId = nil
  self.playerInfo = nil
  self.data = nil
  self.front = nil
end

function AllianceCongratulationCard:OnAddListener()
  base.OnAddListener(self)
end

function AllianceCongratulationCard:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllianceCongratulationCard:UpdateData(data, front)
  self.data = data
  self.front = front
  self.imgBubbleBg.gameObject:SetActive(false)
  if self.data then
    self.gameObject:SetActive(true)
    self.endTime = self.data.expireTimeStamp
    self.targetUid = self.data.uid
    self.configId = self.data.configId
    self.playerInfo = self.data.roleInfo
    if self.playerInfo then
      local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.playerInfo.uid, self.playerInfo.name)
      self.textName:SetText(showName)
      self.compUIPlayerHead:ParseHeadInfo(self.playerInfo)
      self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
    end
    if self.configId then
      local lineData = LocalController:instance():getLine(TableName.LW_Alliance_Congratulation, self.configId)
      if lineData then
        self.textDesc:SetLocalText(lineData.ac_msg_key, lineData.para1)
        local cfgId = lineData.share_components
        if cfgId == nil then
          return
        end
        local oneTemplate
        oneTemplate = LocalController:instance():tryGetLine(TableName.SHARE_COMPONENTS, tostring(cfgId))
        if oneTemplate == nil then
          return
        end
        self.rawImgContent:LoadSpriteAsync(oneTemplate.pic_path)
      end
    end
  else
    self.gameObject:SetActive(false)
  end
end

function AllianceCongratulationCard:SetBubble()
  self.imgBubbleBg.gameObject:SetActive(true)
  local contentList = DataCenter.AllianceCongratulationDataManager:GetListPopBubbleStringContents()
  if not table.IsNullOrEmpty(contentList) and self.data and self.data.count then
    local index = math.random(#contentList)
    self.textBubbleContent:SetLocalText(contentList[index], self.data.count + 1)
  end
end

function AllianceCongratulationCard:Update1000MS()
  if self.endTime and self.front then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.endTime - curTime
    if leftTime < 0 then
      leftTime = 0
      EventManager:GetInstance():Broadcast(EventId.AllianceCongratulationListNew)
    end
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.textCountDown:SetText(countDownTimeStr)
  end
end

return AllianceCongratulationCard
