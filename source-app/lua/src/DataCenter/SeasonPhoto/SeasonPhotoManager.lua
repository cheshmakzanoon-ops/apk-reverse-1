local SeasonPhotoManager = BaseClass("SeasonPhotoManager")
local SeasonPhotoCanva = require("UI.LWSeason.LWSeasonPhoto.Component.SeasonPhotoCanva")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local UIDynamicSkin = require("Framework.UI.Component.UIDynamicSkin")

function SeasonPhotoManager:__init()
  self.init = false
  self.activityId = nil
  self.hasSendAllView = false
  self.photoSimpleArr = {}
  self.photoInfoDic = {}
  self.userSettleRecordDic = {}
  self.commentDic = {}
  self.taskList = nil
  self.rewardRed = 0
  self.status = 0
  self.shotParam = nil
  self:RequestSeasonPhotoAllView()
  self:AddListener()
end

function SeasonPhotoManager:__delete()
  self:RemoveListener()
end

function SeasonPhotoManager:Init()
  if not self:IsActive() then
    return
  end
  self:UpdateActiveView()
  SFSNetwork.SendMessage(MsgDefines.ViewSeasonPhotoTasklist, self.activityId)
end

function SeasonPhotoManager:Startup()
end

function SeasonPhotoManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterWorld, self.OnEnterWorld, self)
end

function SeasonPhotoManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorld, self.OnEnterWorld, self)
end

function SeasonPhotoManager:InitData(data)
  self.activityId = data.id
  self:Init()
end

function SeasonPhotoManager:GetConfigData(id)
  return DataCenter.SeasonPhotoTemplateManager:GetConfigData(id)
end

function SeasonPhotoManager:OnEnterWorld()
  self.hasSendAllView = false
  self.photoInfoDic = {}
  self.userSettleRecordDic = {}
  self.commentDic = {}
  self:ReleaseTexture(true)
end

function SeasonPhotoManager:IsActive(includePrepare)
  return SeasonUtil.IsSeasonActivityOpen(self.activityId, nil, includePrepare, true)
end

function SeasonPhotoManager:GetActivityData(includePrepare)
  if not self:IsActive(includePrepare) then
    return
  end
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
end

function SeasonPhotoManager:CanEditPhoto(season, allianceId, checkModule, showTips_)
  local photoInfo = self:GetSeasonPhotoData(season, allianceId)
  return self:CanEdit(photoInfo, checkModule, showTips_)
end

function SeasonPhotoManager:CanEdit(photoInfo, checkModule, showTips_)
  if not photoInfo then
    if showTips_ then
      UIUtil.ShowTipsId("season_alliance_photo_tips_1")
    end
    return false
  end
  if not self:IsActive() or photoInfo.season ~= SeasonUtil.GetSeason() then
    if showTips_ then
      UIUtil.ShowTipsId("170009")
    end
    return false
  end
  if photoInfo.allianceId ~= LuaEntry.Player.allianceId then
    if showTips_ then
      UIUtil.ShowTips(Localization:GetString("season_alliance_photo_tips_3", string.format("#%d[%s]%s", photoInfo.serverId, photoInfo.abbr, photoInfo.allianceName)))
    end
    return false
  end
  if not self:GetSelfPhotoSimple(photoInfo.season, photoInfo.allianceId, showTips_) then
    return false
  end
  if checkModule and not self:CheckModuleValue(showTips_) then
    return false
  end
  return true
end

function SeasonPhotoManager:CanShare(photoInfo, checkModule, showTips_)
  if not photoInfo then
    if showTips_ then
      UIUtil.ShowTipsId("season_alliance_photo_tips_1")
    end
    return false
  end
  if checkModule and not self:CheckModuleValue(showTips_) then
    return false
  end
  return true
end

function SeasonPhotoManager:SetModuleValue(status)
  self.status = status
end

function SeasonPhotoManager:CheckModuleValue(showView)
  if self.status ~= 1 then
    if showView then
      UIManager:GetInstance():OpenWindow(UIWindowNames.ModuleCheck, {anim = true})
    end
    return false
  end
  return true
end

