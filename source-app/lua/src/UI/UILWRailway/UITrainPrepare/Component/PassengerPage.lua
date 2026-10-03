local PassengerPage = BaseClass("PassengerPage", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Carriage = require("UI.UILWRailway.UITrainPrepare.Component.PrepareCarriage")
local LANG_KEY = {
  [1] = 458605,
  [2] = 458606,
  [3] = 458607,
  [4] = 458608
}
local CROWD_NUM = 3
local TALK_CD = 10

function PassengerPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function PassengerPage:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PassengerPage:ComponentDefine()
  self.carriage = {}
  for i = 1, 4 do
    self.carriage[i] = self:AddComponent(Carriage, "PrepareCarriage" .. i)
  end
  self.bubble = self:AddComponent(UIBaseComponent, "Bubble")
  self.bubble:SetActive(false)
  self.name = self:AddComponent(UIText, "Bubble/name")
  self.head = self:AddComponent(UICommonHead, "Bubble/head")
  self.words = self:AddComponent(UIText, "Bubble/words")
  self.timeCount = TALK_CD
end

function PassengerPage:ComponentDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.carriage = {}
  self.trainData = nil
end

function PassengerPage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PassengerBubble, self.PopBubble)
end

function PassengerPage:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PassengerBubble, self.PopBubble)
end

function PassengerPage:Refresh(trainData)
  for i = 1, 4 do
    self.carriage[i]:Refresh(i + 1, trainData)
  end
  if trainData then
    self.openType = TrainUIOpenType.Departure
  else
    self.openType = TrainUIOpenType.Prepare
  end
end

function PassengerPage:PopBubble(param)
  local pos, player, word = param.pos, param.player, param.word
  self.bubble:SetPosition(pos + Vector3(0, 50, 0))
  self.bubble:SetActive(true)
  self.words:SetText(word)
  self.name:SetText(player.name)
  if player.uid == LuaEntry.Player.uid then
    local headSkinPath = LuaEntry.Player:GetHeadBgImg()
    self.head:SetData(player.uid, player.pic, player.picVer, nil, headSkinPath)
  else
    self.head:SetHeadAndFrame(player.uid, player.headPic, player.headPicVer, false, player.headSkinId, player.headSkinET)
  end
  if self.timer then
    self.timer:Stop()
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.bubble:SetActive(false)
  end, 5)
end

function PassengerPage:Update1000MS()
  if self.openType == TrainUIOpenType.Departure then
    return
  end
  self.timeCount = self.timeCount - 1
  if self.timeCount > 0 then
    return
  end
  self.timeCount = TALK_CD
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  if not platformData or platformData.state ~= TrainPlatformState.TrainWithDriver then
    return
  end
  local playerPool = {}
  for _, queue in pairs(platformData.lineUp) do
    if #queue >= CROWD_NUM then
      for i = 1, #queue do
        table.insert(playerPool, queue[i])
      end
    end
  end
  if #playerPool <= 0 then
    return
  end
  local rand = math.random(#playerPool)
  local player = playerPool[rand]
  local rand2 = math.random(#LANG_KEY)
  local head
  for i = 1, #self.carriage do
    local temp = self.carriage[i]:GetPlayerHeadByUid(player.uid)
    if temp then
      head = temp
      break
    end
  end
  if head then
    local param = {
      pos = head.transform.position,
      player = player,
      word = Localization:GetString(LANG_KEY[rand2])
    }
    self:PopBubble(param)
  end
end

return PassengerPage
