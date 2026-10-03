local BirthdayBtnItem = BaseClass("BirthdayBtnItem", UIBaseContainer)
local base = UIBaseContainer
local rapidjson = require("rapidjson")
local eff_ui_birthday_wishes_wish_idle_path = "Eff_ui_BirthdayWishes_wish_idle"
local eff_ui_birthday_wishes_wish_up_path = "Eff_ui_BirthdayWishes_wish_up"
local eff_ui_birthday_wishes_wish_piaozi_path = "Eff_ui_BirthdayWishes_wish_piaozi"
local eff_ui_birthday_wishes_wish_caidai_path = "Eff_ui_BirthdayWishes_wish_caidai"
local eff_ui_birthday_wishes_wish_caidai_01_path = "Eff_ui_BirthdayWishes_wish_caidai/Eff_ui_BirthdayWishes_wish_caidai_01"
local eff_ui_birthday_wishes_wish_caidai_02_path = "Eff_ui_BirthdayWishes_wish_caidai/Eff_ui_BirthdayWishes_wish_caidai_02"
local eff_ui_birthday_wishes_wish_caidai_03_path = "Eff_ui_BirthdayWishes_wish_caidai/Eff_ui_BirthdayWishes_wish_caidai_03"
local click_arean_path = "clickArean"
local AniName1 = "V_ui_BirthdayWishes_wish_down"
local AniName2 = "V_ui_BirthdayWishes_wish_idle"
local AniName3 = "V_ui_BirthdayWishes_wish_up"
local AniTime1 = 0.1
local AniTime2 = 0.6
local AniTime3 = 0.5
local WaitMsgBackTime = 3
local SuccessShowTime = 3
local BtnState = {
  IDLE = 1,
  DOWN = 2,
  DOWN_KEEP = 3,
  UP = 4,
  WAIT = 5,
  SUCCESS = 6
}

function BirthdayBtnItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function BirthdayBtnItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BirthdayBtnItem:OnAddListener()
  base.OnAddListener(self)
end

function BirthdayBtnItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function BirthdayBtnItem:ComponentDefine()
  self.rootUIEventTrigger = self:AddComponent(UIEventTrigger, "")
  self.rootUIEventTrigger:OnPointerDown(function(eventData)
    self:OnPointerDown(eventData)
  end)
  self.rootUIEventTrigger:OnPointerUp(function(eventData)
    self:OnPointerUp(eventData)
  end)
  self.rootUIEventTrigger:OnPointerExit(function(eventData)
    self:OnPointerExit(eventData)
  end)
  self.rootAni = self:AddComponent(UIAnimator, "")
  self.eff_ui_birthday_wishes_wish_idle = self:AddComponent(UIBaseContainer, eff_ui_birthday_wishes_wish_idle_path)
  self.eff_ui_birthday_wishes_wish_up = self:AddComponent(UIBaseContainer, eff_ui_birthday_wishes_wish_up_path)
  self.eff_ui_birthday_wishes_wish_piaozi = self:AddComponent(UIAnimator, eff_ui_birthday_wishes_wish_piaozi_path)
  self.eff_ui_birthday_wishes_wish_caidai = self:AddComponent(UIBaseContainer, eff_ui_birthday_wishes_wish_caidai_path)
  self.eff_ui_birthday_wishes_wish_piaozi:SetActive(false)
  self.eff_ui_birthday_wishes_wish_caidai:SetActive(false)
  self.eff_ui_birthday_wishes_wish_caidai_01 = self:AddComponent(UIBaseContainer, eff_ui_birthday_wishes_wish_caidai_01_path)
  self.eff_ui_birthday_wishes_wish_caidai_02 = self:AddComponent(UIBaseContainer, eff_ui_birthday_wishes_wish_caidai_02_path)
  self.eff_ui_birthday_wishes_wish_caidai_03 = self:AddComponent(UIBaseContainer, eff_ui_birthday_wishes_wish_caidai_03_path)
  self.click_arean = self:AddComponent(UIBaseContainer, click_arean_path)
end