function SeasonPhotoManager:GetPhotoAllianceId(season)
  season = season or SeasonUtil.GetSeason()
  for k, v in pairs(self.photoSimpleArr) do
    if v.season == season then
      return v.allianceId
    end
  end
  return ""
end

function SeasonPhotoManager:GetSelfPhotoSimple(season, allianceId, showTips_)
  if self.photoSimpleArr and season and allianceId then
    for k, v in pairs(self.photoSimpleArr) do
      if v.season == season and allianceId == v.allianceId then
        return v
      end
    end
  end
  if showTips_ then
    UIUtil.ShowTipsId("season_alliance_photo_tips_19")
  end
end

function SeasonPhotoManager:GetSeasonPhotoActivityData(season, allianceId)
  local curSeason = SeasonUtil.GetSeason()
  if curSeason == season and self:GetPhotoAllianceId(season) == allianceId then
    return self:GetActivityData()
  end
end

function SeasonPhotoManager:GotoActivity()
  if not self:IsActive() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.SingleActivityContainerType2, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.activityId)
end

function SeasonPhotoManager:GetPhotoId(season, allianceId)
  return string.format("%s_%s", season, allianceId)
end

function SeasonPhotoManager:GetAllViewData()
  local activityData = self:GetActivityData()
  local curSeason = activityData and SeasonUtil.GetSeason() or -1
  local list, index = {}, 1
  for k, v in pairs(self.photoSimpleArr) do
    if not (v.season ~= curSeason and v.picVer) or v.picVer > 0 then
      list[index] = v
      index = index + 1
    end
  end
  return list
end

function SeasonPhotoManager:HasPhotoSimpleArr()
  return self.photoSimpleArr ~= nil and next(self.photoSimpleArr)
end

function SeasonPhotoManager:GetSeasonPhotoData(season, allianceId)
  local id = self:GetPhotoId(season, allianceId)
  return self.photoInfoDic[id], self.userSettleRecordDic[id]
end

function SeasonPhotoManager:GetCommentData(season, allianceId)
  local id = self:GetPhotoId(season, allianceId)
  return self.commentDic[id], self.userSettleRecordDic[id]
end

function SeasonPhotoManager:IsPhotoDirty(photoInfo, editPicData)
  if not photoInfo or not editPicData then
    return false
  end
  local changeList, addList = self:GetChangeList(photoInfo, editPicData)
  if table.IsNullOrEmpty(changeList) and table.IsNullOrEmpty(addList) and editPicData.sizeConfigId == photoInfo.picData.sizeConfigId and editPicData.borderConfigId == photoInfo.picData.borderConfigId then
    return false
  end
  return true, changeList, addList
end

function SeasonPhotoManager:SharePhoto(season, allianceId, isMessage_)
  if not season or not allianceId then
    return
  end
  local photoInfo, userRecord = self:GetSeasonPhotoData(season, allianceId)
  if not photoInfo or not userRecord then
    UIUtil.ShowTipsId("season_alliance_photo_tips_1")
    return
  end
  if not self:CanShare(photoInfo, false, true) then
    return
  end
  local share_param = {}
  share_param.postType = PostType.SeasonPhoto
  share_param.season = photoInfo.season
  share_param.allianceId = photoInfo.allianceId
  share_param.uid = userRecord.uid
  share_param.serverId = photoInfo.serverId
  share_param.allianceName = photoInfo.allianceName
  share_param.abbr = photoInfo.abbr
  share_param.icon = photoInfo.icon
  share_param.isMessage = isMessage_
  local chatData = {}
  chatData.post = share_param.postType
  chatData.postType = share_param.postType
  chatData.param = share_param
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, chatData)
end

function SeasonPhotoManager:ChangeSkin(view, season)
  if not view then
    return
  end
  if not view.skinMgr then
    view.skinMgr = view:AddComponent(UIDynamicSkin, "")
  end
  local seasonType = season + 1
  view.skinMgr:SetAsync(true)
  view.skinMgr:ActiveSkin(seasonType)
end

local function __SortComment(a, b)
  return a.refreshTime > b.refreshTime
end

function SeasonPhotoManager:RequestSeasonPhotoAllView()
  if self.hasSendAllView then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonPhotoSimpleAllView)
