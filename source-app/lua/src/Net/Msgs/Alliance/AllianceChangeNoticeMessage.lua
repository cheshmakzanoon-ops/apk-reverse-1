local AllianceChangeNoticeMessage = BaseClass("AllianceChangeNoticeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param.noticeType == ChatNoticeType.ALLIANCE_VOTE then
    if param ~= nil then
      local noticeObj = SFSObject.New()
      if param.title ~= nil then
        noticeObj:PutUtfString("title", param.title)
      end
      if param.options then
        local optionArray = SFSArray.New()
        table.walk(param.options, function(k, v)
          local obj = SFSObject.New()
          obj:PutUtfString("itemId", tostring(v.itemId))
          obj:PutUtfString("item", v.item)
          optionArray:AddSFSObject(obj)
        end)
        noticeObj:PutSFSArray("options", optionArray)
      end
      self.sfsObj:PutInt("noticeType", param.noticeType)
      if param.type then
        noticeObj:PutInt("type", param.type)
      end
      if param.isCryptonym then
        noticeObj:PutBool("isCryptonym", param.isCryptonym)
      end
      if param.timeType then
        self.sfsObj:PutInt("timeType", param.timeType)
      end
      if param.timeHour then
        self.sfsObj:PutInt("timeHour", param.timeHour)
      end
      if param.endTime then
        self.sfsObj:PutLong("endTime", param.endTime)
      end
      if param.isR4R5 then
        self.sfsObj:PutInt("isR4R5", param.isR4R5)
      end
      self.sfsObj:PutSFSObject("notice", noticeObj)
    end
  else
    self.sfsObj:PutUtfString("notice", param.notice)
    self.sfsObj:PutInt("isAdv", param.isAdv)
    if param.uid then
      self.sfsObj:PutUtfString("uuid", tostring(param.uid))
    end
    if param.edited then
      self.sfsObj:PutInt("edited", param.edited)
    end
    if param.isR4R5 then
      self.sfsObj:PutInt("isR4R5", param.isR4R5)
    end
    if param.smallHeight then
      self.sfsObj:PutInt("smallHeight", param.smallHeight)
    end
    if param.smallWidth then
      self.sfsObj:PutInt("smallWidth", param.smallWidth)
    end
    if param.bigHeight then
      self.sfsObj:PutInt("bigHeight", param.bigHeight)
    end
    if param.bigWidth then
      self.sfsObj:PutInt("bigWidth", param.bigWidth)
    end
    if param.noticePicVer then
      self.sfsObj:PutInt("noticePicVer", param.noticePicVer)
    end
    if param.picSenderUid then
      self.sfsObj:PutUtfString("picSenderUid", param.picSenderUid)
    end
    if param.extraJson then
      self.sfsObj:PutUtfString("extraJson", param.extraJson)
    end
    if param.picJson then
      self.sfsObj:PutUtfString("picJson", param.picJson)
    end
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(t)
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.AllianceChangeNotice)
  else
    if t.clientReq and t.clientReq.edited == 1 then
      UIUtil.ShowTipsId("alliancenotice_edit_tips1")
    else
      UIUtil.ShowTipsId(390197)
    end
    DataCenter.AllianceNoticeManager:UpdateAllianceFirstNoticeData(t)
    UIManager.Instance:DestroyWindow(UIWindowNames.LWUIPublishPoll)
    EventManager:GetInstance():Broadcast(EventId.AlNoticeChangeMsgBackSuccess, t)
  end
end

AllianceChangeNoticeMessage.OnCreate = OnCreate
AllianceChangeNoticeMessage.HandleMessage = HandleMessage
return AllianceChangeNoticeMessage
