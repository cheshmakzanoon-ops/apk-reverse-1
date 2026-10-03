local MailMonsterRewardItem = BaseClass("MailMonsterRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local rapidjson = require("rapidjson")
local _cp_txtTitle = "txtTitle"
local _cp_btnPos = "btnPos"
local _cp_txtPos = "btnPos/txtPos"
local _cp_txtTime = "txtTime"
local _cp_txtItemCnt = "itemCnt"
local _cp_newFlag = "newFlag"
local _cp_rewardBtn = "rewardBtn"
local _cp_receive = "received"

function MailMonsterRewardItem:OnCreate()
  base.OnCreate(self)
  self._txtTitle = self:AddComponent(UIText, _cp_txtTitle)
  self._btnPos = self:AddComponent(UIButton, _cp_btnPos)
  self._btnPos:SetOnClick(BindCallback(self, self.OnClickBtnPos))
  self._rewardBtn = self:AddComponent(UIButton, _cp_rewardBtn)
  self._rewardBtn:SetOnClick(BindCallback(self, self.OnClickGetReward))
  self._txtPos = self:AddComponent(UIText, _cp_txtPos)
  self._receive = self:AddComponent(UIText, _cp_receive)
  self._txtTime = self:AddComponent(UIText, _cp_txtTime)
  self._txtItemCnt = self:AddComponent(UIText, _cp_txtItemCnt)
  self._newFlag = self:AddComponent(UIBaseContainer, _cp_newFlag)
  self._receive:SetText("receive")
end

function MailMonsterRewardItem:OnClickBtnPos()
  GoToUtil.CloseAllWindows()
  EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
  local pointId = self.mailData.needCollectReward.pointId or 0
  GoToUtil.MoveToWorldPoint(pointId)
end

function MailMonsterRewardItem:OnClickGetReward()
  local pointId = self.mailData.needCollectReward.pointId or 0
  GoToUtil.CloseAllWindows()
  EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
  GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    WorldArrowManager:GetInstance():ShowArrowEffect(0, SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), ArrowType.Guide_Garbage)
  end)
end

function MailMonsterRewardItem:SetData(maildata)
  local tabMailInfo = rapidjson.decode(maildata.contents)
  local mailObj = tabMailInfo.obj or {}
  self.mailData = PBController.ParsePb1(mailObj.rewardContent, "protobuf.MonsterCollectRewardMail")
  local monsterId = self.mailData.monsterId
  local uuid = self.mailData.needCollectReward.rewardUuid
  local strName = ""
  local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
  if monster ~= nil then
    strName = Localization:GetString("140205", monster.level, Localization:GetString(monster.name))
  end
  local vecPos = SceneUtils.IndexToTilePos(self.mailData.needCollectReward.pointId, ForceChangeScene.World)
  local strPoint = "X" .. vecPos.x .. " Y:" .. vecPos.y
  local strTime = UITimeManager:GetInstance():TimeStampToTimeForLocal(self.mailData.startTime)
  local strCnt = Localization:GetString("104192", strName)
  local lastOpenTime = Setting:GetPrivateInt(SettingKeys.MAIL_MONSTER_REWARD_LAST_OPEN, 0)
  if lastOpenTime < maildata.createTime / 1000 then
    self._newFlag:SetActive(true)
  else
    self._newFlag:SetActive(false)
  end
  self._txtTitle:SetText(strName)
  self._txtPos:SetText(strPoint)
  self._txtTime:SetText(strTime)
  self._txtItemCnt:SetText(strCnt)
  local inUserWorld = self.mailData.needCollectReward.inUserWorld
  if inUserWorld then
    local pointData = DataCenter.CityPointDataManager:GetPointDataByPointId(self.mailData.needCollectReward.pointId)
    if pointData ~= nil then
      self._rewardBtn:SetActive(true)
      self._receive:SetActive(false)
    else
      self._rewardBtn:SetActive(false)
      self._receive:SetActive(true)
    end
  else
    local rewardData = DataCenter.CollectRewardDataManager:GetRewardDataByUuid(uuid)
    if rewardData ~= nil then
      self._rewardBtn:SetActive(true)
      self._receive:SetActive(false)
    else
      self._rewardBtn:SetActive(false)
      self._receive:SetActive(true)
    end
  end
end

return MailMonsterRewardItem
