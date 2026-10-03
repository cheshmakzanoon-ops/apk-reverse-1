local go_bg_path = "GoBg"
local u_i_player_head_path = "UIPlayerHead"
local star_path = "star"
local desc_path = "DescRoot/Desc"
local target_path = "DescRoot/Target"
local reward_content_path = "RewardScrollView/Viewport/RewardContent"
local title_path = "Btns/Title"
local color_bg_path = "Btns/Title/ColorBg"
local star_list_path = "Btns/Title/starList"
local time_path = "Btns/time"
local cd_text_path = "Btns/time/cdText"
local receive_btn_path = "Btns/ReceiveBtn"
local p_btn_thumb_path = "p_btn_thumb"
local p_icon_thumb_path = "p_btn_thumb/p_icon_thumb"
local base = UIBaseContainer
local DispatchTaskMarkItem = BaseClass("DispatchTaskMarkItem", UIBaseContainer)

function DispatchTaskMarkItem:ComponentDefine()
  self.go_bg = self:AddComponent(UIButton, go_bg_path)
  self.go_bg:SetOnClick(BindCallback(self, self.OnGotoClicked))
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.star = self:AddComponent(UIImage, star_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.target = self:AddComponent(UITextMeshProUGUIEx, target_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.title = self:AddComponent(UIBaseContainer, title_path)
  self.color_bg = self:AddComponent(UIImage, color_bg_path)
  self.star_list = self:AddComponent(UIBaseContainer, star_list_path)
  self.time = self:AddComponent(UIBaseContainer, time_path)
  self.cd_text = self:AddComponent(UITextMeshProUGUIEx, cd_text_path)
  self.receive_btn = self:AddComponent(UIButton, receive_btn_path)
  self.receive_btn:SetOnClick(BindCallback(self, self.OnClaimClicked))
  self.p_btn_thumb = self:AddComponent(UIButton, p_btn_thumb_path)
  self.p_btn_thumb:SetOnClick(BindCallback(self, self.OnThumbClicked))
  self.p_icon_thumb = self:AddComponent(UIImage, p_icon_thumb_path)
  self.starImgList = {}
  for i = 1, 5 do
    local starImg = self:AddComponent(UIImage, "Btns/Title/starList/star" .. i)
    table.insert(self.starImgList, starImg)
  end
end

function DispatchTaskMarkItem:ComponentDestroy()
  self.go_bg = nil
  self.u_i_player_head = nil
  self.star = nil
  self.desc = nil
  self.target = nil
  self.reward_content = nil
  self.title = nil
  self.color_bg = nil
  self.star_list = nil
  self.time = nil
  self.cd_text = nil
  self.receive_btn = nil
  self.p_btn_thumb = nil
  self.p_icon_thumb = nil
  self.starImgList = nil
end

function DispatchTaskMarkItem:DataDefine()
end

function DispatchTaskMarkItem:DataDestroy()
end

function DispatchTaskMarkItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DispatchTaskMarkItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DispatchTaskMarkItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DispatchTaskThumbsUp, self.OnThumbsUpCallback)
end

function DispatchTaskMarkItem:OnRemoveListener()
  self:RemoveUIListener(EventId.DispatchTaskThumbsUp, self.OnThumbsUpCallback)
  base.OnRemoveListener(self)
end

function DispatchTaskMarkItem:SetData(data, tab)
  self:ReInit(data)
end

function DispatchTaskMarkItem:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
      self:Update1000MS()
    end
  end
end

function DispatchTaskMarkItem:InitData(data)
  if data ~= nil then
    self.Data = DataCenter.ActDispatchTaskDataManager:GetOneMark(data:GetUuid())
    if self.Data ~= nil and self.Data:Valid() then
      self.ConfigCell = self.Data.Cell
      self.IconThumbNormal = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/zyf_xitongtongzhi_dianzan.png"
      self.IconThumbGray = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_xinwen_dianzan_anniu.png"
      return true
    end
  end
  return false
end

function DispatchTaskMarkItem:InitUi()
  local shareUserInfo = self.Data:GetShareUserInfo()
  if shareUserInfo ~= nil then
    self.u_i_player_head:SetHead(shareUserInfo.uid, shareUserInfo.pic, shareUserInfo.picver, nil, nil)
    self.u_i_player_head:SetEnableClickShowInfo(true, true)
  end
  local shareColor
  if shareUserInfo ~= nil and shareUserInfo.uid == LuaEntry.Player.uid then
    shareColor = "#099b4a"
  end
  local shareName = self:GetPlayerName(shareUserInfo, false, false, shareColor)
  local ownerName = ""
  local ownerUserInfo = self.Data:GetMissionOwnerUserInfo()
  if ownerUserInfo ~= nil then
    ownerName = self:GetPlayerName(ownerUserInfo, true, true)
  end
  self.desc:SetLocalText("dispatch_quick_mark_desc_limit_5", shareName)
  self.target:SetLocalText("dispatch_quick_mark_desc_limit_8", ownerName)
  self.star:SetActive(self.ConfigCell.is_special == 1)
  local quality_icon = QualityImagePath[self.ConfigCell.color]
  self.color_bg:LoadSprite(quality_icon)
  self.color_bg:SetNativeSize()
  local sprites = DataCenter.ActDispatchTaskDataManager:GetStarSprites(self.ConfigCell.task_star)
  for i, starImg in ipairs(self.starImgList) do
    local sprite = sprites[i]
    if sprite == nil then
      starImg:SetActive(false)
    else
      starImg:LoadSprite(string.format(LoadPath.LWCommonPath, sprite))
      starImg:SetActive(true)
    end
  end
  self:ClearList()
  local rewards = DataCenter.RewardManager:ReturnRewardParamForMessage(self.Data:GetRewards())
  if not table.IsNullOrEmpty(rewards) then
    self.Reqs = {}
    local prefabPath = "Assets/Main/Prefabs/UI/LWQuest/ChapterTaskRewardItem.prefab"
    for _, reward in pairs(rewards) do
      local transRoot = self.reward_content
      local req = self:GameObjectInstantiateAsync(prefabPath, function(req)
        local go = req.gameObject
        local transform = go.transform
        go.name = UIUtil.GetLoopListItemIndex("cell_")
        go.transform:GetChild(0).gameObject.name = "obj" .. go.name
        go.transform:GetChild(0).gameObject:SetActive(true)
        transform:SetParent(transRoot.transform)
        transform:Set_localScale(1, 1, 1)
        transform:Set_localPosition(0, 0, 0)
        local comp = transRoot:AddComponent(UICommonResItem, go.name .. "/obj" .. go.name)
        local cellData = {
          rewardType = reward.rewardType,
          itemId = checkstring(reward.itemId),
          count = checknumber(reward.count)
        }
        comp:ReInit(cellData)
        go:SetActive(true)
      end)
      table.insert(self.Reqs, req)
    end
  end
end

function DispatchTaskMarkItem:ClearList()
  self.reward_content:RemoveComponents(UICommonResItem)
  if table.count(self.Reqs) > 0 then
    for _, req in pairs(self.Reqs) do
      if req ~= nil then
        self:GameObjectDestroy(req)
      end
    end
    self.Reqs = nil
  end
end

function DispatchTaskMarkItem:GetPlayerName(userInfo, withAbbr, withZone, color)
  if table.IsNullOrEmpty(userInfo) then
    return ""
  end
  local name = userInfo.name
  if withAbbr and not string.IsNullOrEmpty(userInfo.abbr) then
    name = "[" .. userInfo.abbr .. "] " .. name
  end
  if withZone and checknumber(userInfo.srcServer) > 0 then
    name = "#" .. userInfo.srcServer .. name .. " "
  end
  if not string.IsNullOrEmpty(color) then
    name = "<color=" .. color .. ">" .. name .. "</color>"
  end
  return name
end

function DispatchTaskMarkItem:UpdateData()
  if self.Data ~= nil then
    self.Data = DataCenter.ActDispatchTaskDataManager:GetOneMark(self.Data:GetUuid())
    if self.Data ~= nil and self.Data:Valid() then
      self.HasThumbs = self.Data:HasThumbsUp()
      return true
    end
  end
  return false
end

function DispatchTaskMarkItem:UpdateUi()
  self:UpdateThumb()
end

function DispatchTaskMarkItem:UpdateThumb()
  local fromMe = self.Data:FromMe()
  if not self.HasThumbs and not fromMe then
    self.p_icon_thumb:LoadSpriteAsync(self.IconThumbNormal)
  else
    self.p_icon_thumb:LoadSpriteAsync(self.IconThumbGray)
  end
end

function DispatchTaskMarkItem:OnGotoClicked()
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  self:TaskGotoWorld()
end

function DispatchTaskMarkItem:OnClaimClicked()
  local todayStealNum = DataCenter.ActDispatchTaskDataManager:GetTodayStealNum()
  local steal_count = DataCenter.ActDispatchTaskDataManager:GetDispatchSetting("steal_count")
  if todayStealNum < steal_count then
    if DataCenter.ActDispatchTaskDataManager:IsOpenCrossSteal() or not CrossServerUtil:NeedIntercept(500019) then
      SFSNetwork.SendMessage(MsgDefines.DispatchSteal, self.Data:GetMissionUuid(), self.Data:GetMissionServerId())
    end
  else
    UIUtil.ShowTipsId(456226)
  end
end

function DispatchTaskMarkItem:OnThumbClicked()
  if self.Data == nil then
    return
  end
  DataCenter.ActDispatchTaskDataManager:TryThumbsUpMark(self.Data:GetUuid())
end

function DispatchTaskMarkItem:TaskGotoWorld()
  if self.Data == nil or not self.Data:Valid() then
    return
  end
  local allianceTaskTargetServer = self.Data:GetMissionServerId()
  local isCrossServerSwitchOpen = DataCenter.ActDispatchTaskDataManager:IsCrossServerSwitchOpen()
  local pointId = self.Data:GetMissionPointId()
  if pointId and 0 < pointId then
    GoToUtil.CloseAllWindows()
    local targetServer
    if isCrossServerSwitchOpen then
      targetServer = allianceTaskTargetServer
    elseif LuaEntry.Player.crossFightSrcServerId ~= -1 then
      targetServer = LuaEntry.Player.crossFightSrcServerId
    end
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), nil, nil, function()
      CS.SceneManager.World:UpdateViewRequest(true)
      GoToUtil.MoveToWorldPointAndOpen(pointId, nil, nil, targetServer)
    end, targetServer)
  end
end

function DispatchTaskMarkItem:UpdateTime()
  if self.Data ~= nil then
    local leftTime = self.Data:TimeToClaim()
    self.receive_btn:SetActive(leftTime < 0)
    self.time:SetActive(0 <= leftTime)
    if 0 <= leftTime then
      self.cd_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
    end
  end
end

function DispatchTaskMarkItem:Update1000MS()
  if self.Data ~= nil then
    self:UpdateTime()
  end
end

function DispatchTaskMarkItem:OnThumbsUpCallback(markData)
  if markData == nil or not markData:Valid() then
    return
  end
  if self:UpdateData() then
    self:UpdateUi()
  end
end

return DispatchTaskMarkItem
