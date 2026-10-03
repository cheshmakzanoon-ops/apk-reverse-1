local base = UIBaseView
local UILWAlAssemblyInfoView = BaseClass("UILWAlAssemblyInfoView", base)
local Localization = CS.GameEntry.Localization
local UILWAlAssemblyInfoRallyPanel = require("UI.UILWAlliance.UILWAlAssemblyInfo.Component.UILWAlAssemblyInfoRallyPanel")
local panelBtn_path = "panel"
local titleText_path = "PopUpContent/Common_bg_orange/TitleText"
local closeBtn_path = "PopUpContent/Common_bg_orange/CloseBtn"
local bgRawImage_path = "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/BgRawImage"
local conveneContent_path = "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/ConveneContent"
local conveneBtn_path = "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/ConveneContent/ConveneBtn"
local conveneBtnText_path = "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/ConveneContent/ConveneBtn/ConveneBtnText"
local farawayMemberCountText_path = "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/ConveneContent/FarAwayMemberCountText"
local farawayBubbleTipsBtn_path = "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/ConveneContent/FarAwayBubbleTipsBtn"
local distanceStateContent_path = "PopUpContent/Common_bg_orange/WhiteBg/DistanceStateContent"
local distanceTipsText_path = "PopUpContent/Common_bg_orange/WhiteBg/DistanceStateContent/DistanceTipsText"
local moveContent_path = "PopUpContent/Common_bg_orange/WhiteBg/MoveContent"
local itemCountText_path = "PopUpContent/Common_bg_orange/WhiteBg/MoveContent/ItemCountText"
local moveBtn_path = "PopUpContent/Common_bg_orange/WhiteBg/MoveContent/MoveBtn"
local moveBtnText_path = "PopUpContent/Common_bg_orange/WhiteBg/MoveContent/MoveBtn/MoveBtnText"
local closeFarAwayBubbleBtn_path = "PopUpContent/CloseFarAwayBubbleBtn"
local farawayBubbleTipsText_path = "PopUpContent/CloseFarAwayBubbleBtn/content/FarAwayBubbleTipsText"
local moveBubbleTipsBtn_path = "PopUpContent/Common_bg_orange/WhiteBg/MoveContent/MoveBubbleContent/MoveBubbleTipsBtn"
local moveBubbleTipsText_path = "PopUpContent/Common_bg_orange/WhiteBg/MoveContent/MoveBubbleContent/MoveBubbleTipsBtn/MoveBubbleTipsText"
local moveBubbleContent_path = "PopUpContent/Common_bg_orange/WhiteBg/MoveContent/MoveBubbleContent"
local resItemObj_path = "PopUpContent/Common_bg_orange/WhiteBg/MoveContent/UICommonResItem"
local distanceShowContent_path = "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/DistanceShowContent"
local playerPosMark_path = "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/DistanceShowContent/PlayerPosMark"
local playerHeadObj_path = "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/DistanceShowContent/PlayerPosMark/UIPlayerHead"
local playerDistanceNumText_path = "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/DistanceShowContent/PlayerPosMark/PlayerDistanceNumText"
local conveneBtnRedPoint_path = "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/ConveneContent/ConveneBtn/ConveneBtnRedPoint"
local moveBtnRedPoint_path = "PopUpContent/Common_bg_orange/WhiteBg/MoveContent/MoveBtn/MoveBtnRedPoint"
local scanEffectObj_path = "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/DistanceShowContent/PlayerPosMark/VFX_leida_shijian"
local freeMoveTipsText_path = "PopUpContent/Common_bg_orange/WhiteBg/MoveContent/FreeMoveTipsText"
local distanceTipsBtn_path = "PopUpContent/Common_bg_orange/WhiteBg/DistanceStateContent/DistanceTipsBtn"
local tab_path = "PopUpContent/Common_bg_orange/Tab"
local toggle1_path = "PopUpContent/Common_bg_orange/Tab/Toggle1"
local tab_text1_path = "PopUpContent/Common_bg_orange/Tab/Toggle1/tab_text1"
local tab_2_text1_path = "PopUpContent/Common_bg_orange/Tab/Toggle1/Choose1/tab_2_text1"
local reco_img1_path = "PopUpContent/Common_bg_orange/Tab/Toggle1/reco_img1"
local toggle2_path = "PopUpContent/Common_bg_orange/Tab/Toggle2"
local tab_text2_path = "PopUpContent/Common_bg_orange/Tab/Toggle2/tab_text2"
local tab_2_text2_path = "PopUpContent/Common_bg_orange/Tab/Toggle2/Choose2/tab_2_text2"
local reco_img2_path = "PopUpContent/Common_bg_orange/Tab/Toggle2/reco_img2"
local default_set_path = "PopUpContent/Common_bg_orange/WhiteBg/DefaultSet"
local default_set_toggle_path = "PopUpContent/Common_bg_orange/WhiteBg/DefaultSet/DefaultSetToggle"
local default_set_text_path = "PopUpContent/Common_bg_orange/WhiteBg/DefaultSet/DefaultSetText"
local position_path = "PopUpContent/Common_bg_orange/WhiteBg/DefaultSet/Position"
local checkmark_path = "PopUpContent/Common_bg_orange/WhiteBg/DefaultSet/DefaultSetToggle/Background/Checkmark"
local instruction_path = "PopUpContent/Common_bg_orange/WhiteBg/instruction"
local LONG_AXIS = 323
local SHORT_AXIS = 224

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
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
  self.instruction = self:AddComponent(UIButton, instruction_path)
  self.instruction:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {500006}
    })
  end)
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.bgRawImage = self:AddComponent(UIRawImage, bgRawImage_path)
  self.conveneContent = self:AddComponent(UIBaseContainer, conveneContent_path)
  self.conveneBtn = self:AddComponent(UIButton, conveneBtn_path)
  self.conveneBtnText = self:AddComponent(UIText, conveneBtnText_path)
  self.farawayMemberCountText = self:AddComponent(UIText, farawayMemberCountText_path)
  self.farawayBubbleTipsBtn = self:AddComponent(UIButton, farawayBubbleTipsBtn_path)
  self.distanceStateContent = self:AddComponent(UIBaseContainer, distanceStateContent_path)
  self.distanceTipsText = self:AddComponent(UIText, distanceTipsText_path)
  self.moveContent = self:AddComponent(UIBaseContainer, moveContent_path)
  self.itemCountText = self:AddComponent(UIText, itemCountText_path)
  self.moveBtn = self:AddComponent(UIButton, moveBtn_path)
  self.moveBtnText = self:AddComponent(UIText, moveBtnText_path)
  self.closeFarAwayBubbleBtn = self:AddComponent(UIButton, closeFarAwayBubbleBtn_path)
  self.farawayBubbleTipsText = self:AddComponent(UIText, farawayBubbleTipsText_path)
  self.moveBubbleTipsBtn = self:AddComponent(UIButton, moveBubbleTipsBtn_path)
  self.moveBubbleTipsText = self:AddComponent(UIText, moveBubbleTipsText_path)
  self.moveBubbleContent = self:AddComponent(UIBaseContainer, moveBubbleContent_path)
  self.resItemObj = self:AddComponent(UIBaseContainer, resItemObj_path)
  self.distanceShowContent = self:AddComponent(UIBaseContainer, distanceShowContent_path)
  self.playerPosMark = self:AddComponent(UIBaseContainer, playerPosMark_path)
  self.playerHeadObj = self:AddComponent(UIBaseContainer, playerHeadObj_path)
  self.playerDistanceNumText = self:AddComponent(UIText, playerDistanceNumText_path)
  self.conveneBtnRedPoint = self:AddComponent(UIBaseContainer, conveneBtnRedPoint_path)
  self.moveBtnRedPoint = self:AddComponent(UIBaseContainer, moveBtnRedPoint_path)
  self.scanEffectObj = self:AddComponent(UIBaseContainer, scanEffectObj_path)
  self.freeMoveTipsText = self:AddComponent(UIText, freeMoveTipsText_path)
  self.distanceTipsBtn = self:AddComponent(UIButton, distanceTipsBtn_path)
  self.resItemRender = self:AddComponent(UICommonResItem, resItemObj_path)
  self.playerHeadItemRender = self:AddComponent(UICommonHead, playerHeadObj_path)
  self.titleText:SetLocalText("alliance_AssemblyPoint_title_01")
  self.moveBtnText:SetLocalText("alliance_AssemblyPoint_btn_02")
  self.conveneBtnText:SetLocalText("alliance_AssemblyPoint_btn_03")
  self.moveBubbleTipsText:SetLocalText("alliance_AssemblyPoint_tips_03")
  self.freeMoveTipsText:SetLocalText("130126")
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.conveneBtn:SetSafeClickMode(true)
  self.conveneBtn:SetOnClick(function()
    self:ConveneBtnClick()
  end)
  self.moveBtn:SetSafeClickMode(true)
  self.moveBtn:SetOnClick(function()
    self:MoveBtnClick()
  end)
  self.distanceTipsBtn:SetOnClick(function()
    self:DistanceTipsBtnClick()
  end)
  self.farawayBubbleTipsBtn:SetOnClick(function()
    self.closeFarAwayBubbleBtn:SetActive(true)
  end)
  self.closeFarAwayBubbleBtn:SetOnClick(function()
    self.closeFarAwayBubbleBtn:SetActive(false)
  end)
  self.moveBubbleTipsBtn:SetOnClick(function()
    self.moveBubbleContent:SetActive(false)
  end)
  self.tab = self:AddComponent(UIBaseContainer, tab_path)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabClick(MarkType.Alliance_rally)
    end
  end)
  self.tab_text1 = self:AddComponent(UITextMeshProUGUIEx, tab_text1_path)
  self.tab_text1:SetLocalText(451030)
  self.tab_2_text1 = self:AddComponent(UITextMeshProUGUIEx, tab_2_text1_path)
  self.tab_2_text1:SetLocalText(451030)
  self.reco_img1 = self:AddComponent(UIImage, reco_img1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabClick(MarkType.Alliance_OtherServerRally)
    end
  end)
  self.tab_text2 = self:AddComponent(UITextMeshProUGUIEx, tab_text2_path)
  self.tab_text2:SetLocalText("mail_desc_11040")
  self.tab_2_text2 = self:AddComponent(UITextMeshProUGUIEx, tab_2_text2_path)
  self.tab_2_text2:SetLocalText("mail_desc_11040")
  self.reco_img2 = self:AddComponent(UIImage, reco_img2_path)
  self.default_set = self:AddComponent(UIImage, default_set_path)
  self.checkmark = self:AddComponent(UIImage, checkmark_path)
  self.default_set_toggle = self:AddComponent(UIButton, default_set_toggle_path)
  self.default_set_toggle:SetOnClick(function()
    self:OnToggleClick()
  end)
  self.default_set_text = self:AddComponent(UITextMeshProUGUIEx, default_set_text_path)
  self.default_set_text:SetLocalText("s5_cross_ui04")
  self.position = self:AddComponent(UITextMeshProUGUIEx, position_path)
  self.position_btn = self:AddComponent(UIButton, position_path)
  self.position_btn:SetOnClick(function()
    self:DistanceTipsBtnClick()
  end)
  self.zyf_tonemengjichuyouhua_guang = self:AddComponent(UIRawImage, "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/zyf_tonemengjichuyouhua_guang")
  self.zyf_lianmengjijiedian_biaoji = self:AddComponent(UIImage, "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/zyf_lianmengjijiedian_biaoji")
  self.rallyPanel = self:AddComponent(UILWAlAssemblyInfoRallyPanel, "PopUpContent/Common_bg_orange/WhiteBg/MiniMap/RallyPanel")
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.titleText = nil
  self.closeBtn = nil
  self.bgRawImage = nil
  self.conveneContent = nil
  self.conveneBtn = nil
  self.conveneBtnText = nil
  self.farawayMemberCountText = nil
  self.farawayBubbleTipsBtn = nil
  self.distanceStateContent = nil
  self.distanceTipsText = nil
  self.moveContent = nil
  self.itemCountText = nil
  self.moveBtn = nil
  self.moveBtnText = nil
  self.closeFarAwayBubbleBtn = nil
  self.farawayBubbleTipsText = nil
  self.moveBubbleTipsBtn = nil
  self.moveBubbleTipsText = nil
  self.moveBubbleContent = nil
  self.resItemObj = nil
  self.distanceShowContent = nil
  self.playerPosMark = nil
  self.playerHeadObj = nil
  self.playerDistanceNumText = nil
  self.conveneBtnRedPoint = nil
  self.moveBtnRedPoint = nil
  self.scanEffectObj = nil
  self.freeMoveTipsText = nil
  self.distanceTipsBtn = nil
  self.resItemRender = nil
  self.playerHeadItemRender = nil
  self.tab = nil
  self.toggle1 = nil
  self.tab_text1 = nil
  self.tab_2_text1 = nil
  self.reco_img1 = nil
  self.toggle2 = nil
  self.tab_text2 = nil
  self.tab_2_text2 = nil
  self.reco_img2 = nil
  self.default_set = nil
  self.default_set_toggle = nil
  self.default_set_text = nil
  self.position = nil
  self.rallyPanel = nil
