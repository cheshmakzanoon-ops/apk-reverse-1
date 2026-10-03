local base = UIBaseContainer
local WorldAllianceCollect = BaseClass("WorldAllianceCollect", base)
local Localization = CS.GameEntry.Localization
local icon_path = "BuildInfo/content/Image"
local slider_path = "BuildInfo/content/buildObj/Slider"
local restNum_path = "BuildInfo/content/buildObj/Txt_CollectNum"
local headParent_path = "BuildInfo/collector/playerList"
local headObj_path = "BuildInfo/collector/UIPlayerHead"
local collector_path = "BuildInfo/collector"
local resTimeText_path = "BuildInfo/content/buildObj/Txt_CollectTime"
local desAnimator_path = "BuildInfo/content/buildObj"
local collectSpeed_path = "BuildInfo/collectSpeed/collectSpped"
local collectCount_path = "BuildInfo/collector/collectCount/countTip"
local disappearTimeTip_path = "BuildInfo/disappearTime/specialTimeTip"
local disappearTimeText_path = "BuildInfo/disappearTime/specialTimeTip/specialTimeTxt"
local info_path = "BuildDetails/ScrollView/Viewport/Content/collectDes"
local animator_path = ""
local attackerPlayer_path = "BuildInfo/content/attakcPlayer"
local allianceDes_path = "BuildInfo/content/allianceDes"
local selfColor = Color.New(0.1411764705882353, 0.6078431372549019, 0.7725490196078432, 1)
local otherColor = Color.New(0.45098039215686275, 0.40784313725490196, 0.38823529411764707, 1)
local time = 1

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.restNum = self:AddComponent(UITextMeshProUGUIEx, restNum_path)
  self.headParent = self:AddComponent(UIBaseContainer, headParent_path)
  self.headObj = self:AddComponent(UIBaseContainer, headObj_path)
  self.collector = self:AddComponent(UIBaseContainer, collector_path)
  self.resTimeText = self:AddComponent(UITextMeshProUGUIEx, resTimeText_path)
  self.desAnimator = self:AddComponent(UIAnimator, desAnimator_path)
  self.collectSpeed = self:AddComponent(UITextMeshProUGUIEx, collectSpeed_path)
  self.collectCount = self:AddComponent(UITextMeshProUGUIEx, collectCount_path)
  self.disappearTimeTip = self:AddComponent(UITextMeshProUGUIEx, disappearTimeTip_path)
  self.disappearTimeText = self:AddComponent(UITextMeshProUGUIEx, disappearTimeText_path)
  self.info = self:AddComponent(UITextMeshProUGUIEx, info_path)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.attackerPlayer = self:AddComponent(UITextMeshProUGUIEx, attackerPlayer_path)
  self.allianceDes = self:AddComponent(UITextMeshProUGUIEx, allianceDes_path)
  self.playerHead = self.headObj.gameObject
  self.playerHead:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.icon = nil
  self.slider = nil
  self.restNum = nil
  self.headParent = nil
  self.headObj = nil
  self.collector = nil
  self.resTimeText = nil
  self.desAnimator = nil
  self.collectSpeed = nil
  self.collectCount = nil
  self.disappearTimeTip = nil
  self.disappearTimeText = nil
  self.info = nil
  self.animator = nil
  self.attackerPlayer = nil
  self.allianceDes = nil
end

local function DataDefine(self)
  self.queueReqs = nil
  self.needUpdate = false
end

local function DataDestroy(self)
  self.queueReqs = nil
  self:ClearQueue()
  self.playerHead = nil
  self.needUpdate = nil
end

local function RefreshData(self, param)
  self.data = param
  self.isUpdate = false
  self.isDetectCollect = false
  self.icon:LoadSprite(self.data.icon)
  self.restNum:SetText(Localization:GetString("300642") .. ": " .. self.data.maxValue .. "/" .. self.data.maxValue)
  self.resTimeText:SetText("")
  self.slider:SetValue(1)
  self.collectSpeed:SetLocalText("800810", self.data.showSpeed)
  self.info:SetText(self.data.detailInfo)
end

local function RefreshServerData(self, serverData)
  self.serverData = serverData
  local gatherValue = self.data.maxValue - self.serverData.detailData.remainValue
  self.restNum:SetText(Localization:GetString("300642") .. ": " .. gatherValue .. "/" .. self.data.maxValue)
  self.slider:SetValue(gatherValue / self.data.maxValue)
  if self.serverData.detailData.totalSpeed > 0 then
    self.desAnimator:Enable(true)
    self.desAnimator:Play("txtchangell", 0, 0)
  else
    self.desAnimator:Enable(false)
  end
  self.needUpdate = true
  self:RefreshTime()
  self.restNum:SetColor(Color.New(1, 1, 1, 1))
  self.resTimeText:SetColor(Color.New(1, 1, 1, 1))
  local creatorName = self.serverData.detailData.creatorInfo or ""
  local allianceAbbr
  if not string.IsNullOrEmpty(self.serverData.detailData.allianceAbbr) then
    allianceAbbr = "[" .. self.serverData.detailData.allianceAbbr .. "]"
  else
    allianceAbbr = ""
  end
  if not string.IsNullOrEmpty(creatorName) or not string.IsNullOrEmpty(allianceAbbr) then
    local str = Localization:GetString("season_tips245", allianceAbbr .. creatorName)
    self.attackerPlayer:SetText(str)
  else
    self.attackerPlayer:SetText("")
  end
  if not string.IsNullOrEmpty(allianceAbbr) then
    local str = Localization:GetString("season_tips246", allianceAbbr)
    self.allianceDes:SetText(str)
  else
    self.allianceDes:SetText("")
  end
  if self.serverData.allianceId == LuaEntry.Player.allianceId then
    self.attackerPlayer:SetColor(selfColor)
    self.allianceDes:SetColor(selfColor)
  else
    self.attackerPlayer:SetColor(otherColor)
    self.allianceDes:SetColor(otherColor)
  end
  self.disappearTimeTip:SetLocalText(800823)
  if 0 < self.serverData.detailData.totalCount then
    self.collectCount:SetLocalText("season_alliance_resource_collect_count", self.serverData.detailData.totalCount)
    self.collectCount:SetActive(true)
  else
    self.collectCount:SetActive(false)
  end
  self:RefreshCollector()
