local CarpetManager = BaseClass("CarpetManager")
local Localization = CS.GameEntry.Localization

function CarpetManager:__init()
end

function CarpetManager:__delete()
end

function CarpetManager:UseCarpetItem(itemId)
  local hasCarpet = LuaEntry.Effect:HasStatusByStatusType2(StatusType2.BuildingEffect)
  if not hasCarpet then
    SFSNetwork.SendMessage(MsgDefines.UseItemDecoration, itemId)
  else
    UIUtil.ShowMessage(Localization:GetString("carpet_desc_using"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.UseItemDecoration, itemId)
    end)
  end
end

function CarpetManager:IsHaveAnyCarpetNow()
  return LuaEntry.Effect:HasStatusByStatusType2(StatusType2.BuildingEffect)
end

return CarpetManager