end

local function DataDefine(self)
  self.curMarkType = MarkType.Alliance_rally
  self.moveCityGoodId = 200008
  self.bgPathDict = {}
  local bgStr = LuaEntry.DataConfig:TryGetStr("free_teleport_time", "k4")
  if not string.IsNullOrEmpty(bgStr) then
    local strArr = string.split(bgStr, ";")
    for i, v in ipairs(strArr) do
      self.bgPathDict[i - 1] = v
    end
  end
  self.lastPlayEffectTime = 0
  self.effectInterval = 3000
  DataCenter.AllianceRallyPointDataManager:TrySendGetLongDistanceMemberNumMsg()
  local selfIsLeader = DataCenter.AllianceBaseDataManager:IsSelfLeader()
  if not selfIsLeader then
    SFSNetwork.SendMessage(MsgDefines.ChatAskAllianceGatherMessage)
  end
end

local function DataDestroy(self)
  self.moveCityGoodId = nil
  self.bgPathDict = nil
  self.lastPlayEffectTime = nil
  self.effectInterval = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateLongDistanceMemberNum, self.OnUpdateLongDistanceMemberNum)
  self:AddUIListener(EventId.BuildMainZeroUpgradeSuccess, self.OnRefreshDistanceState)
  self:AddUIListener(EventId.UpdateSelfAllianceRallyPoint, self.OnRefreshDistanceState)
  self:AddUIListener(EventId.ChatPinUpdate, self.RefreshAllianceGatherMemberChatPinMsg)
  self:AddUIListener(EventId.RefreshItems, self.RefreshShowMoveContent)
  self:AddUIListener(EventId.RefreshRecommendRallyPoint, self.OnRefreshRecommendRallyPoint)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateLongDistanceMemberNum, self.OnUpdateLongDistanceMemberNum)
  self:RemoveUIListener(EventId.BuildMainZeroUpgradeSuccess, self.OnRefreshDistanceState)
  self:RemoveUIListener(EventId.UpdateSelfAllianceRallyPoint, self.OnRefreshDistanceState)
  self:RemoveUIListener(EventId.ChatPinUpdate, self.RefreshAllianceGatherMemberChatPinMsg)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshShowMoveContent)
  self:RemoveUIListener(EventId.RefreshRecommendRallyPoint, self.OnRefreshRecommendRallyPoint)
  base.OnRemoveListener(self)