end

function SeasonPhotoManager:RequestSeasonPhotoOneView(season, allianceId)
  if not season or string.IsNullOrEmpty(allianceId) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonPhotoOneView, season, allianceId)
end

function SeasonPhotoManager:SendComment(season, allianceId, content)
  if not (season and allianceId) or string.IsNullOrEmpty(content) then
    UIUtil.ShowTipsId("season_alliance_photo_tips_14")
    return
  end
  local photoInfo = self:GetSeasonPhotoData(season, allianceId)
  local userSettleRecord = photoInfo and self.userSettleRecordDic[photoInfo.id]
  if userSettleRecord and not photoInfo:CheckMessageCd(userSettleRecord, true) then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.sendTimeStamp and curTime - self.sendTimeStamp < 1000 then
    UIUtil.ShowTipsId("season_alliance_photo_tips_9")
    return
  end
  self.sendTimeStamp = curTime
  if not self:CanEdit(photoInfo, true, true) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonPhotoCommentUpdate, season, allianceId, content)
end

function SeasonPhotoManager:SeasonPhotoThumbsUp(season, allianceId, uid, uuid, thumbsType, extParam)
  local param = {
    targetSeason = season,
    targetAllianceId = allianceId,
    targetUuid = uuid,
    targetUid = uid,
    thumbsType = thumbsType or 1,
    extParam = extParam
  }
  if uid == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("avatar_tips001")
    return
  end
  if param.thumbsType == 1 then
    local sequence = InteractiveUtil.TryThumbsUp(uid, InteractiveUtil.ThumbsUpType.SeasonPhotoMessage, "SeasonPhotoMessage", function()
    end, extParam, true)
    if not sequence then
      return
    end
    param.content = sequence
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonPhotoCommentThumbsUp, param)
end

function SeasonPhotoManager:SavePhoto(view)
  local userRecord = view.userSettleRecord
  if self:IsActive() and userRecord and userRecord.allianceId == LuaEntry.Player.allianceId and userRecord.season == DataCenter.SeasonDataManager:GetSeason() then
    UIUtil.ShowTipsId("season_alliance_photo_tips_12")
    return
  end
  if Config.IsPC() then
    UIUtil.ShowTipsId("season_alliance_photo_tips_30")
    return
  end
  if CS.StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, "1.0.282") < 0 then
    UIUtil.ShowTipsId("season_alliance_photo_tips_31")
    return
  end
  self:CameraShot(view, 1730, 2048, function(rtParam)
    local rt = rtParam.renderTexture
    CS.SDKManager.SaveRTToAlbum(rt)
    self:ReleaseTexture(true)
    self:SetSeasonPhotoUploadSuccess()
  end, UIAssets.UISeasonPhotoCanvaShotFull)
end

function SeasonPhotoManager:UploadPhoto(photoInfo, editPicData, userSettleRecord, view)
  local isDirty, changeList, addList = self:IsPhotoDirty(photoInfo, editPicData)
  if not isDirty then
    UIUtil.ShowTipsId("season_alliance_photo_tips_14")
    return
  end
  if not photoInfo:CheckPicCd(userSettleRecord, true) then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.saveTimeStamp and curTime - self.saveTimeStamp < 1000 then
    UIUtil.ShowTipsId("season_alliance_photo_tips_9")
    return
  end
  self.saveTimeStamp = curTime
  if not self:CanEdit(photoInfo, true, true) then
    return
  end
  local param = {
    curVer = photoInfo.picVer,
    targetSeason = photoInfo.season,
    targetAllianceId = photoInfo.allianceId,
    moveMemberArr = changeList,
    addMemberArr = addList,
    picData = editPicData
  }
  self.saveParam = param
  if table.IsNullOrEmpty(changeList) and table.IsNullOrEmpty(addList) then
    UIUtil.ShowTipsId("season_alliance_photo_tips_9")
    self:SetSeasonPhotoUploadSuccess()
  elseif view then
    self:CameraShot(view, 512, 512, function(rtParam)
      SFSNetwork.SendMessage(MsgDefines.FetchNewPicVer, FetchPicVerFuncType.SeasonAlliancePhoto)
    end)
  end
