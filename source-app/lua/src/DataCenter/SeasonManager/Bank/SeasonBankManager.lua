local SeasonBankManager = BaseClass("SeasonBankManager")
local Localization = CS.GameEntry.Localization

function SeasonBankManager:__init()
  self.curServerBankData = {}
  self.selfDepositData = nil
  self.depositBanksDic = nil
  self:RqUserDepositBank()
  self:AddListener()
end

function SeasonBankManager:__delete()
  self:RemoveListener()
end

function SeasonBankManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterWorld, self.RqUserDepositBank, self)
end

function SeasonBankManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorld, self.RqUserDepositBank, self)
end

function SeasonBankManager:InitData(data)
end

function SeasonBankManager:IsCurOpen(anyMode)
  return SeasonUtil.GetCurWorldSeasonType(anyMode, true) == SeasonMapType.NineNation
end

function SeasonBankManager:CanRob(robInfo)
  if not robInfo or robInfo.robStage ~= 1 then
    return false
  end
  return robInfo.robEndTime and UITimeManager:GetInstance():GetServerTime() < robInfo.robEndTime
end

function SeasonBankManager:BankActive(bankInfo)
  if not bankInfo or table.IsNullOrEmpty(bankInfo.bankRobInfo) then
    return false
  end
  return self:IsCurOpen()
end

function SeasonBankManager:CanDepositByScope(serviceScope, serverId, allianceId, showTips)
  if string.IsNullOrEmpty(allianceId) then
    if showTips then
      UIUtil.ShowTipsId("s5_bank_tips08")
    end
    return false
  end
  if serviceScope == 0 and allianceId ~= LuaEntry.Player.allianceId then
    if showTips then
      UIUtil.ShowTipsId("s5_bank_tips12")
    end
    return false
  end
  if serviceScope == 1 and serverId ~= LuaEntry.Player:GetSourceServerId() then
    if showTips then
      UIUtil.ShowTipsId("s5_bank_tips13")
    end
    return false
  end
  return true
end

function SeasonBankManager:HasDepositInBank(cityId)
  if table.IsNullOrEmpty(self.depositBanksDic) then
    return false
  end
  return self.depositBanksDic[cityId] ~= nil
end

function SeasonBankManager:GetDepositIcon(isDeposit)
  if isDeposit then
    return "Assets/Main/SeasonRes/S5/Sprites/Bank/zxl_cundan_tubiao_ziji.png"
  else
    return "Assets/Main/SeasonRes/S5/Sprites/Bank/zxl_cundan_tubiao.png"
  end
end

function SeasonBankManager:CheckDepositCondition(cityId, serverId, showTips)
  local detail = DataCenter.WorldPointDetailManager:GetAllianceCityData(cityId)
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
  local bankDetail = detail and detail.bankDetail
  if not bankDetail or not cityTemplate then
    return true
  end
  if bankDetail.depositCount >= cityTemplate.max_player then
    if showTips then
      UIUtil.ShowTipsId("s5_bank_tips09")
    end
    return false
  end
  if bankDetail.totalAmount >= cityTemplate.max_asset then
    if showTips then
      UIUtil.ShowTipsId("s5_bank_tips10")
    end
    return false
  end
  local userBankInfo = detail.userBankInfo
  local depositCount = userBankInfo and userBankInfo.depositCount or 0
  local maxDepositCount = LuaEntry.DataConfig:TryGetNum("s5_bank_config", "k1", 3)
  if depositCount >= maxDepositCount then
    if showTips then
      UIUtil.ShowTipsId("s5_bank_tips11")
    end
    return false
  end
  return true
end

function SeasonBankManager:GetSettleAmount(depositAmount, rate)
  local curValue = depositAmount * rate
  curValue = curValue - curValue % 0.001
  return math.ceil(curValue)
end

function SeasonBankManager:LoadItemIcon(iconObj, cityMeta, itemId)
  itemId = itemId or cityMeta and cityMeta.asset or 0
  local itemConf = DataCenter.ItemTemplateManager:GetItemSkin(itemId, SeasonUtil.GetCurWorldSeasonId(true))
  if not itemConf or string.IsNullOrEmpty(itemConf.icon) then
    itemConf = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  end
  if itemConf then
    iconObj:LoadSpriteAsync(string.format(LoadPath.ItemPath, itemConf.icon))
  end
end

function SeasonBankManager:LoadServiceScopeIcon(iconObj, serviceScope)
  local iconPath = ""
  if serviceScope == 0 then
    iconPath = "Assets/Main/SeasonRes/S5/Sprites/Bank/zxl_zhihuiguan_tongmeng.png"
  elseif serviceScope == 1 then
    iconPath = "Assets/Main/SeasonRes/S5/Sprites/Bank/zxl_zhihuiguan_tongzhanqu.png"
  else
    iconPath = "Assets/Main/SeasonRes/S5/Sprites/Bank/zxl_zhihuiguan_suoyou.png"
  end
  iconObj:LoadSprite(iconPath)
  iconObj:SetNativeSize()