end

local function OnUpdateLongDistanceMemberNum(self)
  self:RefreshRedPoint()
  self:RefreshShowFarAwayMemberCount()
end

local function OnRefreshDistanceState(self)
  self:RefreshRedPoint()
  self:RefreshShowDistanceState()
end

local function Update1000MS(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - self.lastPlayEffectTime >= self.effectInterval then
    self:RefreshScanEffect()
  end
end

local function ReInit(self)
  local seasonId = SeasonUtil.GetSeason()
  local bgPath = string.format(LoadPath.UILWAssemblyBgPath, "zyf_tonemengjichuyouhua_ditu1")
  if self.bgPathDict[seasonId] then
    bgPath = string.format(LoadPath.UILWAssemblyBgPath, self.bgPathDict[seasonId])
  end
  self.bgRawImage:LoadSprite(bgPath)
  self.playerHeadItemRender:SetAsMyself()
  self:RefreshOtherServerRallyPoint()
  self:RefreshShowFarAwayMemberCount()
  self:RefreshRedPoint()
  self:RefreshShowMoveContent()
  self:RefreshShowDistanceState()
  self:RefreshScanEffect()
end

function UILWAlAssemblyInfoView:RefreshOtherServerRallyPoint()
  local otherData = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint(MarkType.Alliance_OtherServerRally)
  if not otherData then
    self.tab:SetActive(false)
    self.default_set:SetActive(false)
    self.instruction:SetActive(false)
    return
  end
  self.tab:SetActive(true)
  self.default_set:SetActive(true)
  local recommendType = DataCenter.AllianceRallyPointDataManager:GetRecommendType()
  self.curMarkType = recommendType or MarkType.Alliance_rally
  if recommendType == MarkType.Alliance_rally then
    self.toggle1:SetIsOn(true)
  elseif recommendType == MarkType.Alliance_OtherServerRally then
    self.toggle2:SetIsOn(true)
  else
    self.toggle1:SetIsOn(true)
  end
  self:OnRefreshRecommendRallyPoint()
end

function UILWAlAssemblyInfoView:OnTabClick(markType)
  if self.curMarkType == markType then
    return
  end
  self.curMarkType = markType
  DataCenter.AllianceRallyPointDataManager:TrySendGetLongDistanceMemberNumMsg(markType)
  self:OnRefreshRecommendRallyPoint()
  self:RefreshShowFarAwayMemberCount()
  self:RefreshRedPoint()
  self:RefreshShowMoveContent()
  self:RefreshShowDistanceState()
  self:RefreshScanEffect()
end

function UILWAlAssemblyInfoView:OnToggleClick()
  local recommendType = DataCenter.AllianceRallyPointDataManager:GetRecommendType()
  if recommendType == self.curMarkType then
    return
  end
  DataCenter.AllianceRallyPointDataManager:TrySetRecommendRallyPoint(self.curMarkType)
end

function UILWAlAssemblyInfoView:OnRefreshRecommendRallyPoint()
  local recommendType = DataCenter.AllianceRallyPointDataManager:GetRecommendType()
  self.checkmark:SetActive(self.curMarkType == recommendType)
  if recommendType == MarkType.Alliance_rally then
    self.reco_img1:SetActive(true)
    self.reco_img2:SetActive(false)
  elseif recommendType == MarkType.Alliance_OtherServerRally then
    self.reco_img1:SetActive(false)
    self.reco_img2:SetActive(true)
  else
    self.reco_img1:SetActive(false)
    self.reco_img2:SetActive(false)
  end
  local curData = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint(self.curMarkType)
  local v2 = SceneUtils.IndexToTilePos(curData:GetPointIndex(), ForceChangeScene.World)
  self.position:SetText(UIUtil.FormatServerPosition(curData.server, v2.x, v2.y))
  if self.curMarkType == MarkType.Alliance_rally then
    self.instruction:SetActive(false)
    self.zyf_tonemengjichuyouhua_guang:LoadSpriteAsync("Assets/Main/TextureEx/LWUIAllianceAssemblyInfo/zyf_tonemengjichuyouhua_guang.png")
    self.zyf_lianmengjijiedian_biaoji:LoadSpriteAsync("Assets/Main/Sprites/UI/UIAllianceMark/zyf_lianmengjijiedian_biaoji.png")
  elseif self.curMarkType == MarkType.Alliance_OtherServerRally then
    self.instruction:SetActive(true)
    self.zyf_tonemengjichuyouhua_guang:LoadSpriteAsync("Assets/Main/SeasonRes/S5/Textures/RallyPoint/lyt_tonemengjichuyouhua_guang.png")
    self.zyf_lianmengjijiedian_biaoji:LoadSpriteAsync("Assets/Main/Sprites/UI/UIAllianceMark/zyf_lianmengjijiedian_biaoji 1.png")
  end
  self:RefreshShowFarAwayMemberCount()
end

local function RefreshShowDistanceState(self)
  local selfMark = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint(self.curMarkType)
  local selfMarkPos = SceneUtils.BigIndexToTilePos(selfMark.pos, ForceChangeScene.World)
  local distance, angleInRadians = DataCenter.AllianceRallyPointDataManager:CalcSelfPosAndRallyPointPosDisAndAngle(self.curMarkType)
  local rangeRadius = LuaEntry.DataConfig:TryGetNum("free_teleport_time", "k2")
  local SourceServerId = LuaEntry.Player:GetSourceServerId()
  local posStr = Localization:GetString(GameDialogDefine.SHOW_POS, selfMarkPos.x, selfMarkPos.y)
  local otherData = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint(MarkType.Alliance_OtherServerRally)
  if otherData then
    posStr = string.format("<u>#%s (%s)</u>", selfMark.server, posStr)
  elseif SourceServerId ~= nil and SourceServerId ~= 0 and SourceServerId ~= -1 and not LuaEntry.Player:IsLoginSourceServer() then
    posStr = string.format("<u>#%s (%s)</u>", SourceServerId, posStr)
  end
  if distance <= rangeRadius then
    local longAxis = LONG_AXIS - 20
    local shortAxis = SHORT_AXIS - 50
    self.distanceTipsText:SetLocalText("alliance_AssemblyPoint_tips_02", posStr)
    self.playerDistanceNumText:SetText("")
    local x = distance * Mathf.Cos(angleInRadians) * (longAxis / 2 / rangeRadius)
    local y = distance * Mathf.Sin(angleInRadians) * (shortAxis / 2 / rangeRadius)
    self.playerPosMark:SetLocalPositionXYZ(x, y, 0)
  else
    self.distanceTipsText:SetLocalText("alliance_AssemblyPoint_tips_01", posStr)
    self.playerDistanceNumText:SetText(distance .. Localization:GetString(GameDialogDefine.KILOMETRE))
    local ratio = 1.5
    local bgSizeDelta = self.bgRawImage:GetSizeDelta()
    local maxX = (bgSizeDelta.x - 80) / 2
    local minX = -maxX
    local maxY = (bgSizeDelta.y - 114) / 2
    local minY = -maxY
    local x = ratio * LONG_AXIS / 2 * Mathf.Cos(angleInRadians)
    local y = ratio * SHORT_AXIS / 2 * Mathf.Sin(angleInRadians)
    x = math.min(x, maxX)
    x = math.max(x, minX)
    y = math.min(y, maxY)
    y = math.max(y, minY)
    self.playerPosMark:SetLocalPositionXYZ(x, y, 0)
  end
end

local function RefreshShowFarAwayMemberCount(self)
  local recommendType = DataCenter.AllianceRallyPointDataManager:GetRecommendType()
  if DataCenter.AllianceBaseDataManager:IsSelfLeader() and recommendType == self.curMarkType then
    local farawayMemberCount = DataCenter.AllianceRallyPointDataManager:GetFarAwayMemberCount(self.curMarkType)
    self.conveneContent:SetActive(0 < farawayMemberCount)
    if 0 < farawayMemberCount then
      self.farawayMemberCountText:SetText(farawayMemberCount)
      self.farawayBubbleTipsText:SetLocalText("alliance_AssemblyPoint_tips_04", farawayMemberCount)
    end
  else
    self.conveneContent:SetActive(false)
  end
end

local function RefreshShowMoveContent(self)
  local free = LuaEntry.Player:CanFreeAllianceMove(self.curMarkType)
  self.freeMoveTipsText:SetActive(free)
  self.itemCountText:SetActive(not free)
  self.resItemRender:SetActive(not free)
  if not free then
    local ownCount = DataCenter.ItemData:GetItemCount(self.moveCityGoodId)
    local rewardParam = {}
    rewardParam.rewardType = RewardType.GOODS
    rewardParam.itemId = self.moveCityGoodId
    rewardParam.count = ownCount
    self.resItemRender:ReInit(rewardParam)
    local countStr = ""
    if 0 < ownCount then
      countStr = "<color=#5fef87>" .. ownCount .. "</color>" .. "/" .. "1"
    else
      countStr = "<color=#f53c3d>" .. ownCount .. "</color>" .. "/" .. "1"
    end
    self.itemCountText:SetText(countStr)
  end
end

local function RefreshRedPoint(self)
  local redPointCount, selfFarAwayRedPoint, farAwayMemberRedPoint = DataCenter.AllianceRallyPointDataManager:GetAllianceGatherRedPoint()
  local selfIsLeader = DataCenter.AllianceBaseDataManager:IsSelfLeader()
  self.conveneBtnRedPoint:SetActive(farAwayMemberRedPoint and selfIsLeader)
  self.moveBtnRedPoint:SetActive(selfFarAwayRedPoint)
end

local function RefreshAllianceGatherMemberChatPinMsg(self)
  local have = DataCenter.LWChatPinManager:HaveAllianceGatherMemberMsg()
  self.moveBubbleContent:SetActive(have)
end

local function RefreshScanEffect(self)
  self.lastPlayEffectTime = UITimeManager:GetInstance():GetServerTime()
  self.scanEffectObj:SetActive(false)
  self.scanEffectObj:SetActive(true)
end

local function MoveBtnClick(self)
  if not DataCenter.AllianceRallyPointDataManager:CanAllianceMoveCity() then
    UIUtil.ShowTipsId("alliance_AssemblyPoint_tips_06")
    return
  end
  if DataCenter.SeasonHunterManager:IsInBattle() then
    UIUtil.ShowTipsId("season_mastery_s4_tips_11")
    return
  end
  
  local function _callback()
    local free = LuaEntry.Player:CanFreeAllianceMove(self.curMarkType)
    if free then
      UIUtil.ShowMessage(Localization:GetString("310191"), 2, "393106", "393107", function()
        MoveCityUtil.AllianceMoveCityToSelectedRallyPoint(self.curMarkType, 5, false)
        if self.ctrl then
          self.ctrl:CloseSelf()
        end
      end)
    else
      local curNum = DataCenter.ItemData:GetItemCount(self.moveCityGoodId)
      if 0 < curNum then
        UIUtil.ShowMessage(Localization:GetString("393100", curNum), 2, "393106", "393107", function()
          MoveCityUtil.AllianceMoveCityToSelectedRallyPoint(self.curMarkType, 4, false)
          if self.ctrl then
            self.ctrl:CloseSelf()
          end
        end)
      else
        LWResourceLackUtil:GotoGoodsItemLack(self.moveCityGoodId, 1)
      end
    end
  end
  
  local conditions = ConditionChecker.New(_callback)
  conditions:Add({
    need = function()
      return DataCenter.ActMeteoriteBattleManager:NeedNoticeAllianceMoveCityDropMine()
    end,
    checker = function(handle)
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMeteoriteDropNoticeNotice, {anim = true}, {
        ok = function()
          handle:Next()
        end,
        cancel = function()
          handle:Destroy()
        end,
        notice = "yuntieBattle_interface_1038",
        ignoreKey = SettingKeys.NO_METEORITE_DROP_PROMPT
      })
    end
  })
  conditions:Add({
    need = function()
      return DataCenter.ActMeteoriteBattleManager:NeedNoticeAllianceMoveCityPosition()
    end,
    checker = function(handle)
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.MeteoriteAllianceAssembly, CS.GameEntry.Localization:GetString("yuntieBattle_tips_1038"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        handle:Next()
      end, function()
        handle:Destroy()
      end, nil, nil, false, nil, nil)
    end
  })
  conditions:Next()
