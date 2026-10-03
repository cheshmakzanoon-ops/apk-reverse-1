using Leopotam.EcsLite;
using UnityEngine;
using VEngine;

namespace MiniGame.GGGo.Client;

[ExecuteAlways]
public class GGGoCacheableResource : MonoBehaviour
{
	protected EcsPackedEntityWithWorld _entity;

	protected string _path;

	protected Asset _asset;

	protected int _updateActived = -1;

	public string Path
	{
		get
		{
			return _path;
		}
		set
		{
			_path = value;
		}
	}

	public Asset Asset
	{
		get
		{
			return _asset;
		}
		set
		{
			_asset = value;
		}
	}

	public virtual void BindEntity(EcsPackedEntityWithWorld entity)
	{
		_entity = entity;
	}

	public EcsPackedEntityWithWorld GetOwner()
	{
		return _entity;
	}

	public virtual void SetActiveAtLateUpdate(bool active)
	{
		if (!base.gameObject.activeSelf)
		{
			base.gameObject.SetActive(active);
			_updateActived = -1;
		}
		else
		{
			_updateActived = (active ? 1 : 0);
		}
	}

	public virtual void LateUpdate()
	{
		if (_updateActived >= 0)
		{
			base.gameObject.SetActive(_updateActived != 0);
			_updateActived = -1;
		}
	}

	public virtual IGGGoCacheableResourceState SaveState()
	{
		GGGoTransformState gGGoTransformState = default(GGGoTransformState);
		gGGoTransformState.Scale = base.transform.localScale;
		gGGoTransformState.Rotation = base.transform.localRotation.eulerAngles;
		gGGoTransformState.Position = base.transform.localPosition;
		return gGGoTransformState;
	}

	public virtual void LoadState(IGGGoCacheableResourceState state)
	{
		if (state is GGGoTransformState gGGoTransformState)
		{
			base.transform.localScale = gGGoTransformState.Scale;
			base.transform.localRotation = Quaternion.Euler(gGGoTransformState.Rotation);
			base.transform.localPosition = gGGoTransformState.Position;
		}
	}

	public void OnDestroy()
	{
		_asset?.Release();
		_asset = null;
	}
}