end

function SeasonPhotoManager:CameraShot(view, width, height, callBack, prefabPath)
  self:SetSeasonPhotoUploading()
  CommonUtil.ProtectCall(function()
    if self.shotParam and self.shotParam.prefab then
      self:ReleaseTexture(true)
    end
    self.shotParam = {}
    local prefab = CS.GameEntry.Resource:InstantiateAsync(prefabPath or UIAssets.UISeasonPhotoCanvaShot)
    self.shotParam.prefab = prefab
    prefab:completed("+", function()
      if prefab.isError then
        self:SetSeasonPhotoUploadFail()
        return
      end
      local obj = prefab.gameObject
      local trans = obj.transform
      obj.name = "shot"
      obj:SetActive(true)
      trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      trans:Set_position(10000, ResetPosition.y, ResetPosition.z)
      self.shotParam.camera = trans:Find("Camera"):GetComponent(typeof(CS.UnityEngine.Camera))
      trans:SetParent(view.transform)
      self.shotParam.view = view
      self.shotParam.photoCanva = view:AddComponent(SeasonPhotoCanva, obj.name)
      trans:SetParent(nil)
      self.shotParam.photoCanva:SetPhotoData(view.data, view.userSettleRecord, view.picData, false)
      self:OnRenderTexture(width, height, callBack)
    end)
  end, function()
    self:SetSeasonPhotoUploadFail()
  end)
end

function SeasonPhotoManager:RequestStartUploadSeasonPhoto()
  local uploadPicVer = toInt(LuaEntry.GlobalData.lastestPicVer_ChatPhoto)
  if uploadPicVer <= 0 then
    UIUtil.ShowTipsId("avatar_tips006")
    return
  end
  local renderTexture = self.shotParam and self.shotParam.renderTexture
  if not self.saveParam or not renderTexture then
    self:SetSeasonPhotoUploadFail()
    return
  end
  local photoName = "88888888"
  CS.UploadImageManager.Instance:StartUploadPhoto_SeasonAlliance(LuaEntry.Player.uid, uploadPicVer, renderTexture, photoName, CSharpCallLuaInterface.FinishedUploadPhotoSeasonAlliance)
  LuaEntry.GlobalData.lastestPicVer_ChatPhoto = -1
  self:ReleaseTexture(true)
end

function SeasonPhotoManager:FinishedUploadPhotoSeasonAlliance(ret, resData, uploadPicVer)
  if ret ~= "true" then
    UIUtil.ShowTipsId("avatar_tips010")
    Logger.LogInfo("\228\184\138\228\188\160\232\182\133\230\151\182 7 ret:" .. tostring(ret) .. " resData:" .. tostring(resData))
    self:SetSeasonPhotoUploadFail()
    return
  end
  local serverMsg = rapidjson.decode(resData)
  if serverMsg == nil then
    Logger.LogError("#SeasonAlliancePhoto#  Lua:\228\184\138\228\188\160\230\136\144\229\138\159\229\144\142resData\230\149\176\230\141\174\228\184\186\231\169\186\239\188\129")
    self:SetSeasonPhotoUploadFail()
    return
  end
  if not serverMsg.status then
    UIUtil.ShowTipsId("avatar_tips010")
    Logger.LogInfo("\228\184\138\228\188\160\232\182\133\230\151\182 8 ret:" .. tostring(ret) .. " resData:" .. tostring(resData))
    self:SetSeasonPhotoUploadFail()
    return
  end
  if serverMsg.code then
    local code = tonumber(serverMsg.code)
    if code == 0 then
      if uploadPicVer and uploadPicVer ~= -1 then
        self:SetSeasonPhotoUploadSuccess(string.format("%s;%s", LuaEntry.Player.uid, uploadPicVer))
      end
    elseif code == 1 then
      UIUtil.ShowTipsId("avatar_tips009")
      self:SetSeasonPhotoUploadFail()
    else
      Logger.LogError("#SeasonAlliancePhoto#  \228\184\138\228\188\160\231\187\147\230\158\156\231\154\132Code\229\188\130\229\184\184:" .. code)
    end
  end
