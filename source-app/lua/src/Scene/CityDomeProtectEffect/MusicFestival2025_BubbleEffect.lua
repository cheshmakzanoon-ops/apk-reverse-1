local MusicFestival2025_BubbleEffect = BaseClass("MusicFestival2025_BubbleEffect")
local ResourceManager = CS.GameEntry.Resource
local prefabPath = "Assets/Main/Prefabs/UI/ActMusicFestival2025/WorldShow/WorldPlayingPartyBubble.prefab"
local shareIconPath = "Assets/Main/Sprites/UI/UIBuildBtns/zyf_zhujiemian_qipao_fenxiang.png"
local musicFestivalRewardIconPath = "Assets/Main/Sprites/UI/ActMusicFestival2025WorldShow/wxy_yinyuejie_paidui_qipao.png"
local State = {show = 1, hide = 3}

local function OnCreate(self)
  self.request = nil
  self.gameObject = nil
  self.transform = nil
  self.timer = nil
  self.lod = 1
  self.posIndex = 0
  self.endTime = 0
  self.curState = State.hide
  self.nextStateTime = 0
end

local function OnDestroy(self)
  if self.request ~= nil then
    self.request:Destroy()
  end
  self.request = nil
  self.gameObject = nil
  self.transform = nil
  self:DeleteTimer()
  self.lod = nil
  self.posIndex = nil
  self.endTime = nil
  self.curState = nil
  self.nextStateTime = nil
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self, time)
  self:DeleteTimer()
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self:DeleteTimer()
    self:TryRefreshShow()
  end, time / 1000)
end

local function ReInit(self, lod, posIndex, infoUuid, param, extraParam)
  self:DeleteTimer()
  local endTime = 0
  local statusId = 0
  for k, v in pairs(param) do
    statusId = k
    endTime = v
    break
  end
  self.lod = lod
  self.posIndex = posIndex
  self.param = param
  self.extraParam = extraParam
  self.playerUid = extraParam.playerUid
  self.playerName = extraParam.playerName
  self.endTime = endTime
  self.curState = State.hide
  self.nextStateTime = 0
  self.statusId = statusId
  self:TryRefreshShow()
end

function MusicFestival2025_BubbleEffect:TryRefreshShow()
  if self.request == nil then
    local request = ResourceManager:InstantiateAsync(prefabPath)
    self.request = request
    request:completed("+", function()
      if request.isError then
        return
      end
      self:DefineComponent(request)
      self.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      self:TryRefreshShowAfterLoad()
    end)
  elseif self.gameObject then
    self:TryRefreshShowAfterLoad()
  end
end

function MusicFestival2025_BubbleEffect:DefineComponent(request)
  self.gameObject = request.gameObject
  self.transform = request.gameObject.transform
  self.rewardIcon = self.transform:Find("rewardIcon"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.rewardEffect = self.transform:Find("rewardEffect").gameObject
  self.btnCollider = self.transform:GetComponent(typeof(CS.TouchObjectEventTrigger))
  self.rewardNumText = self.transform:Find("rewardTxt"):GetComponent(typeof(CS.SuperTextMesh))
end

local function TryRefreshShowAfterLoad(self)
  if self.transform then
    local pos = SceneUtils.TileIndexToWorld(self.posIndex)
    pos.y = pos.y + 4.3
    pos.x = pos.x
    self.transform.position = pos
  end
  local remainingNum = self.extraParam.status.Layer
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.endTime and 0 < remainingNum then
    self.curState = State.show
    self.nextStateTime = self.endTime - curTime + 100
  else
    self.curState = State.hide
    self.nextStateTime = 0
  end
  self.gameObject:SetActive(self.lod < 3 and self.curState == State.show)
  if self.curState == State.show then
    local recordKey = self.playerUid .. "_" .. self.extraParam.status.Id .. "_" .. self.extraParam.status.ExpireTime
    local hasGot = DataCenter.ActConcertDataManager:HasGotBuildMainReward(recordKey)
    self.rewardEffect:SetActive(not hasGot)
    self.rewardNumText.text = remainingNum
    if hasGot then
      self.rewardIcon:LoadSprite(shareIconPath)
      
      function self.btnCollider.onPointerClick()
        if DataCenter.ActConcertDataManager:GetIfClickConcertBubble(self.extraParam.status.Id) then
          DataCenter.ActConcertDataManager:ShareToChat(self.posIndex, self.playerName)
        else
          local cd = DataCenter.ActConcertDataManager:GetDeltaTime(self.extraParam.status.Id)
          local Localization = CS.GameEntry.Localization
          UIUtil.ShowTips(Localization:GetString("activity_concert_65", cd))
        end
      end
    else
      self.rewardIcon:LoadSprite(musicFestivalRewardIconPath)
      
      function self.btnCollider.onPointerClick()
        local canGetCurClaimReward = DataCenter.ActConcertDataManager:CanGetCurClaimRewardByStatusId(self.statusId)
        if canGetCurClaimReward then
          SFSNetwork.SendMessage(MsgDefines.SkinPartyBaseReward, self.statusId, self.playerUid)
        else
          UIUtil.ShowTipsId("activity_concert_2_3")
        end
      end
    end
  end
  if 0 < self.nextStateTime then
    self:AddTimer(self.nextStateTime)
  end
end

local function SetLod(self, lod)
  self.lod = lod
  self:TryRefreshShow()
end

MusicFestival2025_BubbleEffect.OnCreate = OnCreate
MusicFestival2025_BubbleEffect.OnDestroy = OnDestroy
MusicFestival2025_BubbleEffect.ReInit = ReInit
MusicFestival2025_BubbleEffect.AddTimer = AddTimer
MusicFestival2025_BubbleEffect.DeleteTimer = DeleteTimer
MusicFestival2025_BubbleEffect.TryRefreshShowAfterLoad = TryRefreshShowAfterLoad
MusicFestival2025_BubbleEffect.SetLod = SetLod
return MusicFestival2025_BubbleEffect