end

local function ConveneBtnClick(self)
  local selfMark = DataCenter.AllianceRallyPointDataManager:GetRecommendRallyPoint()
  local pos = SceneUtils.BigIndexToTilePos(selfMark.pos, ForceChangeScene.World)
  UIUtil.ShowMessage(Localization:GetString("s5_allianceflag_tips03", pos.x, pos.y, selfMark.server), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    SFSNetwork.SendMessage(MsgDefines.ChatSendAlliacneGatherMessage, 1, selfMark.type)
    self.ctrl:CloseSelf()
    UIUtil.ShowTipsId(393099)
  end, function()
  end)
end

local function DistanceTipsBtnClick(self)
  local selfMark = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint(self.curMarkType)
  local pointId = SceneUtils.BigIndexToStandardIndex(selfMark.pos)
  local v3 = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, selfMark.server)
  GoToUtil.CloseAllWindows()
  GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
  end, selfMark.server)
end

UILWAlAssemblyInfoView.OnCreate = OnCreate
UILWAlAssemblyInfoView.OnDestroy = OnDestroy
UILWAlAssemblyInfoView.OnEnable = OnEnable
UILWAlAssemblyInfoView.OnDisable = OnDisable
UILWAlAssemblyInfoView.ComponentDefine = ComponentDefine
UILWAlAssemblyInfoView.ComponentDestroy = ComponentDestroy
UILWAlAssemblyInfoView.DataDefine = DataDefine
UILWAlAssemblyInfoView.DataDestroy = DataDestroy
UILWAlAssemblyInfoView.OnAddListener = OnAddListener
UILWAlAssemblyInfoView.OnRemoveListener = OnRemoveListener
UILWAlAssemblyInfoView.OnUpdateLongDistanceMemberNum = OnUpdateLongDistanceMemberNum
UILWAlAssemblyInfoView.OnRefreshDistanceState = OnRefreshDistanceState
UILWAlAssemblyInfoView.ReInit = ReInit
UILWAlAssemblyInfoView.RefreshShowDistanceState = RefreshShowDistanceState
UILWAlAssemblyInfoView.RefreshShowFarAwayMemberCount = RefreshShowFarAwayMemberCount
UILWAlAssemblyInfoView.RefreshShowMoveContent = RefreshShowMoveContent
UILWAlAssemblyInfoView.RefreshRedPoint = RefreshRedPoint
UILWAlAssemblyInfoView.RefreshAllianceGatherMemberChatPinMsg = RefreshAllianceGatherMemberChatPinMsg
UILWAlAssemblyInfoView.MoveBtnClick = MoveBtnClick
UILWAlAssemblyInfoView.ConveneBtnClick = ConveneBtnClick
UILWAlAssemblyInfoView.Update1000MS = Update1000MS
UILWAlAssemblyInfoView.RefreshScanEffect = RefreshScanEffect
UILWAlAssemblyInfoView.DistanceTipsBtnClick = DistanceTipsBtnClick
return UILWAlAssemblyInfoView