end

function SeasonPhotoManager:OnUploadImage(picUid)
  if not self.saveParam then
    return
  end
  if picUid then
    self.saveParam.picData.picUrl = picUid
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonPhotoApplyPicver, self.saveParam)
end

function SeasonPhotoManager:SeasonPhotoApplyPicverMessage(applyVer, season, allianceId)
  if not self.saveParam or season ~= self.saveParam.targetSeason or allianceId ~= self.saveParam.targetAllianceId then
    return
  end
  if not applyVer then
    self:SaveFailure()
    return
  end
  local param = {}
  param.curVer = self.saveParam.curVer
  param.nextVer = applyVer
  param.targetSeason = season
  param.targetAllianceId = allianceId
  param.moveMemberArr = self.saveParam.moveMemberArr
  param.addMemberArr = self.saveParam.addMemberArr
  param.picData = self.saveParam.picData
  SFSNetwork.SendMessage(MsgDefines.SeasonPhotoSavePic, param)
end

function SeasonPhotoManager:SeasonPhotoSavePicMessage(nextVer, userRecordInfo)
  if not self.saveParam or self.saveParam.targetSeason ~= userRecordInfo.season or self.saveParam.targetAllianceId ~= userRecordInfo.allianceId then
    return
  end
  if not nextVer then
    self:SaveFailure()
    return
  end
  self.saveParam = nil
  UIUtil.ShowTipsId("season_alliance_photo_tips_8")
  self:RequestSeasonPhotoOneView(userRecordInfo.season, userRecordInfo.allianceId)
  local photoInfo = self:GetSeasonPhotoData(userRecordInfo.season, userRecordInfo.allianceId)
  if photoInfo then
    photoInfo.picVer = nextVer
    EventManager:GetInstance():Broadcast(EventId.SeasonPhotoSavePicSuccess, photoInfo)
  end
  SFSNetwork.SendMessage(MsgDefines.ViewSeasonPhotoTasklist, self.activityId)
end

function SeasonPhotoManager:SetSeasonPhotoUploading()
  EventManager:GetInstance():Broadcast(EventId.ScreenLoadingUI, "season_alliance_photo_tips_9")
end

function SeasonPhotoManager:SetSeasonPhotoUploadSuccess(picUid)
  EventManager:GetInstance():Broadcast(EventId.ScreenLoadingUI)
  self:OnUploadImage(picUid)
end

function SeasonPhotoManager:SetSeasonPhotoUploadFail()
  self:SaveFailure()
  self:ReleaseTexture(true)
  EventManager:GetInstance():Broadcast(EventId.ScreenLoadingUI)
end

function SeasonPhotoManager:SaveFailure()
  if self.saveParam then
    UIUtil.ShowTipsId("season_alliance_photo_tips_6")
    self:RequestSeasonPhotoOneView(self.saveParam.targetSeason, self.saveParam.targetAllianceId)
    self.saveParam = nil
  end
end

function SeasonPhotoManager:OnRenderTexture(width, height, callback)
  local camera = self.shotParam and self.shotParam.camera
  if not camera then
    self:SetSeasonPhotoUploadFail()
    return
  end
  width = width or 512
  height = height or 512
  local rt = self.shotParam.renderTexture
  if rt and (rt.width ~= width or rt.height ~= height) then
    self:ReleaseTexture()
    rt = nil
  end
  if not rt then
    rt = CS.UnityEngine.RenderTexture.GetTemporary(width, height, 24, CS.UnityEngine.RenderTextureFormat.ARGB32)
    self.shotParam.renderTexture = rt
  end
  camera.targetTexture = rt
  camera.gameObject:SetActive(true)
  TimerManager:GetInstance():DelayInvoke(function()
    if callback then
      callback(self.shotParam)
    end
  end, 0.5)
end