function BirthdayBtnItem:ComponentDestroy()
  self.eff_ui_birthday_wishes_wish_idle = nil
  self.eff_ui_birthday_wishes_wish_up = nil
  self.eff_ui_birthday_wishes_wish_piaozi = nil
  self.eff_ui_birthday_wishes_wish_caidai = nil
  self.eff_ui_birthday_wishes_wish_caidai_01 = nil
  self.eff_ui_birthday_wishes_wish_caidai_02 = nil
  self.eff_ui_birthday_wishes_wish_caidai_03 = nil
  self.click_arean = nil
end

function BirthdayBtnItem:SetData(data, redPacketData)
  self.data = data
  self.redPacketData = redPacketData
  self.curBtnState = BtnState.IDLE
  self.curBtnStateRefreshTime = nil
  self.pressTime = nil
  self.click_arean:SetSizeDeltaXY(0, 0)
  self:RefreshCurBtnState()
end

function BirthdayBtnItem:OnPointerDown(eventData)
  if self.data then
    if self.curBtnState ~= BtnState.IDLE then
      return
    end
  elseif self.redPacketData and self.curBtnState ~= BtnState.IDLE and self.curBtnState ~= BtnState.SUCCESS then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.curBtnState = BtnState.DOWN
  self.curBtnStateRefreshTime = curTime + AniTime1 * 1000
  self.pressTime = curTime
  self:RefreshCurBtnState()
end

function BirthdayBtnItem:OnPointerUp(eventData)
  if self.curBtnState ~= BtnState.DOWN and self.curBtnState ~= BtnState.DOWN_KEEP then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.pointUpTime = curTime
  self.curBtnState = BtnState.UP
  self.curBtnStateRefreshTime = curTime + AniTime3 * 1000
  self:RefreshCurBtnState()
end

function BirthdayBtnItem:OnPointerExit(eventData)
end

function BirthdayBtnItem:RefreshEffectPower()
  local leftTime = self.pointUpTime - self.pressTime
  if leftTime < 1000 then
    self.eff_ui_birthday_wishes_wish_caidai_01:SetActive(true)
    self.eff_ui_birthday_wishes_wish_caidai_02:SetActive(false)
    self.eff_ui_birthday_wishes_wish_caidai_03:SetActive(false)
  elseif leftTime < 2000 then
    self.eff_ui_birthday_wishes_wish_caidai_01:SetActive(false)
    self.eff_ui_birthday_wishes_wish_caidai_02:SetActive(true)
    self.eff_ui_birthday_wishes_wish_caidai_03:SetActive(false)
  else
    self.eff_ui_birthday_wishes_wish_caidai_01:SetActive(false)
    self.eff_ui_birthday_wishes_wish_caidai_02:SetActive(false)
    self.eff_ui_birthday_wishes_wish_caidai_03:SetActive(true)
  end
end

function BirthdayBtnItem:Update100MS()
  if self.curBtnStateRefreshTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.curBtnStateRefreshTime then
    if self.curBtnState == BtnState.DOWN then
      self.curBtnState = BtnState.DOWN_KEEP
      self.curBtnStateRefreshTime = nil
      self:RefreshCurBtnState()
    elseif self.curBtnState == BtnState.UP then
      self.curBtnState = BtnState.WAIT
      self.curBtnStateRefreshTime = curTime + WaitMsgBackTime * 1000
      self:RefreshCurBtnState()
    elseif self.curBtnState == BtnState.WAIT then
      self.curBtnState = BtnState.IDLE
      self.curBtnStateRefreshTime = nil
      self:RefreshCurBtnState()
    elseif self.curBtnState == BtnState.SUCCESS then
      self.curBtnStateRefreshTime = nil
      if self.data then
        SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, self.data.uid)
      end
      EventManager:GetInstance():Broadcast(EventId.BirthdayThumbsUpAniFin)
    end
  end
end

