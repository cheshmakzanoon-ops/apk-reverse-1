local UILWChatAlBubbleTrainTip = BaseClass("UILWChatAlBubbleTrainTip", UIBaseContainer)
local base = UIBaseContainer
local click_btn_path = "Btn"

function UILWChatAlBubbleTrainTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWChatAlBubbleTrainTip:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWChatAlBubbleTrainTip:ComponentDefine()
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
end

function UILWChatAlBubbleTrainTip:ComponentDestroy()
  self.clickBtn = nil
end

function UILWChatAlBubbleTrainTip:OnClick()
  local platform = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if trainData and trainData.vipInfo then
    return
  elseif platform and platform.vipInvite and platform.vipInvite.vipId == LuaEntry.Player.uid then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < platform.vipInvite.endTime then
      local vipType = platform.vipInvite.vipType
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainVIPBeInvitedPop, {anim = true}, vipType)
    end
  end
end

function UILWChatAlBubbleTrainTip:Update1000MS()
  if self.gameObject.activeSelf then
    local platform = DataCenter.LWAllyStationDataManager:GetPlatform(1)
    local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
    if trainData and trainData.vipInfo then
      self.gameObject:SetActive(false)
    elseif platform and platform.vipInvite then
      if platform.vipInvite.vipId == LuaEntry.Player.uid then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if curTime < platform.vipInvite.endTime then
          self.gameObject:SetActive(true)
        else
          self.gameObject:SetActive(false)
        end
      else
        self.gameObject:SetActive(false)
      end
    else
      self.gameObject:SetActive(false)
    end
  end
end

return UILWChatAlBubbleTrainTip
