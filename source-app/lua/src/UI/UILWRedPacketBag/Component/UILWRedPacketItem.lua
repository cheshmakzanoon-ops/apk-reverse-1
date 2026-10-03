local UILWRedPackItem = BaseClass("UILWRedPackItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local sendKey = "red_pocket_desc5"
local rapidjson = require("rapidjson")
local bg1_path = "bg1"

function UILWRedPackItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UILWRedPackItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWRedPackItem:ComponentDefine()
  self.title = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.sendBtn = self:AddComponent(UIButton, "sendBtn")
  self.countText = self:AddComponent(UITextMeshProUGUIEx, "count")
  self.descText = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.sendBtnText = self:AddComponent(UITextMeshProUGUIEx, "sendBtn/sendBtnText")
  self.rewardIcon = self:AddComponent(UIImage, "rewardBg/rewardIcon")
  self.bg1 = self:AddComponent(UIRawImage, bg1_path)
  self.expiredTimeComp = self:AddComponent(UITextMeshProUGUIEx, "expiredTime")
  self.sendBtn:SetOnClick(function()
    self:OnSendClick()
  end)
  self.titleBtn = self:AddComponent(UIButton, "titleBtn")
  self.titleBtn:SetOnClick(function()
    self:OnTitleClick()
  end)
end

function UILWRedPackItem:OnSendClick()
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  if CrossServerUtil:GetIsCrossServer() and not self.redPocketTemp:IsCanCrossServer() then
    UIUtil.ShowTipsId("red_pocket_desc18")
    return
  end
  if not self.redPocketTemp:Condition(true) then
    return
  end
  local share_param = {}
  share_param.post = PostType.RedPackge_New
  share_param.uid = self.param.uuid
  share_param.count = 1
  share_param.redPocketId = self.param.goods.id
  share_param.isCopy = self.redPocketTemp.init_copy == 1
  share_param.redPocketType = self.redPocketTemp.type
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  if self.redPocketTemp.type == 3 then
    self.view.ctrl:CloseSelf()
  end
end

function UILWRedPackItem:OnTitleClick()
  if self.redPocketTemp and self.redPocketTemp.type == 3 and self.param.pointId ~= nil then
    local willPos = SceneUtils.TileIndexToWorld(self.param.pointId, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(willPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end, self.param.serverId, 0)
  end
end

function UILWRedPackItem:ComponentDestroy()
  self.title = nil
  self.sendBtn = nil
  self.countText = nil
  self.sendBtnText = nil
  self.rewardIcon = nil
  self.bg1 = nil
end

function UILWRedPackItem:DataDefine()
end

function UILWRedPackItem:DataDestroy()
end

function UILWRedPackItem:Refresh(param)
  self.param = param
  self:RefreshExpiredTime()
  self.redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplateByGoodsId(tonumber(self.param.goods.id))
  local bType3 = self.redPocketTemp and self.redPocketTemp.type == 3
  if bType3 then
    if self.param.pointId ~= nil then
      local willPos = SceneUtils.IndexToTilePos(self.param.pointId, ForceChangeScene.World)
      local posStr = "(X:" .. willPos.x .. "," .. "Y:" .. willPos.y .. ")"
      self.title:SetLocalText("season_s3_activity_1000072_desc68", self.param.serverId, posStr, self.param.tradeLevel)
    end
  else
    self.title:SetLocalText(self.param.goods.name)
  end
  self.sendBtnText:SetLocalText(sendKey)
  self.countText:SetLocalText("thanksactivity_UI036", self.param.count or 1)
  self.rewardIcon:LoadSprite(string.format(LoadPath.ItemPath, self.redPocketTemp.item_pic))
  self.bg1:LoadSpriteAuto(string.format(LoadPath.ChatRedPacketTexturePath, self.redPocketTemp.pic))
  self.descText:SetActive(bType3)
  if bType3 then
    self.descText:SetLocalText("season_s3_activity_1000072_desc69", self.param.gold)
  end
  self:Update1000MS()
end

function UILWRedPackItem:RefreshExpiredTime()
  self.expiredTime = nil
  if not string.IsNullOrEmpty(self.param.otherParam) and self.param.GetOtherParamTab then
    local otherPara = self.param:GetOtherParamTab()
    if otherPara and otherPara.expireTime then
      self.expiredTime = otherPara.expireTime
    end
  end
  self.expiredTimeComp:SetActive(self.expiredTime ~= nil)
end

function UILWRedPackItem:Update1000MS()
  if self.expiredTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local leftTime = self.expiredTime - curTime
  if leftTime <= 0 then
    leftTime = 0
  end
  local timeStr = UITimeManager:GetInstance():SecondToFmtString(leftTime)
  self.expiredTimeComp:SetText(timeStr)
end

return UILWRedPackItem
