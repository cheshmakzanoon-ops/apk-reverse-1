local PushAlHelpUpdateMessage = BaseClass("PushAlHelpUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local DataCenter = _ENV.DataCenter
local AllianceHelpDataManager = DataCenter.AllianceHelpDataManager

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.senderId ~= nil and t.senderId ~= "" then
    local sender = t.senderId
    local type = t.helpType
    local freeType = t.queueType
    if sender == LuaEntry.Player.uid then
      if t.updateTime ~= nil then
        local uuid = t.queueId
        local startT = t.startTime
        local finishTime = t.updateTime
        if type == AllianceHelpType.Queue then
          DataCenter.QueueDataManager:AllianceHelpAddSpeed(uuid, finishTime, startT)
          EventManager:GetInstance():Broadcast(EventId.AddSpeedSuccess, freeType)
        elseif type == AllianceHelpType.Building then
          DataCenter.BuildManager:AllianceHelpAddSpeed(uuid, finishTime, startT)
          local signal = SFSObject.New()
          signal:PutLong("bUuid", uuid)
          signal:PutLong("startTime", startT)
          signal:PutLong("endTime", finishTime)
          EventManager:GetInstance():Broadcast(EventId.AddBuildSpeedSuccess, signal)
        elseif type == AllianceHelpType.FIX_BUILDING then
          DataCenter.BuildManager:AllianceHelpFixAddSpeed(uuid, finishTime, startT)
          local signal = SFSObject.New()
          signal:PutLong("bUuid", uuid)
          signal:PutLong("startTime", startT)
          signal:PutLong("endTime", finishTime)
          EventManager:GetInstance():Broadcast(EventId.AddBuildFixSpeedSuccess, signal)
        end
      end
      if t.helpName ~= nil then
        local playerHead
        if t.pic and t.uid then
          local headBg
          if t.headSkinId and t.headSkinET then
            headBg = self:GetHeadBgImg(t.headSkinId, t.headSkinET)
          end
          playerHead = {
            uid = t.uid,
            pic = t.pic,
            picVer = t.picVer,
            HeadBg = headBg
          }
        end
        local tempReduceSec = ""
        if t.reduceSec then
          local tempM = math.modf(t.reduceSec / 60)
          local tempS = math.floor(t.reduceSec % 60)
          if 0 < tempM then
            tempReduceSec = tempReduceSec .. tempM .. Localization:GetString("100165")
          end
          if 0 < tempS then
            tempReduceSec = tempReduceSec .. tempS .. Localization:GetString("372115")
          end
        end
        local showTime
        local helpName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(t.uid, t.helpName)
        if type == AllianceHelpType.Building then
          local itemId = t.itemId
          local level = t.level
          local building = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(CommonUtil.GetBuildBaseType(itemId))
          if building ~= nil then
            UIUtil.ShowTips(Localization:GetString("390122", helpName, level, Localization:GetString(building.name), "", tempReduceSec, t.nowCount, t.maxCount), nil, playerHead, nil, true)
            tempReduceSec = nil
          end
          DataCenter.BuildHelpNpcManager:AddHelpNpc(t.queueId, playerHead, t.helperSysName, helpName, tempReduceSec, nil, 3)
        elseif type == AllianceHelpType.FIX_BUILDING then
          local itemId = t.itemId
          local level = t.level
          local building = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(CommonUtil.GetBuildBaseType(itemId))
          if building ~= nil then
            local name = Localization:GetString(building.name) .. "(" .. Localization:GetString("104202") .. ")"
            UIUtil.ShowTips(Localization:GetString("390122", helpName, level, name, "", tempReduceSec, t.nowCount, t.maxCount), nil, playerHead, nil, true)
          end
        elseif type == AllianceHelpType.Queue then
          if freeType == NewQueueType.Science then
            local itemId = t.itemId
            local science = DataCenter.ScienceManager:GetScienceTemplate(tonumber(itemId))
            if science ~= nil then
              UIUtil.ShowTips(Localization:GetString("390121", helpName, Localization:GetString(science.name), tempReduceSec, t.nowCount, t.maxCount), nil, playerHead, nil, true)
            end
          elseif freeType == NewQueueType.Hospital then
            UIUtil.ShowTips(Localization:GetString("390879", helpName, tempReduceSec, t.nowCount, t.maxCount), showTime, playerHead, nil, true)
          elseif freeType == NewQueueType.RebirthHospital then
            UIUtil.ShowTips(Localization:GetString("emergency_center_desc_1011", helpName, tempReduceSec, t.nowCount, t.maxCount), showTime, playerHead, nil, true)
          end
        end
      end
    end
    AllianceHelpDataManager:RefreshAllianceHelp(t)
    AllianceHelpDataManager:UpdateHelpInfoList(t)
    EventManager:GetInstance():Broadcast(EventId.UpdateAllianceGiftNum)
    local nowCount = t.nowCount or 0
    local maxCount = t.maxCount or 0
    if nowCount >= maxCount then
      DataCenter.AllianceHelpDataManager:SetHelpNum(AllianceHelpDataManager:GetHelpNum() - 1)
    end
    local myAllianceCenterUuid = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER)
    if myAllianceCenterUuid then
      EventManager:GetInstance():Broadcast(EventId.AllianceMemberNeedHelp, myAllianceCenterUuid.uuid)
    end
  end
end

local function GetHeadBgImg(self, headSkinId, headSkinET)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(headSkinId, headSkinET)
  return headBgImg
end

PushAlHelpUpdateMessage.OnCreate = OnCreate
PushAlHelpUpdateMessage.HandleMessage = HandleMessage
PushAlHelpUpdateMessage.GetHeadBgImg = GetHeadBgImg
return PushAlHelpUpdateMessage
