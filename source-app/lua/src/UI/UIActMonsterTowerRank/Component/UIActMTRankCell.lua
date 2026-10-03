local UIActMTRankCell = BaseClass("UIActMTRankCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIActMTRankCell:OnCreate()
  base.OnCreate(self)
  self._name_txt = self:AddComponent(UIText, "Txt_Name")
  self._curLevel_txt = self:AddComponent(UIText, "Txt_CurLevel")
  self._diff_img = self:AddComponent(UIImage, "Img_Diff")
  self._help_btn = self:AddComponent(UIButton, "Btn_Help")
  self._help_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickHelp()
  end)
  self._head_btn = self:AddComponent(UIButton, "UIPlayerHead")
  self.playerHead = self:AddComponent(UIPlayerHead, "UIPlayerHead/HeadIcon")
  self.monthCard = self:AddComponent(UIBaseContainer, "UIPlayerHead/Foreground")
  self._head_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickHead()
  end)
end

function UIActMTRankCell:OnDestroy()
  base.OnDestroy(self)
end

function UIActMTRankCell:OnEnable()
  base.OnEnable(self)
end

function UIActMTRankCell:OnDisable()
  base.OnDisable(self)
end

function UIActMTRankCell:SetData(data)
  self.data = data
  self._name_txt:SetText(data.name)
  self._curLevel_txt:SetLocalText(300665, data.curLevel)
  self.playerHead:SetData(data.uid, data.pic, data.picVer)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  self.monthCard:SetActive(data.monthCardEndTime > 0 and curTime < data.monthCardEndTime)
  self._diff_img:LoadSprite(string.format(LoadPath.UIMonsterTower, ActMonsterTowerDiff[data.difficulty]))
  if data.challengeBoss and data.challengeBoss.callHelp == 1 then
    self._help_btn:SetActive(true)
  else
    self._help_btn:SetActive(false)
  end
end

function UIActMTRankCell:OnClickHelp()
  if self.data.uid == LuaEntry.Player.uid then
    UIUtil.ShowTipsId(372435)
  elseif self.data.challengeBoss and self.data.challengeBoss.pointId then
    GoToUtil.CloseAllWindows()
    local pointId = SceneUtils.TileIndexToWorld(self.data.challengeBoss.pointId)
    GoToUtil.GotoPos(pointId, CS.SceneManager.World.InitZoom)
  end
end

function UIActMTRankCell:OnClickHead()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.data.uid)
end

return UIActMTRankCell