function BirthdayBtnItem:RefreshCurBtnState()
  if self.curBtnState == BtnState.IDLE then
    self.eff_ui_birthday_wishes_wish_idle:SetActive(false)
    self.eff_ui_birthday_wishes_wish_up:SetActive(false)
    self.rootAni:SetSpeed(0)
    self.rootAni:SampleAnimationAtTime(AniName1, 0)
    self.rootAni:Play(AniName1)
  elseif self.curBtnState == BtnState.DOWN then
    self.eff_ui_birthday_wishes_wish_idle:SetActive(true)
    self.eff_ui_birthday_wishes_wish_up:SetActive(false)
    self.rootAni:SetSpeed(1)
    self.rootAni:Play(AniName1)
  elseif self.curBtnState == BtnState.DOWN_KEEP then
    self.eff_ui_birthday_wishes_wish_idle:SetActive(true)
    self.eff_ui_birthday_wishes_wish_up:SetActive(false)
    self.rootAni:SetSpeed(1)
    self.rootAni:Play(AniName2)
  elseif self.curBtnState == BtnState.UP then
    self.eff_ui_birthday_wishes_wish_idle:SetActive(false)
    self.eff_ui_birthday_wishes_wish_up:SetActive(true)
    self.rootAni:SetSpeed(1)
    self.rootAni:Play(AniName3)
    if self.data then
      local thePlayerUid = self.data.uid
      InteractiveUtil.TryThumbsUp(thePlayerUid, InteractiveUtil.ThumbsUpType.BirthdayInformation, nil, function()
        if self.view == nil or self.view.ctrl == nil then
          return
        end
        local curTime = UITimeManager:GetInstance():GetServerTime()
        self.curBtnState = BtnState.SUCCESS
        self.curBtnStateRefreshTime = curTime + SuccessShowTime * 1000
        self:RefreshCurBtnState()
      end)
    elseif self.redPacketData and self.redPacketData and self.redPacketData.sendUid and self.redPacketData.sendUid ~= LuaEntry.Player.uid then
      local roomData = ChatInterface.getRoomData(self.redPacketData.roomId)
      local chatData = roomData:getChatDataBySeqId(self.redPacketData.seqId)
      if chatData == nil then
        return
      end
      local chatType = chatData.group == ChatGroupType.GROUP_ALLIANCE and 2 or 1
      local seqId = chatData.seqId
      local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
      local packetId = jsonObj and jsonObj.packetId
      local serverId = jsonObj.serverId or 0
      local extra = string.format("%s|%s|%s|%s|%s|%s", tostring(self.redPacketData.uuid), tostring(self.redPacketData.roomId), tostring(seqId), tostring(packetId), tostring(chatType), tostring(serverId))
      local thumbsUpType = InteractiveUtil.ThumbsUpType.GoldenEgg
      local identifier = "GoldenEgg"
      thumbsUpType = InteractiveUtil.ThumbsUpType.BirthdayRedPacket
      identifier = nil
      InteractiveUtil.TryThumbsUp(self.redPacketData.sendUid, thumbsUpType, identifier, function()
        if self.view == nil or self.view.ctrl == nil then
          return
        end
        local curTime = UITimeManager:GetInstance():GetServerTime()
        self.curBtnState = BtnState.SUCCESS
        self.curBtnStateRefreshTime = curTime + SuccessShowTime * 1000
        self:RefreshCurBtnState()
        UIUtil.ShowTipsId("birthday_tips_35")
      end, extra)
    end
  elseif self.curBtnState == BtnState.WAIT then
    self.eff_ui_birthday_wishes_wish_idle:SetActive(false)
    self.eff_ui_birthday_wishes_wish_up:SetActive(false)
    self.rootAni:SetSpeed(0)
    self.rootAni:SampleAnimationAtTime(AniName3, 1)
  elseif self.curBtnState == BtnState.SUCCESS then
    self.eff_ui_birthday_wishes_wish_idle:SetActive(false)
    self.eff_ui_birthday_wishes_wish_up:SetActive(false)
    self.eff_ui_birthday_wishes_wish_piaozi:SetActive(false)
    self.eff_ui_birthday_wishes_wish_caidai:SetActive(false)
    self.eff_ui_birthday_wishes_wish_piaozi:SetActive(true)
    self.eff_ui_birthday_wishes_wish_caidai:SetActive(true)
    self:RefreshEffectPower()
    local effectScale = 1
    if self.redPacketData then
      effectScale = 2
    end
    self.eff_ui_birthday_wishes_wish_piaozi:SetLocalScaleXYZ(effectScale, effectScale, effectScale)
    self.eff_ui_birthday_wishes_wish_caidai:SetLocalScaleXYZ(effectScale, effectScale, effectScale)
    self.rootAni:SetSpeed(0)
    self.rootAni:SampleAnimationAtTime(AniName3, 1)
  end
end

return BirthdayBtnItem
