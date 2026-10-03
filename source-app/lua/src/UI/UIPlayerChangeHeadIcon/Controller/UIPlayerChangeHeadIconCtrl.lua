local UIPlayerChangeHeadIconCtrl = BaseClass("UIPlayerChangeHeadIconCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerChangeHeadIcon)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self, uid)
  if uid ~= nil then
    self.uid = uid
  else
    self.uid = LuaEntry.Player.uid
  end
end

local function GetUid(self)
  return self.uid
end

local function GetAllHeadIconInfo()
  local showList = {}
  local data = {}
  local id = 0
  data.id = id
  data.picName = "player_head_" .. id
  table.insert(showList, data)
  data = {}
  id = 1
  data.id = id
  data.picName = "player_head_" .. id
  table.insert(showList, data)
  data = {}
  id = 3
  data.id = id
  data.picName = "player_head_" .. id
  table.insert(showList, data)
  return showList
end

local function OnGotoClick(self, id)
  if id == CustomizeAvatarId then
    if LuaEntry.Player.modfiyPicStatus == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerHeadIconSelect, {anim = true}, uuid)
    else
      local curData = DataCenter.MonopolyManager.dataManager:GetCurData()
      local level = LuaEntry.DataConfig:TryGetNum("uploadAvatar_active", "k1")
      if DataCenter.MonopolyManager:GetIsEnd() or curData and level < curData.id then
        GoToUtil.GotoOpenView(UIWindowNames.UIFirstPay, {
          anim = false,
          UIMainAnim = UIMainAnimType.AllHide
        }, {delay = 0.1})
        return
      end
      local monopolyTemplate = DataCenter.MonopolyManager.dataManager:GetTemplate(level)
      if not monopolyTemplate then
        return
      end
      if not curData then
        UIUtil.ShowMessage(Localization:GetString("320301", Localization:GetString(monopolyTemplate.name, level)), 1, "110006", GameDialogDefine.CANCEL, function()
          CloseSelf()
        end)
      elseif level >= curData.id then
        UIUtil.ShowMessage(Localization:GetString("320301", Localization:GetString(monopolyTemplate.name, level)), 1, "110006", GameDialogDefine.CANCEL, function()
          CloseSelf()
        end)
      end
    end
  else
  end
end

local function OnPhotoClick(self)
end

local function OnCameraClick(self)
end

local function OnUseClick(self, picName)
  UIUtil.ShowMessage(Localization:GetString("128134"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    SFSNetwork.SendMessage(MsgDefines.UserChangePic, picName)
  end)
end

UIPlayerChangeHeadIconCtrl.CloseSelf = CloseSelf
UIPlayerChangeHeadIconCtrl.Close = Close
UIPlayerChangeHeadIconCtrl.InitData = InitData
UIPlayerChangeHeadIconCtrl.GetAllHeadIconInfo = GetAllHeadIconInfo
UIPlayerChangeHeadIconCtrl.GetUid = GetUid
UIPlayerChangeHeadIconCtrl.OnGotoClick = OnGotoClick
UIPlayerChangeHeadIconCtrl.OnPhotoClick = OnPhotoClick
UIPlayerChangeHeadIconCtrl.OnCameraClick = OnCameraClick
UIPlayerChangeHeadIconCtrl.OnUseClick = OnUseClick
return UIPlayerChangeHeadIconCtrl