end

function SeasonBankManager:ShowItemTips(iconObj, cityMeta, itemId)
  itemId = itemId or cityMeta and cityMeta.asset or 0
  local itemConf = DataCenter.ItemTemplateManager:GetItemSkin(itemId, SeasonUtil.GetCurWorldSeasonId(true))
  if not itemConf or string.IsNullOrEmpty(itemConf.name) then
    itemConf = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  end
  if not itemConf then
    return
  end
  local param = {}
  param.itemName = Localization:GetString(itemConf.name)
  param.itemDesc = Localization:GetString(itemConf.description)
  param.alignObject = iconObj
  param.isLocal = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function SeasonBankManager:RqUserDepositBank()
  if not (not self.selfDepositData and self:IsCurOpen()) or not SeasonUtil.IsInSeasonNineNationMode() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.LwRqUserDepositBank)
end

function SeasonBankManager:ShowBankPopText(pos, text, iconPath, sender, offsetY_)
  local UI_BUBBLE_PATH = "Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/Group/BankPopTextMessageTip.prefab"
  local bubbleHandle = CS.GameEntry.Resource:InstantiateAsync(UI_BUBBLE_PATH)
  bubbleHandle:completed("+", function(req)
    if req.isError then
      return
    end
    if not CS.SceneManager.World then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local animRoot = go.transform:Find("bg")
    local txt = go.transform:Find("bg/txt")
    local headIcon = go.transform:Find("bg/headIcon")
    local unity_txt = txt.gameObject:GetComponent(typeof(CS.SuperTextMesh))
    if not unity_txt then
      req:Destroy()
      return
    end
    go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    if offsetY_ then
      pos.y = pos.y + offsetY_
    end
    go.transform.position = pos
    go.transform:Set_localScale(1, 1, 1)
    go:SetActive(true)
    unity_txt.text = text
    if headIcon and animRoot then
      local anim = go:GetComponent(typeof(CS.SimpleAnimation))
      local unity_icon = headIcon.gameObject:GetComponent(typeof(CS.UIPlayerHead))
      if unity_icon and anim then
        local specifiedRes
        local pic = sender and sender.headPic or sender.pic
        local picVer = sender and sender.headPicVer or sender.picVer or sender.picver or 0
        if pic and pic ~= "" and type(pic) == "string" then
          local pic1, pic2 = string.match(pic, "(Assets/Main/.*)(Assets/Main/.*)")
          if pic1 and pic2 then
            specifiedRes = pic2
          end
        end
        if specifiedRes then
          unity_icon:UseSpecifiedRes(specifiedRes)
        elseif not pic and not picVer then
          unity_icon:UseSystemHead()
        else
          unity_icon:SetData(sender.uid, pic, toInt(picVer), false)
        end
        animRoot.gameObject:SetActive(true)
        if anim:IsPlaying("Default") then
          anim:Rewind("Default")
        else
          anim:Play("Default")
        end
      end
    end
    if not string.IsNullOrEmpty(iconPath) then
      local icon = go.transform:Find("bg/icon")
      local unity_icon = icon and icon.gameObject:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      if unity_icon then
        unity_icon:LoadSprite(iconPath)
      end
    end
    TimerManager:GetInstance():DelayInvoke(function()
      if req ~= nil then
        req:Destroy()
      end
    end, 3)
  end)
end

function SeasonBankManager:GetDetailTestData(detail, info)
  if detail and not detail.bankDetail then
    if not info then
      local pointInfo = CS.SceneManager.World:GetPointInfo(detail.pointId)
      info = pointInfo and SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo)
    end
    detail.bankDetail = {
      isFirst = true,
      robStage = info and info.bankRobInfo.robStage,
      robEndTime = info and info.bankRobInfo.robEndTime,
      totalAmount = info and info.bankRobInfo.totalAmount,
      robAmount = info and info.bankRobInfo.robAmount,
      setting = {
        lastSetTime = UITimeManager:GetInstance():GetServerTime() - 1000000000,
        lastSetUid = "123456789",
        lastSetUserName = "PlayerName111",
        serviceScope = math.random(0, 2),
        minDepositAmount = 1000
      },
      depositCount = math.random(0, 50),
      depositUsers = {}
    }
    for i = 1, detail.bankDetail.depositCount do
      local member = DataCenter.AllianceMemberDataManager:GetRandomMember()
      table.insert(detail.bankDetail.depositUsers, member)
    end
  end
end

return SeasonBankManager