function SeasonPhotoManager:ReleaseTexture(delete)
  if not self.shotParam then
    return
  end
  if self.shotParam.renderTexture ~= nil then
    CS.UnityEngine.RenderTexture.ReleaseTemporary(self.shotParam.renderTexture)
    self.shotParam.renderTexture = nil
  end
  if self.shotParam.camera ~= nil then
    self.shotParam.camera.targetTexture = nil
  end
  if delete then
    if self.shotParam.view then
      self.shotParam.view:RemoveComponents(SeasonPhotoCanva)
    end
    if self.shotParam.prefab then
      self.shotParam.prefab:Destroy()
      self.shotParam.prefab = nil
    end
    self.shotParam = nil
  end
end

function SeasonPhotoManager:GetRedDotCount()
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    local tipNum = self.hasView and 0 or 1
    return self.rewardRed + tipNum, self.rewardRed, tipNum
  end
  local nodeTask = DataCenter.RedPointManager:GetChild({
    RedDef.Season,
    tostring(self.activityId),
    RedDef.SeasonPhotoTask
  })
  local nodeView = DataCenter.RedPointManager:GetChild({
    RedDef.Season,
    tostring(self.activityId),
    RedDef.SeasonPhotoView
  })
  local countTask = nodeTask and nodeTask:GetCount() or 0
  local countView = nodeView and nodeView:GetCount() or 0
  return countTask + countView, countTask, countView
end

function SeasonPhotoManager:UpdateReward(photoTaskInfo)
  if photoTaskInfo then
    if self.taskList then
      for i, v in ipairs(self.taskList) do
        if v.taskId == photoTaskInfo.taskId then
          self.taskList[i] = photoTaskInfo
          break
        end
      end
    else
      self.taskList = {photoTaskInfo}
    end
  end
  self:UpdateRewardRed()
  if photoTaskInfo then
    EventManager:GetInstance():Broadcast(EventId.SeasonPhotoTaskUpdate, photoTaskInfo)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function SeasonPhotoManager:UpdateRewardList(photoTaskList)
  if photoTaskList then
    if not self.taskList then
      self.taskList = {}
      for i, v in ipairs(photoTaskList) do
        self.taskList[i] = v
      end
    else
      for i, v in ipairs(photoTaskList) do
        for j, k in ipairs(self.taskList) do
          if v.taskId == k.taskId then
            self.taskList[j] = v
            break
          end
        end
      end
    end
  end
  self:UpdateRewardRed()
  if photoTaskList then
    for i, v in ipairs(photoTaskList) do
      EventManager:GetInstance():Broadcast(EventId.SeasonPhotoTaskUpdate, v)
    end
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function SeasonPhotoManager:UpdateRewardRed()
  self.rewardRed = 0
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  if self.taskList then
    for i, v in ipairs(self.taskList) do
      if v.state == TaskState.CanReceive then
        self.rewardRed = self.rewardRed + 1
      end
    end
  end
end

function SeasonPhotoManager:UpdateActiveView(updateIt)
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    if updateIt then
      EventManager:GetInstance():Broadcast(EventId.SeasonPhotoViewOpen, self.activityId)
    end
    return
  end
  local viewCount = UIUtil.GetActiveCount(DataCenter.SeasonDataManager:GetSeasonStartTime(), "PhotoSeason" .. (self.activityId or "-"), updateIt == true)
  local hasView = 0 < viewCount or updateIt
  if hasView ~= self.hasView then
    self.hasView = hasView
    if updateIt then
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
end

function SeasonPhotoManager:GetChangeList(photoInfo, editPicData)
  if not editPicData or editPicData == photoInfo.picData then
    return
  end
  local changeList, addList = {}, {}
  local newPlayerArr = editPicData.playerArr or {}
  local oldPlayerDic = photoInfo.playerDic or {}
  local addIndex, changeIndex, oldPlayer = 1, 1
  for i, v in ipairs(newPlayerArr) do
    oldPlayer = oldPlayerDic[v.uid]
    if not oldPlayer then
      addList[addIndex] = v.uid
      addIndex = addIndex + 1
    elseif oldPlayer.posX ~= v.posX or oldPlayer.posY ~= v.posY or v.pic ~= oldPlayer.pic or v.picVer ~= oldPlayer.picVer then
      changeList[changeIndex] = v.uid
      changeIndex = changeIndex + 1
    end
  end
  return changeList, addList
end

return SeasonPhotoManager