end

local function RefreshTime(self)
  if self.serverData and self.serverData.detailData then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.serverData.detailData.expireTime - curTime
    if remainTime < 0 then
      remainTime = 0
    end
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
    self.disappearTimeText:SetText(timeStr)
    if 0 < remainTime then
      local curValue = self.serverData.detailData:GetCurResourceValue()
      if 0 < curValue then
        local gatherValue = self.data.maxValue - curValue
        self.restNum:SetText(Localization:GetString("300642") .. ": " .. gatherValue .. "/" .. self.data.maxValue)
        self.slider:SetValue(gatherValue / self.data.maxValue)
        local endTime = self.serverData.detailData:GetSelfEndTime()
        if endTime and 0 < endTime then
          local selfEndTimeRemain = endTime - curTime
          if 0 < selfEndTimeRemain then
            self.resTimeText:SetText(Localization:GetString("300641") .. ": " .. UITimeManager:GetInstance():MilliSecondToFmtString(selfEndTimeRemain))
          else
            self.desAnimator:Enable(false)
            self.restNum:SetColor(Color.New(1, 1, 1, 1))
            self.resTimeText:SetText("")
          end
        else
          self.desAnimator:Enable(false)
          self.restNum:SetColor(Color.New(1, 1, 1, 1))
          self.resTimeText:SetText("")
        end
      else
        self.desAnimator:Enable(false)
        self.restNum:SetColor(Color.New(1, 1, 1, 1))
        self.resTimeText:SetText("")
        self.restNum:SetText("")
        self.slider:SetValue(1)
      end
    else
      self.needUpdate = false
      self.desAnimator:Enable(false)
      self.restNum:SetColor(Color.New(1, 1, 1, 1))
      self.resTimeText:SetText("")
      self.slider:SetValue(1)
    end
  end
end

local function Update1000MS(self)
  if self.needUpdate then
    self:RefreshTime()
  end
end

local function ClearQueue(self)
  self.headParent:RemoveComponents(UICommonHead)
  if self.queueReqs then
    for _, req in pairs(self.queueReqs) do
      req:Destroy()
    end
  end
  self.queueReqs = {}
  if self.playerHead then
    self.playerHead:GameObjectRecycleAll()
  end
end

local function RefreshCollector(self)
  self:ClearQueue()
  local playerData = self.serverData.detailData.playerInfoLiset
  local total = #playerData
  if 0 < total then
    self.collector:SetActive(true)
    self.isEvenCount = total % 2 == 0
    self.mid = math.ceil(total / 2)
    for i, player in ipairs(playerData) do
      local go = self.playerHead:GameObjectSpawn()
      local index = i
      local nameStr = "UICollectorHead" .. index
      go.name = nameStr
      go:SetActive(true)
      local transform = go.transform
      transform:SetParent(self.headParent.transform)
      local item = self.headParent:AddComponent(UICommonHead, nameStr)
      item:SetAnchorMinXY(0.5, 0.5)
      item:SetAnchorMaxXY(0.5, 0.5)
      transform:Set_localPosition(self:GetPosByIndex(index, total), 0, 0)
      transform:Set_localScale(1, 1, 1)
      item:SetHeadAndFrame(player.uid, player.pic, player.picVer, false, player.headSkinId, player.headSkinET)
    end
  else
    self.collector:SetActive(false)
  end
end

local function GetPosByIndex(self, index, total)
  if total == 1 then
    return 0
  end
  if total <= 5 then
    if self.isEvenCount then
      if index <= self.mid then
        return -50 - (self.mid - index) * 100
      else
        return 50 + (index - self.mid - 1) * 100
      end
    elseif index == self.mid then
      return 0
    elseif index < self.mid then
      return -(self.mid - index) * 100
    else
      return (index - self.mid) * 100
    end
  else
    local step = 400 / (total - 1)
    return -200 + step * (index - 1)
  end
end

local function OnInfoClick(self)
  self.animator:Enable(true)
  self.animator:Play("switchEnter", 0, 0)
end

local function OnReturnClick(self)
  self.animator:Enable(true)
  self.animator:Play("switchOut", 0, 0)
end

WorldAllianceCollect.OnCreate = OnCreate
WorldAllianceCollect.OnDestroy = OnDestroy
WorldAllianceCollect.OnEnable = OnEnable
WorldAllianceCollect.OnDisable = OnDisable
WorldAllianceCollect.ComponentDefine = ComponentDefine
WorldAllianceCollect.ComponentDestroy = ComponentDestroy
WorldAllianceCollect.DataDefine = DataDefine
WorldAllianceCollect.DataDestroy = DataDestroy
WorldAllianceCollect.Update1000MS = Update1000MS
WorldAllianceCollect.RefreshData = RefreshData
WorldAllianceCollect.RefreshServerData = RefreshServerData
WorldAllianceCollect.RefreshTime = RefreshTime
WorldAllianceCollect.ClearQueue = ClearQueue
WorldAllianceCollect.RefreshCollector = RefreshCollector
WorldAllianceCollect.GetPosByIndex = GetPosByIndex
WorldAllianceCollect.OnInfoClick = OnInfoClick
WorldAllianceCollect.OnReturnClick = OnReturnClick
return WorldAllianceCollect
