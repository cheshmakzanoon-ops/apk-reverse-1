local BuildingRewardBubbleEffect = BaseClass("BuildingRewardBubbleEffect")
local ResourceManager = CS.GameEntry.Resource
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh
local TouchObjectEventTrigger = CS.TouchObjectEventTrigger
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
  self.clickTrigger = nil
  self.rewardBg = nil
  self.rewardIcon = nil
  self.rewardTxt = nil
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

local function ReInit(self, lod, posIndex, infoUuid, param, extarParam)
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
  self.infoUuid = infoUuid
  self.param = param
  self.endTime = endTime
  self.curState = State.hide
  self.nextStateTime = 0
  self.extarParam = extarParam
  self.targetStatusId = 0
  self.targetStatusTemp = nil
  self.targetStatusType2 = 0
  self:TryRefreshShow()
end

local function TryRefreshShow(self)
  local prefabName = "Assets/Main/Prefabs/March/BuildingRewardBubble.prefab"
  if self.request == nil then
    local request = ResourceManager:InstantiateAsync(prefabName)
    self.request = request
    request:completed("+", function()
      if request.isError then
        return
      end
      self.gameObject = request.gameObject
      self.transform = request.gameObject.transform
      self.rewardBg = self.transform:Find("rewardBg"):GetComponent(typeof(SpriteRenderer))
      self.rewardIcon = self.transform:Find("rewardIcon"):GetComponent(typeof(SpriteRenderer))
      self.rewardTxt = self.transform:Find("rewardTxt"):GetComponent(typeof(SuperTextMesh))
      self.clickTrigger = self.transform:GetComponent(typeof(TouchObjectEventTrigger))
      
      function self.clickTrigger.onPointerClick()
        self:ClickFunc()
      end
      
      self.clickTrigger.previewType = 999
      self:TryRefreshShowAfterLoad()
    end)
  elseif self.gameObject then
    self:TryRefreshShowAfterLoad()
  end
end

local function TryRefreshShowAfterLoad(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.endTime then
    self.curState = State.show
    self.nextStateTime = self.endTime - curTime + 100
  else
    self.curState = State.hide
    self.nextStateTime = 0
  end
  if self.curState == State.show then
    local ownerUid = self.extarParam.ownerUid
    local canGetIds = {}
    local canGetDatas = {}
    if ownerUid and ownerUid ~= "" then
      for k, v in pairs(self.param) do
        local isGet = DataCenter.ActGiftGivingDataManager:GetActivityStatusReceiveDict(k, ownerUid)
        if not isGet then
          table.insert(canGetIds, k)
        end
      end
    end
    for k, v in pairs(canGetIds) do
      local statusTemp = DataCenter.StatusManager:GetTemplate(tostring(v))
      if statusTemp then
        local type2 = tonumber(statusTemp.type2) or 0
        local isCanShow = true
        if type2 == StatusType2.BuildingRewardBubble1 then
          local maxNum = DataCenter.ActGiftGivingDataManager:GetWorldRewardBubbleMaxNum()
          local haveGetNum = DataCenter.ActGiftGivingDataManager:GetRewardBubbleGetNum()
          if maxNum <= haveGetNum then
            isCanShow = false
          end
        end
        if isCanShow then
          table.insert(canGetDatas, {
            id = v,
            statusTemp = statusTemp,
            type2 = tonumber(statusTemp.type2) or 0
          })
        end
      end
    end
    table.sort(canGetDatas, function(a, b)
      if a.type2 ~= b.type2 then
        return a.type2 > b.type2
      end
      return a.id < b.id
    end)
    if 0 < #canGetDatas then
      self.targetStatusId = canGetDatas[1].id
      self.targetStatusTemp = canGetDatas[1].statusTemp
      self.targetStatusType2 = canGetDatas[1].type2
    else
      self.targetStatusId = 0
      self.targetStatusTemp = nil
      self.targetStatusType2 = 0
    end
    if 0 < self.targetStatusId then
      if self.targetStatusType2 == StatusType2.BuildingRewardBubble2 then
        self.rewardTxt.text = ""
      elseif self.targetStatusType2 == StatusType2.BuildingRewardBubble1 then
        local maxNum = DataCenter.ActGiftGivingDataManager:GetWorldRewardBubbleMaxNum()
        local haveGetNum = DataCenter.ActGiftGivingDataManager:GetRewardBubbleGetNum()
        if maxNum <= haveGetNum then
          self.rewardTxt.text = "0" .. "/" .. maxNum
        else
          self.rewardTxt.text = haveGetNum .. "/" .. maxNum
        end
      end
    else
      self.curState = State.hide
      self.nextStateTime = 0
    end
  end
  self.gameObject:SetActive(self.lod < 3 and self.curState == State.show)
  if self.curState == State.show then
    local imgPath = "Assets/Main/Sprites/UI/ActLottery/lrb_zhujiemian_ganenjiejidijiangli.png"
    local scale = 1
    local dataStr = self.targetStatusTemp.buff_effect
    local buffData = string.split(dataStr, "|")
    if buffData and #buffData <= 2 then
      imgPath = buffData[1] or imgPath
      scale = buffData[2] or scale
    end
    self.rewardIcon:LoadSprite(imgPath)
    self.rewardIcon.transform.localScale = Vector3.New(scale, scale, scale)
  end
  if self.transform then
    local pos = SceneUtils.TileIndexToWorld(self.posIndex)
    pos.y = pos.y + 5
    pos.x = pos.x
    self.transform.position = pos
  end
  if self.nextStateTime > 0 then
    self:AddTimer(self.nextStateTime)
  end
end

local function SetLod(self, lod)
  self.lod = lod
  self:TryRefreshShow()
end

local function ClickFunc(self)
  if self.targetStatusId <= 0 then
    return
  end
  if self.targetStatusType2 == StatusType2.BuildingRewardBubble1 then
    local targetActId = DataCenter.ActGiftGivingDataManager:GetOneOpenActId()
    if 0 < targetActId then
      SFSNetwork.SendMessage(MsgDefines.ThanksgivingReceiveBaseReward, targetActId, self.extarParam.ownerUid, self.targetStatusId)
    end
  elseif self.targetStatusType2 == StatusType2.BuildingRewardBubble2 then
    MarchUtil.LaunchScout(MarchTargetType.LOTTO_RECEIVE_BASE_REWARD, self.posIndex, self.infoUuid)
  end
end

BuildingRewardBubbleEffect.OnCreate = OnCreate
BuildingRewardBubbleEffect.OnDestroy = OnDestroy
BuildingRewardBubbleEffect.ReInit = ReInit
BuildingRewardBubbleEffect.AddTimer = AddTimer
BuildingRewardBubbleEffect.DeleteTimer = DeleteTimer
BuildingRewardBubbleEffect.TryRefreshShow = TryRefreshShow
BuildingRewardBubbleEffect.TryRefreshShowAfterLoad = TryRefreshShowAfterLoad
BuildingRewardBubbleEffect.SetLod = SetLod
BuildingRewardBubbleEffect.ClickFunc = ClickFunc
return BuildingRewardBubbleEffect
