local ItemUseMessage = BaseClass("ItemUseMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local CS = _ENV.CS
local _useBtnPos

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uuid", param.uuid)
  self.sfsObj:PutInt("num", param.num)
  if param.para1 ~= nil and param.para1 ~= "" then
    self.sfsObj:PutUtfString("para1", param.para1)
  end
  if param.heroId ~= nil and param.heroId ~= "" then
    self.sfsObj:PutInt("heroId", param.heroId)
  end
  if param.prtUid ~= nil and param.prtUid ~= "" then
    self.sfsObj:PutUtfString("prtUid", param.prtUid)
  end
  if param.commentText ~= nil and param.commentText ~= "" then
    self.sfsObj:PutUtfString("commentText", param.commentText)
  end
  if param.style ~= nil and param.style ~= 0 then
    self.sfsObj:PutInt("style", param.style)
  end
  if param.pointId ~= nil and 0 < param.pointId then
    self.sfsObj:PutInt("pointId", param.pointId)
  end
  if param.useItemFromType ~= nil and 0 < param.useItemFromType then
    self.sfsObj:PutInt("useItemFromType", param.useItemFromType)
  end
  if param.chatType then
    self.sfsObj:PutInt("chatType", param.chatType)
  end
  if param.copy ~= nil then
    self.sfsObj:PutBool("copy", param.copy)
  end
  if param.copyChatType ~= nil then
    self.sfsObj:PutInt("copyChatType", param.copyChatType)
  end
  if param.speak ~= nil then
    self.sfsObj:PutUtfString("speak", param.speak)
  end
  if param.cost ~= nil then
    self.sfsObj:PutInt("cost", param.cost)
  end
  if param.version ~= nil then
    self.sfsObj:PutUtfString("version", param.version)
  end
  if param.latencies ~= nil then
    self.sfsObj:PutUtfString("latencies", param.latencies)
  end
  if param.useBtnPos ~= nil then
    _useBtnPos = param.useBtnPos
  else
    _useBtnPos = nil
  end
  if param.continueUse ~= nil and param.continueUse then
    self.sfsObj:PutBool("continueUse", param.continueUse)
  end
  if param.opType then
    self.sfsObj:PutInt("opType", param.opType)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ItemManager:ItemUseHandle(t)
  if t.errorCode == nil then
    if t.itemEffectObj ~= nil and t.itemEffectObj.accPoint then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(t.itemEffectObj.accPoint, _useBtnPos)
    end
    if t.itemEffectObj ~= nil then
      if t.itemEffectObj.fireWorksList then
        local targetUid = t.itemEffectObj.prtUid
        local fireWorksList = PBController.ParsePbFromBytes(t.itemEffectObj.fireWorksList, "protobuf.FireWorksInfoList")
        DataCenter.LWFireworkManager:RecordQueueFireBySelf()
        DataCenter.LWFireworkManager:UpdateFireworkQueueByUserUid(targetUid, fireWorksList.list)
        EventManager:GetInstance():Broadcast(EventId.FireworkSelfUseItemUpdateBubble)
        if DataCenter.LWFireworkManager:IsInQuickMode() then
          local m = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(targetUid)
          local name = m and m.name or ""
          local showName = m and DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(targetUid, m.name) or name
          local queueCount = DataCenter.LWFireworkManager:GetQueueCountByUid(targetUid)
          if queueCount == 1 then
            UIUtil.ShowTips(Localization:GetString("firework_tips_1008", showName))
          end
        end
      end
      if t.itemEffectObj.fishArr then
        DataCenter.FishingDataManager:HandleUseItem(t.itemEffectObj)
      end
    end
    if t.itemEffectObj and t.itemEffectObj.redPackets then
      DataCenter.RedPacketManager:UpdateRedPacket(t.itemEffectObj)
    end
    local itemId = t.itemId
    local item = DataCenter.ItemData:GetItemById(itemId)
    if item ~= nil then
      EventManager:GetInstance():Broadcast(EventId.CLICK_RESOURCE_ITEM)
    else
      EventManager:GetInstance():Broadcast(EventId.REFRESH_RESOURCE_BAG)
    end
  end
end

ItemUseMessage.OnCreate = OnCreate
ItemUseMessage.HandleMessage = HandleMessage
return ItemUseMessage
