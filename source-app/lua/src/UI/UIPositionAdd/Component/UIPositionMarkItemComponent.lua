local base = UIBaseContainer
local UIPositionMarkItemComponent = BaseClass("UIPositionMarkItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local MARK_ICON_IMG_PATH = {
  [0] = "Common_img_mark",
  [1] = "Common_img_mark_friend",
  [2] = "Common_img_mark_enemy"
}

function UIPositionMarkItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPositionMarkItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPositionMarkItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgFlag = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textPosition = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnShare = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.btnDel = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnDel:SetOnClick(function()
    self:OnBtnDelClick()
  end)
  self.btnPosition = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnPosition:SetOnClick(function()
    self:OnBtnPositionClick()
  end)
end

function UIPositionMarkItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgFlag = nil
  self.textName = nil
  self.textPosition = nil
  self.btnShare = nil
  self.btnDel = nil
  self.btnPosition = nil
end

function UIPositionMarkItemComponent:DataDefine()
  self.markData = {}
end

function UIPositionMarkItemComponent:DataDestroy()
  self.markData = nil
end

function UIPositionMarkItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIPositionMarkItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPositionMarkItemComponent:OnBtnShareClick()
  local share_param = {}
  share_param.sid = self.markData.server
  share_param.pos = (self.markData.pos - self.markData.pos % 10) / 10
  share_param.uname = ""
  if not string.IsNullOrEmpty(self.markData.pointInfo) then
    local info = rapidjson.decode(self.markData.pointInfo)
    if info then
      if info.uname then
        share_param.uname = info.uname
      else
        share_param.uname = ""
      end
      if info.abbr then
        share_param.abbr = info.abbr
      end
      if info.oname then
        share_param.oname = info.oname
      end
      if info.olv then
        share_param.olv = info.olv
      end
      share_param.uid = info.uid
      if not string.IsNullOrEmpty(info.posType) then
        share_param.posType = toInt(info.posType)
      end
    end
  end
  GoToUtil.GotoOpenView(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function UIPositionMarkItemComponent:OnBtnDelClick()
  local markData = self.markData
  UIUtil.TryShowConfirm(TodayNoSecondConfirmType.WorldBookmarkDelConfirm, Localization:GetString("alliance_tag_opt_UI_5"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    local fav = DataCenter.WorldFavoDataManager:GetBookmark(markData.pos, markData.server, true)
    if fav then
      self.view.ctrl:DelBookMark(fav)
    end
  end, function()
  end, function()
  end)
end

function UIPositionMarkItemComponent:OnBtnPositionClick()
  local mark_pos = (self.markData.pos - self.markData.pos % 10) / 10
  GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(mark_pos), CS.SceneManager.World.InitZoom, nil, nil, self.markData.server)
  self.view.ctrl:CloseSelf()
end

function UIPositionMarkItemComponent:SetData(data)
  local mark_pos = (data.pos - data.pos % 10) / 10
  local pos = SceneUtils.IndexToTilePos(mark_pos)
  self.markData = data
  self.textName:SetText(data.name)
  self.textPosition:SetLocalText(128005, data.server, pos.x, pos.y)
  self.imgFlag:LoadSprite(string.format(LoadPath.CommonNewPath, MARK_ICON_IMG_PATH[data.type]))
end

return UIPositionMarkItemComponent
